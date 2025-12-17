/// Centralized Strings for Donfin AI
/// Organized by Feature with Common Section
///
/// Updated: 2025-12-17
/// Changes: Applied UX research recommendations, added Bangladesh market support,
/// fixed terminology inconsistencies, improved error messages, added accessibility strings
///
/// Usage: AppStrings.common.buttonSave, AppStrings.auth.welcomeTitle, etc.
class AppStrings {
  const AppStrings._();

  // App-level constants
  static const appName = 'Donfin AI';

  // Feature sections
  static const common = _CommonStrings();
  static const auth = _AuthStrings();
  static const onboarding = _OnboardingStrings();
  static const chat = _ChatStrings();
  static const chatPrompts = _ChatBotPrompts();
  static const dashboard = _DashboardStrings();
  static const transactions = _TransactionsStrings();
  static const subscription = _SubscriptionStrings();
  static const profile = _ProfileStrings();
  static const accounts = _AccountStrings();
  static const accessibility = _AccessibilityStrings();
  static const sync = _SyncStrings();
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
  final gotIt = 'Got It';
  final okay = 'Okay';
  final understand = 'I Understand';

  // Status
  final loading = 'Loading';
  final loadingContent = 'Loading content, please wait';
  final success = 'Success';
  final error = 'Error';
  final warning = 'Warning';
  final info = 'Info';
  final processing = 'Processing...';
  final processingRequest = 'Processing your request';
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
  final savedSuccessfully = 'Saved successfully!';
  final deletedSuccessfully = 'Deleted successfully!';
  final updatedSuccessfully = 'Updated successfully!';
  final operationFailed = 'Unable to complete action. Please try again.';

  // Time
  final today = 'Today';
  final yesterday = 'Yesterday';
  final thisWeek = 'This Week';
  final thisMonth = 'This Month';
  final thisYear = 'This Year';
  final custom = 'Custom';

  // Currency
  final currencySymbol = '৳';
  final currencyCode = 'BDT';
  final currencyName = 'Bangladeshi Taka';
  final takaShort = 'Tk';

  // Misc
  final noData = 'No data available';
  final noDataYet = 'No data available yet. Start tracking to see insights!';
  final comingSoon = 'Coming Soon';
  final selectTextMode = 'Select text mode';
}

// ============================================================================
// AUTH STRINGS - Authentication & Onboarding
// ============================================================================
class _AuthStrings {
  const _AuthStrings();

  // Onboarding
  final welcomeTitle = 'Donfin AI';
  final welcomeSubtitle = 'Your AI-powered personal finance assistant';
  final continueGoogle = 'Continue with Google';
  final continueApple = 'Continue with Apple';
  final termsPrivacy =
      'By continuing, you agree to our Terms of Service\nand Privacy Policy';
  final termsLink = 'View Terms of Service';
  final privacyLink = 'View Privacy Policy';

  // Login
  final loginTitle = 'Welcome Back';
  final loginSubtitle = 'Sign in to continue';
  final emailLabel = 'Email';
  final emailHint = 'Enter your email';
  final passwordLabel = 'Password';
  final passwordHint = 'Enter your password';
  final forgotPassword = 'Forgot Password?';
  final loginButton = 'Login';
  final noAccount = "Don't have an account?";
  final signupLink = 'Sign Up';

  // Signup
  final signupTitle = 'Create Account';
  final signupSubtitle = 'Join Donfin AI today';
  final nameLabel = 'Full Name';
  final nameHint = 'Enter your name';
  final confirmPasswordLabel = 'Confirm Password';
  final confirmPasswordHint = 'Re-enter your password';
  final signupButton = 'Sign Up';
  final haveAccount = 'Already have an account?';
  final loginLink = 'Login';

