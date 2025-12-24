import 'package:balance_iq/core/strings/dashboard_strings.dart';

class DashboardStringsImpl implements DashboardStrings {
  const DashboardStringsImpl();

  @override
  String get welcome => 'Welcome back,';
  @override
  String get goodMorning => 'Good Morning';
  @override
  String get goodAfternoon => 'Good Afternoon';
  @override
  String get goodEvening => 'Good Evening';
  @override
  String get yourBalance => 'Your Balance';
  @override
  String get netBalance => 'Net Balance';
  @override
  String get totalIncome => 'Total Income';
  @override
  String get totalExpense => 'Total Expense';
  @override
  String get totalIncomeThisMonth => 'Total Income (This Month)';
  @override
  String get totalExpenseThisMonth => 'Total Expense (This Month)';
  @override
  String get income => 'Income';
  @override
  String get expense => 'Expense';

  @override
  String get spendingTrend => 'Spending Trend';
  @override
  String get spendingByCategory => 'Spending by Category';
  @override
  String get financialRatios => 'Financial Ratios';
  @override
  String get accounts => 'Accounts';
  @override
  String get biggestIncome => 'Biggest Income';
  @override
  String get biggestExpense => 'Biggest Expense';
  @override
  String get categories => 'Top Categories';
  @override
  String get categoryBreakdown => 'Category Breakdown';
  @override
  String get recentTransactions => 'Recent Transactions';
  @override
  String get expenseRatio => 'Expense Ratio';
  @override
  String get expenseRatioHelp => 'Percentage of your income spent this month';
  @override
  String get savingsRate => 'Savings Rate';
  @override
  String get savingsRateHelp => 'Percentage of your income saved this month';
  @override
  String get incomeExpenseRatio => 'Income/Expense Ratio';

  @override
  String get selectDateRange => 'Select Date Range';
  @override
  String get selectDate => 'Select Date';
  @override
  String get customRange => 'Custom Range';
  @override
  String get apply => 'Apply';

  @override
  String get noTransactions => 'No transactions yet';
  @override
  String get noTransactionsMessage =>
      'Start tracking your finances by chatting with your AI assistant or adding transactions manually';
  @override
  String get noDataForPeriod => 'No data for this period';

  @override
  String get welcomeToApp => 'Welcome to Dolfin AI';
  @override
  String get welcomeSubtitle =>
      'Start tracking your finances and\ntake control of your money';
  @override
  String get trackExpenses => 'Track Expenses';
  @override
  String get trackExpensesDesc => 'Monitor your spending in real-time';
  @override
  String get smartInsights => 'Smart Insights';
  @override
  String get smartInsightsDesc => 'Get AI-powered financial advice';
  @override
  String get reachGoals => 'Reach Goals';
  @override
  String get reachGoalsDesc => 'Save smarter with personalized plans';

  @override
  String get errorTitle => 'Something went wrong';
  @override
  String get commonIssues => 'Common issues:';
  @override
  String get checkInternet => 'Check your internet connection';
  @override
  String get serverDown => 'Server might be temporarily down';
  @override
  String get tryAgainMoments => 'Try again in a few moments';
  @override
  String get goToLogin => 'Go to Login';
  @override
  String get backToLoginPage => 'Back to Login Page';

  @override
  String get completeProfile => 'Complete Your Profile';
  @override
  String get verifyEmailSetup =>
      'Tap here to verify your email and set up your account.';
}
