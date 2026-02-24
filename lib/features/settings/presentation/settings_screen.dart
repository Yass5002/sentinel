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
import 'package:sentinel/features/settings/locale_provider.dart';
import 'package:flag/flag.dart';
import 'package:sentinel/l10n/app_localizations.dart';

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
        title: Text(
          AppLocalizations.of(context)!.logOut,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          AppLocalizations.of(context)!.logOutConfirmBody,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _performLogout();
            },
            child: Text(
              AppLocalizations.of(context)!.logOut,
              style: const TextStyle(color: AppTheme.errorColor),
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
        title: Text(
          AppLocalizations.of(context)!.deleteAccount,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          AppLocalizations.of(context)!.deleteAccountConfirmBody,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: AppTheme.errorColor),
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
        if (mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _deleteAccountError = AppLocalizations.of(
              context,
            )!.failedToDeleteAccount;
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

  List<Map<String, dynamic>> _getLocalizedLanguages(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {'code': 'en', 'name': l10n.english, 'flag': FlagsCode.US},
      {'code': 'fr', 'name': l10n.french, 'flag': FlagsCode.FR},
      {'code': 'es', 'name': l10n.spanish, 'flag': FlagsCode.ES},
      {'code': 'ar', 'name': l10n.arabic, 'flag': FlagsCode.MA},
      {'code': 'zh', 'name': l10n.chinese, 'flag': FlagsCode.CN},
    ];
  }

  void _showLanguagePicker() {
    final l10n = AppLocalizations.of(context)!;
    final languages = _getLocalizedLanguages(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final locale = ref.watch(localeNotifierProvider);
            final currentCode = locale?.languageCode ?? 'en';

            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      l10n.language,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...languages.map((lang) {
                    final isSelected = currentCode == lang['code'];
                    return ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flag.fromCode(
                            lang['flag'],
                            height: 20,
                            width: 28,
                            borderRadius: 4,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            lang['name']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: AppTheme.primaryColor,
                            )
                          : null,
                      onTap: () async {
                        await ref
                            .read(localeNotifierProvider.notifier)
                            .setLocale(Locale(lang['code']!));
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesServiceProvider);
    final isNotifEnabled = prefs.notificationsEnabled;
    final isLocationEnabled = prefs.locationTrackingEnabled;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(letterSpacing: 2.0, fontSize: 16),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward_sharp
                : Icons.arrow_back_sharp,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- LANGUAGE ---
          _buildSectionHeader(
            AppLocalizations.of(context)!.language.toUpperCase(),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.appLanguage,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Consumer(
              builder: (context, ref, child) {
                final locale = ref.watch(localeNotifierProvider);
                final currentCode = locale?.languageCode ?? 'en';
                final languages = _getLocalizedLanguages(context);
                final lang = languages.firstWhere(
                  (lang) => lang['code'] == currentCode,
                  orElse: () => languages.first,
                );
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flag.fromCode(
                      lang['flag'],
                      height: 16,
                      width: 22,
                      borderRadius: 2,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lang['name']!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
            trailing: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_back_ios_sharp
                  : Icons.arrow_forward_ios_sharp,
              color: Colors.grey,
              size: 16,
            ),
            onTap: _showLanguagePicker,
          ),

          const SizedBox(height: 32),

          // --- NOTIFICATIONS ---
          _buildSectionHeader(AppLocalizations.of(context)!.notifications),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(
              AppLocalizations.of(context)!.checkInReminders,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.checkInRemindersSub,
              style: const TextStyle(color: Colors.grey),
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
          _buildSectionHeader(AppLocalizations.of(context)!.location),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(
              AppLocalizations.of(context)!.locationTracking,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.locationTrackingSub,
              style: const TextStyle(color: Colors.grey),
            ),
            value: isLocationEnabled,
            activeThumbColor: AppTheme.primaryColor,
            onChanged: (val) async {
              if (val) {
                if (_osLocationPermissionGranted) {
                  await prefs.setLocationTrackingEnabled(true);
                  final l10n = AppLocalizations.of(context)!;
                  ref
                      .read(locationTrackingManagerProvider)
                      .syncTrackingState(
                        notifTitle: l10n.notifTrackingTitle,
                        notifBody: l10n.notifTrackingBody,
                        notifDesc: l10n.notifTrackingDesc,
                      );
                } else {
                  final status = await Permission.locationWhenInUse.request();
                  if (status.isGranted) {
                    await prefs.setLocationTrackingEnabled(true);
                    _checkOsLocationPermission();
                    if (!context.mounted) return;
                    final l10n = AppLocalizations.of(context)!;
                    ref
                        .read(locationTrackingManagerProvider)
                        .syncTrackingState(
                          notifTitle: l10n.notifTrackingTitle,
                          notifBody: l10n.notifTrackingBody,
                          notifDesc: l10n.notifTrackingDesc,
                        );
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ).copyWith(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.locationBlocked,
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
                    child: Text(
                      AppLocalizations.of(context)!.openSettings,
                      style: const TextStyle(
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
          _buildSectionHeader(AppLocalizations.of(context)!.account),
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
              child: Text(
                AppLocalizations.of(context)!.logOut,
                style: const TextStyle(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // --- DANGER ZONE ---
          _buildSectionHeader(AppLocalizations.of(context)!.dangerZone),
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
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.errorColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.deleting,
                          style: const TextStyle(
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      AppLocalizations.of(context)!.deleteAccount,
                      style: const TextStyle(
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 48),

          // --- ABOUT ---
          _buildSectionHeader(AppLocalizations.of(context)!.about),
          const SizedBox(height: 16),
          _buildAboutLink(
            AppLocalizations.of(context)!.privacyPolicy,
            'https://sentinel.yssn.tech/privacy',
          ),
          const SizedBox(height: 16),
          _buildAboutLink(
            AppLocalizations.of(context)!.termsOfService,
            'https://sentinel.yssn.tech/terms',
          ),
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
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_back_ios_sharp
                  : Icons.arrow_forward_ios_sharp,
              color: Colors.white.withValues(alpha: 0.3),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
