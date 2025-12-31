import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:dolfin_core/analytics/analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters?.cast<String, Object>(),
    );
  }

  @override
  Future<void> setUserId(String id) async {
    await _analytics.setUserId(id: id);
    await _crashlytics.setUserIdentifier(id);
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> logError(dynamic exception, StackTrace? stackTrace,
      {dynamic reason}) async {
    await _crashlytics.recordError(exception, stackTrace, reason: reason);
  }
}
