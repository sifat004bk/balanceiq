import 'package:dolfin_core/storage/secure_storage_service_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple Manual Mock for FlutterSecureStorage (implements only needed methods)
class MockFlutterSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> delete(
      {required String key,
      IOSOptions? iOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions,
      WindowsOptions? wOptions,
      WebOptions? webOptions,
      MacOsOptions? mOptions}) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll(
      {IOSOptions? iOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions,
      WindowsOptions? wOptions,
      WebOptions? webOptions,
      MacOsOptions? mOptions}) async {
    _storage.clear();
  }

  @override
  Future<String?> read(
      {required String key,
      IOSOptions? iOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions,
      WindowsOptions? wOptions,
      WebOptions? webOptions,
      MacOsOptions? mOptions}) async {
    return _storage[key];
  }

  @override
  Future<void> write(
      {required String key,
      required String? value,
      IOSOptions? iOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions,
      WindowsOptions? wOptions,
      WebOptions? webOptions,
      MacOsOptions? mOptions}) async {
    if (value != null) {
      _storage[key] = value;
    }
  }
}

void main() {
  group('SecureStorageServiceImpl', () {
    late SecureStorageServiceImpl storageService;
    late MockFlutterSecureStorage mockStorage;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      storageService = SecureStorageServiceImpl(storage: mockStorage);
    });

    group('Basic Operations', () {
      test('read should return value from storage', () async {
        // Arrange
        const key = 'test_key';
        const value = 'test_value';
        await mockStorage.write(key: key, value: value);

        // Act
        final result = await storageService.read(key: key);

        // Assert
        expect(result, equals(value));
      });

      test('read should return null when key does not exist', () async {
        // Arrange
        const key = 'nonexistent_key';

        // Act
        final result = await storageService.read(key: key);

        // Assert
        expect(result, isNull);
      });

      test('write should save value to storage', () async {
        // Arrange
        const key = 'test_key';
        const value = 'test_value';

        // Act
        await storageService.write(key: key, value: value);

        // Assert - verify by reading back
        final readValue = await mockStorage.read(key: key);
        expect(readValue, equals(value));
      });

      test('delete should remove value from storage', () async {
        // Arrange
        const key = 'test_key';
        const value = 'test_value';
        await mockStorage.write(key: key, value: value);
        expect(await mockStorage.read(key: key), equals(value));

        // Act
        await storageService.delete(key: key);

        // Assert
        final result = await mockStorage.read(key: key);
        expect(result, isNull);
      });

      test('deleteAll should clear all storage', () async {
        // Arrange
        await mockStorage.write(key: 'key1', value: 'value1');
        await mockStorage.write(key: 'key2', value: 'value2');

        // Act
        await storageService.deleteAll();

        // Assert
        final val1 = await mockStorage.read(key: 'key1');
        final val2 = await mockStorage.read(key: 'key2');
        expect(val1, isNull);
        expect(val2, isNull);
      });
    });

    group('Token Management', () {
      test('getToken should read access token', () async {
        // Arrange
        const token = 'access_token_123';
        await mockStorage.write(key: 'access_token', value: token);

        // Act
        final result = await storageService.getToken();

        // Assert
        expect(result, equals(token));
      });

      test('saveToken should write access token', () async {
        // Arrange
        const token = 'new_access_token';

        // Act
        await storageService.saveToken(token);

        // Assert
        final result = await mockStorage.read(key: 'access_token');
        expect(result, equals(token));
      });

      test('getRefreshToken should read refresh token', () async {
        // Arrange
        const token = 'refresh_token_123';
        await mockStorage.write(key: 'refresh_token', value: token);

        // Act
        final result = await storageService.getRefreshToken();

        // Assert
        expect(result, equals(token));
      });

      test('saveRefreshToken should write refresh token', () async {
        // Arrange
        const token = 'new_refresh_token';

        // Act
        await storageService.saveRefreshToken(token);

        // Assert
        final result = await mockStorage.read(key: 'refresh_token');
        expect(result, equals(token));
      });

      test('clearAllTokens should delete both access and refresh tokens',
          () async {
        // Arrange
        await mockStorage.write(key: 'access_token', value: 'access_123');
        await mockStorage.write(key: 'refresh_token', value: 'refresh_123');
        expect(await mockStorage.read(key: 'access_token'), isNotNull);
        expect(await mockStorage.read(key: 'refresh_token'), isNotNull);

        // Act
        await storageService.clearAllTokens();

        // Assert
        expect(await mockStorage.read(key: 'access_token'), isNull);
        expect(await mockStorage.read(key: 'refresh_token'), isNull);
      });
    });

    group('User ID Management', () {
      test('getUserId should read user ID', () async {
        // Arrange
        const userId = 'user_123';
        await mockStorage.write(key: 'user_id', value: userId);

        // Act
        final result = await storageService.getUserId();

        // Assert
        expect(result, equals(userId));
      });

      test('saveUserId should write user ID', () async {
        // Arrange
        const userId = 'user_456';

        // Act
        await storageService.saveUserId(userId);

        // Assert
        final result = await mockStorage.read(key: 'user_id');
        expect(result, equals(userId));
      });
    });

    group('Integration Scenarios', () {
      test('should handle complete auth flow', () async {
        // Arrange
        const userId = 'user_123';
        const accessToken = 'access_token_abc';
        const refreshToken = 'refresh_token_xyz';

        // Act - Login (save all auth data)
        await storageService.saveUserId(userId);
        await storageService.saveToken(accessToken);
        await storageService.saveRefreshToken(refreshToken);

        // Assert
        expect(await mockStorage.read(key: 'user_id'), equals(userId));
        expect(
            await mockStorage.read(key: 'access_token'), equals(accessToken));
        expect(
            await mockStorage.read(key: 'refresh_token'), equals(refreshToken));
      });

      test('should handle logout flow', () async {
        // Arrange
        await mockStorage.write(key: 'access_token', value: 'token_abc');
        await mockStorage.write(key: 'refresh_token', value: 'token_xyz');

        // Act - Logout (clear all tokens)
        await storageService.clearAllTokens();

        // Assert
        expect(await mockStorage.read(key: 'access_token'), isNull);
        expect(await mockStorage.read(key: 'refresh_token'), isNull);
      });

      test('should handle token refresh flow', () async {
        // Arrange
        const oldToken = 'old_access_token';
        const newToken = 'new_access_token';
        await mockStorage.write(key: 'access_token', value: oldToken);

        // Act
        final currentToken = await storageService.getToken();
        expect(currentToken, equals(oldToken));

        await storageService.saveToken(newToken);

        // Assert
        final updatedToken = await mockStorage.read(key: 'access_token');
        expect(updatedToken, equals(newToken));
      });
    });
  });
}
