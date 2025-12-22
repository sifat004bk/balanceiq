import 'package:flutter/material.dart';
import 'package:feature_auth/domain/auth_config.dart';

/// Test App Auth Configuration
class TestAuthConfig implements AuthConfig {
  @override
  void onAuthenticated(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void onUnauthenticated(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void onOnboardingRequired(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Future<bool> isSessionValid() async {
    return true;
  }
}
