import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/chat_request_models.dart';
import '../repositories/chat_repository.dart';

class GetChatHistory {
  final ChatRepository repository;

  GetChatHistory(this.repository);

  Future<Either<Failure, ChatHistoryResponse>> call({
    required String userId,
    required int page,
    int? limit,
  }) async {
    return await repository.getChatHistory(
      userId: userId,
      page: page,
      limit: limit,
    );
  }
}
