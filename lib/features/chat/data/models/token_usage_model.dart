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
    // Parse timestamp - if no timezone info, treat as UTC then convert to local
    final timestampStr = json['timestamp'] as String;
    DateTime parsedTimestamp = DateTime.parse(timestampStr);

    // If the timestamp doesn't end with 'Z' and isn't already UTC, treat it as UTC
    if (!timestampStr.endsWith('Z') && !timestampStr.contains('+') && !timestampStr.contains('-', 10)) {
      // Server sends UTC without 'Z', so parse as UTC then convert to local
      parsedTimestamp = DateTime.utc(
        parsedTimestamp.year,
        parsedTimestamp.month,
        parsedTimestamp.day,
        parsedTimestamp.hour,
        parsedTimestamp.minute,
        parsedTimestamp.second,
        parsedTimestamp.millisecond,
        parsedTimestamp.microsecond,
      ).toLocal();
    } else {
      parsedTimestamp = parsedTimestamp.toLocal();
    }

    return TokenUsageHistoryItem(
      amount: json['amount'] as int,
      action: json['action'] as String,
      timestamp: parsedTimestamp,
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
