import 'package:balance_iq/core/constants/gemini_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/floating_chat_input.dart';
import '../widgets/message_list.dart';
import '../widgets/suggested_prompts.dart';

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
      create: (_) => sl<ChatCubit>()..loadChatHistory(botId),
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
  String? _latestMessageId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // For reverse ListView, maxScrollExtent is at the top (oldest messages)
    // Trigger pagination when user scrolls near the top
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<ChatCubit>().loadMoreMessages();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          // For reversed list, minScrollExtent is the bottom (newest messages)
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GeminiColors.background(context),
      body: SafeArea(
        child: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            // Auto-scroll to bottom ONLY when a NEW message arrives (latest message changes)
            if (state is ChatLoaded && state.messages.isNotEmpty) {
              final latestMessage = state.messages.first;
              // Check if the latest message is different from what we saw last time
              if (_latestMessageId != latestMessage.id) {
                _latestMessageId = latestMessage.id;
                _scrollToBottom();
              }
            }
          },
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ChatLoaded) {
              // Show suggested prompts if no messages
              if (state.messages.isEmpty && !state.isSending) {
                return SuggestedPrompts(
                  botId: widget.botId,
                  onPromptSelected: (prompt) {
                    context.read<ChatCubit>().sendNewMessage(
                          botId: widget.botId,
                          content: prompt,
                        );
                  },
                );
              }

              return MessageList(
                messages: state.messages,
                botId: widget.botId,
                botName: widget.botName,
                isSending: state.isSending,
                hasMore: state.hasMore,
                isLoadingMore: state.isLoadingMore,
                scrollController: _scrollController,
              );
            } else if (state is ChatError) {
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
                            .loadChatHistory(widget.botId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomSheet: FloatingChatInput(
        botId: widget.botId,
        botColor: AppTheme.getBotColor(widget.botId),
      ),
    );
  }
}
