/// Centralized Strings for BalanceIQ
/// Organized by Feature with Common Section
///
/// Usage: AppStrings.common.buttonSave, AppStrings.auth.welcomeTitle, etc.
class AppStrings {
  const AppStrings._();

  // App-level constants
  static const appName = 'BalanceIQ';

  // Feature sections
  static const common = _CommonStrings();
  static const auth = _AuthStrings();
  static const chat = _ChatStrings();
  static const dashboard = _DashboardStrings();
  static const transactions = _TransactionsStrings();
  static const subscription = _SubscriptionStrings();
  static const profile = _ProfileStrings();
  static const errors = _ErrorStrings();
}

// ============================================================================
// COMMON STRINGS - Shared across multiple screens
// ============================================================================
class _CommonStrings {
  const _CommonStrings();

  // Actions
  final save = 'Save';
  final saveChanges = 'Save Changes';
  final cancel = 'Cancel';
  final delete = 'Delete';
  final edit = 'Edit';
  final confirm = 'Confirm';
  final close = 'Close';
  final done = 'Done';
  final next = 'Next';
  final back = 'Back';
  final skip = 'Skip';
  final retry = 'Retry';
  final refresh = 'Refresh';
  final viewAll = 'View All';
  final learnMore = 'Learn More';
  final getStarted = 'Get Started';

  // Status
  final loading = 'Loading...';
  final success = 'Success';
  final error = 'Error';
  final warning = 'Warning';
  final info = 'Info';
  final processing = 'Processing...';
  final pleaseWait = 'Please wait...';

  // Validation
  final required = 'Required';
  final invalidEmail = 'Invalid email address';
  final invalidPassword = 'Invalid password';
  final passwordTooShort = 'Password must be at least 8 characters';
  final passwordMismatch = 'Passwords do not match';
  final fieldRequired = 'This field is required';

  // Feedback
  final copied = 'Copied to clipboard';
  final saved = 'Saved successfully';
  final deleted = 'Deleted successfully';
  final updated = 'Updated successfully';
  final failed = 'Operation failed';

  // Time
  final today = 'Today';
  final yesterday = 'Yesterday';
  final thisWeek = 'This Week';
  final thisMonth = 'This Month';
  final thisYear = 'This Year';
  final custom = 'Custom';

  // Misc
  final noData = 'No data available';
  final comingSoon = 'Coming Soon';
  final selectTextMode = 'Select text mode';
}

// ============================================================================
// AUTH STRINGS - Authentication & Onboarding
// ============================================================================
class _AuthStrings {
  const _AuthStrings();

  // Onboarding
  final welcomeTitle = 'BalanceIQ';
  final welcomeSubtitle = 'Your AI-powered personal finance assistant';
  final continueGoogle = 'Continue with Google';
  final termsPrivacy =
      'By continuing, you agree to our Terms of Service\nand Privacy Policy';

  // Login
  final loginTitle = 'Welcome Back';
  final loginSubtitle = 'Sign in to continue';
  final emailLabel = 'Email';
  final emailHint = 'Enter your email';
  final passwordLabel = 'Password';
  final passwordHint = 'Enter your password';
  final forgotPassword = 'Forgot Password?';
  final loginButton = 'Log In';
  final noAccount = "Don't have an account?";
  final signUpLink = 'Sign Up';

  // Signup
  final signupTitle = 'Create Account';
  final signupSubtitle = 'Join BalanceIQ today';
  final nameLabel = 'Full Name';
  final nameHint = 'Enter your name';
  final confirmPasswordLabel = 'Confirm Password';
  final confirmPasswordHint = 'Re-enter your password';
  final signupButton = 'Sign Up';
  final haveAccount = 'Already have an account?';
  final loginLink = 'Log In';

  // Password Management
  final forgotPasswordTitle = 'Forgot Password';
  final forgotPasswordSubtitle = 'Enter your email to reset password';
  final sendResetLink = 'Send Reset Link';
  final resetLinkSent = 'Reset link sent to your email';
  final resetPasswordTitle = 'Reset Password';
  final resetPasswordSubtitle = 'Enter your new password';
  final newPasswordLabel = 'New Password';
  final resetPasswordButton = 'Reset Password';
  final changePasswordTitle = 'Change Password';
  final currentPasswordLabel = 'Current Password';
  final changePasswordButton = 'Change Password';
  final passwordChanged = 'Password changed successfully';

  // Email Verification
  final verifyEmailTitle = 'Verify Your Email';
  final verifyEmailSubtitle =
      'Click the button to send a verification email. This unlocks all features!';
  final sendVerificationEmail = 'Send Verification Email';
  final emailSent = 'Verification email sent to';
  final checkInbox = 'Check your inbox';
  final verificationSuccess = 'Email Verified!';
  final verificationSuccessMessage =
      'Your email has been successfully verified';
  final skipVerificationDevOnly = 'Skip Verification (Dev Only)';

