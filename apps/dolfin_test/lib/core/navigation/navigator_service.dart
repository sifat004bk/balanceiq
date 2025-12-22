import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void navigateToLogin({String? errorMessage}) {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(
    '/login',
    (route) => false,
  );
}
