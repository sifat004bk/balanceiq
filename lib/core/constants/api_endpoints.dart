import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get backendBaseUrl => dotenv.get(
        'BACKEND_BASE_URL',
        fallback: 'http://localhost:8080',
      );

  static String get authBaseUrl => dotenv.get(
        'AUTH_BASE_URL',
        fallback: '$backendBaseUrl/api/auth',
      );

  static String get financeGuruBaseUrl => dotenv.get(
        'FINANCE_GURU_BASE_URL',
        fallback: '$backendBaseUrl/api/finance-guru',
      );

  // Authentication APIs
  static String get signup => '$authBaseUrl/signup';
  static String get login => '$authBaseUrl/login';
  static String get refreshToken => '$authBaseUrl/refresh-token';
  static String get getProfile => '$authBaseUrl/profile';
  static String get forgotPassword => '$authBaseUrl/forgot-password';
  static String get resetPassword => '$authBaseUrl/reset-password';
  static String get changePassword => '$authBaseUrl/change-password';
  static String get sendVerification => '$authBaseUrl/send-verification';
  static String get resendVerification => '$authBaseUrl/resend-verification';
  static String get verifyEmail => '$authBaseUrl/verify-email';

  // Finance Guru APIs
  static String get dashboard => '$financeGuruBaseUrl/dashboard';
  static String get chat => '$financeGuruBaseUrl/chat';
  static String get chatHistory => '$financeGuruBaseUrl/chat-history';
  static String get transactions => '$financeGuruBaseUrl/transactions';
  static String get tokenUsage => '$financeGuruBaseUrl/token-usage';

  // Chat feedback endpoint (requires message ID)
  static String chatFeedback(int messageId) =>
      '$financeGuruBaseUrl/chat-history/$messageId/feedback';

  // Subscription APIs
  static String get subscriptionsBaseUrl => '$backendBaseUrl/api/subscriptions';
  static String get plansBaseUrl => '$backendBaseUrl/api/plans';

  static String get allPlans => plansBaseUrl;
  static String get subscriptionStatus => '$subscriptionsBaseUrl/status';
  static String get createSubscription => subscriptionsBaseUrl;
}
