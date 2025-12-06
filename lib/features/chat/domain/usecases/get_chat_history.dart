import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_history_response.dart';
import '../repositories/chat_repository.dart';

class GetChatHistory {
  final ChatRepository repository;

  GetChatHistory(this.repository);

  Future<Either<Failure, ChatHistoryResponse>> call({
    required String userId,
    required int page,
    int? limit,
    String? botId,
  }) async {
    return await repository.getChatHistory(
      userId: userId,
      page: page,
      limit: limit,
      botId: botId,
    );
  }
}
