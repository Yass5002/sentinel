import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  static const _keyJwt = 'jwt_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyJwt, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyJwt);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyJwt);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
