import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentinel/features/events/data/event_repository.dart';
import 'package:sentinel/features/events/domain/event_model.dart';

part 'event_providers.g.dart';

@riverpod
class EventList extends _$EventList {
  @override
  FutureOr<List<Event>> build() async {
    return _fetchEvents();
  }

  Future<List<Event>> _fetchEvents() async {
    final repository = ref.read(eventRepositoryProvider);
    // Fetch all events
    final events = await repository.getEvents(filter: 'all');

    // Sort: Active events first (soonest expiry), then Terminated (recent first)
    // Active = !terminated && !checkedIn && !fired && expiresAt > now
    // Actually, backend might handle some logic, but let's sort client side per spec.
    final now = DateTime.now();

    events.sort((a, b) {
      final aIsActive =
          !a.terminated && !a.checkedIn && !a.fired && a.expiresAt.isAfter(now);
      final bIsActive =
          !b.terminated && !b.checkedIn && !b.fired && b.expiresAt.isAfter(now);

      if (aIsActive && !bIsActive) return -1;
      if (!aIsActive && bIsActive) return 1;

      if (aIsActive && bIsActive) {
        // Both active: soonest expiry first
        return a.expiresAt.compareTo(b.expiresAt);
      } else {
        // Both inactive: newest updated/created first
        return b.updatedAt.compareTo(a.updatedAt);
      }
    });

    return events;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchEvents());
  }
}
