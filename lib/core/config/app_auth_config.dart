import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:feature_auth/domain/auth_config.dart';
import 'package:balance_iq/features/home/domain/usecase/get_user_dashbaord.dart';

class AppAuthConfig implements AuthConfig {
  String get googleClientId => AppConstants.serverClientId;

  String get authBaseUrl => dotenv.get(
        'AUTH_BASE_URL',
        fallback: 'http://localhost:8080/api/auth',
      );

  String get financeGuruBaseUrl => dotenv.get(
        'FINANCE_GURU_BASE_URL',
        fallback: 'http://localhost:8080/api/finance-guru',
      );

  String get backendBaseUrl => dotenv.get(
        'BACKEND_BASE_URL',
        fallback: 'http://localhost:8080',
      );

  @override
  Future<bool> isSessionValid() async {
    try {
      final getDashboardSummary = GetIt.instance<GetDashboardSummary>();

      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);

      final startDate =
          "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
      final endDate =
          "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";

      final result =
          await getDashboardSummary(startDate: startDate, endDate: endDate);

      return result.fold(
        (failure) => false,
        (summary) => true,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  void onAuthenticated(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void onUnauthenticated(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void onOnboardingRequired(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/interactive-onboarding');
  }
}
