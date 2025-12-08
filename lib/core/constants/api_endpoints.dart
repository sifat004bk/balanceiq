import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get backendBaseUrl => dotenv.get(
    'BACKEND_BASE_URL',
    fallback: 'https://primary-production-7383b.up.railway.app',
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
  static String get getProfile => '$authBaseUrl/me';
  static String get forgotPassword => '$authBaseUrl/forgot-password';
  static String get resetPassword => '$authBaseUrl/reset-password';
  static String get changePassword => '$authBaseUrl/change-password';

  // Finance Guru APIs
  static String get dashboard => '$financeGuruBaseUrl/v1/dashboard';
  static String get chat => '$financeGuruBaseUrl/chat';
  static String get chatHistory => '$financeGuruBaseUrl/chat-history';
  static String get transactions => '$financeGuruBaseUrl/v1/transactions';
  static String get tokenUsage => '$financeGuruBaseUrl/v1/token-usage';

  // Chat feedback endpoint (requires message ID)
  static String chatFeedback(int messageId) =>
      '$financeGuruBaseUrl/v1/chat-history/$messageId/feedback';
}
