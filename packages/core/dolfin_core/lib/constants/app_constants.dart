abstract class AppConstants {
  // App Info
  String get appName;
  String get appVersion;

  // Bot Types
  String get balanceTracker;
  String get investmentGuru;
  String get budgetPlanner;
  String get finTips;

  // Bot IDs for API
  String get balanceTrackerID;
  String get investmentGuruID;
  String get budgetPlannerID;
  String get finTipsID;

  // Local Database
  String get databaseName;
  int get databaseVersion;

  // Table Names
  String get messagesTable;
  String get usersTable;

  // Shared Preferences Keys
  String get keyUserId;
  String get keyUserEmail;
  String get keyUserName;
  String get keyUserPhotoUrl;
  String get keyUserAuthProvider;
  String get keyIsLoggedIn;
  String get keyUserCurrency;
  String get keyIsEmailVerified;
  String get keyThemeMode;
  String get keyCurrencyCode;

  // Mock Mode - Already done
  bool get isMockMode;

  // Message Types
  String get messageTypeText;
  String get messageTypeImage;
  String get messageTypeAudio;

  // Message Sender Types
  String get senderUser;
  String get senderBot;

  // Timeouts
  Duration get apiTimeout;
  Duration get recordingTimeout;

  // File Size Limits (in bytes)
  int get maxImageSize;
  int get maxAudioSize;

  // Message Usage Limits (per day, resets at 00:00 UTC)
  int get dailyMessageLimit;

  // Auth
  String get serverClientId;

  // Security - Certificate Pinning
  List<String> get pinnedCertificateHashes;
  List<String> get pinnedDomains;
}
