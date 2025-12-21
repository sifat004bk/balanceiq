import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class UpdateMessage {
  final ChatRepository repository;

  UpdateMessage(this.repository);

  Future<Either<Failure, void>> call(Message message) async {
    return await repository.saveMessage(message);
  }
}
