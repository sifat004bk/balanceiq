import 'package:balance_iq/core/utils/app_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLogger', () {
    test('should not crash on debug calls', () {
      AppLogger.debug('Debug message');
      AppLogger.debug('Debug message', name: 'Test');
    });

    test('should not crash on info calls', () {
      AppLogger.info('Info message');
    });

    test('should not crash on warning calls', () {
      AppLogger.warning('Warning message');
    });

    test('should not crash on error calls', () {
      AppLogger.error('Error message', error: Exception('Test'));
    });
  });
}
