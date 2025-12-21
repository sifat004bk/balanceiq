import 'package:equatable/equatable.dart';

/// Transaction entity for FinanceGuru transaction search
class Transaction extends Equatable {
  final int transactionId;
  final String type; // INCOME, EXPENSE, TRANSFER
  final double amount;
  final String category;
  final String description;
  final DateTime transactionDate;
  final DateTime createdAt;
  final double? relevanceScore;
  final int? totalMatches;

  const Transaction({
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.transactionDate,
    required this.createdAt,
    this.relevanceScore,
    this.totalMatches,
  });

  @override
  List<Object?> get props => [
        transactionId,
        type,
        amount,
        category,
        description,
        transactionDate,
        createdAt,
        relevanceScore,
        totalMatches,
      ];

  /// Helper to check if transaction is income
  bool get isIncome => type == 'INCOME';

  /// Helper to check if transaction is expense
  bool get isExpense => type == 'EXPENSE';

  /// Helper to check if transaction is transfer
  bool get isTransfer => type == 'TRANSFER';

  /// Format amount with BDT currency symbol
  String get formattedAmount => '৳${amount.toStringAsFixed(2)}';

  /// Format transaction date
  String get formattedDate {
    final day = transactionDate.day.toString().padLeft(2, '0');
    final month = transactionDate.month.toString().padLeft(2, '0');
    final year = transactionDate.year;
    return '$day-$month-$year';
  }

  @override
  String toString() {
    return 'Transaction(id: $transactionId, type: $type, amount: $amount, category: $category, date: $transactionDate)';
  }
}

/// Transaction search result entity
class TransactionSearchResult extends Equatable {
  final bool success;
  final int count;
  final List<Transaction> transactions;

  const TransactionSearchResult({
    required this.success,
    required this.count,
    required this.transactions,
  });

  @override
  List<Object?> get props => [success, count, transactions];

  /// Check if search returned results
  bool get hasResults => transactions.isNotEmpty;

  /// Get total amount of all transactions
  double get totalAmount {
    return transactions.fold(
        0.0, (sum, transaction) => sum + transaction.amount);
  }

  /// Get transactions filtered by type
  List<Transaction> getByType(String type) {
    return transactions.where((t) => t.type == type).toList();
  }

  @override
  String toString() {
    return 'TransactionSearchResult(success: $success, count: $count, transactions: ${transactions.length})';
  }
}
