import 'package:equatable/equatable.dart';

class SpendingTrendPoint extends Equatable {
  final int day;
  final double amount;

  const SpendingTrendPoint({
    required this.day,
    required this.amount,
  });

  @override
  List<Object?> get props => [day, amount];
}

class DashboardSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final double expenseRatio;
  final double savingsRate;
  final int incomeTransactions;
  final int expenseTransactions;
  final double avgIncome;
  final double avgExpense;
  final List<SpendingTrendPoint> spendingTrend;
  final Map<String, double> categories;
  final Map<String, double> accountsBreakdown;
  final double biggestExpenseAmount;
  final String biggestExpenseDescription;
  final String expenseCategory;
  final String expenseAccount;
  final String biggestCategoryName;
  final double biggestCategoryAmount;
  final String period;
  final int daysRemainingInMonth;

  const DashboardSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.expenseRatio,
    required this.savingsRate,
    required this.incomeTransactions,
    required this.expenseTransactions,
    required this.avgIncome,
    required this.avgExpense,
    required this.spendingTrend,
    required this.categories,
    required this.accountsBreakdown,
    required this.biggestExpenseAmount,
    required this.biggestExpenseDescription,
    required this.expenseCategory,
    required this.expenseAccount,
    required this.biggestCategoryName,
    required this.biggestCategoryAmount,
    required this.period,
    required this.daysRemainingInMonth,
  });

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        netBalance,
        expenseRatio,
        savingsRate,
        incomeTransactions,
        expenseTransactions,
        avgIncome,
        avgExpense,
        spendingTrend,
        categories,
        accountsBreakdown,
        biggestExpenseAmount,
        biggestExpenseDescription,
        expenseCategory,
        expenseAccount,
        biggestCategoryName,
        biggestCategoryAmount,
        period,
        daysRemainingInMonth,
      ];
}
