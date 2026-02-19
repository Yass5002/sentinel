import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/core/router/app_router.dart';
import 'package:sentinel/core/storage/secure_storage_service.dart';
import 'package:sentinel/core/time/time_sync_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://52.54.196.131',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  final secureStorage = ref.read(secureStorageProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip auth for login/OTP endpoints
        if (!options.path.startsWith('/auth') && options.path != '/health') {
          final token = await secureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Global 401 Redirect Logic
        // Broad check to ensure we never redirect on auth-related 401s
        final uri = e.requestOptions.uri.toString().toLowerCase();
        final path = e.requestOptions.path.toLowerCase();

        final isAuthRelated =
            uri.contains('/auth') ||
            uri.contains('otp') ||
            uri.contains('login') ||
            uri.contains('profile') || // Profile fetch might fail on login
            path.contains('/auth') ||
            path.contains('otp') ||
            path.contains('login') ||
            path.contains('profile');

        if (e.response?.statusCode == 401 && !isAuthRelated) {
          await secureStorage.deleteToken();

          final context = rootNavigatorKey.currentContext;
          if (context != null && context.mounted) {
            GoRouter.of(context).go('/login');
          }
        }
      },
    ),
  );

  // Time Sync Interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) {
        final dateHeader = response.headers.value('date');
        if (dateHeader != null) {
          try {
            final serverTime = HttpDate.parse(dateHeader);
            ref.read(timeSyncProvider.notifier).syncWithServer(serverTime);
          } catch (e) {
            // Ignore parsing errors
          }
        }
        return handler.next(response);
      },
    ),
  );

  // Self-signed certificate handling
  // CRITCAL: We must trust the specific certificate for 52.54.196.131
  // For now, we allow the bad certificate callback if the host matches.
  // In a real production environment with a self-signed cert, we should embed the DER/PEM
  // and check against it. Since we don't have the file yet, we conditionally allow it for this IP.
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
          return host == '52.54.196.131';
        };
    return client;
  };

  return dio;
});
