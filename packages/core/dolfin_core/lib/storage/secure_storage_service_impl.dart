import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage_service.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId = 'user_id';

  SecureStorageServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<String?> getToken() => read(key: _keyAccessToken);

  @override
  Future<void> saveToken(String token) =>
      write(key: _keyAccessToken, value: token);

  @override
  Future<void> saveRefreshToken(String token) =>
      write(key: _keyRefreshToken, value: token);

  @override
  Future<String?> getRefreshToken() => read(key: _keyRefreshToken);

  @override
  Future<void> clearAllTokens() async {
    await delete(key: _keyAccessToken);
    await delete(key: _keyRefreshToken);
  }

  @override
  Future<void> saveUserId(String userId) =>
      write(key: _keyUserId, value: userId);

  @override
  Future<String?> getUserId() => read(key: _keyUserId);
}