  // Password Management
  final forgotPasswordTitle = 'Forgot Password';
  final forgotPasswordSubtitle = 'Enter your email to reset password';
  final resetYourPassword = 'Reset Your Password';
  final resetInstructions =
      'Enter your email address and we\'ll send you instructions to reset your password. The link will expire in 24 hours.';
  final emailAddressLabel = 'Email Address';
  final enterEmailHint = 'Enter your email';
  final emailRequired = 'Please enter your email';
  final emailInvalid = 'Please enter a valid email';
  final sendResetLink = 'Send Reset Link';
  final resetLinkSent =
      'Password reset link sent! Check your email (and spam folder) for instructions.';
  String resetEmailSent(String email) =>
      'Password reset email sent to $email. Please check your inbox and spam folder.';
  final backToLogin = 'Back to Login';
  final resetPasswordTitle = 'Reset Password';
  final resetPasswordSubtitle = 'Enter your new password';
  final createNewPassword = 'Create New Password';
  final enterNewPasswordHint = 'Please enter your new password.';
  final newPasswordLabel = 'New Password';
  final enterNewPasswordPlaceholder = 'Enter new password';
  final passwordRequired = 'Please enter a password';
  final passwordMinLength = 'Password must be at least 8 characters';
  final passwordStrengthHint =
      'Use at least 8 characters with uppercase, lowercase, and numbers';
  final confirmPasswordRequired = 'Please confirm your password';
  final confirmNewPasswordRequired = 'Please confirm your new password';
  final passwordsDoNotMatch = 'Passwords do not match';
  final confirmNewPasswordHint = 'Confirm new password';
  final resetPasswordButton = 'Reset Password';
  final resetSuccess = 'Password reset successful! You can now login.';
  final changePasswordTitle = 'Change Password';
  final updatePasswordTitle = 'Update Your Password';
  final updatePasswordHint =
      'Please enter your current password and choose a new one.';
  final currentPasswordLabel = 'Current Password';
  final enterCurrentPasswordHint = 'Enter current password';
  final currentPasswordRequired = 'Please enter your current password';
  final newPasswordRequired = 'Please enter a new password';
  final passwordMustBeDifferent =
      'New password must be different from current password';
  final confirmNewPasswordLabel = 'Confirm New Password';
  final changePasswordButton = 'Change Password';
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
      'Welcome! Your account is now active and ready to go.';
  final skipVerificationDevOnly = 'Skip Verification (Dev Only)';
  final accountCreated = 'Account created successfully!';
  final pleaseLogin = 'Please login to continue';
  final openEmailApp = 'Open Email App';
  final didntReceive = "Didn't receive it? ";
  String resendIn(int seconds) => 'Resend in ${seconds}s';
  final continueToDashboard = 'Continue to Dashboard';

  // Session Management
  final sessionExpired = 'Session Expired';
  final sessionExpiredMessage =
      'For your security, please login again to continue.';
  final emailAlreadyInUse =
      'This email is already registered. Try logging in instead.';

  // Loading & Errors
  final signingIn = 'Signing in';
  final signingUp = 'Creating account';
  final sendingEmail = 'Sending email';
  final networkError = 'Network Error';
  final networkErrorMessage = 'Please check your internet connection';
  final authError = 'Unable to sign in. Please check your email and password.';
  final tryAgain = 'Try Again';

  // Security
  final dataSecurityNotice = 'Your financial data is encrypted and secure';
  final biometricOptional = 'Add fingerprint or face unlock (optional)';
}

// ============================================================================
// ONBOARDING STRINGS - Onboarding Screens
// ============================================================================
class _OnboardingStrings {
  const _OnboardingStrings();

  // Slides
  final slide1Title = 'Welcome to Donfin AI';
  final slide1Description =
      'Your AI-powered personal finance assistant for smart money management';
  final slide2Title = 'Track Every Taka';
  final slide2Description =
      'Easily track expenses, income, and manage your cash, bank, and mobile money';
  final slide3Title = 'Chat with Your AI Assistant';
  final slide3Description =
      'Get answers, track expenses, and receive personalized financial advice through conversation';
  final slide4Title = 'Reach Your Financial Goals';
  final slide4Description =
      'Set budgets, track progress, and achieve your savings goals faster';

  // Actions
  final getStarted = 'Get Started';
  final loginButton = 'Login';
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
  final regenerating = 'Regenerating response';
  final thinking = 'Thinking';

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
  final micPermissionDenied =
      'Microphone permission denied. Enable it in Settings to use voice input.';
  final cameraPermissionDenied =
      'Camera permission denied. Enable it in Settings to take photos.';
  final storagePermissionDenied =
      'Storage permission denied. Enable it in Settings to attach files.';
  final sentMedia = 'Sent media';
  final messageLimitReached =
      'Daily message limit reached. Resets at midnight or upgrade your plan.';
  String nearMessageLimit(int remaining) =>
      'You have $remaining messages tokens today';
  final limitReached = 'Limit Reached';

