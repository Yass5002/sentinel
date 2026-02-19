import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/network/dio_client.dart';
import 'package:sentinel/features/auth/domain/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<void> sendOtp(String email) async {
    try {
      await _dio.post('/auth/otp/send', data: {'email': email});
    } on DioException catch (e) {
      // 429 is handled by UI/ViewModel usually, or we can rethrow
      if (e.response?.statusCode == 429) {
        throw Exception('Please wait before requesting another code.');
      }
      throw Exception(e.response?.data['error'] ?? 'Failed to send code');
    }
  }

  Future<(String?, String?)> verifyOtp({
    required String email,
    required String otp,
    required String name,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/otp/verify',
        data: {'email': email, 'otp': otp, 'name': name},
        options: Options(
          validateStatus: (status) {
            return true; // Accept ALL statuses to prevent DioException and global interceptors
          },
        ),
      );

      if (response.statusCode == 401) {
        return (null, 'Invalid or expired code.');
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        return (
          null,
          response.data['error']?.toString() ?? 'Verification failed',
        );
      }

      return (response.data['token'] as String?, null);
    } catch (e) {
      if (e is DioException) {
        return (
          null,
          e.response?.data['error']?.toString() ?? 'Verification failed',
        );
      }
      return (null, e.toString());
    }
  }

  Future<User?> getProfile() async {
    try {
      final response = await _dio.get(
        '/profile',
        options: Options(
          validateStatus: (status) => true, // Manual handling
        ),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
