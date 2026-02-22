import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/core/storage/preferences_service.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/services/notification_service.dart';
import 'package:sentinel/core/services/native_timer_service.dart';
import 'package:sentinel/core/services/native_location_service.dart';
import 'package:sentinel/core/services/location_tracking_provider.dart';
import 'package:sentinel/core/storage/secure_storage_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:sentinel/features/auth/presentation/auth_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  bool _osNotificationPermissionGranted = false;
  bool _osLocationPermissionGranted = false;
  bool _isDeletingAccount = false;
  String? _deleteAccountError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkOsPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkOsPermissions();
    }
  }

  Future<void> _checkOsPermissions() async {
    await _checkOsNotificationPermission();
    await _checkOsLocationPermission();
  }

  Future<void> _checkOsNotificationPermission() async {
    final status = await Permission.notification.status;
    final granted = status.isGranted || status.isProvisional;

    final prefs = ref.read(preferencesServiceProvider);
    bool prefsChanged = false;

    if (!granted && prefs.notificationsEnabled) {
      await prefs.setNotificationsEnabled(false);
      prefsChanged = true;
    }

    if (mounted &&
        (granted != _osNotificationPermissionGranted || prefsChanged)) {
      setState(() {
        _osNotificationPermissionGranted = granted;
      });
    }
  }

  Future<void> _checkOsLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    final granted = status.isGranted;

    final prefs = ref.read(preferencesServiceProvider);
    bool prefsChanged = false;

    if (!granted && prefs.locationTrackingEnabled) {
      await prefs.setLocationTrackingEnabled(false);
      prefsChanged = true;
    }

    if (mounted && (granted != _osLocationPermissionGranted || prefsChanged)) {
      setState(() {
        _osLocationPermissionGranted = granted;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Log out', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _performLogout();
            },
            child: const Text(
              'Log out',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    // Cancel all notifications and native timers
    try {
      await ref.read(notificationServiceProvider).cancelAll();
      await ref.read(nativeTimerServiceProvider).cancelAll();
    } catch (_) {}

    // Stop location tracking
    try {
      await ref.read(nativeLocationServiceProvider).stopTracking();
    } catch (_) {}

    // Clear JWT
    await ref.read(secureStorageProvider).deleteToken();

    if (mounted) {
      context.go('/login');
    }
  }

  Future<void> _handleDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _isDeletingAccount = true;
        _deleteAccountError = null;
      });

      try {
        await ref.read(authNotifierProvider.notifier).deleteAccount();
        // Successful teardown handles routing automatically via auth state listener
      } catch (e) {
        if (mounted) {
          setState(() {
            _deleteAccountError = 'Failed to delete account. Please try again.';
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isDeletingAccount = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesServiceProvider);
    final isNotifEnabled = prefs.notificationsEnabled;
    final isLocationEnabled = prefs.locationTrackingEnabled;

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
          // --- NOTIFICATIONS ---
          _buildSectionHeader('NOTIFICATIONS'),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Check-in reminders',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Get alerted 1h, 15m, and 5m before your Sentinels expire.',
              style: TextStyle(color: Colors.grey),
            ),
            value: isNotifEnabled,
            activeThumbColor: AppTheme.primaryColor,
            onChanged: (val) async {
              if (val) {
                if (_osNotificationPermissionGranted) {
                  await prefs.setNotificationsEnabled(true);
                } else {
                  final status = await Permission.notification.request();
                  if (status.isGranted || status.isProvisional) {
                    await prefs.setNotificationsEnabled(true);
                    _checkOsNotificationPermission();
                  } else if (status.isPermanentlyDenied) {
                    openAppSettings();
                  }
                }
              } else {
                await prefs.setNotificationsEnabled(false);
                await ref.read(notificationServiceProvider).cancelAll();
                await ref.read(nativeTimerServiceProvider).cancelAll();
              }
              if (mounted) setState(() {});
            },
          ),

          const SizedBox(height: 32),

          // --- LOCATION ---
          _buildSectionHeader('LOCATION'),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Location tracking',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Share your location with emergency contacts while events are active.',
              style: TextStyle(color: Colors.grey),
            ),
            value: isLocationEnabled,
            activeThumbColor: AppTheme.primaryColor,
            onChanged: (val) async {
              if (val) {
                if (_osLocationPermissionGranted) {
                  await prefs.setLocationTrackingEnabled(true);
                  ref.read(locationTrackingManagerProvider).syncTrackingState();
                } else {
                  final status = await Permission.locationWhenInUse.request();
                  if (status.isGranted) {
                    await prefs.setLocationTrackingEnabled(true);
                    _checkOsLocationPermission();
                    ref
                        .read(locationTrackingManagerProvider)
                        .syncTrackingState();
                  } else if (status.isPermanentlyDenied) {
                    openAppSettings();
                  }
                }
              } else {
                await prefs.setLocationTrackingEnabled(false);
                await ref.read(nativeLocationServiceProvider).stopTracking();
              }
              if (mounted) setState(() {});
            },
          ),
          if (isLocationEnabled && !_osLocationPermissionGranted)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Location access is blocked by your device settings',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => openAppSettings(),
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'Open settings',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 32),

          // --- ACCOUNT ---
          _buildSectionHeader('ACCOUNT'),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: _showLogoutDialog,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.errorColor),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // --- DANGER ZONE ---
          _buildSectionHeader('DANGER ZONE'),
          const SizedBox(height: 16),
          if (_deleteAccountError != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                _deleteAccountError!,
                style: const TextStyle(
                  color: AppTheme.errorColor,
                  fontSize: 13,
                ),
              ),
            ),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: _isDeletingAccount ? null : _handleDeleteAccount,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.errorColor),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: _isDeletingAccount
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.errorColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Deleting...',
                          style: TextStyle(
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Delete Account',
                      style: TextStyle(
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 48),

          // --- ABOUT ---
          _buildSectionHeader('ABOUT'),
          const SizedBox(height: 16),
          _buildAboutLink('Privacy policy', 'https://sentinel.app/privacy'),
          const SizedBox(height: 16),
          _buildAboutLink('Terms of service', 'https://sentinel.app/terms'),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF666666),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  Widget _buildAboutLink(String label, String url) {
    return InkWell(
      onTap: () => launchUrlString(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.white.withValues(alpha: 0.3),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
