import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // App Info
  static const String appName = 'BalanceIQ';
  static const String appVersion = '1.0.0';

  // Bot Types
  static const String balanceTracker = 'Balance Tracker';
  static const String investmentGuru = 'Investment Guru';
  static const String budgetPlanner = 'Budget Planner';
  static const String finTips = 'Fin Tips';

  // Bot IDs for API
  static const String balanceTrackerID = 'balance_tracker';
  static const String investmentGuruID = 'investment_guru';
  static const String budgetPlannerID = 'budget_planner';
  static const String finTipsID = 'fin_tips';

  // Local Database
  static const String databaseName = 'balance_iq.db';
  static const int databaseVersion = 6; // Updated for feedback column

  // Table Names
  static const String messagesTable = 'messages';
  static const String usersTable = 'users';

  // Shared Preferences Keys
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyUserPhotoUrl = 'user_photo_url';
  static const String keyUserAuthProvider = 'user_auth_provider';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyThemeMode = 'theme_mode';

  // Mock Mode
  // When true, uses mock data instead of real API calls
  static bool get isMockMode {
    final mockMode = dotenv.get('MOCK_MODE', fallback: 'false').toLowerCase();
    return mockMode == 'true' || mockMode == '1' || mockMode == 'yes';
  }

  // Message Types
  static const String messageTypeText = 'text';
  static const String messageTypeImage = 'image';
  static const String messageTypeAudio = 'audio';

  // Message Sender Types
  static const String senderUser = 'user';
  static const String senderBot = 'bot';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration recordingTimeout = Duration(minutes: 5);

  // File Size Limits (in bytes)
  static const int maxImageSize = 10 * 1024 * 1024; // 10 MB
  static const int maxAudioSize = 25 * 1024 * 1024; // 25 MB

  // Feature Limits
  static const int dailyTokenLimit = 5000;
}
