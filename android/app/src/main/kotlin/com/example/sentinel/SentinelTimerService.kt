package com.example.sentinel

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.content.pm.ServiceInfo
import android.util.Log
import androidx.core.app.NotificationCompat
import com.example.sentinel.R

class SentinelTimerService : Service() {

    private val CHANNEL_ID = "sentinel_countdown_channel"
    private val NOTIFICATION_ID = 1001
    private val handler = Handler(Looper.getMainLooper())
    private var wakeLock: PowerManager.WakeLock? = null

    // Default countdown duration — used as fallback if expiryEpochMs is missing
    private val countdownDurationMs = 5 * 60 * 1000L

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // F7: Always accept new intents — cancel old handler and replace the countdown.
        // This prevents silently swallowing a second Sentinel's countdown.
        handler.removeCallbacksAndMessages(null)
        releaseWakeLock()

        val expiryEpochMs = intent?.getLongExtra("expiryEpochMs", 0L) ?: 0L
        val eventName = intent?.getStringExtra("eventName") ?: "Unknown"

        // If the old pending intent fires and lacks the extra (yielding 0L),
        // fall back to currentTimeMillis() + 5 minutes to prevent the 1970 bug.
        val targetEpochMs = if (expiryEpochMs > 0L) {
            expiryEpochMs
        } else {
            System.currentTimeMillis() + countdownDurationMs
        }

        val tapIntent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }
        val pendingIntent = android.app.PendingIntent.getActivity(
            this,
            0,
            tapIntent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(eventName)
            .setContentText("Emergency alerts will trigger when the timer reaches zero. Tap to check in.")
            .setContentIntent(pendingIntent)
            .setSmallIcon(R.drawable.ic_stat_sentinel)
            .setOngoing(true)
            .setUsesChronometer(true)
            .setChronometerCountDown(true)
            .setWhen(targetEpochMs)
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .build()

        // F3: Use specialUse instead of shortService to avoid the 3-minute hard kill limit.
        // shortService is limited to ~3 minutes on Android 14+, but our countdown is 5 minutes.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            if (Build.VERSION.SDK_INT >= 34) {
                startForeground(
                    NOTIFICATION_ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE
                )
            } else {
                startForeground(
                    NOTIFICATION_ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_NONE
                )
            }
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }

        // F4: Release the WakeLock transferred from TimerAlarmReceiver now that
        // startForeground() has been called and the service is guaranteed to run.
        TimerAlarmReceiver.releaseReceiverWakeLock()

        // F6: Acquire a WakeLock for the countdown duration to prevent Doze mode
        // from suspending handler.postDelayed (which uses uptimeMillis internally).
        val timeRemainingMs = Math.max(0L, targetEpochMs - System.currentTimeMillis())
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "sentinel:countdown_wakelock")
        wakeLock?.acquire(timeRemainingMs + 2000L) // +2s safety margin

        // Stop itself precisely when the countdown reaches zero
        handler.postDelayed({
            stopSelf()
        }, timeRemainingMs)

        return START_NOT_STICKY
    }

    // F3: Safety net for Android 14+ — if the system determines we've exceeded
    // the foreground service time limit, we must stop immediately to avoid ANR.
    override fun onTimeout(startId: Int, fgsType: Int) {
        Log.w("Sentinel", "onTimeout called by system — stopping service to prevent ANR")
        stopSelf()
    }

    override fun onTimeout(startId: Int) {
        Log.w("Sentinel", "onTimeout (legacy) called — stopping service")
        stopSelf()
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacksAndMessages(null)
        releaseWakeLock()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun releaseWakeLock() {
        wakeLock?.let {
            if (it.isHeld) it.release()
        }
        wakeLock = null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Sentinel Countdown"
            val descriptionText = "Displays the active countdown timer"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}
