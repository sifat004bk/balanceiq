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
  static const onboarding = _OnboardingStrings();
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
  final gotIt = 'Got it';

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
  final resetYourPassword = 'Reset Your Password';
  final resetInstructions =
      'Enter your email address and we\'ll send you instructions to reset your password.';
  final emailAddressLabel = 'Email Address';
  final enterEmailHint = 'Enter your email';
  final emailRequired = 'Please enter your email';
  final emailInvalid = 'Please enter a valid email';
  final sendResetLink = 'Send Reset Link';
  final resetLinkSent = 'Reset link sent to your email';
  String resetEmailSent(String email) => 'Password reset email sent to $email';
  final backToLogin = 'Back to Login';
  final resetPasswordTitle = 'Reset Password';
  final resetPasswordSubtitle = 'Enter your new password';
  final createNewPassword = 'Create New Password';
  final enterNewPasswordHint = 'Please enter your new password.';
  final newPasswordLabel = 'New Password';
  final enterNewPasswordPlaceholder = 'Enter new password';
  final passwordRequired = 'Please enter a password';
  final passwordMinLength = 'Password must be at least 6 characters';
  final confirmPasswordRequired = 'Please confirm your password';
  final confirmNewPasswordRequired = 'Please confirm your new password';
  final passwordsDoNotMatch = 'Passwords do not match';
  final confirmNewPasswordHint = 'Confirm new password';
  final resetPasswordButton = 'Reset Password';
  final resetSuccess = 'Password reset successful! Please login.';
  final changePasswordTitle = 'Change Password';
  final updatePasswordTitle = 'Update Your Password';
  final updatePasswordHint =
      'Please enter your current password and choose a new one.';
  final currentPasswordLabel = 'Current Password';
  final enterCurrentPasswordHint = 'Enter current password';
  final currentPasswordRequired = 'Please enter your current password';
  final newPasswordRequired = 'Please enter a new password';
  final passwordMustBeDifferent = 'New password must be different from current';
  final confirmNewPasswordLabel = 'Confirm New Password';
  final changePasswordButton = 'Change Password';
  final passwordChanged = 'Password changed successfully';
  final passwordChangeSuccess = 'Password changed successfully!';

  // Email Verification
  final verifyEmailTitle = 'Verify Your Email';
  final verifyEmailSubtitle =
      'Click the button to send a verification email. This unlocks all features!';
  final sendVerificationEmail = 'Send Verification Email';
  final emailSent = 'Verification email sent to';
  final checkInbox = 'Check your inbox';
  final checkSpamFolder = '. Please check your spam folder as well.';
  final verificationLinkSent = "We've sent a verification link to ";
  final verificationSuccess = 'Email Verified!';
  final verificationSuccessMessage =
      'Your email has been successfully verified';
  final verificationSuccessTitle = 'Verification Successful!';
  final verificationWelcomeMessage =
      'Welcome, User! Your account is now active and ready to go.';
  final skipVerificationDevOnly = 'Skip Verification (Dev Only)';
  final accountCreated = 'Account created';
  final pleaseLogin = 'Please login to continue';
  final openEmailApp = 'Open Email App';
  final didntReceive = "Didn't receive it? ";
  String resendIn(int seconds) => 'Resend in ${seconds}s';
  final continueToDashboard = 'Continue to Dashboard';

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
// ONBOARDING STRINGS - Onboarding Screens
// ============================================================================
class _OnboardingStrings {
  const _OnboardingStrings();

  // Slides
  final slide1Title = 'Welcome to Your All-in-One BalanceIQ';
  final slide1Description =
      'Centralize your digital life and automate tasks with ease.';
  final slide2Title = 'Powered by n8n Automation';
  final slide2Description =
      'Connect your favorite apps and create powerful workflows without any code.';
  final slide3Title = 'Chat with Your AI Assistant';
  final slide3Description =
      'Get answers, generate content, and control your automations with a simple chat.';
  final slide4Title = 'Manage Your Work & Life';
  final slide4Description =
      'Handle your finances, e-commerce, and social media all in one place.';

  // Actions
  final getStarted = 'Get Started';
  final logInButton = 'Log In';
}

// ============================================================================
// CHAT STRINGS - Chat Interface
// ============================================================================
class _ChatStrings {
  const _ChatStrings();

  // Input
  final inputPlaceholder = 'Ask about your finances...';
  final inputPlaceholderGeneral = 'What do you want to write?';
  final sendMessage = 'Send';
  final attachFile = 'Attach File';
  final camera = 'Camera';
  final gallery = 'Gallery';
  final files = 'Files';
  final drive = 'Drive';

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

  // Errors & Messages
  String imagePickFailed(String error) => 'Failed to pick image: $error';
  String photoFailed(String error) => 'Failed to take photo: $error';
  final micPermissionDenied = 'Microphone permission denied';
  final sentMedia = 'Sent media';
  final tokenLimitReached = 'Daily token limit reached. Chat unavailable.';
  String nearTokenLimit(int remaining) =>
      'Near token limit ($remaining remaining)';
  final limitReached = 'Limit reached';

