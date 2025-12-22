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
    _log('└─────────────────────────────────────────────────────────────');
  }

  void _logResponse(Response response) {
    _log('\n');
    _log('┌─────────────────────────────────────────────────────────────');
    _log('│ ✅ RESPONSE');
    _log('├─────────────────────────────────────────────────────────────');
    _log('│ Status Code: ${response.statusCode}');
    _log('│ URL: ${response.requestOptions.uri}');
    _log('└─────────────────────────────────────────────────────────────');
  }

  void _logError(DioException error) {
    _log('\n');
    _log('┌─────────────────────────────────────────────────────────────');
    _log('│ ❌ ERROR');
    _log('├─────────────────────────────────────────────────────────────');
    _log('│ Type: ${error.type}');
    _log('│ Message: ${error.message}');
    _log('│ URL: ${error.requestOptions.uri}');
    _log('└─────────────────────────────────────────────────────────────');
  }
}
