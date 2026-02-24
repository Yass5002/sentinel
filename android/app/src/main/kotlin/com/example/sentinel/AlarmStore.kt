package com.example.sentinel

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONObject

/**
 * Lightweight persistence layer for native AlarmManager alarms.
 * Stores alarm metadata in SharedPreferences so alarms can be
 * rescheduled after device reboot or package replacement.
 */
object AlarmStore {
    private const val PREFS_NAME = "sentinel_alarm_store"
    private const val KEY_ALARMS = "active_alarms"

    private fun prefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    data class AlarmData(
        val eventId: String,
        val eventName: String,
        val triggerAtMs: Long,
        val expiryEpochMs: Long,
        val notifChannelName: String? = null,
        val notifChannelDesc: String? = null,
        val notifTitle: String? = null,
        val notifBody: String? = null
    )

    fun save(context: Context, data: AlarmData) {
        val prefs = prefs(context)
        val json = prefs.getString(KEY_ALARMS, "{}") ?: "{}"
        val map = JSONObject(json)

        val entry = JSONObject().apply {
            put("eventName", data.eventName)
            put("triggerAtMs", data.triggerAtMs)
            put("expiryEpochMs", data.expiryEpochMs)
            put("notifChannelName", data.notifChannelName)
            put("notifChannelDesc", data.notifChannelDesc)
            put("notifTitle", data.notifTitle)
            put("notifBody", data.notifBody)
        }
        map.put(data.eventId, entry)

        prefs.edit().putString(KEY_ALARMS, map.toString()).apply()
    }

    fun remove(context: Context, eventId: String) {
        val prefs = prefs(context)
        val json = prefs.getString(KEY_ALARMS, "{}") ?: "{}"
        val map = JSONObject(json)
        map.remove(eventId)
        prefs.edit().putString(KEY_ALARMS, map.toString()).apply()
    }

    fun getAll(context: Context): List<AlarmData> {
        val prefs = prefs(context)
        val json = prefs.getString(KEY_ALARMS, "{}") ?: "{}"
        val map = JSONObject(json)
        val result = mutableListOf<AlarmData>()

        val keys = map.keys()
        while (keys.hasNext()) {
            val eventId = keys.next()
            val entry = map.getJSONObject(eventId)
            result.add(
                AlarmData(
                    eventId = eventId,
                    eventName = entry.getString("eventName"),
                    triggerAtMs = entry.getLong("triggerAtMs"),
                    expiryEpochMs = entry.getLong("expiryEpochMs"),
                    notifChannelName = entry.optString("notifChannelName", null),
                    notifChannelDesc = entry.optString("notifChannelDesc", null),
                    notifTitle = entry.optString("notifTitle", null),
                    notifBody = entry.optString("notifBody", null)
                )
            )
        }
        return result
    }

    fun clear(context: Context) {
        prefs(context).edit().remove(KEY_ALARMS).apply()
    }
}
