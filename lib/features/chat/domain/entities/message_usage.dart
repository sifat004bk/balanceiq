import 'package:equatable/equatable.dart';

/// Recent message activity item entity
class RecentMessageItem extends Equatable {
  final DateTime timestamp;
  final String actionType;

  const RecentMessageItem({
    required this.timestamp,
    required this.actionType,
  });

  @override
  List<Object?> get props => [timestamp, actionType];

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

  /// Format action name for display (snake_case to Title Case)
  String get formattedActionType {
    return actionType
        .toLowerCase()
        .split('_')
        .map((word) =>
            word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  @override
  String toString() {
    return 'RecentMessageItem(timestamp: $timestamp, actionType: $actionType)';
  }
}

/// Message usage entity - tracks daily message-based usage limits
class MessageUsage extends Equatable {
  final int messagesUsedToday;
  final int messagesRemaining;
  final int dailyLimit;
  final DateTime limitResetsAt;
  final double usagePercentage;
  final DateTime? lastMessageAt;
  final List<RecentMessageItem> recentMessages;

  const MessageUsage({
    required this.messagesUsedToday,
    required this.messagesRemaining,
    required this.dailyLimit,
    required this.limitResetsAt,
    required this.usagePercentage,
    this.lastMessageAt,
    required this.recentMessages,
  });

  @override
  List<Object?> get props => [
        messagesUsedToday,
        messagesRemaining,
        dailyLimit,
        limitResetsAt,
        usagePercentage,
        lastMessageAt,
        recentMessages,
      ];

  /// Check if user has reached their daily limit
  bool get isLimitReached => messagesRemaining <= 0;

  /// Check if user is near their daily limit (>= 80% used)
  bool get isNearLimit => usagePercentage >= 80.0;

  /// Check if user has used any messages today
  bool get hasUsedToday => messagesUsedToday > 0;

  /// Get recent messages (last 5 items for display)
  List<RecentMessageItem> get recentHistory {
    if (recentMessages.length <= 5) return recentMessages;
    return recentMessages.sublist(0, 5);
  }

  /// Format reset time for display (e.g., "12:00 AM")
  String get formattedResetTime {
    int hour = limitResetsAt.hour;
    final minute = limitResetsAt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    
    // Convert to 12-hour format
    hour = hour % 12;
    if (hour == 0) hour = 12;
    
    return '$hour:$minute $period';
  }

  /// Format reset date for display (e.g., "18 Dec")
  String get formattedResetDate {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final day = limitResetsAt.day;
    final month = months[limitResetsAt.month - 1];
    return '$day $month';
  }

  /// Format reset date and time for display (e.g., "18 Dec, 00:00")
  String get formattedResetDateTime {
    return '$formattedResetDate, $formattedResetTime';
  }

  @override
  String toString() {
    return 'MessageUsage(used: $messagesUsedToday, remaining: $messagesRemaining, limit: $dailyLimit, recentCount: ${recentMessages.length})';
  }
}
