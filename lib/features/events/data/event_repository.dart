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

  Future<List<Event>> getEvents({String filter = 'all'}) async {
    try {
      final response = await _dio.get(
        '/events',
        queryParameters: {'filter': filter},
      );

      final eventsData = response.data['events'];
      if (eventsData == null) {
        return [];
      }

      final List<dynamic> eventsJson = eventsData;
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      if (e is DioException) {
        // If 404 (Not Found), it likely means no events exist yet. Return empty list.
        if (e.response?.statusCode == 404) {
          return [];
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
}
