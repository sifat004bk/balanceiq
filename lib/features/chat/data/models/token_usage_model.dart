/// Token usage history item model
class TokenUsageHistoryItem {
  final int amount;
  final String action;
  final DateTime timestamp;

  const TokenUsageHistoryItem({
    required this.amount,
    required this.action,
    required this.timestamp,
  });

  factory TokenUsageHistoryItem.fromJson(Map<String, dynamic> json) {
    return TokenUsageHistoryItem(
      amount: json['amount'] as int,
      action: json['action'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'TokenUsageHistoryItem(amount: $amount, action: $action, timestamp: $timestamp)';
  }
}

/// Token usage response model
class TokenUsageModel {
  final int totalUsage;
  final int todayUsage;
  final List<TokenUsageHistoryItem> history;

  const TokenUsageModel({
    required this.totalUsage,
    required this.todayUsage,
    required this.history,
  });

  factory TokenUsageModel.fromJson(Map<String, dynamic> json) {
    final historyList = json['history'] as List<dynamic>? ?? [];
    final history = historyList
        .map((item) =>
            TokenUsageHistoryItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return TokenUsageModel(
      totalUsage: json['totalUsage'] as int,
      todayUsage: json['todayUsage'] as int,
      history: history,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsage': totalUsage,
      'todayUsage': todayUsage,
      'history': history.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'TokenUsageModel(totalUsage: $totalUsage, todayUsage: $todayUsage, historyItems: ${history.length})';
  }
}
