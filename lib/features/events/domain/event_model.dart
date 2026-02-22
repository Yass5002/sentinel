// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sentinel/features/files/domain/file_model.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    String? message,
    @JsonKey(name: 'duration_ms') required int durationMs,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @Default(false) @JsonKey(name: 'checked_in') bool checkedIn,
    @Default(false) bool terminated,
    @Default(false) bool fired,
    @Default([]) List<EventContact> contacts,
    @Default([]) List<FileModel> attachments,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

@freezed
class EventContact with _$EventContact {
  const factory EventContact({
    required String id,
    @JsonKey(name: 'event_id') required String eventId,
    required String email,
    String? name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _EventContact;

  factory EventContact.fromJson(Map<String, dynamic> json) =>
      _$EventContactFromJson(json);
}

@freezed
class PaginatedEventResponse with _$PaginatedEventResponse {
  const factory PaginatedEventResponse({
    @Default([]) List<Event> events,
    @JsonKey(name: 'total_count') @Default(0) int totalCount,
    @Default(1) int page,
    @Default(20) int limit,
    @JsonKey(name: 'has_more') @Default(false) bool hasMore,
  }) = _PaginatedEventResponse;

  factory PaginatedEventResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginatedEventResponseFromJson(json);
}
