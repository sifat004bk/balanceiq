import 'package:dolfin_core/config/environment_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnvironmentConfig', () {
    group('DevelopmentConfig', () {
      late DevelopmentConfig config;

      setUp(() {
        config = DevelopmentConfig();
      });

      test('should have correct apiBaseUrl', () {
        expect(config.apiBaseUrl, 'https://api.example.com');
      });

      test('should have isDebug set to true', () {
        expect(config.isDebug, isTrue);
      });

      test('should have correct appName', () {
        expect(config.appName, 'Dolfin Dev');
      });

      test('should have correct appVersion', () {
        expect(config.appVersion, '1.0.0-dev');
      });
    });

    group('Custom EnvironmentConfig implementation', () {
      test('should allow custom implementations', () {
        // Arrange
        final customConfig = _CustomConfig();

        // Assert
        expect(customConfig.apiBaseUrl, 'https://custom.api.com');
        expect(customConfig.isDebug, isFalse);
        expect(customConfig.appName, 'Custom App');
        expect(customConfig.appVersion, '2.0.0');
      });

      test('should work with production-like config', () {
        // Arrange
        final prodConfig = _ProductionConfig();

        // Assert
        expect(prodConfig.apiBaseUrl, 'https://api.production.com');
        expect(prodConfig.isDebug, isFalse);
        expect(prodConfig.appName, 'Dolfin');
        expect(prodConfig.appVersion, '1.0.0');
      });
    });
  });
}

/// Test custom config implementation
class _CustomConfig implements EnvironmentConfig {
  @override
  String get apiBaseUrl => 'https://custom.api.com';

  @override
  bool get isDebug => false;

  @override
  String get appName => 'Custom App';

  @override
  String get appVersion => '2.0.0';
}

/// Test production config implementation
class _ProductionConfig implements EnvironmentConfig {
  @override
  String get apiBaseUrl => 'https://api.production.com';

  @override
  bool get isDebug => false;

  @override
  String get appName => 'Dolfin';

  @override
  String get appVersion => '1.0.0';
}
