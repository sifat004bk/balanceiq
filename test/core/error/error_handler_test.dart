import 'package:balance_iq/core/error/app_exception.dart';
import 'package:balance_iq/core/error/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorHandler', () {
    test('should return existing AppException as is', () {
      const exception = ServerException('Server Error');
      final result = ErrorHandler.handle(exception);
      expect(result, exception);
    });

    test('should handle generic exception as UnknownException', () {
      final exception = Exception('Generic Error');
      final result = ErrorHandler.handle(exception);
      expect(result, isA<UnknownException>());
      expect(result.message, 'Exception: Generic Error');
    });

    group('DioException handling', () {
      test('should handle connection timeout', () {
        final error = DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        );
        final result = ErrorHandler.handle(error);
        expect(result, isA<NetworkException>());
        expect(result.message, 'Connection timed out');
      });

      test('should handle bad response 401 as AuthException', () {
        final error = DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
        );
        final result = ErrorHandler.handle(error);
        expect(result, isA<AuthException>());
        expect(result.message, 'Unauthorized');
      });

      test('should handle bad response 500 as ServerException', () {
        final error = DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 500,
            data: {'error': 'Internal Server Error'},
          ),
        );
        final result = ErrorHandler.handle(error);
        expect(result, isA<ServerException>());
        expect(result.message, 'Internal Server Error');
        expect((result as ServerException).statusCode, 500);
      });
    });
  });
}
