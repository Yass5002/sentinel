import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentinel/core/storage/preferences_service.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale? build() {
    final prefs = ref.watch(preferencesServiceProvider);
    final savedLocale = prefs.selectedLocale;
    if (savedLocale != null) {
      return Locale(savedLocale);
    }
    return null; // Null means system locale (handled by MaterialApp initially)
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = ref.read(preferencesServiceProvider);
    await prefs.setSelectedLocale(locale.languageCode);
  }
}
