// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Centralized logging interceptor for all network requests and responses
/// Only logs in debug mode, no logs in release builds
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logRequest(options);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logResponse(response);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logError(err);
    }
    super.onError(err, handler);
  }

  void _logRequest(RequestOptions options) {
    print('\n');
    print('┌─────────────────────────────────────────────────────────────');
    print('│ 🚀 REQUEST');
    print('├─────────────────────────────────────────────────────────────');
    print('│ Method: ${options.method}');
    print('│ URL: ${options.uri}');

    if (options.headers.isNotEmpty) {
      print('│ Headers:');
      options.headers.forEach((key, value) {
        print('│   $key: $value');
      });
    }

    if (options.queryParameters.isNotEmpty) {
      print('│ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        print('│   $key: $value');
      });
    }

    if (options.data != null) {
      print('│ Body:');
      _printBody(options.data);
    }

    print('└─────────────────────────────────────────────────────────────');
    print('\n');
  }

  void _logResponse(Response response) {
    print('\n');
    print('┌─────────────────────────────────────────────────────────────');
    print('│ ✅ RESPONSE');
    print('├─────────────────────────────────────────────────────────────');
    print('│ Status Code: ${response.statusCode}');
    print('│ Status Message: ${response.statusMessage}');
    print('│ URL: ${response.requestOptions.uri}');

    if (response.headers.map.isNotEmpty) {
      print('│ Headers:');
      response.headers.map.forEach((key, value) {
        print('│   $key: ${value.join(", ")}');
      });
    }

    if (response.data != null) {
      print('│ Response Body:');
      _printBody(response.data);
    }

    print('└─────────────────────────────────────────────────────────────');
    print('\n');
  }

  void _logError(DioException error) {
    print('\n');
    print('┌─────────────────────────────────────────────────────────────');
    print('│ ❌ ERROR');
    print('├─────────────────────────────────────────────────────────────');
    print('│ Type: ${error.type}');
    print('│ Message: ${error.message}');
    print('│ URL: ${error.requestOptions.uri}');

    if (error.response != null) {
      print('│ Status Code: ${error.response?.statusCode}');
      print('│ Status Message: ${error.response?.statusMessage}');

      if (error.response?.data != null) {
        print('│ Error Response:');
        _printBody(error.response?.data);
      }
    }

    print('│ Stack Trace:');
    final stackLines = error.stackTrace.toString().split('\n').take(5);
    for (var line in stackLines) {
      print('│   $line');
    }

    print('└─────────────────────────────────────────────────────────────');
    print('\n');
  }

  void _printBody(dynamic body) {
    try {
      String bodyString;

      if (body is Map || body is List) {
        // Pretty print JSON
        const encoder = JsonEncoder.withIndent('  ');
        bodyString = encoder.convert(body);
      } else if (body is String) {
        try {
          // Try to parse and pretty print if it's JSON string
          final decoded = jsonDecode(body);
          const encoder = JsonEncoder.withIndent('  ');
          bodyString = encoder.convert(decoded);
        } catch (_) {
          // Not JSON, print as-is
          bodyString = body;
        }
      } else {
        bodyString = body.toString();
      }

      // Limit body size for very large responses
      if (bodyString.length > 5000) {
        final lines = bodyString.split('\n');
        final limitedLines = lines.take(50).toList();
        limitedLines.add(
            '... (${bodyString.length} characters total, truncated for readability)');
        bodyString = limitedLines.join('\n');
      }

      // Print with indentation
      final lines = bodyString.split('\n');
      for (var line in lines) {
        print('│   $line');
      }
    } catch (e) {
      print('│   [Unable to format body: $e]');
    }
  }
}