  // Access Control
  final emailVerificationRequired = 'Email Verification Required';
  final emailVerificationMessage =
      'Please verify your email address to use the chat feature.';
  final verifyEmailButton = 'Verify Email';
  final subscriptionRequired = 'Subscription Required';
  final subscriptionRequiredMessage =
      'You need an active subscription plan to use the chat feature.';
  final viewPlans = 'View Plans';
  final subscriptionExpired = 'Subscription Expired';
  final subscriptionExpiredMessage =
      'Your subscription has expired. Please renew to continue using the chat feature.';
  final renewSubscription = 'Renew Subscription';
  final tokenLimitExceeded = 'Token Limit Exceeded';
  final tokenLimitExceededMessage = 'You have reached your daily token limit.';
  final upgradePlan = 'Upgrade Plan';
  final tooManyRequests = 'Too Many Requests';
  final rateLimitMessage = 'Please wait a moment before sending more messages.';
  final backToChat = 'Back to Chat';
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
  final spendingByCategory = 'Spending by Category';
  final financialRatios = 'Financial Ratios';
  final accounts = 'Accounts';
  final biggestIncome = 'Biggest Income';
  final biggestExpense = 'Biggest Expense';
  final categories = 'Top Categories';
  final categoryBreakdown = 'Category Breakdown';
  final recentTransactions = 'Recent Transactions';
  final expenseRatio = 'Expense Ratio';
  final savingsRate = 'Savings Rate';

  // Ratios
  final incomeExpenseRatio = 'Income/Expense Ratio';

  // Date Selector
  final selectDateRange = 'Select Date Range';
  final selectDate = 'Select Date';
  final customRange = 'Custom Range';
  final apply = 'Apply';

  // Empty States
  final noTransactions = 'No transactions yet';
  final noTransactionsMessage =
      'Start tracking your finances by adding transactions';
  final noDataForPeriod = 'No data for this period';

  // Welcome Page
  final welcomeToApp = 'Welcome to BalanceIQ';
  final welcomeSubtitle =
      'Start tracking your finances and\\ntake control of your money';
  final trackExpenses = 'Track Expenses';
  final trackExpensesDesc = 'Monitor your spending in real-time';
  final smartInsights = 'Smart Insights';
  final smartInsightsDesc = 'Get AI-powered financial advice';
  final reachGoals = 'Reach Goals';
  final reachGoalsDesc = 'Save smarter with personalized plans';

  // Error Page
  final errorTitle = 'Oops! Something went wrong';
  final commonIssues = 'Common issues:';
  final checkInternet = 'Check your internet connection';
  final serverDown = 'Server might be temporarily down';
  final tryAgainMoments = 'Try again in a few moments';
  final goToLogin = 'Go to Login';
  final backToLoginPage = 'Back to Login Page';

  // Tour
  final completeProfile = 'Complete Your Profile';
  final verifyEmailSetup =
      'Tap here to verify your email and set up your account.';
}

// ============================================================================
// TRANSACTIONS STRINGS - Transaction Management
// ============================================================================
class _TransactionsStrings {
  const _TransactionsStrings();

  // List
  final title = 'Transactions';
  final allTransactions = 'All Transactions';
  final recentTransactions = 'Recent Transactions';
  final filterTransactions = 'Filter';
  final sortBy = 'Sort By';
  final searchTransactions = 'Search transactions...';
  final searchHint = 'Search transactions...';
  final dateRange = 'Date Range';
  final all = 'All';
  final noTransactionsFound = 'No transactions found matching your criteria.';

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
  final choosePlanTitle = 'Choose Your Plan';
  final choosePlanSubtitle = 'Select the plan that works best for you';
  final currentPlan = 'Current Plan';
  final upgradePlan = 'Upgrade Plan';
  final subscribeToPlan = 'Subscribe';
  final subscribeButton = 'Subscribe';
  final yearlySavings = 'Save 20% with yearly billing';
  final termsOfService = 'Terms of Service';
  final privacyPolicy = 'Privacy Policy';
  final monthly = 'Monthly';
  final yearly = 'Yearly';
  final perMonth = '/ month';
  final mostPopular = 'Most Popular';

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
  final manageSubscriptionTitle = 'Manage Subscription';
  final noActiveSubscription = 'No Active Subscription';
  final subscribeMessage = 'Subscribe to a plan to unlock premium features';
  final viewPlans = 'View Plans';
  final subscriptionDetails = 'Subscription Details';
  final activePlan = 'Active Plan';
  final inactive = 'Inactive';
  String nextBillingDate(String date) => 'Next billing date: $date';
  String expiresIn(int days) => 'Expires in $days days';
  final changePlan = 'Change Plan';
  final startDate = 'Start Date';
  final endDate = 'End Date';
  final daysRemaining = 'Days Remaining';
  final status = 'Status';
  final autoRenewal = 'Auto-renewal';
  final autoRenewalDescription = 'Automatically renew subscription';
  final cancelConfirmation =
      'Are you sure you want to cancel your subscription? You will lose access to all premium features at the end of your current billing period.';
  final cancelButton = 'Cancel Subscription';
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
  final somethingWrong = 'Something went wrong';
  final tryAgain = 'An error occurred. Please try again.';
  final tryAgainLater = 'Please try again later';
  final contactSupport = 'Contact support if the problem persists';

  // Recovery Actions
  final retry = 'Retry';
  final goBack = 'Go Back';
  final goHome = 'Go to Home';
  final refresh = 'Refresh';
}
