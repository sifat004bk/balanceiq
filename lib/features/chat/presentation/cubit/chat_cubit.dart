import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  String? currentBotId;

  ChatCubit({
    required this.getMessages,
    required this.sendMessage,
  }) : super(ChatInitial());

  Future<void> loadMessages(String botId) async {
    currentBotId = botId;
    if (!isClosed) emit(ChatLoading());
    final result = await getMessages(botId);
    if (!isClosed) {
      result.fold(
        (failure) => emit(ChatError(message: failure.message)),
        (messages) => emit(ChatLoaded(messages: messages)),
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

      // Start sending in background (repository saves user message immediately)
      // Don't await - let it run in background
      sendMessage(
        botId: botId,
        content: content,
        imagePath: imagePath,
        audioPath: audioPath,
      ).then((result) {
        // After API completes, reload messages to show bot response
        if (!isClosed) {
          loadMessages(botId);
        }
      });

      // Wait a bit for the user message to be saved to DB
      await Future.delayed(const Duration(milliseconds: 300));

      // Reload messages to show user message with typing indicator
      final messagesResult = await getMessages(botId);
      if (!isClosed) {
        messagesResult.fold(
          (failure) => emit(ChatError(message: failure.message)),
          (messages) => emit(ChatLoaded(messages: messages, isSending: true)),
        );
      }
    }
  }

  void clearChat() {
    if (currentBotId != null) {
      emit(const ChatLoaded(messages: []));
    }
  }
}
