abstract class AnalyticsService {
  /// Log a custom event
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  });

  /// Set user ID for tracking
  Future<void> setUserId(String id);

  /// Set user properties (e.g., plan_type, usage_count)
  Future<void> setUserProperty({
    required String name,
    required String value,
  });

  /// Log non-fatal error to Crashlytics
  Future<void> logError(dynamic exception, StackTrace? stackTrace,
      {dynamic reason});
}
