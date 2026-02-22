import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/network/dio_client.dart';
import 'package:sentinel/features/files/domain/file_model.dart';
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'package:mime/mime.dart'; // For lookupMimeType
import 'package:path_provider/path_provider.dart';

final fileRepositoryProvider = Provider<FileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return FileRepository(dio);
});

class FileRepository {
  final Dio _dio;

  FileRepository(this._dio);

  Future<FileModel> uploadFile(File file) async {
    try {
      final filename = file.path.split('/').last;
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: filename,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post(
        '/files',
        data: formData,
        onSendProgress: (count, total) {
          // Progress could be exposed via a stream if needed
        },
      );

      return FileModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['error'] ?? 'Failed to upload file');
      }
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> deleteStagedFile(String id) async {
    try {
      await _dio.delete('/files/$id');
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) return; // Already gone
        throw Exception(e.response?.data['error'] ?? 'Failed to delete file');
      }
      throw Exception('Failed to delete file: $e');
    }
  }

  Future<File> downloadFile(
    String id,
    String filename, {
    void Function(int, int)? onProgress,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final savePath = '${tempDir.path}/$filename';

      if (await File(savePath).exists()) {
        return File(savePath);
      }

      await _dio.download(
        '/files/$id/download',
        savePath,
        onReceiveProgress: onProgress,
      );

      return File(savePath);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['error'] ?? 'Failed to download file');
      }
      throw Exception('Failed to download file: $e');
    }
  }
}
