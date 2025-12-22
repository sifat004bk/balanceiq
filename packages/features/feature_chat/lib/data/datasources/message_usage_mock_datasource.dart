import 'package:feature_chat/data/models/message_usage_model.dart';
import 'message_usage_datasource.dart';

/// Mock implementation of message usage data source for testing/demo
class MessageUsageMockDataSource implements MessageUsageDataSource {
  MessageUsageMockDataSource();

  @override
  Future<MessageUsageModel> getMessageUsage() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final resetAt = DateTime.utc(now.year, now.month, now.day + 1, 0, 0, 0);

    return MessageUsageModel(
      messagesUsedToday: 3,
      messagesRemaining: 7,
      dailyLimit: 10,
      limitResetsAt: resetAt,
      usagePercentage: 30.0,
      lastMessageAt: now.subtract(const Duration(hours: 1)),
      recentMessages: [
        RecentMessageItemModel(
          timestamp: now.subtract(const Duration(hours: 1)),
          actionType: 'search_transaction',
        ),
        RecentMessageItemModel(
          timestamp: now.subtract(const Duration(hours: 2)),
          actionType: 'record_expense',
        ),
        RecentMessageItemModel(
          timestamp: now.subtract(const Duration(hours: 3)),
          actionType: 'general_chat',
        ),
      ],
    );
  }
}
