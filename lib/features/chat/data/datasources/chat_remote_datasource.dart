import '../models/chat_request_models.dart';
import '../models/chat_history_response_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<MessageModel> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  });

  Future<ChatHistoryResponseModel> getChatHistory({
    required String userId,
    required int page,
    int? limit,
  });
}
