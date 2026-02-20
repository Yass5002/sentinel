import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/core/storage/preferences_service.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/services/notification_service.dart';
import 'package:sentinel/core/services/native_timer_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  bool _osPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkOsPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkOsPermission();
    }
  }

  Future<void> _checkOsPermission() async {
    final status = await Permission.notification.status;
    final granted = status.isGranted || status.isProvisional;

    // If OS denies, forcefully disable app preference.
    // However, if OS allows, we leave app preference alone (the user may want them off internally).
    final prefs = ref.read(preferencesServiceProvider);
    if (!granted && prefs.notificationsEnabled) {
      await prefs.setNotificationsEnabled(false);
    }

    if (mounted && granted != _osPermissionGranted) {
      setState(() {
        _osPermissionGranted = granted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesServiceProvider);
    final isEnabled = prefs.notificationsEnabled;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'SETTINGS',
          style: TextStyle(letterSpacing: 2.0, fontSize: 16),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'NOTIFICATIONS',
            style: TextStyle(
              color: Color(0xFF666666),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Check-in Reminders',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Get alerted 1h, 15m, and 5m before your Sentinels expire.',
              style: TextStyle(color: Colors.grey),
            ),
            value: isEnabled,
            activeThumbColor: AppTheme.primaryColor,
            onChanged: (val) async {
              if (val) {
                // Turning on: Check OS permission first
                if (_osPermissionGranted) {
                  // OS already allows, just enable internally
                  await prefs.setNotificationsEnabled(true);
                } else {
                  // Request OS permission
                  final status = await Permission.notification.request();
                  if (status.isGranted || status.isProvisional) {
                    await prefs.setNotificationsEnabled(true);
                    _checkOsPermission();
                  } else if (status.isPermanentlyDenied) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enable notifications in OS settings.',
                          ),
                        ),
                      );
                    }
                    openAppSettings();
                  }
                }
              } else {
                // F13: Turning off — cancel all existing scheduled notifications
                // and native countdown alarms so they don't fire after being disabled.
                await prefs.setNotificationsEnabled(false);
                await ref.read(notificationServiceProvider).cancelAll();
                await ref.read(nativeTimerServiceProvider).cancelAll();
              }
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