  // Loading & Errors
  final signingIn = 'Signing in...';
  final signingUp = 'Creating account...';
  final sendingEmail = 'Sending email...';
  final networkError = 'Network Error';
  final networkErrorMessage = 'Please check your internet connection';
  final authError = 'Authentication failed';
  final tryAgain = 'Try Again';
}

// ============================================================================
// CHAT STRINGS - Chat Interface
// ============================================================================
class _ChatStrings {
  const _ChatStrings();

  // Input
  final inputPlaceholder = 'Ask about your finances...';
  final sendMessage = 'Send';
  final attachFile = 'Attach File';

  // Suggestions
  final suggestionBill = 'Add Electricity Bill';
  final suggestionIncome = 'Log Salary';
  final suggestionBudget = 'Set Monthly Budget';
  final suggestionAnalyze = 'Analyze Spending';

  // Empty State
  final emptyStateTitle = 'Start a conversation';
  final emptyStateSubtitle =
      'I can help track expenses, set budgets, or analyze your spending.';

  // Feedback
  final feedbackThanks = 'Thanks for the feedback!';
  final regenerating = 'Regenerating response...';
  final thinking = 'Thinking...';

  // Actions
  final changeActionType = 'Change Action Type';
  final recordedIncome = 'Recorded Income';
  final recordedExpense = 'Recorded Expense';
  final change = 'Change';
  final copyMessage = 'Copy';
  final regenerate = 'Regenerate';
  final like = 'Like';
  final dislike = 'Dislike';

  // Attachment
  final attachmentTitle = 'Attach File';
  final selectImage = 'Select Image';
  final selectDocument = 'Select Document';
  final takePhoto = 'Take Photo';
}

// ============================================================================
// DASHBOARD STRINGS - Home & Dashboard
// ============================================================================
class _DashboardStrings {
  const _DashboardStrings();

  // Welcome
  final welcome = 'Welcome back,';
  final goodMorning = 'Good Morning';
  final goodAfternoon = 'Good Afternoon';
  final goodEvening = 'Good Evening';

  // Balance Card
  final walletBalance = 'Wallet Balance';
  final netBalance = 'Net Balance';
  final totalIncome = 'Total Income';
  final totalExpense = 'Total Expense';
  final income = 'Income';
  final expense = 'Expense';

  // Widgets
  final spendingTrend = 'Spending Trend';
  final financialRatios = 'Financial Ratios';
  final accounts = 'Accounts';
  final biggestIncome = 'Biggest Income';
  final biggestExpense = 'Biggest Expense';
  final categories = 'Top Categories';
  final categoryBreakdown = 'Category Breakdown';
  final recentTransactions = 'Recent Transactions';

  // Ratios
  final expenseRatio = 'Expense Ratio';
  final savingsRate = 'Savings Rate';
  final incomeExpenseRatio = 'Income/Expense Ratio';

  // Date Selector
  final selectDateRange = 'Select Date Range';
  final customRange = 'Custom Range';
  final apply = 'Apply';

  // Empty States
  final noTransactions = 'No transactions yet';
  final noTransactionsMessage =
      'Start tracking your finances by adding transactions';
  final noDataForPeriod = 'No data for this period';
}

// ============================================================================
// TRANSACTIONS STRINGS - Transaction Management
// ============================================================================
class _TransactionsStrings {
  const _TransactionsStrings();

  // List
  final allTransactions = 'All Transactions';
  final recentTransactions = 'Recent Transactions';
  final filterTransactions = 'Filter';
  final sortBy = 'Sort By';
  final searchTransactions = 'Search transactions...';

  // Detail Modal
  final transactionDetails = 'Transaction Details';
  final editTransaction = 'Edit Transaction';
  final deleteTransaction = 'Delete Transaction';
  final transactionId = 'ID';

  // Form Fields
  final transactionType = 'Transaction Type';
  final amount = 'Amount';
  final description = 'Description';
  final descriptionHint = 'Enter description...';
  final category = 'Category';
  final date = 'Date';
  final selectDate = 'Select Date';

  // Categories
  final categoryFood = 'Food & Dining';
  final categoryTransport = 'Transportation';
  final categoryShopping = 'Shopping';
  final categoryEntertainment = 'Entertainment';
  final categoryBills = 'Bills & Utilities';
  final categoryHealthcare = 'Healthcare';
  final categoryEducation = 'Education';
  final categorySalary = 'Salary';
  final categoryInvestment = 'Investment';
  final categoryGift = 'Gift';
  final categoryOther = 'Other';

  // Actions
  final addTransaction = 'Add Transaction';
  final updateTransaction = 'Update';
  final deleteConfirmTitle = 'Delete Transaction';
  final deleteConfirmMessage =
      'Are you sure you want to delete this transaction? This action cannot be undone.';
  final deleting = 'Deleting transaction...';
  final noDescription = 'No description';

  // Status
  final transactionAdded = 'Transaction added';
  final transactionUpdated = 'Transaction updated';
  final transactionDeleted = 'Transaction deleted';
}

