import 'package:flutter/material.dart';

abstract class AuthConfig {
  /// Checks if the current user session is valid.
  /// Returns [true] if valid, [false] otherwise.
  Future<bool> isSessionValid();

  /// Callback when authentication is successful or session is valid.
  void onAuthenticated(BuildContext context);

  /// Callback when user is unauthenticated or session is invalid.
  void onUnauthenticated(BuildContext context);

  /// Callback when user needs to go through onboarding.
  void onOnboardingRequired(BuildContext context);
}
