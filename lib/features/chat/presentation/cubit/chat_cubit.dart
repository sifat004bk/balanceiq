import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_state.dart';
import '../../../../core/constants/app_constants.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final Uuid uuid;
  String? currentBotId;

  ChatCubit({
    required this.getMessages,
    required this.sendMessage,
    required this.uuid,
  }) : super(ChatInitial());

  Future<void> loadMessages(String botId, {bool showLoading = true}) async {
    currentBotId = botId;
    print('📥 [ChatCubit] loadMessages called - showLoading: $showLoading');
    if (!isClosed && showLoading) {
      print('⏳ [ChatCubit] Emitting ChatLoading...');
      emit(ChatLoading());
    }
    final result = await getMessages(botId);
    if (!isClosed) {
      result.fold(
        (failure) {
          print('❌ [ChatCubit] Error loading messages: ${failure.message}');
          emit(ChatError(message: failure.message));
        },
        (messages) {
          print('✅ [ChatCubit] Loaded ${messages.length} messages from DB');
          print('📋 [ChatCubit] Emitting ChatLoaded with ${messages.length} messages');
          emit(ChatLoaded(messages: messages));
        },
      );
    }
  }

  Future<void> sendNewMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      print('📤 [ChatCubit] Starting sendNewMessage - Current messages: ${currentState.messages.length}');

      // Create temporary user message for immediate display
      final tempUserMessage = Message(
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
      print('✨ [ChatCubit] Created temp message: ${tempUserMessage.content.length > 20 ? tempUserMessage.content.substring(0, 20) + "..." : tempUserMessage.content}');

      // Immediately show user message in UI
      final updatedMessages = [...currentState.messages, tempUserMessage];
      print('📊 [ChatCubit] Emitting optimistic state - Messages: ${updatedMessages.length}, isSending: true');
      emit(ChatLoaded(messages: updatedMessages, isSending: true));

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
      // Don't show loading state to avoid clearing the optimistic message
      if (!isClosed) {
        print('🔄 [ChatCubit] Reloading messages from DB (showLoading: false)');
        loadMessages(botId, showLoading: false);
      }
    }
  }

  void clearChat() {
    if (currentBotId != null) {
      emit(const ChatLoaded(messages: []));
    }
  }
}
