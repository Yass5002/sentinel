package com.example.sentinel

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.HandlerThread
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.security.SecureRandom
import java.security.cert.X509Certificate
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager

class LocationTrackingService : Service() {

    companion object {
        private const val TAG = "SentinelLocation"
        private const val CHANNEL_ID = "sentinel_location_channel"
        private const val NOTIFICATION_ID = 2001
        private const val PREFS_NAME = "sentinel_location_prefs"
        private const val KEY_JWT = "location_jwt"
        private const val MAX_RETRY_BUFFER = 5

        @Volatile
        var isRunning = false
            private set
    }

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private var locationCallback: LocationCallback? = null
    private var jwt: String? = null
    private var httpClient: OkHttpClient? = null
    private var executor: ExecutorService? = null
    private var locationHandlerThread: HandlerThread? = null
    private var locationHandler: Handler? = null

    // In-memory buffer for failed location POSTs (retry on next success)
    private val retryBuffer = mutableListOf<LocationData>()

    private data class LocationData(val lat: Double, val lng: Double, val accuracy: Float)

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        httpClient = createHttpClient()
        executor = Executors.newSingleThreadExecutor { r ->
            Thread(r, "sentinel-location-http").apply { isDaemon = true }
        }

        // Dedicated background thread for location callbacks
        locationHandlerThread = HandlerThread("sentinel-location-handler").apply { start() }
        locationHandler = Handler(locationHandlerThread!!.looper)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Extract JWT from intent or fall back to SharedPreferences (START_STICKY restart)
        jwt = intent?.getStringExtra("jwt") ?: getStoredJwt()

        if (jwt.isNullOrEmpty()) {
            Log.w(TAG, "No JWT available — stopping service")
            stopSelf()
            return START_NOT_STICKY
        }

        // Persist JWT for START_STICKY restart scenario
        storeJwt(jwt!!)

        // If already running, this is idempotent — just update JWT
        if (isRunning) {
            Log.d(TAG, "Service already running — JWT updated")
            return START_STICKY
        }

        isRunning = true
        startForegroundNotification()
        startLocationUpdates()

