import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentinel/core/storage/preferences_service.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    // Load initial state from preferences
    final prefs = ref.watch(preferencesServiceProvider);
    return prefs.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(preferencesServiceProvider);
    await prefs.setThemeMode(mode);
  }
}
