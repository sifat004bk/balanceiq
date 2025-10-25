import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';
import '../../../../core/error/failures.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Future<Either<Failure, List<Message>>> call(String botId) async {
    return await repository.getMessages(botId);
  }
}
