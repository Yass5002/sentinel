import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentinel/features/contacts/data/contact_repository.dart';
import 'package:sentinel/features/contacts/domain/contact_model.dart';

part 'contacts_provider.g.dart';

@riverpod
class ContactsNotifier extends _$ContactsNotifier {
  @override
  FutureOr<List<Contact>> build() async {
    return ref.read(contactRepositoryProvider).getContacts();
  }

  Future<String?> addContact({
    required String email,
    required String name,
  }) async {
    try {
      final contact = await ref
          .read(contactRepositoryProvider)
          .addContact(email: email, name: name);
      final current = state.valueOrNull ?? [];
      state = AsyncValue.data([...current, contact]);
      return null; // success
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<String?> updateContact({
    required String id,
    required String email,
    required String name,
  }) async {
    try {
      final updated = await ref
          .read(contactRepositoryProvider)
          .updateContact(id: id, email: email, name: name);
      final current = state.valueOrNull ?? [];
      state = AsyncValue.data(
        current.map((c) => c.id == id ? updated : c).toList(),
      );
      return null; // success
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<String?> deleteContact(String id) async {
    try {
      await ref.read(contactRepositoryProvider).deleteContact(id);
      final current = state.valueOrNull ?? [];
      state = AsyncValue.data(current.where((c) => c.id != id).toList());
      return null; // success
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}
