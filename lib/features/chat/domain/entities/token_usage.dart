import 'package:equatable/equatable.dart';

/// Token usage history item entity
class TokenUsageHistoryItem extends Equatable {
  final int amount;
  final String action;
  final DateTime timestamp;

  const TokenUsageHistoryItem({
    required this.amount,
    required this.action,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [amount, action, timestamp];

  /// Format timestamp for display
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Format date for display
  String get formattedDate {
    final day = timestamp.day.toString().padLeft(2, '0');
    final month = timestamp.month.toString().padLeft(2, '0');
    final year = timestamp.year;
    return '$day-$month-$year';
  }

  @override
  String toString() {
    return 'TokenUsageHistoryItem(amount: $amount, action: $action, timestamp: $timestamp)';
  }
}

/// Token usage entity
class TokenUsage extends Equatable {
  final int totalUsage;
  final int todayUsage;
  final List<TokenUsageHistoryItem> history;

  const TokenUsage({
    required this.totalUsage,
    required this.todayUsage,
    required this.history,
  });

  @override
  List<Object?> get props => [totalUsage, todayUsage, history];

  /// Calculate percentage of today's usage vs total
  double get todayUsagePercentage {
    if (totalUsage == 0) return 0.0;
    return (todayUsage / totalUsage) * 100;
  }

  /// Check if user has used tokens today
  bool get hasUsedToday => todayUsage > 0;

  /// Get recent history (last 5 items)
  List<TokenUsageHistoryItem> get recentHistory {
    if (history.length <= 5) return history;
    return history.sublist(0, 5);
  }

  /// Format total usage for display
  String get formattedTotalUsage {
    if (totalUsage >= 1000000) {
      return '${(totalUsage / 1000000).toStringAsFixed(1)}M';
    } else if (totalUsage >= 1000) {
      return '${(totalUsage / 1000).toStringAsFixed(1)}K';
    }
    return totalUsage.toString();
  }

  /// Format today's usage for display
  String get formattedTodayUsage {
    if (todayUsage >= 1000) {
      return '${(todayUsage / 1000).toStringAsFixed(1)}K';
    }
    return todayUsage.toString();
  }

  @override
  String toString() {
    return 'TokenUsage(totalUsage: $totalUsage, todayUsage: $todayUsage, historyItems: ${history.length})';
  }
}
