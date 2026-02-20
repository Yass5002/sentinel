package com.example.sentinel

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.sentinel.app/timer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startCountdown" -> {
                    val eventId = call.argument<String>("eventId")
                    val eventName = call.argument<String>("eventName") ?: "Unknown"
                    val triggerAtMs = call.argument<Number>("triggerAtMs")?.toLong()
                    val expiryEpochMs = call.argument<Number>("expiryEpochMs")?.toLong()
                    if (eventId != null && triggerAtMs != null && expiryEpochMs != null) {
                        scheduleAlarm(eventId, eventName, triggerAtMs, expiryEpochMs, result)
                    } else {
                        result.error("INVALID_ARGS", "Missing eventId, triggerAtMs, or expiryEpochMs", null)
                    }
                }
                "cancelCountdown" -> {
                    val eventId = call.argument<String>("eventId")
                    if (eventId != null) {
                        cancelAlarm(eventId)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGS", "Missing eventId", null)
                    }
                }
                "cancelAll" -> {
                    // F5: Cancel ALL pending AlarmManager alarms using persisted data,
                    // not just the currently-running service.
                    cancelAllAlarms()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun scheduleAlarm(eventId: String, eventName: String, triggerAtMs: Long, expiryEpochMs: Long, result: MethodChannel.Result) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (!alarmManager.canScheduleExactAlarms()) {
                Log.w("Sentinel", "Cannot schedule exact alarms! Skipping native countdown.")
                result.success(false)
                return
            }
        }

        val intent = Intent(context, TimerAlarmReceiver::class.java).apply {
            putExtra("eventId", eventId)
            putExtra("eventName", eventName)
            putExtra("expiryEpochMs", expiryEpochMs)
        }
        
        val requestCode = eventId.hashCode()

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        try {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                triggerAtMs,
                pendingIntent
            )

            // F1: Persist the alarm so it can be rescheduled after reboot
            AlarmStore.save(context, AlarmStore.AlarmData(
                eventId = eventId,
                eventName = eventName,
                triggerAtMs = triggerAtMs,
                expiryEpochMs = expiryEpochMs
            ))

            result.success(true)
        } catch (e: SecurityException) {
            Log.e("Sentinel", "SecurityException scheduling alarm: ${e.message}")
            result.success(false)
        }
    }

    private fun cancelAlarm(eventId: String) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, TimerAlarmReceiver::class.java)
        val requestCode = eventId.hashCode()

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        alarmManager.cancel(pendingIntent)

        // F1: Remove from persisted store
        AlarmStore.remove(context, eventId)
        
        val serviceIntent = Intent(context, SentinelTimerService::class.java)
        context.stopService(serviceIntent)
    }

    /**
     * F5: Cancel all pending AlarmManager alarms by iterating persisted alarm data,
     * then stop the foreground service and clear the store.
     */
    private fun cancelAllAlarms() {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val alarms = AlarmStore.getAll(context)

        for (alarm in alarms) {
            val intent = Intent(context, TimerAlarmReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                alarm.eventId.hashCode(),
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            alarmManager.cancel(pendingIntent)
        }

        AlarmStore.clear(context)

        val serviceIntent = Intent(context, SentinelTimerService::class.java)
        context.stopService(serviceIntent)
    }
}
