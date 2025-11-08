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
      // Start sending in background (repository saves user message immediately)
      final sendFuture = sendMessage(
        botId: botId,
        content: content,
        imagePath: imagePath,
        audioPath: audioPath,
      );

      // Give repository time to save user message to DB
      await Future.delayed(const Duration(milliseconds: 150));

      // Reload to show user message
      await loadMessages(botId);

      // Wait for API response
      final result = await sendFuture;

      result.fold(
        (failure) {
          if (!isClosed) {
            // Reload messages even on error
            loadMessages(botId);
          }
        },
        (botMessage) {
          // Reload messages to get bot response from DB
          if (!isClosed) {
            loadMessages(botId);
          }
        },
      );
    }
  }

  void clearChat() {
    if (currentBotId != null) {
      emit(const ChatLoaded(messages: []));
    }
  }
}
