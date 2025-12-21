import 'dart:convert';
import 'dart:developer';
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

  void _log(String message) {
    log(message, name: 'DIO');
  }

  void _logRequest(RequestOptions options) {
    _log('\n');
    _log('┌─────────────────────────────────────────────────────────────');
    _log('│ 🚀 REQUEST');
    _log('├─────────────────────────────────────────────────────────────');
    _log('│ Method: ${options.method}');
    _log('│ URL: ${options.uri}');

    if (options.headers.isNotEmpty) {
      _log('│ Headers:');
      options.headers.forEach((key, value) {
        _log('│   $key: $value');
      });
    }

    if (options.queryParameters.isNotEmpty) {
      _log('│ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        _log('│   $key: $value');
      });
    }

    if (options.data != null) {
      _log('│ Body:');
      _printBody(options.data);
    }

    _log('└─────────────────────────────────────────────────────────────');
    _log('\n');
  }

  void _logResponse(Response response) {
    _log('\n');
    _log('┌─────────────────────────────────────────────────────────────');
    _log('│ ✅ RESPONSE');
    _log('├─────────────────────────────────────────────────────────────');
    _log('│ Status Code: ${response.statusCode}');
    _log('│ Status Message: ${response.statusMessage}');
    _log('│ URL: ${response.requestOptions.uri}');

    if (response.headers.map.isNotEmpty) {
      _log('│ Headers:');
      response.headers.map.forEach((key, value) {
        _log('│   $key: ${value.join(", ")}');
      });
    }

    if (response.data != null) {
      _log('│ Response Body:');
      _printBody(response.data);
    }

    _log('└─────────────────────────────────────────────────────────────');
    _log('\n');
  }

  void _logError(DioException error) {
    _log('\n');
    _log('┌─────────────────────────────────────────────────────────────');
    _log('│ ❌ ERROR');
    _log('├─────────────────────────────────────────────────────────────');
    _log('│ Type: ${error.type}');
    _log('│ Message: ${error.message}');
    _log('│ URL: ${error.requestOptions.uri}');

    if (error.response != null) {
      _log('│ Status Code: ${error.response?.statusCode}');
      _log('│ Status Message: ${error.response?.statusMessage}');

      if (error.response?.data != null) {
        _log('│ Error Response:');
        _printBody(error.response?.data);
      }
    }

    _log('│ Stack Trace:');
    final stackLines = error.stackTrace.toString().split('\n').take(5);
    for (var line in stackLines) {
      _log('│   $line');
    }

    _log('└─────────────────────────────────────────────────────────────');
    _log('\n');
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
        _log('│   $line');
      }
    } catch (e) {
      _log('│   [Unable to format body: $e]');
    }
  }
}
