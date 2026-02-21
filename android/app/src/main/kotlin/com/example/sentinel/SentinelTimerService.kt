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
import java.util.Collections

class SentinelTimerService : Service() {

    private val CHANNEL_ID = "sentinel_countdown_channel"
    private val NOTIFICATION_ID = 1001
    private val handler = Handler(Looper.getMainLooper())
    private var wakeLock: PowerManager.WakeLock? = null

    // Default countdown duration — used as fallback if expiryEpochMs is missing
    private val countdownDurationMs = 5 * 60 * 1000L

    data class TimerEvent(val eventId: String, val eventName: String, val expiryEpochMs: Long)

    private val eventQueue = mutableListOf<TimerEvent>()

    companion object {
        const val ACTION_START = "ACTION_START"
        const val ACTION_CANCEL = "ACTION_CANCEL"
        var isRunning = false
            private set
    }

    override fun onCreate() {
        super.onCreate()
        isRunning = true
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action ?: ACTION_START
        val eventId = intent?.getStringExtra("eventId") ?: ""

        if (action == ACTION_CANCEL) {
            if (eventId.isNotEmpty()) {
                // Remove the specific event from the queue
                eventQueue.removeAll { it.eventId == eventId }
                if (eventQueue.isEmpty()) {
                    stopSelf()
                } else {
                    displayTopEvent()
                }
            }
            return START_NOT_STICKY
        }

        // Action is ACTION_START
        val expiryEpochMs = intent?.getLongExtra("expiryEpochMs", 0L) ?: 0L
        val eventName = intent?.getStringExtra("eventName") ?: "Unknown"

        if (eventId.isNotEmpty()) {
            val targetEpochMs = if (expiryEpochMs > 0L) {
                expiryEpochMs
            } else {
                System.currentTimeMillis() + countdownDurationMs
            }

            // Remove any existing entry for this eventId, then add the new one
            eventQueue.removeAll { it.eventId == eventId }
            eventQueue.add(TimerEvent(eventId, eventName, targetEpochMs))
            
            // Sort by soonest expiry (ascending)
            eventQueue.sortBy { it.expiryEpochMs }
        }

        displayTopEvent()

        // F4: Release the WakeLock transferred from TimerAlarmReceiver now that
        // startForeground() has been called and the service is guaranteed to run.
        TimerAlarmReceiver.releaseReceiverWakeLock()

        return START_NOT_STICKY
    }

    private fun displayTopEvent() {
        if (eventQueue.isEmpty()) {
            stopSelf()
            return
        }

        val topEvent = eventQueue.first()

        handler.removeCallbacksAndMessages(null)
        releaseWakeLock()

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
            .setContentTitle(topEvent.eventName)
            .setContentText("Emergency alerts will trigger when the timer reaches zero. Tap to check in.")
            .setContentIntent(pendingIntent)
            .setSmallIcon(R.drawable.ic_stat_sentinel)
            .setOngoing(true)
            .setUsesChronometer(true)
            .setChronometerCountDown(true)
            .setWhen(topEvent.expiryEpochMs)
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .build()

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

        val timeRemainingMs = Math.max(0L, topEvent.expiryEpochMs - System.currentTimeMillis())
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "sentinel:countdown_wakelock")
        wakeLock?.acquire(timeRemainingMs + 2000L) // +2s safety margin

        // When the countdown reaches zero, remove it from the queue and display the next one
        handler.postDelayed({
            eventQueue.remove(topEvent)
            displayTopEvent()
        }, timeRemainingMs)
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
        isRunning = false
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
