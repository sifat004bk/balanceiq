import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../entities/chat_history_response.dart';
import '../../../../core/error/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Message>>> getMessages(
      String userId, String botId,
      {int? limit});
  Future<Either<Failure, Message>> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  });
  Future<Either<Failure, void>> saveMessage(Message message);
  Future<Either<Failure, void>> deleteMessage(String messageId);
  Future<Either<Failure, void>> clearChatHistory(String userId, String botId);
  Future<Either<Failure, void>> clearAllUserMessages(String userId);

  // Remote chat history with smart sync
  Future<Either<Failure, ChatHistoryResponse>> getChatHistory({
    required String userId,
    required int page,
    int? limit,
    String? botId,
  });
}
