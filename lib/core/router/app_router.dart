import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/storage/secure_storage_service.dart';
import 'package:sentinel/features/auth/presentation/login_screen.dart';
import 'package:sentinel/features/auth/presentation/otp_screen.dart';
import 'package:sentinel/features/auth/presentation/splash_screen.dart';
import 'package:sentinel/features/contacts/presentation/contacts_screen.dart';
import 'package:sentinel/features/events/presentation/create_event_screen.dart';
import 'package:sentinel/features/events/presentation/active_event_screen.dart';
import 'package:sentinel/features/events/presentation/event_detail_screen.dart';
import 'package:sentinel/features/home/presentation/home_screen.dart';
import 'package:sentinel/features/help/presentation/help_screen.dart';
import 'package:sentinel/features/profile/presentation/profile_screen.dart';
import 'package:sentinel/features/settings/presentation/settings_screen.dart';

// Global Navigator Key
final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) async {
      // Use the shared Riverpod-provided instance instead of creating a new one
      final storage = ref.read(secureStorageProvider);
      final token = await storage.getToken();
      final isLoggedIn = token != null;

      final path = state.uri.path;
      final isLoginRoute = path == '/login';
      final isOtpRoute = path == '/otp';
      final isSplashRoute = path == '/splash';

      if (isSplashRoute) return null; // Let splash handle its own logic

      if (!isLoggedIn && !isLoginRoute && !isOtpRoute) {
        return '/login';
      }

      if (isLoggedIn && (isLoginRoute || isOtpRoute)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final email = state.extra as String?;
          return OtpScreen(email: email ?? '');
        },
      ),
      GoRoute(
        path: '/create-event',
        builder: (context, state) => const CreateEventScreen(),
      ),
      GoRoute(
        path: '/event/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ActiveEventScreen(eventId: id);
        },
      ),
      GoRoute(
        path: '/history/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EventDetailScreen(eventId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(path: '/help', builder: (context, state) => const HelpScreen()),
      GoRoute(
        path: '/contacts',
        builder: (context, state) => const ContactsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
