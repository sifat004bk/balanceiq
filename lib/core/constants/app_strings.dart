/// Centralized Strings for BalanceIQ.
/// Organized by Feature.
class AppStrings {
  const AppStrings._();

  static const appName = 'BalanceIQ';

  static const auth = _AuthStrings();
  static const chat = _ChatStrings();
  static const dashboard = _DashboardStrings();
  static const settings = _SettingsStrings();
  static const common = _CommonStrings();
}

class _AuthStrings {
  const _AuthStrings();
  final welcomeTitle = 'BalanceIQ';
  final welcomeSubtitle = 'Your AI-powered personal finance assistant';
  final continueGoogle = 'Continue with Google';
  final termsPrivacy =
      'By continuing, you agree to our Terms of Service\nand Privacy Policy';
}

class _ChatStrings {
  const _ChatStrings();
  final inputPlaceholder = 'Ask about your finances...';
  final suggestionBill = 'Add Electricity Bill';
  final suggestionIncome = 'Log Salary';
  final emptyStateTitle = 'Start a conversation';
  final emptyStateSubtitle =
      'I can help track expenses, set budgets, or analyze your spending.';

  final feedbackThanks = 'Thanks for the feedback!';
  final regenerating = 'Regenerating response...';
  final changeActionType = 'Change Action Type';
  final recordedIncome = 'Recorded Income';
  final recordedExpense = 'Recorded Expense';
  final change = 'Change';
}

class _DashboardStrings {
  const _DashboardStrings();
  final welcome = 'Welcome back,';
  final walletBalance = 'Wallet Balance';
  final totalIncome = 'Total Income';
  final totalExpense = 'Total Expense';
  final income = 'Income';
  final expense = 'Expense';
  final spendingTrend = 'Spending Trend';
  final financialRatios = 'Financial Ratios';
  final accounts = 'Accounts';
  final biggestIncome = 'Biggest Income';
  final biggestExpense = 'Biggest Expense';
  final categories = 'Top Categories';
  final recentTransactions = 'Recent Transactions';
  final viewAll = 'View All';
  final noData = 'No data available';
  final expenseRatio = 'Expense Ratio';
  final savingsRate = 'Savings Rate';
}

class _SettingsStrings {
  const _SettingsStrings();
  final profile = 'Profile';
  final accountDetails = 'Account Details';
  final security = 'Security';
  final notifications = 'Notifications';
  final appearance = 'Appearance';
  final helpCenter = 'Help Center';
  final logOut = 'Log Out';
  final verifyEmail = 'Verify Your Email';
  final verifyEmailDesc =
      'Click the button to send a verification email. This unlocks all features!';
  final choosePlan = 'Choose a Plan';
  final choosePlanDesc =
      'Subscribe to start tracking your finances. We have a free plan to get you started!';
  final comingSoon = 'coming soon';
  final emailSent = 'Verification email sent to';
}

class _CommonStrings {
  const _CommonStrings();
  final copied = 'Copied to clipboard';
  final selectTextMode = 'Select text mode';
}
