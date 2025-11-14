import 'package:balance_iq/features/home/domain/entities/dashbaord_summary.dart';

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.totalIncome,
    required super.totalExpense,
    required super.netBalance,
    required super.expenseRatio,
    required super.savingsRate,
    required super.incomeTransactions,
    required super.expenseTransactions,
    required super.avgIncome,
    required super.avgExpense,
    required super.spendingTrend,
    required super.categories,
    required super.accountsBreakdown,
    required super.biggestExpenseAmount,
    required super.biggestExpenseDescription,
    required super.expenseCategory,
    required super.expenseAccount,
    required super.biggestCategoryName,
    required super.biggestCategoryAmount,
    required super.period,
    required super.daysRemainingInMonth,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse spending trend with strict type checking
      final List<SpendingTrendPoint> spendingTrend = [];
      final dynamic spendingTrendData = json['spending_trend'];

      if (spendingTrendData != null) {
        if (spendingTrendData is! List) {
          throw FormatException('spending_trend must be a List');
        }

        for (final dynamic point in spendingTrendData) {
          if (point is! Map<String, dynamic>) {
            throw FormatException(
                'spending_trend item must be a Map<String, dynamic>');
          }

          spendingTrend.add(SpendingTrendPoint(
            day: _parseInt(point['day'], 'day'),
            amount: _parseDouble(point['amount'], 'amount'),
          ));
        }
      }

      // Parse categories map with strict type checking
      final Map<String, double> categories = {};
      final dynamic categoriesData = json['categories'];

      if (categoriesData != null) {
        if (categoriesData is! Map) {
          throw FormatException('categories must be a Map');
        }

        categoriesData.forEach((key, value) {
          if (key is! String) {
            throw FormatException('categories key must be String');
          }
          categories[key] = _parseDouble(value, 'categories[$key]');
        });
      }

      // Parse accounts breakdown with strict type checking
      final Map<String, double> accountsBreakdown = {};
      final dynamic accountsData = json['accounts_breakdown'];

      if (accountsData != null) {
        if (accountsData is! Map) {
          throw FormatException('accounts_breakdown must be a Map');
        }

        accountsData.forEach((key, value) {
          if (key is! String) {
            throw FormatException('accounts_breakdown key must be String');
          }
          accountsBreakdown[key] =
              _parseDouble(value, 'accounts_breakdown[$key]');
        });
      }

      return DashboardSummaryModel(
        totalIncome: _parseDouble(json['total_income'], 'total_income'),
        totalExpense: _parseDouble(json['total_expense'], 'total_expense'),
        netBalance: _parseDouble(json['net_balance'], 'net_balance'),
        expenseRatio: _parseDouble(json['expense_ratio'], 'expense_ratio'),
        savingsRate: _parseDouble(json['savings_rate'], 'savings_rate'),
        incomeTransactions:
            _parseInt(json['income_transactions'], 'income_transactions'),
        expenseTransactions:
            _parseInt(json['expense_transactions'], 'expense_transactions'),
        avgIncome: _parseDouble(json['avg_income'], 'avg_income'),
        avgExpense: _parseDouble(json['avg_expense'], 'avg_expense'),
        spendingTrend: spendingTrend,
        categories: categories,
        accountsBreakdown: accountsBreakdown,
        biggestExpenseAmount: _parseDouble(
            json['biggest_expense_amount'], 'biggest_expense_amount'),
        biggestExpenseDescription: _parseString(
            json['biggest_expense_description'], 'biggest_expense_description'),
        expenseCategory:
            _parseString(json['expense_category'], 'expense_category'),
        expenseAccount:
            _parseString(json['expense_account'], 'expense_account'),
        biggestCategoryName: _parseString(
            json['biggest_category_name'], 'biggest_category_name'),
        biggestCategoryAmount: _parseDouble(
            json['biggest_category_amount'], 'biggest_category_amount'),
        period: _parseString(json['period'], 'period').trim(),
        daysRemainingInMonth: _parseInt(
            json['days_remaining_in_month'], 'days_remaining_in_month'),
      );
    } catch (e) {
      throw FormatException('Failed to parse DashboardSummaryModel: $e');
    }
  }

  /// Type-safe helper to parse integers
  static int _parseInt(dynamic value, String fieldName) {
    if (value == null) {
      throw FormatException('$fieldName is null');
    }

    if (value is int) {
      return value;
    }

    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed == null) {
        throw FormatException('$fieldName: Cannot parse "$value" as int');
      }
      return parsed;
    }

    if (value is double) {
      return value.toInt();
    }

    throw FormatException('$fieldName: Unsupported type ${value.runtimeType}');
  }

  /// Type-safe helper to parse doubles
  static double _parseDouble(dynamic value, String fieldName) {
    if (value == null) {
      throw FormatException('$fieldName is null');
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed == null) {
        throw FormatException('$fieldName: Cannot parse "$value" as double');
      }
      return parsed;
    }

    throw FormatException('$fieldName: Unsupported type ${value.runtimeType}');
  }

  /// Type-safe helper to parse strings
  static String _parseString(dynamic value, String fieldName) {
    if (value == null) {
      throw FormatException('$fieldName is null');
    }

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'net_balance': netBalance,
      'expense_ratio': expenseRatio,
      'savings_rate': savingsRate,
      'income_transactions': incomeTransactions,
      'expense_transactions': expenseTransactions,
      'avg_income': avgIncome,
      'avg_expense': avgExpense,
      'spending_trend': spendingTrend
          .map((SpendingTrendPoint point) => <String, dynamic>{
                'day': point.day,
                'amount': point.amount,
              })
          .toList(),
      'categories': categories,
      'accounts_breakdown': accountsBreakdown,
      'biggest_expense_amount': biggestExpenseAmount,
      'biggest_expense_description': biggestExpenseDescription,
      'expense_category': expenseCategory,
      'expense_account': expenseAccount,
      'biggest_category_name': biggestCategoryName,
      'biggest_category_amount': biggestCategoryAmount,
      'period': period,
      'days_remaining_in_month': daysRemainingInMonth,
    };
  }
}
