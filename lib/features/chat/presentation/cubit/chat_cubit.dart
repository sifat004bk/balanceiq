import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:synchronized/synchronized.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_chat_history.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/get_token_usage.dart';
import 'chat_state.dart';
import '../../../../core/constants/app_constants.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessages getMessages;
  final GetChatHistory getChatHistory;
  final GetTokenUsage getTokenUsage;
  final SendMessage sendMessage;
  final SharedPreferences sharedPreferences;
  final Uuid uuid;

  String? currentBotId;
  int _apiPage = 0;
  bool _hasMore = true;
  final Lock _lock = Lock();  // Concurrency control

  ChatCubit({
    required this.getMessages,
    required this.getChatHistory,
    required this.getTokenUsage,
    required this.sendMessage,
    required this.sharedPreferences,
    required this.uuid,
  }) : super(ChatInitial());

  Future<void> loadTokenUsage() async {
    final result = await getTokenUsage();
    result.fold(
      (failure) => print('⚠️ [ChatCubit] Failed to load token usage: ${failure.message}'),
      (usage) {
        if (state is ChatLoaded) {
          emit((state as ChatLoaded).copyWith(
            currentTokenUsage: usage.todayUsage,
            dailyTokenLimit: AppConstants.dailyTokenLimit,
          ));
        }
      },
    );
  }

  /// Load chat history with cache-first strategy
  /// 1. Load from local cache immediately (fast UX)
  /// 2. Sync with API in background
  /// 3. Reload from cache with updated data
  Future<void> loadChatHistory(String botId) async {
    currentBotId = botId;
    print('📥 [ChatCubit] loadChatHistory called for botId: $botId');

    emit(ChatLoading());

    // Load token usage first
    await loadTokenUsage();

    // Get user ID from SharedPreferences
    final userId = sharedPreferences.getString(AppConstants.keyUserId) ?? '';

    // Step 1: Load from cache immediately (fast UX)
    print('💾 [ChatCubit] Loading from cache...');
    final cachedResult = await getMessages(userId, botId, limit: 20);
    cachedResult.fold(
      (failure) {
        print('⚠️ [ChatCubit] Cache load failed: ${failure.message}');
        // Ignore cache failures, try API sync
      },
      (cached) {
        if (cached.isNotEmpty && !isClosed) {
          print('✅ [ChatCubit] Cache loaded: ${cached.length} messages');
          emit(ChatLoaded(messages: cached, hasMore: true));
        }
      },
    );

    // Step 2: Sync with API in background
    print('🌐 [ChatCubit] Syncing with API...');
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
          print('❌ [ChatCubit] API sync failed: ${failure.message}');
          // If we have cache, show error but keep cached messages
          final currentState = state;
          if (currentState is ChatLoaded) {
            emit(ChatError(message: failure.message, messages: currentState.messages));
          } else {
            emit(ChatError(message: failure.message));
          }
        },
        (response) async {
          print('✅ [ChatCubit] API synced: ${response.conversations.length} conversations');
          _hasMore = response.pagination.hasNext;

          // Step 3: Reload from cache (now includes API data)
          final updatedResult = await getMessages(userId, botId, limit: 20);
          updatedResult.fold(
            (failure) => emit(ChatError(message: failure.message)),
            (messages) {
              print('🔄 [ChatCubit] Reloaded from cache: ${messages.length} messages');
              emit(ChatLoaded(messages: messages, hasMore: _hasMore));
            },
          );
        },
      );
    }
  }

  /// Load older messages (pagination)
  Future<void> loadMoreMessages() async {
    if (!_hasMore || currentBotId == null) {
      print('⏹️ [ChatCubit] No more messages to load');
      return;
    }

    final currentState = state;
    if (currentState is! ChatLoaded) {
      print('⚠️ [ChatCubit] Cannot load more: not in ChatLoaded state');
      return;
    }

    if (currentState.isLoadingMore) {
      print('⚠️ [ChatCubit] Already loading more messages');
      return;
    }

    print('📄 [ChatCubit] Loading more messages...');
    emit(currentState.copyWith(isLoadingMore: true));

    _apiPage++;
    final userId = sharedPreferences.getString(AppConstants.keyUserId) ?? '0';

    final result = await getChatHistory(
      userId: userId,
      page: _apiPage,
      limit: 10,
      botId: currentBotId,
    );

    if (!isClosed) {
      result.fold(
        (failure) {
          print('❌ [ChatCubit] Load more failed: ${failure.message}');
          emit(currentState.copyWith(isLoadingMore: false));
        },
        (response) async {
          print('✅ [ChatCubit] Loaded page $_apiPage: ${response.conversations.length} conversations');
          _hasMore = response.pagination.hasNext;

          // Reload with more messages
          final currentCount = currentState.messages.length;
          final updatedResult = await getMessages(userId, currentBotId!, limit: currentCount + 20);
          updatedResult.fold(
            (failure) => emit(currentState.copyWith(isLoadingMore: false)),
            (messages) {
              print('🔄 [ChatCubit] Now have ${messages.length} total messages');
              emit(ChatLoaded(
                messages: messages,
                hasMore: _hasMore,
                isLoadingMore: false,
              ));
            },
          );
        },
      );
    }
  }

  /// Legacy method for backward compatibility
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
    // Use lock to prevent race conditions with chat history sync
    await _lock.synchronized(() async {
      if (state is ChatLoaded) {
        final currentState = state as ChatLoaded;
        print('📤 [ChatCubit] Starting sendNewMessage - Current messages: ${currentState.messages.length}');

        // Get user ID from SharedPreferences
        final userId = sharedPreferences.getString(AppConstants.keyUserId) ?? '';

        // Create temporary user message for immediate display (optimistic UI)
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
        print('✨ [ChatCubit] Created temp message: ${tempUserMessage.content.length > 20 ? tempUserMessage.content.substring(0, 20) + "..." : tempUserMessage.content}');

        // Immediately show user message in UI (prepend for descending order)
        final updatedMessages = [tempUserMessage, ...currentState.messages];
        print('📊 [ChatCubit] Emitting optimistic state - Messages: ${updatedMessages.length}, isSending: true');
        emit(currentState.copyWith(messages: updatedMessages, isSending: true));

        // Send message in background (repository will save with different ID)
        print('🌐 [ChatCubit] Starting API call...');
        final result = await sendMessage(
          botId: botId,
          content: content,
          imagePath: imagePath,
          audioPath: audioPath,
        );
        print('✅ [ChatCubit] API call completed');

        // After API completes, reload from DB to get actual messages
        if (!isClosed) {
          // Check result of API call
          result.fold(
            (failure) {
              print('❌ [ChatCubit] sendNewMessage failed: ${failure.message}');
              // Optionally show error state or undo optimistic update
            },
            (_) => null,
          );

          print('🔄 [ChatCubit] Reloading messages from cache');
          final reloadResult = await getMessages(userId, botId, limit: currentState.messages.length + 2);
          reloadResult.fold(
            (failure) => emit(currentState.copyWith(isSending: false)),
            (messages) {
              emit(currentState.copyWith(messages: messages, isSending: false));
              // Update token usage
              loadTokenUsage();
            },
          );
        }
      }
    });
  }

  void clearChat() {
    if (currentBotId != null) {
      emit(const ChatLoaded(messages: []));
    }
  }
}

