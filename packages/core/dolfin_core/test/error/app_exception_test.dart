import 'package:dolfin_core/error/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException', () {
    group('NetworkException', () {
      test('creates with message', () {
        const exception = NetworkException(message: 'No internet');
        expect(exception.message, 'No internet');
      });

      test('creates with optional code', () {
        const exception = NetworkException(
          message: 'Connection timeout',
          code: 'TIMEOUT',
        );
        expect(exception.message, 'Connection timeout');
        expect(exception.code, 'TIMEOUT');
      });

      test('creates with optional details', () {
        const exception = NetworkException(
          message: 'DNS error',
          details: 'Could not resolve hostname',
        );
        expect(exception.message, 'DNS error');
        expect(exception.details, 'Could not resolve hostname');
      });

      test('code defaults to null', () {
        const exception = NetworkException(message: 'Error');
        expect(exception.code, isNull);
      });

      test('details defaults to null', () {
        const exception = NetworkException(message: 'Error');
        expect(exception.details, isNull);
      });
    });

    group('ServerException', () {
      test('creates with message', () {
        const exception = ServerException(message: 'Internal server error');
        expect(exception.message, 'Internal server error');
      });

      test('creates with status code', () {
        const exception = ServerException(
          message: 'Not found',
          statusCode: 404,
        );
        expect(exception.message, 'Not found');
        expect(exception.statusCode, 404);
      });

      test('creates with all parameters', () {
        const exception = ServerException(
          message: 'Bad request',
          code: 'BAD_REQUEST',
          details: 'Missing required field',
          statusCode: 400,
        );
        expect(exception.message, 'Bad request');
        expect(exception.code, 'BAD_REQUEST');
        expect(exception.details, 'Missing required field');
        expect(exception.statusCode, 400);
      });

      test('statusCode defaults to null', () {
        const exception = ServerException(message: 'Error');
        expect(exception.statusCode, isNull);
      });
    });

    group('AuthException', () {
      test('creates with message', () {
        const exception = AuthException(message: 'Invalid credentials');
        expect(exception.message, 'Invalid credentials');
      });

      test('creates with code', () {
        const exception = AuthException(
          message: 'Token expired',
          code: 'TOKEN_EXPIRED',
        );
        expect(exception.message, 'Token expired');
        expect(exception.code, 'TOKEN_EXPIRED');
      });

      test('creates with details', () {
        const exception = AuthException(
          message: 'Session invalid',
          details: 'Please log in again',
        );
        expect(exception.message, 'Session invalid');
        expect(exception.details, 'Please log in again');
      });
    });

    group('CacheException', () {
      test('creates with message', () {
        const exception = CacheException(message: 'Cache miss');
        expect(exception.message, 'Cache miss');
      });

      test('creates with code', () {
        const exception = CacheException(
          message: 'Cache corrupted',
          code: 'CORRUPTION',
        );
        expect(exception.message, 'Cache corrupted');
        expect(exception.code, 'CORRUPTION');
      });

      test('creates with details', () {
        const exception = CacheException(
          message: 'Read failed',
          details: 'File does not exist',
        );
        expect(exception.message, 'Read failed');
        expect(exception.details, 'File does not exist');
      });
    });

    group('ValidationException', () {
      test('creates with message', () {
        const exception = ValidationException(message: 'Invalid email');
        expect(exception.message, 'Invalid email');
      });

      test('creates with code', () {
        const exception = ValidationException(
          message: 'Password too short',
          code: 'PASSWORD_TOO_SHORT',
        );
        expect(exception.message, 'Password too short');
        expect(exception.code, 'PASSWORD_TOO_SHORT');
      });

      test('creates with details', () {
        const exception = ValidationException(
          message: 'Invalid input',
          details: 'Field must be at least 8 characters',
        );
        expect(exception.message, 'Invalid input');
        expect(exception.details, 'Field must be at least 8 characters');
      });
    });

    group('UnknownException', () {
      test('creates with message', () {
        const exception = UnknownException(message: 'Something went wrong');
        expect(exception.message, 'Something went wrong');
      });

      test('creates with code', () {
        const exception = UnknownException(
          message: 'Unexpected error',
          code: 'UNKNOWN',
        );
        expect(exception.message, 'Unexpected error');
        expect(exception.code, 'UNKNOWN');
      });

      test('creates with details', () {
        const exception = UnknownException(
          message: 'Unknown error',
          details: 'Please try again later',
        );
        expect(exception.message, 'Unknown error');
        expect(exception.details, 'Please try again later');
      });
    });

    group('AppException sealed class hierarchy', () {
      test('all exceptions extend AppException', () {
        expect(const NetworkException(message: ''), isA<AppException>());
        expect(const ServerException(message: ''), isA<AppException>());
        expect(const AuthException(message: ''), isA<AppException>());
        expect(const CacheException(message: ''), isA<AppException>());
        expect(const ValidationException(message: ''), isA<AppException>());
        expect(const UnknownException(message: ''), isA<AppException>());
      });

      test('can pattern match on exception types', () {
        const AppException exception = NetworkException(message: 'Test');

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

        expect(categorize(const NetworkException(message: '')), 'network');
        expect(categorize(const ServerException(message: '')), 'server');
        expect(categorize(const AuthException(message: '')), 'auth');
        expect(categorize(const CacheException(message: '')), 'cache');
        expect(categorize(const ValidationException(message: '')), 'validation');
        expect(categorize(const UnknownException(message: '')), 'unknown');
      });
    });
  });
}
