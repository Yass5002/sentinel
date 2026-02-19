// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileModelImpl _$$FileModelImplFromJson(Map<String, dynamic> json) =>
    _$FileModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      eventId: json['event_id'] as String?,
      key: json['key'] as String,
      filename: json['filename'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      mimeType: json['mime_type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$FileModelImplToJson(_$FileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'event_id': instance.eventId,
      'key': instance.key,
      'filename': instance.filename,
      'file_size': instance.fileSize,
      'mime_type': instance.mimeType,
      'created_at': instance.createdAt.toIso8601String(),
    };