  // GenUI Errors
  String errorRenderingChart(String error) => 'Error rendering chart: $error';
  String errorRenderingTable(String error) => 'Error rendering table: $error';
  String errorRenderingSummary(String error) =>
      'Error rendering summary card: $error';
  String errorRenderingActionList(String error) =>
      'Error rendering action list: $error';
  String errorRenderingMetric(String error) =>
      'Error rendering metric card: $error';
  String errorRenderingProgress(String error) =>
      'Error rendering progress: $error';
  String errorRenderingActionButtons(String error) =>
      'Error rendering action buttons: $error';
  String errorRenderingStats(String error) => 'Error rendering stats: $error';
  String errorRenderingInsight(String error) =>
      'Error rendering insight card: $error';
  final errorMissingChartType =
      'Error rendering chart: Missing or invalid chart type';
  String actionTriggered(String action) => 'Action triggered: $action';
  final comingSoon = 'Coming soon!';

  // Bot Status
  final botNotResponding =
      'AI assistant is not responding. Please try again in a moment.';
  final messageQueuedOffline = 'Message queued. Will send when online.';
  final voiceRecordingFailed =
      'Voice recording failed. Check microphone permission.';
  final imageUploadFailed =
      'Image upload failed. Try a smaller file (max 10MB).';
  final chatHistoryCleared = 'Chat history cleared';

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
  final messageLimitExceeded = 'Message Limit Exceeded';
  final messageLimitExceededMessage =
      'You have reached your daily message limit. Resets at midnight.';
  final upgradePlan = 'Upgrade Plan';
  final tooManyRequests = 'Too Many Requests';
  final rateLimitMessage = 'Please wait a moment before sending more messages.';
  final backToChat = 'Back to Chat';
}

// ============================================================================
// CHAT PROMPTS - Suggested Prompts per Bot
// ============================================================================
class _ChatBotPrompts {
  const _ChatBotPrompts();

  // Balance Tracker
  final trackExpenseLabel = 'Track expense';
  final trackExpensePrompt = 'I spent 500 taka on groceries';
  final checkBalanceLabel = 'Check balance';
  final checkBalancePrompt = 'What is my current balance?';
  final monthlySummaryLabel = 'Monthly summary';
  final monthlySummaryPrompt = 'Show me my spending summary for this month';
  final addIncomeLabel = 'Add income';
  final addIncomePrompt = 'I received salary of 50,000 taka';

  // Investment Guru
  final investmentTipsLabel = 'Investment tips';
  final investmentTipsPrompt =
      'What are some good investment options for beginners?';
  final stockAdviceLabel = 'Stock advice';
  final stockAdvicePrompt = 'Should I invest in stocks or mutual funds?';
  final portfolioReviewLabel = 'Portfolio review';
  final portfolioReviewPrompt =
      'How should I diversify my investment portfolio?';
  final marketTrendsLabel = 'Market trends';
  final marketTrendsPrompt = 'What are the current market trends?';

  // Budget Planner
  final createBudgetLabel = 'Create budget';
  final createBudgetPrompt = 'Help me create a monthly budget plan';
  final budgetCategoriesLabel = 'Budget categories';
  final budgetCategoriesPrompt = 'Show me my spending by category';
  final saveMoneyLabel = 'Save money';
  final saveMoneyPrompt = 'How can I save 20% of my income?';
  final budgetAlertsLabel = 'Budget alerts';
  final budgetAlertsPrompt = 'Am I overspending in any category?';

  // FinTips
  final moneyTipsLabel = 'Money tips';
  final moneyTipsPrompt = 'Give me some practical money management tips';
  final learnFinanceLabel = 'Learn finance';
  final learnFinancePrompt = 'Explain the concept of compound interest';
  final emergencyFundLabel = 'Emergency fund';
  final emergencyFundPrompt = 'How much should I keep in my emergency fund?';
  final creditAdviceLabel = 'Credit advice';
  final creditAdvicePrompt =
      'What are the best practices for using credit cards?';

  // Default / General
  final getStartedLabel = 'Get started';
  final getStartedPrompt = 'How can you help me with my finances?';
  final learnMoreLabel = 'Learn more';
  final learnMorePrompt = 'Tell me what you can do';

