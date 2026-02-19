// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  message: json['message'] as String?,
  durationMs: (json['duration_ms'] as num).toInt(),
  expiresAt: DateTime.parse(json['expires_at'] as String),
  checkedIn: json['checked_in'] as bool? ?? false,
  terminated: json['terminated'] as bool? ?? false,
  fired: json['fired'] as bool? ?? false,
  contacts:
      (json['contacts'] as List<dynamic>?)
          ?.map((e) => EventContact.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => FileModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'message': instance.message,
      'duration_ms': instance.durationMs,
      'expires_at': instance.expiresAt.toIso8601String(),
      'checked_in': instance.checkedIn,
      'terminated': instance.terminated,
      'fired': instance.fired,
      'contacts': instance.contacts,
      'attachments': instance.attachments,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$EventContactImpl _$$EventContactImplFromJson(Map<String, dynamic> json) =>
    _$EventContactImpl(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$EventContactImplToJson(_$EventContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event_id': instance.eventId,
      'email': instance.email,
      'name': instance.name,
      'created_at': instance.createdAt.toIso8601String(),
    };
