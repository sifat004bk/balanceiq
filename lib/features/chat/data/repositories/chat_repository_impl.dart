import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/chat_history_response.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_history_response_model.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;
  final ChatRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;
  final Uuid uuid;

  ChatRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.sharedPreferences,
    required this.uuid,
  });

  @override
  Future<Either<Failure, List<Message>>> getMessages(String userId, String botId, {int? limit}) async {
    try {
      final messages = await localDataSource.getMessages(userId, botId, limit: limit);
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
      // Get user ID from SharedPreferences
      final userId = sharedPreferences.getString(AppConstants.keyUserId) ?? '';

      // Create user message
      final userMessage = MessageModel(
        id: uuid.v4(),
        userId: userId,
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

      // Send message to backend API and get bot response
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
  Future<Either<Failure, void>> clearChatHistory(String userId, String botId) async {
    try {
      await localDataSource.clearChatHistory(userId, botId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear chat history: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllUserMessages(String userId) async {
    try {
      await localDataSource.clearAllUserMessages(userId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear user messages: $e'));
    }
  }

  @override
  Future<Either<Failure, ChatHistoryResponse>> getChatHistory({
    required String userId,
    required int page,
    int? limit,
    String? botId,
  }) async {
    try {
      // Call API to get chat history
      final responseModel = await remoteDataSource.getChatHistory(
        userId: userId,
        page: page,
        limit: limit,
      );

      // Convert to messages and save to local cache
      // This enables offline-first UX and deduplication
      if (responseModel.conversations.isNotEmpty && botId != null) {
        final messages = responseModel.toMessageModels(botId);
        await localDataSource.saveMessages(messages);
      }

      // Return domain entity
      return Right(responseModel.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to get chat history: $e'));
    }
  }
}
