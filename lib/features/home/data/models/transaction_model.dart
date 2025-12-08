/// Transaction model for FinanceGuru transaction search API
class TransactionModel {
  final int transactionId;
  final String type; // INCOME, EXPENSE, TRANSFER
  final double amount;
  final String category;
  final String description;
  final DateTime transactionDate;
  final DateTime createdAt;
  final double? relevanceScore;
  final int? totalMatches;

  const TransactionModel({
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

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transaction_id'] as int,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      relevanceScore: json['relevance_score'] != null
          ? (json['relevance_score'] as num).toDouble()
          : null,
      totalMatches: json['total_matches'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'type': type,
      'amount': amount,
      'category': category,
      'description': description,
      'transaction_date': transactionDate.toIso8601String().split('T')[0],
      'created_at': createdAt.toIso8601String(),
      'relevance_score': relevanceScore,
      'total_matches': totalMatches,
    };
  }

  @override
  String toString() {
    return 'TransactionModel(id: $transactionId, type: $type, amount: $amount, category: $category, date: $transactionDate)';
  }
}

/// Response wrapper for transaction search API
class TransactionSearchResponse {
  final bool success;
  final int count;
  final List<TransactionModel> transactions;

  const TransactionSearchResponse({
    required this.success,
    required this.count,
    required this.transactions,
  });

  factory TransactionSearchResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    final transactions = dataList
        .map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return TransactionSearchResponse(
      success: json['success'] as bool? ?? true,
      count: json['count'] as int? ?? transactions.length,
      transactions: transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': transactions.map((t) => t.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'TransactionSearchResponse(success: $success, count: $count, transactions: ${transactions.length})';
  }
}
