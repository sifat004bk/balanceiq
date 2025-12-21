import 'package:balance_iq/core/storage/secure_storage_service_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureStorageServiceImpl secureStorageService;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    secureStorageService = SecureStorageServiceImpl(storage: mockStorage);
  });

  group('SecureStorageServiceImpl', () {
    const key = 'test_key';
    const value = 'test_value';

    test('read calls storage.read', () async {
      when(() => mockStorage.read(key: key)).thenAnswer((_) async => value);
      final result = await secureStorageService.read(key: key);
      expect(result, value);
      verify(() => mockStorage.read(key: key)).called(1);
    });

    test('write calls storage.write', () async {
      when(() => mockStorage.write(key: key, value: value))
          .thenAnswer((_) async {});
      await secureStorageService.write(key: key, value: value);
      verify(() => mockStorage.write(key: key, value: value)).called(1);
    });

    test('delete calls storage.delete', () async {
      when(() => mockStorage.delete(key: key)).thenAnswer((_) async {});
      await secureStorageService.delete(key: key);
      verify(() => mockStorage.delete(key: key)).called(1);
    });

    test('deleteAll calls storage.deleteAll', () async {
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});
      await secureStorageService.deleteAll();
      verify(() => mockStorage.deleteAll()).called(1);
    });

    test('saveToken writes to correct key', () async {
      when(() => mockStorage.write(key: 'access_token', value: value))
          .thenAnswer((_) async {});
      await secureStorageService.saveToken(value);
      verify(() => mockStorage.write(key: 'access_token', value: value))
          .called(1);
    });

    test('getToken reads from correct key', () async {
      when(() => mockStorage.read(key: 'access_token'))
          .thenAnswer((_) async => value);
      final result = await secureStorageService.getToken();
      expect(result, value);
      verify(() => mockStorage.read(key: 'access_token')).called(1);
    });
  });
}
