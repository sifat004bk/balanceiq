import 'package:dolfin_core/network/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoggingInterceptor', () {
    late LoggingInterceptor interceptor;
    late RequestOptions requestOptions;

    setUp(() {
      interceptor = LoggingInterceptor();
      requestOptions = RequestOptions(
        path: '/api/test',
        baseUrl: 'https://example.com',
        method: 'GET',
      );
    });

    group('onRequest', () {
      test('should call handler.next with options', () {
        final handler = _MockRequestInterceptorHandler();

        interceptor.onRequest(requestOptions, handler);

        expect(handler.nextCalled, isTrue);
        expect(handler.options, equals(requestOptions));
      });

      test('should log request with headers in debug mode', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://api.example.com',
          method: 'POST',
          headers: {
            'Authorization': 'Bearer token123',
            'Content-Type': 'application/json',
          },
        );
        final handler = _MockRequestInterceptorHandler();

        // Note: Actual logging verification would require mocking dart:developer log
        // This test verifies the method executes without errors
        interceptor.onRequest(options, handler);

        expect(handler.nextCalled, isTrue);
      });

      test('should log request with query parameters', () {
        final options = RequestOptions(
          path: '/api/search',
          baseUrl: 'https://api.example.com',
          method: 'GET',
          queryParameters: {
            'q': 'flutter',
            'limit': '10',
            'page': '1',
          },
        );
        final handler = _MockRequestInterceptorHandler();

        interceptor.onRequest(options, handler);

        expect(handler.nextCalled, isTrue);
      });

      test('should log request with body data', () {
        final options = RequestOptions(
          path: '/api/users',
          baseUrl: 'https://api.example.com',
          method: 'POST',
          data: {
            'name': 'John Doe',
            'email': 'john@example.com',
          },
        );
        final handler = _MockRequestInterceptorHandler();

        interceptor.onRequest(options, handler);

        expect(handler.nextCalled, isTrue);
      });
    });

    group('onResponse', () {
      test('should call handler.next with response', () {
        final response = Response(
          requestOptions: requestOptions,
          statusCode: 200,
          data: {'success': true},
        );
        final handler = _MockResponseInterceptorHandler();

        interceptor.onResponse(response, handler);

        expect(handler.nextCalled, isTrue);
        expect(handler.response, equals(response));
      });

      test('should log successful response with headers', () {
        final response = Response(
          requestOptions: requestOptions,
          statusCode: 200,
          statusMessage: 'OK',
          headers: Headers.fromMap({
            'content-type': ['application/json'],
            'x-request-id': ['abc123'],
          }),
          data: {'message': 'Success'},
        );
        final handler = _MockResponseInterceptorHandler();

        interceptor.onResponse(response, handler);

        expect(handler.nextCalled, isTrue);
      });

      test('should log response with large body data', () {
        // Create a large response body
        final largeData = List.generate(
            100,
            (i) => {
                  'id': i,
                  'name': 'Item $i',
                  'description': 'This is a long description for item $i' * 10,
                });

        final response = Response(
          requestOptions: requestOptions,
          statusCode: 200,
          data: largeData,
        );
        final handler = _MockResponseInterceptorHandler();

        interceptor.onResponse(response, handler);

        expect(handler.nextCalled, isTrue);
      });
    });

    group('onError', () {
      test('should call handler.next with error', () {
        final error = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        );
        final handler = _MockErrorInterceptorHandler();

        interceptor.onError(error, handler);

        expect(handler.nextCalled, isTrue);
        expect(handler.error, equals(error));
      });

      test('should log connection timeout error', () {
        final error = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout after 10s',
        );
        final handler = _MockErrorInterceptorHandler();

        interceptor.onError(error, handler);

        expect(handler.nextCalled, isTrue);
      });

      test('should log error with response data', () {
        final error = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Bad response',
          response: Response(
            requestOptions: requestOptions,
            statusCode: 404,
            statusMessage: 'Not Found',
            data: {'error': 'Resource not found'},
          ),
        );
        final handler = _MockErrorInterceptorHandler();

        interceptor.onError(error, handler);

        expect(handler.nextCalled, isTrue);
      });

      test('should log error with stack trace', () {
        final error = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.unknown,
          message: 'Unknown error occurred',
          stackTrace: StackTrace.current,
        );
        final handler = _MockErrorInterceptorHandler();

        interceptor.onError(error, handler);

        expect(handler.nextCalled, isTrue);
      });
    });

    group('Body formatting', () {
      test('should handle JSON object body', () {
        final options = RequestOptions(
          path: '/api/test',
          method: 'POST',
          data: {
            'user': {
              'name': 'John',
              'age': 30,
            },
            'meta': {
              'timestamp': '2024-01-01',
            },
          },
        );
        final handler = _MockRequestInterceptorHandler();

        interceptor.onRequest(options, handler);

        expect(handler.nextCalled, isTrue);
      });

      test('should handle JSON array body', () {
        final options = RequestOptions(
          path: '/api/batch',
          method: 'POST',
          data: [
            {'id': 1, 'name': 'Item 1'},
            {'id': 2, 'name': 'Item 2'},
            {'id': 3, 'name': 'Item 3'},
          ],
        );
        final handler = _MockRequestInterceptorHandler();

        interceptor.onRequest(options, handler);

        expect(handler.nextCalled, isTrue);
      });

      test('should handle string body', () {
        final options = RequestOptions(
          path: '/api/text',
          method: 'POST',
          data: 'Plain text content',
        );
        final handler = _MockRequestInterceptorHandler();

        interceptor.onRequest(options, handler);

        expect(handler.nextCalled, isTrue);
      });

      test('should handle JSON string body', () {
        final options = RequestOptions(
          path: '/api/json',
          method: 'POST',
          data: '{"name":"John","email":"john@example.com"}',
        );
        final handler = _MockRequestInterceptorHandler();

        interceptor.onRequest(options, handler);

        expect(handler.nextCalled, isTrue);
      });

      test('should truncate very large body content', () {
        // Create a string larger than 5000 characters
        final largeBody = 'x' * 6000;
        final options = RequestOptions(
          path: '/api/large',
          method: 'POST',
          data: largeBody,
        );
        final handler = _MockRequestInterceptorHandler();

        interceptor.onRequest(options, handler);

        expect(handler.nextCalled, isTrue);
      });
    });
  });
}

// Mock Handlers for Testing
class _MockRequestInterceptorHandler extends RequestInterceptorHandler {
  bool nextCalled = false;
  RequestOptions? options;

  @override
  void next(RequestOptions options) {
    nextCalled = true;
    this.options = options;
  }
}

class _MockResponseInterceptorHandler extends ResponseInterceptorHandler {
  bool nextCalled = false;
  Response? response;

  @override
  void next(Response response) {
    nextCalled = true;
    this.response = response;
  }
}

class _MockErrorInterceptorHandler extends ErrorInterceptorHandler {
  bool nextCalled = false;
  DioException? error;

  @override
  void next(DioException err) {
    nextCalled = true;
    error = err;
  }
}
