import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentinel/core/storage/preferences_service.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/theme/text_style_helper.dart';
import 'package:sentinel/core/services/location_tracking_provider.dart';
import 'package:sentinel/core/widgets/custom_error_widget.dart';
import 'package:sentinel/features/events/presentation/event_providers.dart';
import 'package:sentinel/features/home/presentation/widgets/app_drawer.dart';
import 'package:sentinel/features/home/presentation/widgets/event_card.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/l10n/app_localizations.dart';
import 'package:sentinel/features/settings/locale_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runOnboardingSequence();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(eventListProvider);
      final l10n = AppLocalizations.of(context)!;
      ref
          .read(locationTrackingManagerProvider)
          .syncTrackingState(
            notifTitle: l10n.notifTrackingTitle,
            notifBody: l10n.notifTrackingBody,
            notifDesc: l10n.notifTrackingDesc,
          );
    }
  }

  /// Runs the onboarding sequence: notification primer → location primer.
  Future<void> _runOnboardingSequence() async {
    await _maybeShowNotificationOnboarding();
    if (!mounted) return;
    await _maybeShowLocationOnboarding();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ref
        .read(locationTrackingManagerProvider)
        .syncTrackingState(
          notifTitle: l10n.notifTrackingTitle,
          notifBody: l10n.notifTrackingBody,
          notifDesc: l10n.notifTrackingDesc,
        );
  }

  // --- Notification Onboarding (unchanged) ---

  Future<void> _maybeShowNotificationOnboarding() async {
    final prefs = ref.read(preferencesServiceProvider);
    if (prefs.hasShownNotificationOnboarding) return;

    final status = await Permission.notification.status;
    await prefs.setNotificationOnboardingShown();

    if (status.isGranted || status.isProvisional) {
      await prefs.setNotificationsEnabled(true);
      if (Platform.isAndroid) {
        final exactStatus = await Permission.scheduleExactAlarm.status;
        if (!exactStatus.isGranted) {
          await Permission.scheduleExactAlarm.request();
        }
      }
      return;
    }

    if (status.isPermanentlyDenied) {
      await prefs.setNotificationPermissionDismissedPermanently(true);
      await prefs.setNotificationsEnabled(false);
      return;
    }

    if (!mounted) return;
    final accepted = await _showPrimerDialog();

    if (!accepted) {
      await prefs.setNotificationsEnabled(false);
      return;
    }

    final newStatus = await Permission.notification.request();

    if (newStatus.isPermanentlyDenied) {
      await prefs.setNotificationPermissionDismissedPermanently(true);
      await prefs.setNotificationsEnabled(false);
    } else if (newStatus.isDenied) {
      await prefs.setNotificationPermissionDenied(true);
      await prefs.setNotificationsEnabled(false);
    } else if (newStatus.isGranted || newStatus.isProvisional) {
      await prefs.setNotificationsEnabled(true);
      if (Platform.isAndroid) {
        final exactStatus = await Permission.scheduleExactAlarm.status;
        if (!exactStatus.isGranted) {
          await Permission.scheduleExactAlarm.request();
        }
      }
    }
  }

  Future<bool> _showPrimerDialog() async {
    bool accepted = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          AppLocalizations.of(context)!.neverMissCheckIn,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.notificationPrimer,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              accepted = false;
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.notNow,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              accepted = true;
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.enableNotifications,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return accepted;
  }

  // --- Location Onboarding ---

  Future<void> _maybeShowLocationOnboarding() async {
    final prefs = ref.read(preferencesServiceProvider);
    if (prefs.hasShownLocationOnboarding) return;

    // Check if already granted
    final status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      await prefs.setLocationOnboardingShown();
      await _requestBackgroundLocationIfNeeded();
      return;
    }

    if (!mounted) return;
    final accepted = await _showLocationPrimerDialog();

    // Mark as shown regardless of outcome
    await prefs.setLocationOnboardingShown();

    if (!accepted) return;

    // Stage A: Request foreground location
    final locationStatus = await Permission.locationWhenInUse.request();
    if (!locationStatus.isGranted) return;

    // Stage B: Request background location (API 30+)
    if (!mounted) return;
    await _requestBackgroundLocationIfNeeded();
  }

  Future<void> _requestBackgroundLocationIfNeeded() async {
    if (!Platform.isAndroid) return;

    final bgStatus = await Permission.locationAlways.status;
    if (bgStatus.isGranted) return;

    if (!mounted) return;

    final proceed = await _showBackgroundLocationPrimerDialog();
    if (!proceed) return;

    await Permission.locationAlways.request();
  }

  Future<bool> _showLocationPrimerDialog() async {
    bool accepted = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          AppLocalizations.of(context)!.shareLocationTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.shareLocationBody,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              accepted = false;
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.notNow,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              accepted = true;
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.enableLocation,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return accepted;
  }

  Future<bool> _showBackgroundLocationPrimerDialog() async {
    bool accepted = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          AppLocalizations.of(context)!.allowBackgroundLocation,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.backgroundLocationBody,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              accepted = false;
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.skip,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              accepted = true;
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.continueText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return accepted;
  }

  @override
  Widget build(BuildContext context) {
    final eventListAsync = ref.watch(eventListProvider);

    // Sync tracking state when locale changes to update notification language
    ref.listen(localeNotifierProvider, (prev, next) {
      if (next != null) {
        final l10n = AppLocalizations.of(context)!;
        ref
            .read(locationTrackingManagerProvider)
            .syncTrackingState(
              notifTitle: l10n.notifTrackingTitle,
              notifBody: l10n.notifTrackingBody,
              notifDesc: l10n.notifTrackingDesc,
            );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            letterSpacing: TextStyleHelper.getLetterSpacing(context, 2.0),
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.push('/help'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.helpTitle.toUpperCase(),
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.0),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        backgroundColor: AppTheme.darkSurface,
        onRefresh: () async {
          await ref.read(eventListProvider.notifier).refresh();
        },
        child: eventListAsync.when(
          data: (events) {
            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'S',
                      style: TextStyle(
                        fontFamily: 'SentinelBrand',
                        fontSize: 80,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.noEventCreatedYet.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        letterSpacing: TextStyleHelper.getLetterSpacing(context, 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }
            final eventListNotifier = ref.read(eventListProvider.notifier);
            final hasMore = eventListNotifier.hasMore;
            final isLoadingMore = eventListNotifier.isLoadingMore;

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: events.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == events.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: isLoadingMore
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryColor,
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                ref
                                    .read(eventListProvider.notifier)
                                    .fetchNextPage();
                                // Trigger a rebuild to show the loading spinner immediately
                                setState(() {});
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.loadMore.toUpperCase(),
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: TextStyleHelper.getLetterSpacing(context, 2.0),
                                ),
                              ),
                            ),
                    ),
                  );
                }

                final event = events[index];
                return EventCard(
                  event: event,
                  onTap: () {
                    if (event.terminated || event.fired) {
                      context.push('/history/${event.id}');
                    } else {
                      context.push('/event/${event.id}');
                    }
                  },
                );
              },
            );
          },
          loading: () => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return Container(height: 100, color: AppTheme.darkSurface);
            },
          ),
          error: (err, stack) => CustomErrorWidget(
            message: AppLocalizations.of(context)!.failedToLoadEvents,
            onRetry: () => ref.read(eventListProvider.notifier).refresh(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/create-event');
        },
        backgroundColor: AppTheme.primaryColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: const Icon(Icons.add_sharp, color: Colors.white),
      ),
    );
  }
}
