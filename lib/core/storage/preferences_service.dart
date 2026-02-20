import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesService(prefs);
});

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static const _keyThemeMode = 'theme_mode';
  static const _keyNotificationsEnabled = 'notifications_enabled';

  static const _keyNotificationPermissionDenied =
      'notification_permission_denied';
  static const _keyNotificationPermissionDeferred =
      'notification_permission_deferred';
  static const _keyNotificationPermissionDismissedPermanently =
      'notification_permission_dismissed_permanently';
  static const _keyDeferralCount = 'notification_deferral_count';

  ThemeMode getThemeMode() {
    final modeString = _prefs.getString(_keyThemeMode);
    if (modeString == 'ThemeMode.light') return ThemeMode.light;
    if (modeString == 'ThemeMode.dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_keyThemeMode, mode.toString());
  }

  // F12: Default to false — notifications are only enabled after explicit user consent.
  bool get notificationsEnabled =>
      _prefs.getBool(_keyNotificationsEnabled) ?? false;

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  bool get notificationPermissionDenied =>
      _prefs.getBool(_keyNotificationPermissionDenied) ?? false;
  Future<void> setNotificationPermissionDenied(bool value) async {
    await _prefs.setBool(_keyNotificationPermissionDenied, value);
  }

  bool get notificationPermissionDeferred =>
      _prefs.getBool(_keyNotificationPermissionDeferred) ?? false;
  Future<void> setNotificationPermissionDeferred(bool value) async {
    await _prefs.setBool(_keyNotificationPermissionDeferred, value);
  }

  bool get notificationPermissionDismissedPermanently =>
      _prefs.getBool(_keyNotificationPermissionDismissedPermanently) ?? false;
  Future<void> setNotificationPermissionDismissedPermanently(bool value) async {
    await _prefs.setBool(_keyNotificationPermissionDismissedPermanently, value);
  }

  int get deferralCount => _prefs.getInt(_keyDeferralCount) ?? 0;
  Future<void> incrementDeferralCount() async {
    final current = deferralCount;
    await _prefs.setInt(_keyDeferralCount, current + 1);
  }
}