        return START_STICKY
    }

    private fun startForegroundNotification() {
        val tapIntent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }
        val pendingIntent = PendingIntent.getActivity(
            this, 0, tapIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Sentinel")
            .setContentText("Sentinel is tracking your location")
            .setContentIntent(pendingIntent)
            .setSmallIcon(R.drawable.ic_stat_sentinel)
            .setOngoing(true)
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .build()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            // API 29+ all use FOREGROUND_SERVICE_TYPE_LOCATION
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    private fun startLocationUpdates() {
        val locationRequest = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY, 30_000L
        )
            .setMinUpdateIntervalMillis(15_000L)
            .setMinUpdateDistanceMeters(0f)
            .build()

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                val location = result.lastLocation ?: return
                postLocation(location.latitude, location.longitude, location.accuracy)
            }
        }

        try {
            fusedLocationClient.requestLocationUpdates(
                locationRequest,
                locationCallback!!,
                locationHandler?.looper ?: android.os.Looper.getMainLooper()
            )
            Log.d(TAG, "Location updates started")
        } catch (e: SecurityException) {
            Log.e(TAG, "SecurityException starting location updates: ${e.message}")
            stopSelf()
        }
    }

    private fun postLocation(lat: Double, lng: Double, accuracy: Float) {
        val currentJwt = jwt ?: return
        val client = httpClient ?: return

        executor?.submit {
            // First, try to flush any buffered failed locations
            flushRetryBuffer(currentJwt, client)

            try {
                val json = JSONObject().apply {
                    put("lat", lat)
                    put("lng", lng)
                    put("accuracy", accuracy.toDouble())
                }

                val body = json.toString()
                    .toRequestBody("application/json; charset=utf-8".toMediaType())

                val request = Request.Builder()
                    .url("https://52.54.196.131/location")
                    .addHeader("Authorization", "Bearer $currentJwt")
                    .addHeader("Content-Type", "application/json")
                    .post(body)
                    .build()

                val response = client.newCall(request).execute()
                try {
                    when (response.code) {
                        200 -> {
                            Log.d(TAG, "Location posted: lat=$lat, lng=$lng")
                        }
                        401 -> {
                            Log.w(TAG, "JWT expired (401) — stopping service")
                            clearStoredJwt()
                            stopSelf()
                        }
                        else -> {
                            Log.w(TAG, "Location POST returned ${response.code}")
                            bufferFailedLocation(lat, lng, accuracy)
                        }
                    }
                } finally {
                    response.close()
                }
            } catch (e: Exception) {
                // Network error — buffer this location for retry
                Log.w(TAG, "Location POST failed: ${e.message}")
                bufferFailedLocation(lat, lng, accuracy)
            }
        }
    }

    private fun bufferFailedLocation(lat: Double, lng: Double, accuracy: Float) {
        synchronized(retryBuffer) {
            if (retryBuffer.size >= MAX_RETRY_BUFFER) {
                retryBuffer.removeAt(0) // Drop oldest
            }
            retryBuffer.add(LocationData(lat, lng, accuracy))
        }
    }

    private fun flushRetryBuffer(currentJwt: String, client: OkHttpClient) {
        val toRetry: List<LocationData>
        synchronized(retryBuffer) {
            if (retryBuffer.isEmpty()) return
            toRetry = retryBuffer.toList()
            retryBuffer.clear()
        }

        for (loc in toRetry) {
            try {
                val json = JSONObject().apply {
                    put("lat", loc.lat)
                    put("lng", loc.lng)
                    put("accuracy", loc.accuracy.toDouble())
                }

                val body = json.toString()
                    .toRequestBody("application/json; charset=utf-8".toMediaType())

                val request = Request.Builder()
                    .url("https://52.54.196.131/location")
                    .addHeader("Authorization", "Bearer $currentJwt")
                    .addHeader("Content-Type", "application/json")
                    .post(body)
                    .build()

                val response = client.newCall(request).execute()
                try {
                    if (response.code == 200) {
                        Log.d(TAG, "Buffered location flushed: lat=${loc.lat}, lng=${loc.lng}")
                    } else if (response.code == 401) {
                        clearStoredJwt()
                        stopSelf()
                        return
                    }
                } finally {
                    response.close()
                }
            } catch (e: Exception) {
                Log.w(TAG, "Retry POST failed: ${e.message}")
                // Re-buffer remaining items and stop retrying this batch
                synchronized(retryBuffer) {
                    retryBuffer.addAll(0, toRetry.subList(toRetry.indexOf(loc), toRetry.size))
                }
                return
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        isRunning = false

        // Stop location updates
        locationCallback?.let {
            fusedLocationClient.removeLocationUpdates(it)
        }
        locationCallback = null

        // Shut down the location handler thread
        locationHandlerThread?.quitSafely()
        locationHandlerThread = null
        locationHandler = null

        // Grab local references for background cleanup
        val execToShutdown = executor
        val clientToShutdown = httpClient
        
        executor = null
        httpClient = null

        Thread {
            // Shut down HTTP executor
            execToShutdown?.shutdown()
            try {
                if (execToShutdown?.awaitTermination(3, TimeUnit.SECONDS) == false) {
                    execToShutdown.shutdownNow()
                }
            } catch (_: InterruptedException) {
                execToShutdown?.shutdownNow()
            }

            // Clean up OkHttp resources
            clientToShutdown?.dispatcher?.executorService?.shutdown()
            clientToShutdown?.connectionPool?.evictAll()
        }.start()

        // NOTE: Do NOT clear JWT here. If the system killed us, START_STICKY
        // needs the persisted JWT to resume tracking on restart.
        // JWT is cleared in the right places:
        //   - On 401 auth failure (in postLocation)
        //   - On explicit logout (via clearJwt method channel from Flutter)

        Log.d(TAG, "Location service stopped and cleaned up")
    }

    // API 34+ timeout callback — system enforces ~6h limit for location FGS
    override fun onTimeout(startId: Int, fgsType: Int) {
        Log.w(TAG, "onTimeout called by system (FGS type=$fgsType) — stopping service")
        stopSelf()
    }

    override fun onTimeout(startId: Int) {
        Log.w(TAG, "onTimeout (legacy) called — stopping service")
        stopSelf()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    // --- Notification Channel ---

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Location tracking",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Shows when Sentinel is tracking your location"
                setShowBadge(false)
            }
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.createNotificationChannel(channel)
        }
    }

    // --- JWT Persistence (for START_STICKY restart) ---

    private fun getPrefs(): SharedPreferences {
        return getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    private fun storeJwt(token: String) {
        getPrefs().edit().putString(KEY_JWT, token).apply()
    }

    private fun getStoredJwt(): String? {
        return getPrefs().getString(KEY_JWT, null)
    }

    fun clearStoredJwt() {
        getPrefs().edit().remove(KEY_JWT).apply()
    }

    // --- OkHttp Client with Self-Signed Cert Trust ---

    // TODO: PRODUCTION — Replace trust-all-certs with proper certificate pinning.
    // This currently trusts any certificate for the dev server at 52.54.196.131.
    // For production, embed the server's public certificate and validate against it.
    private fun createHttpClient(): OkHttpClient {
        val trustManager = object : X509TrustManager {
            override fun checkClientTrusted(chain: Array<out X509Certificate>?, authType: String?) {}
            override fun checkServerTrusted(chain: Array<out X509Certificate>?, authType: String?) {}
            override fun getAcceptedIssuers(): Array<X509Certificate> = arrayOf()
        }

        val sslContext = SSLContext.getInstance("TLS")
        sslContext.init(null, arrayOf<TrustManager>(trustManager), SecureRandom())

        return OkHttpClient.Builder()
            .sslSocketFactory(sslContext.socketFactory, trustManager)
            .hostnameVerifier { hostname, _ ->
                // Only trust the specific IP
                hostname == "52.54.196.131"
            }
            .connectTimeout(10, TimeUnit.SECONDS)
            .readTimeout(10, TimeUnit.SECONDS)
            .writeTimeout(10, TimeUnit.SECONDS)
            .build()
    }
}
