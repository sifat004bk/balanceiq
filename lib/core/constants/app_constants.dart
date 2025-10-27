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
  static const int databaseVersion = 1;

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

  // API Configuration
  static const String n8nWebhookUrl = String.fromEnvironment(
    'N8N_WEBHOOK_URL',
    defaultValue: 'https://primary-production-7383b.up.railway.app/webhook/b1cfaa07-8bf1-4005-90e0-9759144705f2',
  );

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
}
