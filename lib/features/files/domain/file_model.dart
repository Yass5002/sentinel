// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_model.freezed.dart';
part 'file_model.g.dart';

@freezed
class FileModel with _$FileModel {
  const factory FileModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'event_id') String? eventId,
    required String key,
    required String filename,
    @JsonKey(name: 'file_size') required int fileSize,
    @JsonKey(name: 'mime_type') required String mimeType,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _FileModel;

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);
}
