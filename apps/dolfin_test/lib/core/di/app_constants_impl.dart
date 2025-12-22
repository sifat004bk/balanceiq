import 'package:dolfin_core/constants/app_constants.dart';

/// Test App Constants Implementation
class TestAppConstantsImpl implements AppConstants {
  // App Info
  @override
  String get appName => 'Dolfin Test';
  @override
  String get appVersion => '1.0.0';

  // Bot Types
  @override
  String get balanceTracker => 'Balance Tracker';
  @override
  String get investmentGuru => 'Investment Guru';
  @override
  String get budgetPlanner => 'Budget Planner';
  @override
  String get finTips => 'Fin Tips';

  // Bot IDs for API
  @override
  String get balanceTrackerID => 'balance_tracker';
  @override
  String get investmentGuruID => 'investment_guru';
  @override
  String get budgetPlannerID => 'budget_planner';
  @override
  String get finTipsID => 'fin_tips';

  // Local Database
  @override
  String get databaseName => 'dolfin_test.db';
  @override
  int get databaseVersion => 7;

  // Table Names
  @override
  String get messagesTable => 'messages';
  @override
  String get usersTable => 'users';

  // Shared Preferences Keys
  @override
  String get keyUserId => 'user_id';
  @override
  String get keyUserEmail => 'user_email';
  @override
  String get keyUserName => 'user_name';
  @override
  String get keyUserPhotoUrl => 'user_photo_url';
  @override
  String get keyUserAuthProvider => 'user_auth_provider';
  @override
  String get keyIsLoggedIn => 'is_logged_in';
  @override
  String get keyIsEmailVerified => 'is_email_verified';
  @override
  String get keyThemeMode => 'theme_mode';

  // Mock Mode - Always true for test app
  @override
  bool get isMockMode => true;

  // Message Types
  @override
  String get messageTypeText => 'text';
  @override
  String get messageTypeImage => 'image';
  @override
  String get messageTypeAudio => 'audio';

  // Message Sender Types
  @override
  String get senderUser => 'user';
  @override
  String get senderBot => 'bot';

  // Timeouts
  @override
  Duration get apiTimeout => const Duration(seconds: 30);
  @override
  Duration get recordingTimeout => const Duration(minutes: 5);

  // File Size Limits (in bytes)
  @override
  int get maxImageSize => 10 * 1024 * 1024; // 10 MB
  @override
  int get maxAudioSize => 25 * 1024 * 1024; // 25 MB

  // Message Usage Limits
  @override
  int get dailyMessageLimit => 10;

  // Auth
  @override
  String get serverClientId => '';
}
