/// Centralized Strings for BalanceIQ.
/// Organized by Feature.
class AppStrings {
  const AppStrings._();

  static const appName = 'BalanceIQ';

  static const auth = _AuthStrings();
  static const chat = _ChatStrings();
  static const dashboard = _DashboardStrings();
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
}

class _DashboardStrings {
  const _DashboardStrings();
  final totalBalance = 'Total Balance';
  final income = 'Income';
  final expense = 'Expense';
  final recentTransactions = 'Recent Transactions';
  final viewAll = 'View All';
}
