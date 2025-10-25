import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(currentState.copyWith(isSending: true));

      final result = await sendMessage(
        botId: botId,
        content: content,
        imagePath: imagePath,
        audioPath: audioPath,
      );

      result.fold(
        (failure) {
          if (!isClosed) {
            emit(ChatError(
              message: failure.message,
              messages: currentState.messages,
            ));
            // Reload messages after error
            loadMessages(botId);
          }
        },
        (botMessage) {
          // Reload messages to include both user and bot messages
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
