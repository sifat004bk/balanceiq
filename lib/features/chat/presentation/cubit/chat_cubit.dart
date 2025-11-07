import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_state.dart';
import '../../../../core/constants/app_constants.dart';

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

      // Create optimistic user message to show immediately
      final userMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        botId: botId,
        sender: AppConstants.senderUser,
        content: content,
        timestamp: DateTime.now(),
        imageUrl: imagePath,
      );

      // Add user message immediately to UI
      final updatedMessages = [userMessage, ...currentState.messages];
      emit(ChatLoaded(messages: updatedMessages, isSending: true));

      // Send message and get bot response
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
          // Reload messages to get the actual saved messages from DB
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
