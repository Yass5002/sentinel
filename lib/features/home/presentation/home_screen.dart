import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentinel/core/storage/preferences_service.dart';
import 'package:sentinel/core/theme/app_theme.dart';
import 'package:sentinel/core/services/location_tracking_provider.dart';
import 'package:sentinel/features/events/presentation/event_providers.dart';
import 'package:sentinel/features/home/presentation/widgets/app_drawer.dart';
import 'package:sentinel/features/home/presentation/widgets/event_card.dart';
import 'package:go_router/go_router.dart';

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
      ref.read(locationTrackingManagerProvider).syncTrackingState();
    }
  }

  /// Runs the onboarding sequence: notification primer → location primer.
  Future<void> _runOnboardingSequence() async {
    await _maybeShowNotificationOnboarding();
    if (!mounted) return;
    await _maybeShowLocationOnboarding();
    if (!mounted) return;
    ref.read(locationTrackingManagerProvider).syncTrackingState();
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
        title: const Text(
          'Never Miss a Check-in',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Sentinel needs notification permissions to alert you before your '
          'Sentinels expire. Without this, you won\'t receive the crucial '
          '1hr, 15m, and 5m countdown alerts.',
          style: TextStyle(color: Colors.white70),
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
            child: const Text('Not Now', style: TextStyle(color: Colors.grey)),
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
            child: const Text(
              'Enable Notifications',
              style: TextStyle(color: Colors.white),
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
        title: const Text(
          'Share your location with contacts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'If you don\'t check in, Sentinel sends your last known '
          'location to your emergency contacts so they can find you. '
          'Location is only tracked while you have an active event.',
          style: TextStyle(color: Colors.white70),
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
            child: const Text('Not now', style: TextStyle(color: Colors.grey)),
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
            child: const Text(
              'Enable location',
              style: TextStyle(color: Colors.white),
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
        title: const Text(
          'Allow background location',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'For your safety, allow location access "All the time" '
          'on the next screen. This ensures tracking continues even '
          'when your phone is locked.',
          style: TextStyle(color: Colors.white70),
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
            child: const Text('Skip', style: TextStyle(color: Colors.grey)),
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
            child: const Text(
              'Continue',
              style: TextStyle(color: Colors.white),
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'SENTINEL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_sharp),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        backgroundColor: AppTheme.darkSurface,
        onRefresh: () async {
          ref.invalidate(eventListProvider);
          await ref.read(eventListProvider.future);
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
                      'NO EVENT CREATED YET',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
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
          error: (err, stack) => Center(
            child: Text(
              'Failed to load events',
              style: TextStyle(color: Colors.red.withValues(alpha: 0.7)),
            ),
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
