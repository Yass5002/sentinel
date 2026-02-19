import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/features/events/data/event_repository.dart';
import 'package:sentinel/features/events/domain/event_model.dart';
import 'package:sentinel/features/events/presentation/event_providers.dart';

class ActiveEventState {
  final AsyncValue<Event> event;
  final bool isCheckingIn;
  final bool isCancelling;

  const ActiveEventState({
    required this.event,
    this.isCheckingIn = false,
    this.isCancelling = false,
  });

  ActiveEventState copyWith({
    AsyncValue<Event>? event,
    bool? isCheckingIn,
    bool? isCancelling,
  }) {
    return ActiveEventState(
      event: event ?? this.event,
      isCheckingIn: isCheckingIn ?? this.isCheckingIn,
      isCancelling: isCancelling ?? this.isCancelling,
    );
  }
}

class ActiveEventNotifier extends StateNotifier<ActiveEventState> {
  final EventRepository _repository;
  final String _eventId;
  final Ref _ref;

  ActiveEventNotifier(this._repository, this._eventId, this._ref)
    : super(const ActiveEventState(event: AsyncValue.loading())) {
    _fetchEvent();
  }

  Future<void> _fetchEvent() async {
    try {
      final event = await _repository.getEvent(_eventId);
      state = state.copyWith(event: AsyncValue.data(event));
    } catch (e, st) {
      state = state.copyWith(event: AsyncValue.error(e, st));
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(event: const AsyncValue.loading());
    await _fetchEvent();
  }

  Future<bool> checkIn() async {
    state = state.copyWith(isCheckingIn: true);
    try {
      await _repository.checkIn(_eventId);
      // Refresh home list
      _ref.invalidate(eventListProvider);
      return true;
    } catch (e, st) {
      state = state.copyWith(
        isCheckingIn: false,
        event: AsyncValue.error(e, st),
      );
      return false;
    }
  }

  Future<bool> cancelEvent() async {
    state = state.copyWith(isCancelling: true);
    try {
      await _repository.cancelEvent(_eventId);
      // Refresh home list
      _ref.invalidate(eventListProvider);
      return true;
    } catch (e, st) {
      state = state.copyWith(
        isCancelling: false,
        event: AsyncValue.error(e, st),
      );
      return false;
    }
  }
}

final activeEventProvider =
    StateNotifierProvider.family<ActiveEventNotifier, ActiveEventState, String>(
      (ref, eventId) {
        final repository = ref.watch(eventRepositoryProvider);
        return ActiveEventNotifier(repository, eventId, ref);
      },
    );