// ============================================================================
// SUBSCRIPTION STRINGS - Subscription & Plans
// ============================================================================
class _SubscriptionStrings {
  const _SubscriptionStrings();

  // Plans Page
  final choosePlan = 'Choose Your Plan';
  final choosePlanSubtitle = 'Select the plan that works best for you';
  final currentPlan = 'Current Plan';
  final upgradePlan = 'Upgrade Plan';
  final subscribeToPlan = 'Subscribe';

  // Plan Names
  final freePlan = 'Free';
  final basicPlan = 'Basic';
  final proPlan = 'Pro';
  final premiumPlan = 'Premium';

  // Features
  final unlimitedTransactions = 'Unlimited Transactions';
  final aiInsights = 'AI-Powered Insights';
  final budgetTracking = 'Budget Tracking';
  final categoryAnalysis = 'Category Analysis';
  final exportData = 'Export Data';
  final prioritySupport = 'Priority Support';
  final advancedReports = 'Advanced Reports';
  final customCategories = 'Custom Categories';

  // Manage Subscription
  final mySubscription = 'My Subscription';
  final planDetails = 'Plan Details';
  final renewsOn = 'Renews on';
  final expiresOn = 'Expires on';
  final daysLeft = 'days left';
  final managePlan = 'Manage Plan';
  final cancelSubscription = 'Cancel Subscription';
  final renewSubscription = 'Renew Subscription';

  // Status
  final active = 'Active';
  final expired = 'Expired';
  final cancelled = 'Cancelled';
  final trial = 'Trial';

  // Messages
  final noActivePlan = 'No Active Plan';
  final subscribeMessage = 'Subscribe to unlock premium features';
  final subscriptionSuccess = 'Subscription successful!';
  final subscriptionFailed = 'Subscription failed';
  final cancellationSuccess = 'Subscription cancelled';
}

// ============================================================================
// PROFILE STRINGS - Profile & Settings
// ============================================================================
class _ProfileStrings {
  const _ProfileStrings();

  // Profile Header
  final profile = 'Profile';
  final myProfile = 'My Profile';
  final editProfile = 'Edit Profile';

  // Menu Items
  final accountDetails = 'Account Details';
  final security = 'Security';
  final notifications = 'Notifications';
  final appearance = 'Appearance';
  final language = 'Language';
  final currency = 'Currency';
  final helpCenter = 'Help Center';
  final aboutApp = 'About';
  final termsOfService = 'Terms of Service';
  final privacyPolicy = 'Privacy Policy';

  // Actions
  final logOut = 'Log Out';
  final logOutConfirm = 'Are you sure you want to log out?';
  final deleteAccount = 'Delete Account';
  final deleteAccountConfirm = 'Are you sure? This action cannot be undone.';

  // Account Details
  final name = 'Name';
  final email = 'Email';
  final phone = 'Phone';
  final joinedDate = 'Member Since';
  final accountStatus = 'Account Status';
  final verified = 'Verified';
  final notVerified = 'Not Verified';

  // Appearance
  final theme = 'Theme';
  final lightMode = 'Light Mode';
  final darkMode = 'Dark Mode';
  final systemDefault = 'System Default';

  // Notifications
  final pushNotifications = 'Push Notifications';
  final emailNotifications = 'Email Notifications';
  final transactionAlerts = 'Transaction Alerts';
  final budgetAlerts = 'Budget Alerts';
  final weeklyReports = 'Weekly Reports';
}

// ============================================================================
// ERROR STRINGS - Error Messages
// ============================================================================
class _ErrorStrings {
  const _ErrorStrings();

  // Network Errors
  final networkError = 'Network Error';
  final noInternet = 'No internet connection';
  final serverError = 'Server error occurred';
  final timeoutError = 'Request timed out';
  final connectionFailed = 'Connection failed';

  // Validation Errors
  final invalidInput = 'Invalid input';
  final requiredField = 'This field is required';
  final invalidEmail = 'Invalid email address';
  final invalidAmount = 'Invalid amount';
  final amountTooLarge = 'Amount is too large';
  final amountTooSmall = 'Amount must be greater than 0';

  // Auth Errors
  final authFailed = 'Authentication failed';
  final invalidCredentials = 'Invalid email or password';
  final emailAlreadyExists = 'Email already exists';
  final weakPassword = 'Password is too weak';
  final accountNotFound = 'Account not found';
  final emailNotVerified = 'Email not verified';

  // Data Errors
  final loadFailed = 'Failed to load data';
  final saveFailed = 'Failed to save';
  final deleteFailed = 'Failed to delete';
  final updateFailed = 'Failed to update';

  // Generic
  final somethingWentWrong = 'Something went wrong';
  final tryAgainLater = 'Please try again later';
  final contactSupport = 'Contact support if the problem persists';

  // Recovery Actions
  final retry = 'Retry';
  final goBack = 'Go Back';
  final goHome = 'Go to Home';
  final refresh = 'Refresh';
}
