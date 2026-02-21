import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentinel/core/services/native_location_service.dart';
import 'package:sentinel/core/storage/preferences_service.dart';
import 'package:sentinel/features/events/data/event_repository.dart';
import 'package:sentinel/features/events/domain/event_model.dart';

/// Manages the location tracking service lifecycle based on active event count,
/// permissions, and user preferences.
///
/// Watches the event list and reacts to transitions:
///   0 → 1 active events → start tracking (if permission + toggle OK)
///   1 → 0 active events → stop tracking
///   App launch with active events → check isTracking, start if needed
final locationTrackingManagerProvider = Provider<LocationTrackingManager>((
  ref,
) {
  return LocationTrackingManager(ref);
});

class LocationTrackingManager {
  final Ref _ref;

  LocationTrackingManager(this._ref);

  /// Call this on app launch and whenever the event list changes.
  /// Evaluates the current state and starts/stops tracking as needed.
  Future<void> syncTrackingState() async {
    final locationService = _ref.read(nativeLocationServiceProvider);
    final prefs = _ref.read(preferencesServiceProvider);

    // Check if location tracking is enabled in settings
    if (!prefs.locationTrackingEnabled) {
      await locationService.stopTracking();
      return;
    }

    // Count active events — fetch from repository directly to avoid
    // race condition with eventListProvider's cached AsyncValue
    final activeCount = await _getActiveEventCount();

    if (activeCount > 0) {
      // Should be tracking — check if permission is granted
      final hasPermission = await _hasLocationPermission();
      if (hasPermission) {
        final alreadyTracking = await locationService.isTracking();
        if (!alreadyTracking) {
          await locationService.startTracking();
        }
      } else {
        dev.log(
          'syncTrackingState: $activeCount active events but no location permission',
          name: 'Location',
        );
      }
    } else {
      // No active events — stop tracking
      await locationService.stopTracking();
    }
  }

  /// Called when the active event count transitions from 0 → ≥1.
  /// Also checks active event count to avoid starting for nothing.
  Future<void> startTrackingIfAllowed() async {
    final prefs = _ref.read(preferencesServiceProvider);
    if (!prefs.locationTrackingEnabled) return;

    final hasPermission = await _hasLocationPermission();
    if (!hasPermission) return;

    // Verify there are actually active events before starting
    final activeCount = await _getActiveEventCount();
    if (activeCount <= 0) return;

    await _ref.read(nativeLocationServiceProvider).startTracking();
  }

  /// Called when all active events have ended
  Future<void> stopTracking() async {
    await _ref.read(nativeLocationServiceProvider).stopTracking();
  }

  Future<bool> _hasLocationPermission() async {
    if (!Platform.isAndroid) return false;
    // Use locationWhenInUse to match the permission requested in onboarding
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted;
  }

  Future<int> _getActiveEventCount() async {
    try {
      // Fetch events directly from the repository to avoid relying on
      // eventListProvider's cached AsyncValue, which may not be loaded yet.
      final repository = _ref.read(eventRepositoryProvider);
      final events = await repository.getEvents(filter: 'all');
      final now = DateTime.now();
      return events.where((e) => _isActive(e, now)).length;
    } catch (e) {
      dev.log('_getActiveEventCount failed: $e', name: 'Location');
      return 0;
    }
  }

  bool _isActive(Event e, DateTime now) {
    return !e.terminated &&
        !e.checkedIn &&
        !e.fired &&
        e.expiresAt.isAfter(now);
  }
}
