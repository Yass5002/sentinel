import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/network/dio_client.dart';
import 'package:sentinel/features/events/domain/event_model.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return EventRepository(dio);
});

class EventRepository {
  final Dio _dio;

  EventRepository(this._dio);

  Future<Event> getEvent(String id) async {
    try {
      final response = await _dio.get('/events/$id');
      return Event.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['error'] ?? 'Failed to fetch event');
      }
      throw Exception('Failed to fetch event: $e');
    }
  }

  Future<PaginatedEventResponse> getEvents({
    String filter = 'all',
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/events',
        queryParameters: {'filter': filter, 'page': page, 'limit': limit},
      );

      return PaginatedEventResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        // If 404 (Not Found), it likely means no events exist yet. Return empty response.
        if (e.response?.statusCode == 404) {
          return const PaginatedEventResponse(events: [], hasMore: false);
        }
        throw Exception(e.response?.data['error'] ?? 'Failed to fetch events');
      }
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<Event> createEvent({
    required String name,
    String? message,
    required int durationMs,
    required List<Map<String, String>> contacts,
    List<String>? fileIds,
  }) async {
    try {
      final response = await _dio.post(
        '/events',
        data: {
          'name': name,
          'message': message,
          'duration_ms': durationMs,
          'contacts': contacts,
          'file_ids': fileIds,
        },
      );
      return Event.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['error'] ?? 'Failed to create event');
      }
      throw Exception('Failed to create event: $e');
    }
  }

  Future<void> checkIn(String eventId) async {
    try {
      await _dio.post('/events/$eventId/checkin');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['error'] ?? 'Failed to check in');
      }
      throw Exception('Failed to check in: $e');
    }
  }

  Future<void> cancelEvent(String eventId) async {
    try {
      await _dio.delete('/events/$eventId');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['error'] ?? 'Failed to cancel event');
      }
      throw Exception('Failed to cancel event: $e');
    }
  }

  Future<void> deleteEventHistory(String eventId) async {
    try {
      await _dio.delete('/events/$eventId/history');
    } catch (e) {
      if (e is DioException) {
        throw Exception(
          e.response?.data['error'] ?? 'Failed to delete event history',
        );
      }
      throw Exception('Failed to delete event history: $e');
    }
  }
}
