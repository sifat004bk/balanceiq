import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';
import 'package:dolfin_core/error/failures.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, Message>> call({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    return await repository.sendMessage(
      botId: botId,
      content: content,
      imagePath: imagePath,
      audioPath: audioPath,
    );
  }
}
