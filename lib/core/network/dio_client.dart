import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/network/api_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinel/core/router/app_router.dart';
import 'package:sentinel/core/storage/secure_storage_service.dart';
import 'package:sentinel/core/time/time_sync_provider.dart';
import 'package:sentinel/features/auth/presentation/auth_notifier.dart';
import 'package:flutter/material.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
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
        // Intercept HandshakeErrors (CERTIFICATE_VERIFY_FAILED) which indicate the
        // device clock is severely desynced or they are on a captive portal.
        if ((e.type == DioExceptionType.unknown ||
                e.type == DioExceptionType.connectionError ||
                e.type == DioExceptionType.badCertificate) &&
            e.error != null &&
            e.error.toString().contains('CERTIFICATE_VERIFY_FAILED')) {
          return handler.reject(
            e.copyWith(
              message:
                  "Your device's date and time are incorrect. Please update them in Settings to connect to Sentinel.",
            ),
          );
        }

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
          // Trigger the central logout teardown (clears tokens, stops services/timers/notifications)
          ref.read(authNotifierProvider.notifier).logout();

          final context = rootNavigatorKey.currentContext;
          if (context != null && context.mounted) {
            // Unfocus any active text inputs
            FocusScope.of(context).unfocus();

            // Pop any open dialogs, bottom sheets, or intermediate routes
            rootNavigatorKey.currentState?.popUntil((route) => route.isFirst);

            // Redirect context to login
            GoRouter.of(context).go('/login');
          }
        }

        return handler.next(e);
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

  return dio;
});
