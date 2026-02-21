import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel/core/network/dio_client.dart';
import 'package:sentinel/features/contacts/domain/contact_model.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ContactRepository(dio);
});

class ContactRepository {
  final Dio _dio;

  ContactRepository(this._dio);

  Future<List<Contact>> getContacts() async {
    final response = await _dio.get('/contacts');
    final List<dynamic> list = response.data['contacts'] ?? [];
    return list
        .map((e) => Contact.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Returns the created contact or throws.
  /// On 409, throws a message containing "duplicate".
  Future<Contact> addContact({
    required String email,
    required String name,
  }) async {
    try {
      final response = await _dio.post(
        '/contacts',
        data: {'email': email, 'name': name},
      );
      return Contact.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('A contact with this email already exists');
      }
      throw Exception(
        e.response?.data['error']?.toString() ?? 'Failed to add contact',
      );
    }
  }

  Future<Contact> updateContact({
    required String id,
    required String email,
    required String name,
  }) async {
    try {
      final response = await _dio.patch(
        '/contacts/$id',
        data: {'email': email, 'name': name},
      );
      return Contact.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('A contact with this email already exists');
      }
      if (e.response?.statusCode == 404) {
        throw Exception('Contact not found');
      }
      throw Exception(
        e.response?.data['error']?.toString() ?? 'Failed to update contact',
      );
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      await _dio.delete('/contacts/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Contact not found');
      }
      throw Exception(
        e.response?.data['error']?.toString() ?? 'Failed to delete contact',
      );
    }
  }
}
