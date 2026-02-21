package com.example.sentinel

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

/**
 * Reschedules all persisted native alarms after device reboot or package replacement.
 * Without this, AlarmManager alarms are lost on reboot — the most critical lifecycle gap.
 */
class BootCompletedReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED &&
            intent.action != Intent.ACTION_MY_PACKAGE_REPLACED &&
            intent.action != "android.intent.action.QUICKBOOT_POWERON" &&
            intent.action != "com.htc.intent.action.QUICKBOOT_POWERON") {
            return
        }

        Log.d("Sentinel", "Boot/package-replace detected — rescheduling native alarms")

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val now = System.currentTimeMillis()

        // Check if we can schedule exact alarms (Android 12+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (!alarmManager.canScheduleExactAlarms()) {
                Log.w("Sentinel", "Cannot schedule exact alarms after reboot, skipping.")
                return
            }
        }

        val alarms = AlarmStore.getAll(context)
        for (alarm in alarms) {
            // Skip alarms whose trigger time has already passed
            if (alarm.triggerAtMs <= now) {
                // Also skip if the expiry itself has passed (event is fully expired)
                if (alarm.expiryEpochMs <= now) {
                    AlarmStore.remove(context, alarm.eventId)
                    continue
                }
                // Trigger time passed but expiry hasn't — start the service immediately
                val serviceIntent = Intent(context, SentinelTimerService::class.java).apply {
                    putExtra("expiryEpochMs", alarm.expiryEpochMs)
                    putExtra("eventName", alarm.eventName)
                }
                androidx.core.content.ContextCompat.startForegroundService(context, serviceIntent)
                AlarmStore.remove(context, alarm.eventId)
                continue
            }

            // Re-schedule the alarm
            val alarmIntent = Intent(context, TimerAlarmReceiver::class.java).apply {
                putExtra("eventId", alarm.eventId)
                putExtra("eventName", alarm.eventName)
                putExtra("expiryEpochMs", alarm.expiryEpochMs)
            }

            val pendingIntent = PendingIntent.getBroadcast(
                context,
                alarm.eventId.hashCode(),
                alarmIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            try {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    alarm.triggerAtMs,
                    pendingIntent
                )
                Log.d("Sentinel", "Rescheduled alarm for event: ${alarm.eventId}")
            } catch (e: SecurityException) {
                Log.e("Sentinel", "SecurityException rescheduling alarm: ${e.message}")
                AlarmStore.remove(context, alarm.eventId)
            }
        }


    }
}
