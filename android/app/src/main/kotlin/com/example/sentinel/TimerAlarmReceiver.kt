package com.example.sentinel

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.PowerManager
import android.util.Log
import androidx.core.content.ContextCompat

/**
 * Receives exact alarm broadcasts and starts the foreground countdown service.
 *
 * F4 Fix: The WakeLock is held as a companion object reference and released
 * by the SentinelTimerService AFTER startForeground() is called, preventing
 * the CPU from sleeping in the gap between startForegroundService() and
 * the service actually reaching startForeground().
 */
class TimerAlarmReceiver : BroadcastReceiver() {

    companion object {
        private var wakeLock: PowerManager.WakeLock? = null

        fun releaseReceiverWakeLock() {
            wakeLock?.let {
                if (it.isHeld) {
                    it.release()
                    Log.d("Sentinel", "Receiver WakeLock released by service")
                }
            }
            wakeLock = null
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        // F4: Acquire a partial wake lock — transferred to the service, not released here.
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "sentinel:alarm_receiver_wakelock"
        )
        // Safety timeout so the lock doesn't leak if the service fails to start
        wakeLock?.acquire(60 * 1000L)

        val expiryEpochMs = intent.getLongExtra("expiryEpochMs", 0L)
        val eventName = intent.getStringExtra("eventName") ?: context.getString(R.string.unknown_event)
        val eventId = intent.getStringExtra("eventId") ?: ""
        val notifChannelName = intent.getStringExtra("notifChannelName")
        val notifChannelDesc = intent.getStringExtra("notifChannelDesc")
        val notifTitle = intent.getStringExtra("notifTitle")
        val notifBody = intent.getStringExtra("notifBody")

        // Clean up the persisted alarm entry now that it has fired
        if (eventId.isNotEmpty()) {
            AlarmStore.remove(context, eventId)
        }

        val serviceIntent = Intent(context, SentinelTimerService::class.java).apply {
            action = SentinelTimerService.ACTION_START
            putExtra("expiryEpochMs", expiryEpochMs)
            putExtra("eventName", eventName)
            putExtra("eventId", eventId)
            putExtra("notifChannelName", notifChannelName)
            putExtra("notifChannelDesc", notifChannelDesc)
            putExtra("notifTitle", notifTitle)
            putExtra("notifBody", notifBody)
        }

        // Starting foreground service from exact alarm broadcast is allowed on API 31+.
        ContextCompat.startForegroundService(context, serviceIntent)

        // F4: Do NOT release the WakeLock here.
        // The SentinelTimerService will release it after calling startForeground().
    }
}
