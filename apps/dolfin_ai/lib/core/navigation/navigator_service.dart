import 'package:flutter/material.dart';

/// Global navigator key for app-wide navigation
/// Used primarily for navigation from non-widget contexts like interceptors
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Navigate to login screen from anywhere in the app
/// Clears the navigation stack and goes to login
/// [errorMessage] - Optional error message to display on login page
void navigateToLogin({String? errorMessage}) {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(
    '/login',
    (route) => false,
    arguments: errorMessage != null ? {'errorMessage': errorMessage} : null,
  );
}

/// Navigate to onboarding screen from anywhere in the app
/// Clears the navigation stack and goes to onboarding
void navigateToOnboarding() {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(
    '/onboarding',
    (route) => false,
  );
}
