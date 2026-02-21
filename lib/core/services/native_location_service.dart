import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/storage/secure_storage_service.dart';
import 'package:sentinel/core/network/api_constants.dart';

final nativeLocationServiceProvider = Provider<NativeLocationService>((ref) {
  return NativeLocationService(ref);
});

class NativeLocationService {
  static const MethodChannel _channel = MethodChannel(
    'com.sentinel.app/location',
  );

  final Ref _ref;

  NativeLocationService(this._ref);

  /// Reads JWT from secure storage and starts the native location service.
  /// Idempotent — safe to call if already tracking.
  Future<void> startTracking() async {
    final jwt = await _ref.read(secureStorageProvider).getToken();
    if (jwt == null || jwt.isEmpty) {
      dev.log('startTracking: No JWT available — skipping', name: 'Location');
      return;
    }

    try {
      await _channel.invokeMethod('startTracking', {
        'jwt': jwt,
        'baseUrl': ApiConstants.baseUrl,
      });
    } on PlatformException catch (e) {
      dev.log('startTracking failed: ${e.message}', name: 'Location');
    }
  }

  /// Stops the native location service. Idempotent.
  Future<void> stopTracking() async {
    try {
      await _channel.invokeMethod('stopTracking');
    } on PlatformException catch (e) {
      dev.log('stopTracking failed: ${e.message}', name: 'Location');
    }
  }

  /// Returns whether the native location service is currently running.
  Future<bool> isTracking() async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('isTracking');
      return result ?? false;
    } on PlatformException catch (e) {
      dev.log('isTracking failed: ${e.message}', name: 'Location');
      return false;
    }
  }
}