  // UI Text
  final howCanIHelp = 'How can I help you today?';
  final choosePrompt = 'Choose a prompt or type your own question';
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
  final yourBalance = 'Your Balance';
  final netBalance = 'Net Balance';
  final totalIncome = 'Total Income';
  final totalExpense = 'Total Expense';
  final totalIncomeThisMonth = 'Total Income (This Month)';
  final totalExpenseThisMonth = 'Total Expense (This Month)';
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
  final expenseRatioHelp = 'Percentage of your income spent this month';
  final savingsRate = 'Savings Rate';
  final savingsRateHelp = 'Percentage of your income saved this month';

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
      'Start tracking your finances by chatting with your AI assistant or adding transactions manually';
  final noDataForPeriod = 'No data for this period';

  // Welcome Page
  final welcomeToApp = 'Welcome to Donfin AI';
  final welcomeSubtitle =
      'Start tracking your finances and\ntake control of your money';
  final trackExpenses = 'Track Expenses';
  final trackExpensesDesc = 'Monitor your spending in real-time';
  final smartInsights = 'Smart Insights';
  final smartInsightsDesc = 'Get AI-powered financial advice';
  final reachGoals = 'Reach Goals';
  final reachGoalsDesc = 'Save smarter with personalized plans';

  // Error Page
  final errorTitle = 'Something went wrong';
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
  final categoryFreelance = 'Freelance Income';
  final categoryRemittance = 'Remittance';
  final categoryBusiness = 'Business Income';
  final categoryInvestment = 'Investment';
  final categoryGift = 'Gift';
  final categoryMobileRecharge = 'Mobile Recharge';
  final categoryInternetBill = 'Internet Bill';
  final categoryRent = 'Rent';
  final categoryOther = 'Other';

  // Actions
  final addTransaction = 'Add Transaction';
  final updateTransaction = 'Update';
  final deleteConfirmTitle = 'Delete Transaction';
  final deleteConfirmMessage =
      'Are you sure you want to delete this transaction? This action cannot be undone.';
  final deleting = 'Deleting transaction';
  final noDescription = 'No description';

  // Transaction Confirmations
  final largeTransactionTitle = 'Large Amount';
  String largeTransactionConfirm(String amount) =>
      'This is a large amount ($amount). Please confirm this transaction.';
  final duplicateWarning = 'Possible Duplicate';
  final duplicateMessage =
      'This looks similar to a recent transaction. Add anyway?';
  final addAnyway = 'Add Anyway';
  final futureTransactionWarning = 'Future Date';
  final futureTransactionMessage = 'This transaction is dated in the future';
  final categoryNotSelected = 'Please select a category';
  final invalidDate = 'Please select a valid date';
  final invalidAmount = 'Please enter a valid amount';

  // Status
  final transactionAdded = 'Transaction added successfully!';
  final transactionUpdated = 'Transaction updated successfully!';
  final transactionDeleted = 'Transaction deleted successfully!';
  String expenseRecorded(String amount, String category) =>
      '$amount expense recorded in $category';
  String incomeAdded(String amount) => '$amount income added to your balance';
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
      'Are you sure you want to cancel your subscription? You will lose access to premium features at the end of your current billing period.';
  final cancelButton = 'Cancel Subscription';
  final planDetails = 'Plan Details';
  final renewsOn = 'Renews on';
  final expiresOn = 'Expires on';
  final daysLeft = 'days left';
  final managePlan = 'Manage Plan';
  final cancelSubscription = 'Cancel Subscription';
  final renewSubscription = 'Renew Subscription';

  // Plan Changes
  final downgradePlanTitle = 'Downgrade Plan';
  String downgradePlanConfirm(String features) =>
      'Downgrading will disable: $features. Continue?';
  final upgradePlanTitle = 'Upgrade Plan';
  final upgradePlanMessage = 'Unlock more features with a higher plan';

  // Payment
  final paymentFailed = 'Payment Failed';
  final paymentFailedMessage =
      'Payment could not be processed. Please update your payment method and try again.';
  final updatePaymentMethod = 'Update Payment Method';
  final subscriptionPaused = 'Subscription Paused';
  final subscriptionPausedMessage =
      'Your subscription is paused. Renew to access premium features.';

  // Trial
  final trialEnding = 'Trial Ending Soon';
  String trialEndingMessage(int days) =>
      'Your trial ends in $days days. Subscribe to continue enjoying premium features.';

  // Status
  final active = 'Active';
  final expired = 'Expired';
  final cancelled = 'Cancelled';
  final trial = 'Trial';

