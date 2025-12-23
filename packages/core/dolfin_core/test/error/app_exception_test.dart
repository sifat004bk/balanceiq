import 'package:dolfin_core/error/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException', () {
    group('NetworkException', () {
      test('creates with message', () {
        const exception = NetworkException('No internet');
        expect(exception.message, 'No internet');
      });

      test('creates with default message', () {
        const exception = NetworkException();
        expect(exception.message, 'No internet connection');
      });

      test('has correct code', () {
        const exception = NetworkException('Connection timeout');
        expect(exception.code, 'NETWORK_ERROR');
      });
    });

    group('ServerException', () {
      test('creates with message', () {
        const exception = ServerException('Internal server error');
        expect(exception.message, 'Internal server error');
      });

      test('creates with status code', () {
        const exception = ServerException('Not found', statusCode: 404);
        expect(exception.message, 'Not found');
        expect(exception.statusCode, 404);
      });

      test('statusCode defaults to null', () {
        const exception = ServerException('Error');
        expect(exception.statusCode, isNull);
      });

      test('has correct code', () {
        const exception = ServerException('Bad request', statusCode: 400);
        expect(exception.code, 'SERVER_ERROR');
      });
    });

    group('AuthException', () {
      test('creates with message', () {
        const exception = AuthException('Invalid credentials');
        expect(exception.message, 'Invalid credentials');
      });

      test('has correct code', () {
        const exception = AuthException('Token expired');
        expect(exception.code, 'AUTH_ERROR');
      });
    });

    group('CacheException', () {
      test('creates with message', () {
        const exception = CacheException('Cache miss');
        expect(exception.message, 'Cache miss');
      });

      test('has correct code', () {
        const exception = CacheException('Cache corrupted');
        expect(exception.code, 'CACHE_ERROR');
      });
    });

    group('ValidationException', () {
      test('creates with message', () {
        const exception = ValidationException('Invalid email');
        expect(exception.message, 'Invalid email');
      });

      test('has correct code', () {
        const exception = ValidationException('Password too short');
        expect(exception.code, 'VALIDATION_ERROR');
      });
    });

    group('UnknownException', () {
      test('creates with message', () {
        const exception = UnknownException('Something went wrong');
        expect(exception.message, 'Something went wrong');
      });

      test('has correct code', () {
        const exception = UnknownException('Unexpected error');
        expect(exception.code, 'UNKNOWN');
      });
    });

    group('AppException sealed class hierarchy', () {
      test('all exceptions extend AppException', () {
        expect(const NetworkException(), isA<AppException>());
        expect(const ServerException(''), isA<AppException>());
        expect(const AuthException(''), isA<AppException>());
        expect(const CacheException(''), isA<AppException>());
        expect(const ValidationException(''), isA<AppException>());
        expect(const UnknownException(''), isA<AppException>());
      });

      test('can pattern match on exception types', () {
        const AppException exception = NetworkException('Test');

        final result = switch (exception) {
          NetworkException() => 'network',
          ServerException() => 'server',
          AuthException() => 'auth',
          CacheException() => 'cache',
          ValidationException() => 'validation',
          UnknownException() => 'unknown',
        };

        expect(result, 'network');
      });

      test('pattern matching works for all types', () {
        String categorize(AppException exception) {
          return switch (exception) {
            NetworkException() => 'network',
            ServerException() => 'server',
            AuthException() => 'auth',
            CacheException() => 'cache',
            ValidationException() => 'validation',
            UnknownException() => 'unknown',
          };
        }

        expect(categorize(const NetworkException()), 'network');
        expect(categorize(const ServerException('')), 'server');
        expect(categorize(const AuthException('')), 'auth');
        expect(categorize(const CacheException('')), 'cache');
        expect(categorize(const ValidationException('')), 'validation');
        expect(categorize(const UnknownException('')), 'unknown');
      });
    });
  });
}
