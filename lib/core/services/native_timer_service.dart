import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nativeTimerServiceProvider = Provider<NativeTimerService>((ref) {
  return NativeTimerService();
});

class NativeTimerService {
  static const MethodChannel _channel = MethodChannel('com.sentinel.app/timer');

  Future<bool> startCountdown({
    required String eventId,
    required String eventName,
    required DateTime triggerAt,
    required DateTime expiresAt,
    required Duration timeDelta,
    required String notificationChannelName,
    required String notificationChannelDesc,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    // IMPORTANT: Both timestamps are adjusted from server-time to device-local time
    // here on the Dart side. The native Kotlin code (SentinelTimerService) compares
    // these directly against System.currentTimeMillis() — no further adjustment needed.
    final adjustedTriggerAt = triggerAt.subtract(timeDelta);
    final triggerAtMs = adjustedTriggerAt.millisecondsSinceEpoch;

    final adjustedExpiresAt = expiresAt.subtract(timeDelta);
    final expiryEpochMs = adjustedExpiresAt.millisecondsSinceEpoch;

    try {
      final bool? result = await _channel.invokeMethod<bool>('startCountdown', {
        'eventId': eventId,
        'eventName': eventName,
        'triggerAtMs': triggerAtMs,
        'expiryEpochMs': expiryEpochMs,
        'notifChannelName': notificationChannelName,
        'notifChannelDesc': notificationChannelDesc,
        'notifTitle': notificationTitle,
        'notifBody': notificationBody,
      });
      return result ?? false;
    } on PlatformException {
      // Return false if failed due to SecurityException or other native error
      return false;
    }
  }

  Future<void> cancelCountdown(String eventId) async {
    try {
      await _channel.invokeMethod('cancelCountdown', {'eventId': eventId});
    } on PlatformException {
      // Log or ignore
    }
  }

  Future<void> cancelAll() async {
    try {
      await _channel.invokeMethod('cancelAll');
    } on PlatformException {
      // Log or ignore
    }
  }
}
