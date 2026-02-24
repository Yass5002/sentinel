import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentinel/app.dart';
import 'package:sentinel/core/storage/preferences_service.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:sentinel/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timeago locales
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('es', timeago.EsMessages());
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('zh', timeago.ZhMessages());

  // Initialize SharedPrefs before app start
  final sharedPreferences = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(sharedPreferences)],
  );

  // Initialize local notifications
  await container.read(notificationServiceProvider).init();

  runApp(
    UncontrolledProviderScope(container: container, child: const SentinelApp()),
  );
}
