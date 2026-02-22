import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentinel/features/events/data/event_repository.dart';
import 'package:sentinel/features/events/domain/event_model.dart';

part 'event_providers.g.dart';

@riverpod
class EventList extends _$EventList {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  final int _limit = 20;

  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  @override
  FutureOr<List<Event>> build() async {
    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(_page);
  }

  Future<List<Event>> _fetchPage(int page) async {
    final repository = ref.read(eventRepositoryProvider);
    final response = await repository.getEvents(
      filter: 'all',
      page: page,
      limit: _limit,
    );

    _hasMore = response.hasMore;
    final events = List<Event>.from(response.events);

    final now = DateTime.now();

    events.sort((a, b) {
      final aIsActive =
          !a.terminated && !a.checkedIn && !a.fired && a.expiresAt.isAfter(now);
      final bIsActive =
          !b.terminated && !b.checkedIn && !b.fired && b.expiresAt.isAfter(now);

      if (aIsActive && !bIsActive) return -1;
      if (!aIsActive && bIsActive) return 1;

      if (aIsActive && bIsActive) {
        return a.expiresAt.compareTo(b.expiresAt);
      } else {
        return b.updatedAt.compareTo(a.updatedAt);
      }
    });

    return events;
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    // Notify listeners so UI can show loading indicator at the bottom if needed
    // However, riverpod state is AsyncValue<List<Event>> which doesn't easily let us change a side property
    // We will just fetch and append to the current data.

    try {
      final nextPage = _page + 1;
      final newEvents = await _fetchPage(nextPage);

      final currentEvents = state.value ?? [];

      // We must combine and sort again because the API sorting might not perfectly match
      // the client side sort exactly across pages, though ideally it should.
      // For simplicity, we just append and sort the whole list again.
      final combined = [...currentEvents, ...newEvents];

      final now = DateTime.now();
      combined.sort((a, b) {
        final aIsActive =
            !a.terminated &&
            !a.checkedIn &&
            !a.fired &&
            a.expiresAt.isAfter(now);
        final bIsActive =
            !b.terminated &&
            !b.checkedIn &&
            !b.fired &&
            b.expiresAt.isAfter(now);

        if (aIsActive && !bIsActive) return -1;
        if (!aIsActive && bIsActive) return 1;

        if (aIsActive && bIsActive) {
          return a.expiresAt.compareTo(b.expiresAt);
        } else {
          return b.updatedAt.compareTo(a.updatedAt);
        }
      });

      _page = nextPage;
      state = AsyncValue.data(combined);
    } catch (e) {
      // Don't overwrite the whole state with error, just keep the current data
      // the UI can handle the error or we just silently fail and let them try again.
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> deleteHistory(String eventId) async {
    try {
      await ref.read(eventRepositoryProvider).deleteEventHistory(eventId);
      state.whenData((events) {
        state = AsyncValue.data(events.where((e) => e.id != eventId).toList());
      });
    } catch (e) {
      // Re-throw to allow caller to show an error message.
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
    state = await AsyncValue.guard(() => _fetchPage(_page));
  }
}
