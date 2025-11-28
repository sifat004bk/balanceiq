import '../models/chat_request_models.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<MessageModel> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  });

  Future<ChatHistoryResponse> getChatHistory({
    required String userId,
    required int page,
    int? limit,
  });
}
