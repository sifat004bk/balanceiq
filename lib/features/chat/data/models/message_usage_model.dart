/// Recent message item model - matches API response format
class RecentMessageItemModel {
  final DateTime timestamp;
  final String actionType;

  const RecentMessageItemModel({
    required this.timestamp,
    required this.actionType,
  });

  factory RecentMessageItemModel.fromJson(Map<String, dynamic> json) {
    // Parse timestamp - if no timezone info, treat as UTC then convert to local
    final timestampStr = json['timestamp'] as String;
    DateTime parsedTimestamp = DateTime.parse(timestampStr);

    // If the timestamp doesn't end with 'Z' and isn't already UTC, treat it as UTC
    if (!timestampStr.endsWith('Z') &&
        !timestampStr.contains('+') &&
        !timestampStr.contains('-', 10)) {
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

    return RecentMessageItemModel(
      timestamp: parsedTimestamp,
      actionType: json['actionType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'actionType': actionType,
    };
  }

  @override
  String toString() {
    return 'RecentMessageItemModel(timestamp: $timestamp, actionType: $actionType)';
  }
}

/// Message usage response model - matches new API response format
/// 
/// API Response:
/// {
///   "messagesUsedToday": 3,
///   "messagesRemaining": 7,
///   "dailyLimit": 10,
///   "limitResetsAt": "2025-12-18T00:00:00",
///   "usagePercentage": 30.0,
///   "lastMessageAt": "2025-12-17T10:30:15",
///   "recentMessages": [...]
/// }
class MessageUsageModel {
  final int messagesUsedToday;
  final int messagesRemaining;
  final int dailyLimit;
  final DateTime limitResetsAt;
  final double usagePercentage;
  final DateTime? lastMessageAt;
  final List<RecentMessageItemModel> recentMessages;

  const MessageUsageModel({
    required this.messagesUsedToday,
    required this.messagesRemaining,
    required this.dailyLimit,
    required this.limitResetsAt,
    required this.usagePercentage,
    this.lastMessageAt,
    required this.recentMessages,
  });

  factory MessageUsageModel.fromJson(Map<String, dynamic> json) {
    // Parse limitResetsAt - keep as UTC, DO NOT convert to local
    // API sends: "2025-12-18T00:00:00" (UTC without 'Z')
    final resetAtStr = json['limitResetsAt'] as String;
    DateTime resetAt;
    
    // Add 'Z' suffix to force UTC parsing if not already present
    if (!resetAtStr.endsWith('Z') &&
        !resetAtStr.contains('+') &&
        !resetAtStr.contains('-', 10)) {
      // Parse as UTC by appending 'Z'
      resetAt = DateTime.parse('${resetAtStr}Z');
    } else {
      resetAt = DateTime.parse(resetAtStr);
    }
    // Keep in UTC - don't call .toLocal()

    // Parse lastMessageAt (nullable)
    DateTime? lastMessage;
    if (json['lastMessageAt'] != null) {
      final lastMessageStr = json['lastMessageAt'] as String;
      lastMessage = DateTime.parse(lastMessageStr);
      if (!lastMessageStr.endsWith('Z') &&
          !lastMessageStr.contains('+') &&
          !lastMessageStr.contains('-', 10)) {
        lastMessage = DateTime.utc(
          lastMessage.year,
          lastMessage.month,
          lastMessage.day,
          lastMessage.hour,
          lastMessage.minute,
          lastMessage.second,
        ).toLocal();
      } else {
        lastMessage = lastMessage.toLocal();
      }
    }

    // Parse recentMessages array
    final recentList = json['recentMessages'] as List<dynamic>? ?? [];
    final recentMessages = recentList
        .map((item) =>
            RecentMessageItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return MessageUsageModel(
      messagesUsedToday: json['messagesUsedToday'] as int,
      messagesRemaining: json['messagesRemaining'] as int,
      dailyLimit: json['dailyLimit'] as int,
      limitResetsAt: resetAt,
      usagePercentage: (json['usagePercentage'] as num).toDouble(),
      lastMessageAt: lastMessage,
      recentMessages: recentMessages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messagesUsedToday': messagesUsedToday,
      'messagesRemaining': messagesRemaining,
      'dailyLimit': dailyLimit,
      'limitResetsAt': limitResetsAt.toIso8601String(),
      'usagePercentage': usagePercentage,
      if (lastMessageAt != null)
        'lastMessageAt': lastMessageAt!.toIso8601String(),
      'recentMessages': recentMessages.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'MessageUsageModel(used: $messagesUsedToday, remaining: $messagesRemaining, limit: $dailyLimit)';
  }
}
