import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/features/events/data/event_repository.dart';
import 'package:sentinel/features/events/domain/event_model.dart';

final eventDetailProvider = FutureProvider.family<Event, String>((
  ref,
  eventId,
) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEvent(eventId);
});
