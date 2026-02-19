import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentinel/core/storage/secure_storage_service.dart';
import 'package:sentinel/features/auth/data/auth_repository.dart';
import 'package:sentinel/features/auth/domain/user_model.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<User?> build() async {
    final token = await ref.read(secureStorageProvider).getToken();
    if (token == null) return null;

    // Validate token by fetching profile
    try {
      return await ref.read(authRepositoryProvider).getProfile();
    } catch (e) {
      // Token likely invalid
      await ref.read(secureStorageProvider).deleteToken();
      return null;
    }
  }

  Future<void> login(String otp, String email) async {
    // NOTE: We intentionally do NOT set state = AsyncValue.loading() here.
    // Doing so would trigger a GoRouter redirect evaluation, which finds no
    // token (user isn't logged in yet) and kicks the user back to /login
    // before the verification even completes.
    //
    // Instead, errors are thrown so the OTP screen can catch them locally
    // and display an error message without affecting the global auth state.

    final name = _generateNameFromEmail(email);

    final (token, error) = await ref
        .read(authRepositoryProvider)
        .verifyOtp(email: email, otp: otp, name: name);

    if (error != null) {
      throw Exception(error);
    }

    if (token != null) {
      await ref.read(secureStorageProvider).saveToken(token);

      // Fetch profile to confirm and update state
      final user = await ref.read(authRepositoryProvider).getProfile();
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        throw Exception('Failed to load profile');
      }
    }
  }

  Future<void> logout() async {
    await ref.read(secureStorageProvider).deleteToken();
    state = const AsyncValue.data(null);
  }

  String _generateNameFromEmail(String email) {
    try {
      final localPart = email.split('@').first;
      final cleaned = localPart.replaceAll(RegExp(r'[._-]'), ' ');
      final titleCased = cleaned
          .split(' ')
          .map((word) {
            if (word.isEmpty) return '';
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          })
          .join(' ');
      return titleCased.trim();
    } catch (_) {
      return 'User';
    }
  }
}
