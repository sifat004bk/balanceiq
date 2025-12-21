import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:synchronized/synchronized.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_usage.dart';
import '../../domain/usecases/get_chat_history.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/update_message.dart';
import '../../domain/usecases/get_message_usage.dart';
import '../../domain/usecases/submit_feedback.dart';
import '../../domain/entities/chat_feedback.dart';
import 'chat_state.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessages getMessages;
  final GetChatHistory getChatHistory;
  final GetMessageUsage getMessageUsage;
  final SendMessage sendMessage;
  final UpdateMessage updateMessage;
  final SubmitFeedback submitFeedback;
  final SecureStorageService secureStorage;
  final Uuid uuid;

  String? currentBotId;
  int _apiPage = 0;
  bool _hasMore = true;
  final Lock _lock = Lock();
  MessageUsage? _cachedMessageUsage;

  ChatCubit({
    required this.getMessages,
    required this.getChatHistory,
    required this.getMessageUsage,
    required this.sendMessage,
    required this.updateMessage,
    required this.submitFeedback,
    required this.secureStorage,
    required this.uuid,
  }) : super(ChatInitial());

  Future<void> loadMessageUsage() async {
    final result = await getMessageUsage();
    result.fold(
      (failure) {},
      (usage) {
        _cachedMessageUsage = usage;

        if (state is ChatLoaded) {
          emit((state as ChatLoaded).copyWith(
            messagesUsedToday: usage.messagesUsedToday,
            dailyMessageLimit: usage.dailyLimit,
            messageUsage: usage,
          ));
        }
      },
    );
  }

  Future<void> loadChatHistory(String botId) async {
    currentBotId = botId;

    emit(ChatLoading());

    await loadMessageUsage();

    final userId = await secureStorage.getUserId() ?? '';

    final cachedResult = await getMessages(userId, botId, limit: 20);
    cachedResult.fold(
      (failure) {},
      (cached) {
        if (cached.isNotEmpty && !isClosed) {
          emit(ChatLoaded(
            messages: cached,
            hasMore: true,
            messagesUsedToday: _cachedMessageUsage?.messagesUsedToday ?? 0,
            messageUsage: _cachedMessageUsage,
          ));
        }
      },
    );

    _apiPage = 1;

    final apiResult = await getChatHistory(
      userId: userId,
      page: _apiPage,
      limit: 10,
      botId: botId,
    );

    if (!isClosed) {
      apiResult.fold(
        (failure) {
          final currentState = state;
          if (currentState is ChatLoaded) {
            emit(ChatError(
                message: failure.message, messages: currentState.messages));
          } else {
            emit(ChatError(message: failure.message));
          }
        },
        (response) async {
          _hasMore = response.pagination.hasNext;

          final updatedResult = await getMessages(userId, botId, limit: 20);
          updatedResult.fold(
            (failure) => emit(ChatError(message: failure.message)),
            (messages) {
              emit(ChatLoaded(
                messages: messages,
                hasMore: _hasMore,
                messagesUsedToday: _cachedMessageUsage?.messagesUsedToday ?? 0,
                messageUsage: _cachedMessageUsage,
              ));
            },
          );
        },
      );
    }
  }

  Future<void> loadMoreMessages() async {
    if (!_hasMore || currentBotId == null) {
      return;
    }

    final currentState = state;
    if (currentState is! ChatLoaded) {
      return;
    }

    if (currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    _apiPage++;
    final userId = await secureStorage.getUserId() ?? '0';

    final result = await getChatHistory(
      userId: userId,
      page: _apiPage,
      limit: 10,
      botId: currentBotId,
    );

    if (!isClosed) {
      result.fold(
        (failure) {
          emit(currentState.copyWith(isLoadingMore: false));
        },
        (response) async {
          _hasMore = response.pagination.hasNext;

          final currentCount = currentState.messages.length;
          final updatedResult = await getMessages(userId, currentBotId!,
              limit: currentCount + 20);
          updatedResult.fold(
            (failure) => emit(currentState.copyWith(isLoadingMore: false)),
            (messages) {
              emit(ChatLoaded(
                messages: messages,
                hasMore: _hasMore,
                isLoadingMore: false,
                messagesUsedToday: _cachedMessageUsage?.messagesUsedToday ??
                    currentState.messagesUsedToday,
                messageUsage: _cachedMessageUsage ?? currentState.messageUsage,
              ));
            },
          );
        },
      );
    }
  }

  @Deprecated('Use loadChatHistory instead')
  Future<void> loadMessages(String botId, {bool showLoading = true}) async {
    await loadChatHistory(botId);
  }

  Future<void> sendNewMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    await _lock.synchronized(() async {
      if (state is ChatLoaded) {
        final currentState = state as ChatLoaded;

        final userId = await secureStorage.getUserId() ?? '';

        final tempUserMessage = Message(
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

        final updatedMessages = [tempUserMessage, ...currentState.messages];

        emit(currentState.copyWith(messages: updatedMessages, isSending: true));

        final result = await sendMessage(
          botId: botId,
          content: content,
          imagePath: imagePath,
          audioPath: audioPath,
        );

        if (!isClosed) {
          result.fold(
            (failure) {
              if (failure is ChatApiFailure) {
                final errorType = _mapChatFailureType(failure.failureType);
                emit(ChatError(
                  message: failure.message,
                  messages: currentState.messages,
                  errorType: errorType,
                ));
                return;
              }
            },
            (_) => null,
          );

          if (state is! ChatError) {
            final reloadResult = await getMessages(userId, botId,
                limit: currentState.messages.length + 2);
            reloadResult.fold(
              (failure) => emit(currentState.copyWith(isSending: false)),
              (messages) {
                emit(currentState.copyWith(
                    messages: messages, isSending: false));
                loadMessageUsage();
              },
            );
          }
        }
      }
    });
  }

  ChatErrorType _mapChatFailureType(ChatFailureType failureType) {
    switch (failureType) {
      case ChatFailureType.emailNotVerified:
        return ChatErrorType.emailNotVerified;
      case ChatFailureType.subscriptionRequired:
        return ChatErrorType.subscriptionRequired;
      case ChatFailureType.subscriptionExpired:
        return ChatErrorType.subscriptionExpired;
      case ChatFailureType.tokenLimitExceeded:
        return ChatErrorType.messageLimitExceeded;
      case ChatFailureType.rateLimitExceeded:
        return ChatErrorType.rateLimitExceeded;
      case ChatFailureType.general:
        return ChatErrorType.general;
    }
  }

  Future<void> submitMessageFeedback(
      String messageId, FeedbackType feedback) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;

      final updatedMessages = currentState.messages.map((msg) {
        if (msg.id == messageId) {
          return msg.copyWith(feedback: feedback.toApiValue());
        }
        return msg;
      }).toList();

      emit(currentState.copyWith(messages: updatedMessages));

      final updatedMessage =
          updatedMessages.firstWhere((m) => m.id == messageId);
      await updateMessage(updatedMessage);

      if (updatedMessage.conversationId != null) {
        final result = await submitFeedback(
          messageId: updatedMessage.conversationId!,
          feedback: feedback,
        );

        result.fold(
          (failure) {},
          (success) {},
        );
      } else {}
    }
  }

  void clearChat() {
    if (currentBotId != null) {
      emit(const ChatLoaded(messages: []));
    }
  }
}
