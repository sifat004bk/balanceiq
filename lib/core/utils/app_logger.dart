import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void debug(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        '🔍 $message',
        name: name ?? 'BalanceIQ',
        error: error,
        stackTrace: stackTrace,
        level: 500,
      );
    }
  }

  static void info(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      'ℹ️ $message',
      name: name ?? 'BalanceIQ',
      error: error,
      stackTrace: stackTrace,
      level: 800,
    );
  }

  static void warning(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      '⚠️ $message',
      name: name ?? 'BalanceIQ',
      error: error,
      stackTrace: stackTrace,
      level: 900,
    );
  }

  static void error(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      '❌ $message',
      name: name ?? 'BalanceIQ',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}
