import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/message_model.dart';
import '../../../auth/data/models/auth_request_models.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;
  final ChatRemoteDataSource remoteDataSource;
  final Uuid uuid;

  ChatRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.uuid,
  });

  @override
  Future<Either<Failure, List<Message>>> getMessages(String botId) async {
    try {
      final messages = await localDataSource.getMessages(botId);
      return Right(messages);
    } catch (e) {
      return Left(CacheFailure('Failed to load messages: $e'));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    try {
      // Create user message
      final userMessage = MessageModel(
        id: uuid.v4(),
        botId: botId,
        sender: AppConstants.senderUser,
        content: content,
        imageUrl: imagePath,
        audioUrl: audioPath,
        timestamp: DateTime.now(),
        isSending: false,
        hasError: false,
      );

      // Save user message to local database
      await localDataSource.saveMessage(userMessage);

      // Send message to n8n workflow and get bot response
      final botMessage = await remoteDataSource.sendMessage(
        botId: botId,
        content: content,
        imagePath: imagePath,
        audioPath: audioPath,
      );

      // Save bot response to local database
      await localDataSource.saveMessage(botMessage);

      return Right(botMessage);
    } catch (e) {
      return Left(ServerFailure('Failed to send message: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveMessage(Message message) async {
    try {
      final messageModel = MessageModel.fromEntity(message);
      await localDataSource.saveMessage(messageModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save message: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      await localDataSource.deleteMessage(messageId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete message: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearChatHistory(String botId) async {
    try {
      await localDataSource.clearChatHistory(botId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear chat history: $e'));
    }
  }

  @override
  Future<Either<Failure, ChatHistoryResponse>> getChatHistory({
    required String userId,
    required int page,
    int? limit,
  }) async {
    try {
      final response = await remoteDataSource.getChatHistory(
        userId: userId,
        page: page,
        limit: limit,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure('Failed to get chat history: $e'));
    }
  }
}