  // Messages
  final noActivePlan = 'No Active Plan';
  final subscriptionSuccess = 'Subscription successful!';
  final subscriptionFailed = 'Subscription failed. Please try again.';
  final cancellationSuccess = 'Subscription cancelled successfully';
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
  final logOut = 'Logout';
  final logOutConfirm = 'Are you sure you want to logout?';
  final deleteAccount = 'Delete Account';
  final deleteAccountTitle = 'Delete Account Permanently?';
  final deleteAccountWarning =
      'All your financial data, transactions, and account history will be permanently deleted. This action cannot be undone.';
  final deleteAccountButton = 'Delete My Account';
  final deleteAccountSuccess = 'Account deleted. We\'re sorry to see you go.';

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
  final themeChanged = 'Theme changed successfully';

  // Notifications
  final pushNotifications = 'Push Notifications';
  final emailNotifications = 'Email Notifications';
  final transactionAlerts = 'Transaction Alerts';
  final budgetAlerts = 'Budget Alerts';
  final weeklyReports = 'Weekly Reports';
  final notificationSettingsSaved = 'Notification preferences saved';

  // Profile Updates
  final profileUpdated = 'Profile updated successfully!';
  final emailVerified = 'Email verified successfully!';
  final languageChanged = 'Language changed successfully';
}

// ============================================================================
// ACCOUNT STRINGS - Account Types (Bangladesh-specific)
// ============================================================================
class _AccountStrings {
  const _AccountStrings();

  // Account Types
  final accountType = 'Account Type';
  final accountTypeCash = 'Cash';
  final accountTypeMobileBanking = 'Mobile Banking';
  final accountTypeBank = 'Bank Account';
  final accountTypeCard = 'Debit/Credit Card';

  // Mobile Banking (Bangladesh)
  final mobileBanking = 'Mobile Banking';
  final bKash = 'bKash';
  final nagad = 'Nagad';
  final rocket = 'Rocket';
  final upay = 'Upay';
  final mobileBankingNumber = 'Mobile Banking Number';
  final mobileBankingBalance = 'Mobile Banking Balance';
  final mobileMoneyTransfer = 'Mobile Money Transfer';
  final cashInOut = 'Cash In/Out';

  // Account Management
  final cashInHand = 'Cash in Hand';
  final bankBalance = 'Bank Balance';
  final totalBalance = 'Total Balance';
  final addAccount = 'Add Account';
  final editAccount = 'Edit Account';
  final deleteAccount = 'Delete Account';
  final accountName = 'Account Name';
  final accountBalance = 'Account Balance';
  final setAsDefault = 'Set as Default';
  final defaultAccount = 'Default Account';

  // Payment Methods
  final paymentMethod = 'Payment Method';
  final paymentCash = 'Cash';
  final paymentMobileBanking = 'Mobile Banking';
  final paymentBankTransfer = 'Bank Transfer';
  final paymentCard = 'Debit/Credit Card';
}

// ============================================================================
// ACCESSIBILITY STRINGS - Screen Reader & Accessibility Labels
// ============================================================================
class _AccessibilityStrings {
  const _AccessibilityStrings();

  // Button Labels
  final sendMessageButton = 'Send message';
  final copyToClipboard = 'Copy message to clipboard';
  final attachFileButton = 'Attach file or image';
  final voiceInputButton = 'Record voice message';
  final passwordVisibilityToggle = 'Toggle password visibility';
  final showPassword = 'Show password';
  final hidePassword = 'Hide password';
  final refreshData = 'Pull down to refresh data';
  final viewAllTransactions = 'View all transactions';
  final retryLoadingData = 'Retry loading data';

  // Content Descriptions
  final balanceCardDescription = 'Your current balance and financial summary';
  final spendingChartDescription = 'Spending trend chart for selected period';
  final categoryChartDescription = 'Spending breakdown by category';
  final profileImageLabel = 'Profile picture. Tap to change.';
  final botAvatarLabel = 'AI assistant avatar';
  final transactionItemDescription = 'Transaction item. Tap to view details.';

  // Status Announcements
  final loadingContentAnnouncement = 'Loading content, please wait';
  final processingRequestAnnouncement = 'Processing your request';
  final dataLoadedAnnouncement = 'Data loaded successfully';
  final errorOccurredAnnouncement = 'An error occurred';
  final transactionAddedAnnouncement = 'Transaction added successfully';
  final messagesentAnnouncement = 'Message sent';
}

// ============================================================================
// SYNC STRINGS - Synchronization & Offline Mode
// ============================================================================
class _SyncStrings {
  const _SyncStrings();

