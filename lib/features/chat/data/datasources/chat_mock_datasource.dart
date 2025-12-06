import 'package:balance_iq/core/constants/app_constants.dart';
import 'package:balance_iq/core/mock/mock_data.dart';
import '../models/chat_request_models.dart';
import '../models/chat_history_response_model.dart';
import '../models/message_model.dart';
import 'chat_remote_datasource.dart';

/// Mock implementation of ChatRemoteDataSource for testing without API calls
class ChatMockDataSource implements ChatRemoteDataSource {
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

    // Simulate network delay
    await _simulateNetworkDelay();

    // Get contextual response based on bot and message
    final responseText = MockData.getResponse(botId, content);

    // Create mock response message
    final botMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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

    // Return empty chat history for mock matching actual API structure
    return ChatHistoryResponseModel(
      userId: int.tryParse(userId) ?? 0,
      conversations: [],
      pagination: PaginationModel(
        currentPage: page,
        limit: limit ?? 20,
        returned: 0,
        hasNext: false,
        nextPage: null,
      ),
    );
  }
}
