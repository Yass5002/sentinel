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

  Future<void> updateFCMToken(String token) async {
    try {
      await _dio.post('/user/device-token', data: {'deviceToken': token});
    } catch (e) {
      // Don't throw, this is a non-critical background operation
      print('Failed to update FCM token: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _dio.delete('/account');
    } catch (e) {
      if (e is DioException) {
        throw Exception(
          e.response?.data['error'] ?? 'Failed to delete account',
        );
      }
      throw Exception('Failed to delete account: $e');
    }
  }

  Future<void> sendOtp(String email) async {
    try {
      await _dio.post('/auth/otp/send', data: {'email': email});
    } on DioException catch (e) {
      // 429 is handled by UI/ViewModel usually, or we can rethrow
      if (e.response?.statusCode == 429) {
        throw Exception('Please wait before requesting another code.');
      }

      final errorMsg = (e.response?.data is Map)
          ? e.response?.data['error']?.toString()
          : e.message; // Let Dio interceptor messages pass cleanly

      throw Exception(errorMsg ?? 'Failed to send code');
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
        final errorMsg = (response.data is Map)
            ? response.data['error']?.toString()
            : null;
        return (null, errorMsg ?? 'Verification failed');
      }

      return (response.data['token'] as String?, null);
    } catch (e) {
      if (e is DioException) {
        final errorMsg = (e.response?.data is Map)
            ? e.response?.data['error']?.toString()
            : e.message;
        return (null, errorMsg ?? 'Verification failed');
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

  Future<void> updateProfile({required String name}) async {
    try {
      await _dio.patch('/profile', data: {'name': name});
    } on DioException catch (e) {
      final errorMsg = (e.response?.data is Map)
          ? e.response?.data['error']?.toString()
          : e.message;
      throw Exception(errorMsg ?? 'Failed to update profile');
    }
  }
}
