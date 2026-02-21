import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentinel/features/auth/data/auth_repository.dart';
import 'package:sentinel/features/auth/domain/user_model.dart';
import 'package:sentinel/features/auth/presentation/auth_notifier.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  FutureOr<User?> build() async {
    return ref.read(authRepositoryProvider).getProfile();
  }

  Future<String?> updateName(String name) async {
    try {
      await ref.read(authRepositoryProvider).updateProfile(name: name);
      // Refresh profile data
      final updated = await ref.read(authRepositoryProvider).getProfile();
      if (updated != null) {
        state = AsyncValue.data(updated);
        // Also refresh the auth notifier so drawer/header picks up the name
        ref.invalidate(authNotifierProvider);
      }
      return null; // success
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}
