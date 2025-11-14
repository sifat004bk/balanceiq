import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_list.dart';

class ChatPage extends StatelessWidget {
  final String botId;
  final String botName;

  const ChatPage({
    super.key,
    required this.botId,
    required this.botName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatCubit>()..loadMessages(botId),
      child: ChatView(botId: botId, botName: botName),
    );
  }
}

class ChatView extends StatefulWidget {
  final String botId;
  final String botName;

  const ChatView({
    super.key,
    required this.botId,
    required this.botName,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();
  int _previousMessageCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    print('🔽 [ChatPage] _scrollToBottom called');
    if (_scrollController.hasClients) {
      // Use WidgetsBinding to ensure layout is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          print('📜 [ChatPage] Scrolling to position 0.0');
          // Since list is reversed, scroll to minScrollExtent (top = newest messages)
          _scrollController.animateTo(
            0.0, // Scroll to top of reversed list (which shows newest messages)
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.botName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor:
            isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark
                ? const Color(0xFF374151).withValues(alpha: 0.3)
                : const Color(0xFFE5E7EB).withValues(alpha: 0.3),
            height: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // TODO: Show menu for clear chat, settings, etc.
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                print('👂 [ChatPage] Listener - State: ${state.runtimeType}');
                // Auto-scroll to bottom when new message arrives
                if (state is ChatLoaded) {
                  print('📨 [ChatPage] ChatLoaded - Messages: ${state.messages.length}, isSending: ${state.isSending}');
                  print('📊 [ChatPage] Previous count: $_previousMessageCount, Current count: ${state.messages.length}');
                  // Only scroll if message count changed (new message added)
                  if (state.messages.length != _previousMessageCount) {
                    print('✅ [ChatPage] Message count changed! Scrolling to bottom...');
                    _previousMessageCount = state.messages.length;
                    _scrollToBottom();
                  } else {
                    print('⏸️ [ChatPage] Message count unchanged, not scrolling');
                  }
                }
              },
              builder: (context, state) {
                print('🎨 [ChatPage] Builder - State: ${state.runtimeType}');
                if (state is ChatLoading) {
                  print('⏳ [ChatPage] Builder - Showing loading indicator');
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ChatLoaded) {
                  print('✅ [ChatPage] Builder - Building MessageList with ${state.messages.length} messages, isSending: ${state.isSending}');
                  return MessageList(
                    messages: state.messages,
                    botId: widget.botId,
                    botName: widget.botName,
                    isSending: state.isSending,
                    scrollController: _scrollController,
                  );
                } else if (state is ChatError) {
                  print('❌ [ChatPage] Builder - Showing error: ${state.message}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<ChatCubit>()
                                .loadMessages(widget.botId);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                print('⚠️ [ChatPage] Builder - Unknown state, showing empty widget');
                return const SizedBox.shrink();
              },
            ),
          ),
          ChatInput(
            botId: widget.botId,
            botColor: AppTheme.getBotColor(widget.botId),
          ),
        ],
      ),
    );
  }
}
