class ApiEndpoints {
  static String _backendBaseUrl = 'http://localhost:8080';
  static String _authBaseUrl = 'http://localhost:8080/api/auth';
  static String _agentBaseUrl = 'http://localhost:8080/api/finance-guru';

  static void init({
    required String backendBaseUrl,
    required String authBaseUrl,
    required String agentBaseUrl,
  }) {
    _backendBaseUrl = backendBaseUrl;
    _authBaseUrl = authBaseUrl;
    _agentBaseUrl = agentBaseUrl;
  }

  static String get backendBaseUrl => _backendBaseUrl;
  static String get authBaseUrl => _authBaseUrl;
  static String get agentBaseUrl => _agentBaseUrl;

  // Authentication APIs
  static String get signup => '$authBaseUrl/signup';
  static String get login => '$authBaseUrl/login';
  static String get googleOAuth => '$authBaseUrl/oauth2/google';
  static String get refreshToken => '$authBaseUrl/refresh-token';
  static String get getProfile => '$authBaseUrl/profile';
  static String get forgotPassword => '$authBaseUrl/forgot-password';
  static String get resetPassword => '$authBaseUrl/reset-password';
  static String get changePassword => '$authBaseUrl/change-password';
  static String get sendVerification => '$authBaseUrl/send-verification';
  static String get resendVerification => '$authBaseUrl/resend-verification';
  static String get verifyEmail => '$authBaseUrl/verify-email';
  static String get updateCurrency => '$authBaseUrl/currency';
  static String get updateProfile => '$authBaseUrl/profile';
  static String get logout => '$authBaseUrl/logout';

  // Finance Guru APIs
  static String get dashboard => '$agentBaseUrl/dashboard';
  static String get chat => '$agentBaseUrl/chat';
  static String get chatHistory => '$agentBaseUrl/chat-history';
  static String get transactions => '$agentBaseUrl/transactions';
  static String get messageUsage => '$agentBaseUrl/usage';

  // Chat feedback endpoint (requires message ID)
  static String chatFeedback(int messageId) =>
      '$agentBaseUrl/chat-history/$messageId/feedback';

  // Subscription APIs
  static String get subscriptionsBaseUrl => '$backendBaseUrl/api/subscriptions';
  static String get plansBaseUrl => '$backendBaseUrl/api/plans';

  static String get allPlans => plansBaseUrl;
  static String get subscriptionStatus => '$subscriptionsBaseUrl/status';
  static String get createSubscription => subscriptionsBaseUrl;
  static String get cancelSubscription => '$subscriptionsBaseUrl/cancel';
}