  // Sync Status
  final syncing = 'Syncing';
  final syncingData = 'Syncing your data';
  final syncComplete = 'All changes synced successfully';
  final syncFailed =
      'Some changes couldn\'t sync. Will retry automatically when online.';
  final lastSynced = 'Last synced';
  final neverSynced = 'Not yet synced';
  String lastSyncedAt(String time) => 'Last synced $time ago';

  // Offline Mode
  final offline = 'Offline';
  final offlineMode = 'You\'re offline. Changes will sync when connected.';
  final offlineMessage =
      'No internet connection. You can continue working, and your changes will sync automatically when you\'re back online.';
  final cachedData = 'Showing saved data. Pull down to refresh.';
  final workingOffline = 'Working offline';

  // Sync Actions
  final syncNow = 'Sync Now';
  final syncPending = 'Sync pending';
  String changesPending(int count) => '$count changes pending sync';
  final retrySync = 'Retry Sync';
  final syncSettings = 'Sync Settings';
  final autoSync = 'Auto-sync';
  final autoSyncDescription = 'Automatically sync when connected to internet';
  final syncOnWifiOnly = 'Sync on Wi-Fi only';

  // Data Download
  final downloadingData = 'Downloading data';
  final downloadComplete = 'Download complete';
  final downloadFailed = 'Download failed. Check your connection.';

  // Export/Import
  final exportingData = 'Exporting data';
  final exportSuccess = 'Data exported successfully';
  final exportFailed = 'Export failed. Please try again.';
  final importingData = 'Importing data';
  final importSuccess = 'Data imported successfully';
  final importFailed = 'Import failed. Check file format.';
  final noDataToExport = 'No data available to export';
}

// ============================================================================
// ERROR STRINGS - Error Messages
// ============================================================================
class _ErrorStrings {
  const _ErrorStrings();

  // Network Errors
  final networkError = 'Network Error';
  final noInternet =
      'No internet connection. Connect to Wi-Fi or mobile data to continue.';
  final serverError =
      'Server error occurred. Our team has been notified. Please try again later.';
  final timeoutError =
      'Connection took too long. Please check your internet and try again.';
  final connectionFailed =
      'Couldn\'t connect to server. Check your internet connection and try again.';

  // Validation Errors
  final invalidInput = 'Invalid input';
  final requiredField = 'This field is required';
  final invalidEmail = 'Invalid email address';
  final invalidAmount = 'Invalid amount';
  final amountTooLarge = 'Amount is too large';
  final amountTooSmall = 'Amount must be greater than 0';

  // Auth Errors
  final authFailed = 'Unable to sign in. Please check your email and password.';
  final invalidCredentials = 'Invalid email or password';
  final emailAlreadyExists = 'This email is already registered';
  final weakPassword =
      'Password is too weak. Use at least 8 characters with uppercase, lowercase, and numbers.';
  final accountNotFound =
      'Account not found. Please check your email or sign up.';
  final emailNotVerified =
      'Email not verified. Please check your inbox for verification link.';

  // Data Errors
  final loadFailed =
      'Couldn\'t load data. Pull down to refresh or check your connection.';
  final saveFailed =
      'Couldn\'t save changes. Check your internet connection and try again.';
  final deleteFailed = 'Couldn\'t delete. Please try again.';
  final updateFailed =
      'Couldn\'t update. Check your connection and try again.';

  // Storage Errors
  final storageNearFull =
      'Storage almost full. Consider archiving old transactions.';
  final storageFull =
      'Storage full. Please delete some data or upgrade your plan.';

  // Limit Errors
  final transactionLimitReached =
      'Free plan limit: 50 transactions per month. Upgrade for unlimited.';
  final exportLimitReached =
      'Export limit reached. Upgrade for unlimited exports.';
  final featureNotAvailable =
      'This feature is not available on your current plan.';

  // Generic
  final somethingWentWrong =
      'We couldn\'t complete that action. Please try again.';
  final genericError = 'An error occurred. Please try again.';
  final tryAgainLater =
      'Something went wrong. Please try again in a few moments.';
  final contactSupport =
      'If the problem persists, please contact our support team.';

  // Recovery Actions
  final retry = 'Retry';
  final goBack = 'Go Back';
  final goHome = 'Go to Home';
  final refresh = 'Refresh';
  final cancel = 'Cancel';
}
