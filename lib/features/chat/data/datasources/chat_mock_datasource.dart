import 'package:balance_iq/core/constants/app_constants.dart';
import 'package:balance_iq/core/mock/mock_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_request_models.dart';
import '../models/chat_history_response_model.dart';
import '../models/message_model.dart';
import 'chat_remote_datasource.dart';

/// Mock implementation of ChatRemoteDataSource for testing without API calls
class ChatMockDataSource implements ChatRemoteDataSource {
  final SharedPreferences sharedPreferences;

  ChatMockDataSource(this.sharedPreferences);

  /// Simulate network delay (300-800ms)
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(
      Duration(milliseconds: 300 + DateTime.now().millisecond % 500),
    );
  }

  @override
  Future<MessageModel> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    print('🤖 [MockDataSource] Sending message to bot: $botId');
    print('📝 [MockDataSource] Message content: $content');

    // Get user ID from SharedPreferences
    final userId = sharedPreferences.getString(AppConstants.keyUserId) ?? '';

    // Simulate network delay
    await _simulateNetworkDelay();

    // Get contextual response based on bot and message
    final responseText = MockData.getResponse(botId, content);

    // Create mock response message
    final botMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      botId: botId,
      sender: AppConstants.senderBot,
      content: responseText,
      imageUrl: null,
      audioUrl: null,
      timestamp: DateTime.now(),
      isSending: false,
      hasError: false,
    );

    print('✅ [MockDataSource] Mock response generated');
    return botMessage;
  }

  @override
  Future<ChatHistoryResponseModel> getChatHistory({
    required String userId,
    required int page,
    int? limit,
  }) async {
    print('🤖 [MockDataSource] Getting chat history for user: $userId, page: $page');

    // Simulate network delay
    await _simulateNetworkDelay();

    // Return mock chat history with Gen UI examples
    return ChatHistoryResponseModel(
      userId: int.tryParse(userId) ?? 0,
      conversations: [
        ConversationModel(
          userMessage: "Show me my monthly summary",
          aiResponse: 'Here is your monthly summary:\n\n```ui:summary_card\n{\n  "title": "Total Balance",\n  "value": "45,500 BDT",\n  "trend": "+12%",\n  "trendColor": "green",\n  "icon": "wallet"\n}\n```\n\n```ui:chart\n{\n  "type": "bar",\n  "title": "Income vs Expenses",\n  "data": [\n    {"label": "Income", "value": 50000, "color": "#4CAF50"},\n    {"label": "Expenses", "value": 4500, "color": "#FF5252"}\n  ],\n  "gradient": true\n}\n```',
          createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        ),
        ConversationModel(
          userMessage: "How are my investments doing?",
          aiResponse: 'Your portfolio is growing steadily:\n\n```ui:chart\n{\n  "type": "line",\n  "title": "Portfolio Growth",\n  "data": [\n    {"label": "Jan", "value": 10000},\n    {"label": "Feb", "value": 12000},\n    {"label": "Mar", "value": 11500},\n    {"label": "Apr", "value": 14000}\n  ],\n  "gradient": true\n}\n```\n\n```ui:action_list\n{\n  "title": "Actions",\n  "actions": [\n    {"label": "View Details", "action": "view_details"},\n    {"label": "Add Funds", "action": "add_funds"}\n  ]\n}\n```',
          createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        ),
      ],
      pagination: PaginationModel(
        currentPage: page,
        limit: limit ?? 20,
        returned: 2,
        hasNext: false,
        nextPage: null,
      ),
    );
  }
}
