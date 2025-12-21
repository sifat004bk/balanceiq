/// Environment configuration interface
///
/// Apps implement this to provide their specific API endpoints
/// and other environment-specific configuration.
abstract class EnvironmentConfig {
  /// Base URL for the main API
  String get apiBaseUrl;

  /// Whether the app is in debug mode
  bool get isDebug;

  /// App name for display purposes
  String get appName;

  /// App version
  String get appVersion;
}

/// Default implementation for development
class DevelopmentConfig implements EnvironmentConfig {
  @override
  String get apiBaseUrl => 'https://api.example.com';

  @override
  bool get isDebug => true;

  @override
  String get appName => 'Dolfin Dev';

  @override
  String get appVersion => '1.0.0-dev';
}
