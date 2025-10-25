import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../../../../core/error/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Message>>> getMessages(String botId);
  Future<Either<Failure, Message>> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  });
  Future<Either<Failure, void>> saveMessage(Message message);
  Future<Either<Failure, void>> deleteMessage(String messageId);
  Future<Either<Failure, void>> clearChatHistory(String botId);
}
