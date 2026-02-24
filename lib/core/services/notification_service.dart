import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_sentinel');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Provide a callback if necessary
    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.createNotificationChannel(
        const AndroidNotificationChannel(
          'checkin_reminders',
          'Check-in reminders',
          description: 'Reminders before your event expires',
          importance: Importance.defaultImportance,
        ),
      );
    }

    _initialized = true;
  }

  Future<bool> _canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidImplementation == null) return false;

    try {
      final bool? canScheduleExact = await androidImplementation
          .canScheduleExactNotifications();
      return canScheduleExact ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> scheduleReminders({
    required String eventId,
    required String eventName,
    required DateTime expiresAt,
    required Duration timeDelta,
    required String title,
    required String alertTitle,
    required String hourBody,
    required String fifteenMinBody,
    required String fiveMinBody,
    required String firedBody,
  }) async {
    if (!_initialized) await init();

    // The current time Delta approach: adjust the target time
    final adjustedExpiresAt = expiresAt.subtract(timeDelta);
    final now = DateTime.now();

    final canExact = await _canScheduleExactAlarms();
    // Default to strict exact, or loosely inexact if disabled by OS
    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    const androidDetails = AndroidNotificationDetails(
      'checkin_reminders',
      'Check-in reminders',
      channelDescription: 'Reminders before your event expires',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    final baseId = eventId.hashCode.abs() % 100000000;

    // 1 hour
    final oneHourBefore = adjustedExpiresAt.subtract(const Duration(hours: 1));
    if (oneHourBefore.isAfter(now)) {
      await _scheduleThreshold(
        id: baseId + 0,
        time: oneHourBefore,
        mode: scheduleMode,
        details: notificationDetails,
        title: title,
        body: hourBody,
        payload: eventId,
      );
    }

    // 15 minutes
    final fifteenMinBefore = adjustedExpiresAt.subtract(
      const Duration(minutes: 15),
    );
    if (fifteenMinBefore.isAfter(now)) {
      await _scheduleThreshold(
        id: baseId + 1,
        time: fifteenMinBefore,
        mode: scheduleMode,
        details: notificationDetails,
        title: title,
        body: fifteenMinBody,
        payload: eventId,
      );
    }

    // 5 minutes
    final fiveMinBefore = adjustedExpiresAt.subtract(
      const Duration(minutes: 5),
    );
    if (fiveMinBefore.isAfter(now)) {
      await _scheduleThreshold(
        id: baseId + 2,
        time: fiveMinBefore,
        mode: scheduleMode,
        details: notificationDetails,
        title: title,
        body: fiveMinBody,
        payload: eventId,
      );
    }

    // 0 minutes (Timer Expired / Sentinel Fired)
    if (adjustedExpiresAt.isAfter(now)) {
      await _scheduleThreshold(
        id: baseId + 3,
        time: adjustedExpiresAt,
        mode: scheduleMode,
        details: notificationDetails,
        title: alertTitle,
        body: firedBody,
        payload: eventId,
      );
    }
  }

  Future<void> _scheduleThreshold({
    required int id,
    required DateTime time,
    required AndroidScheduleMode mode,
    required NotificationDetails details,
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(time, tz.local),
        notificationDetails: details,
        androidScheduleMode: mode,
        payload: payload,
      );
    } catch (e) {
      // Ignore scheduling errors silently to avoid app crashes
    }
  }

  Future<void> cancelReminders(String eventId) async {
    if (!_initialized) await init();
    final baseId = eventId.hashCode.abs() % 100000000;
    await _flutterLocalNotificationsPlugin.cancel(id: baseId + 0);
    await _flutterLocalNotificationsPlugin.cancel(id: baseId + 1);
    await _flutterLocalNotificationsPlugin.cancel(id: baseId + 2);
    await _flutterLocalNotificationsPlugin.cancel(id: baseId + 3);
  }

  Future<void> cancelAll() async {
    if (!_initialized) await init();
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
