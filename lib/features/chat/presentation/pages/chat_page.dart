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

  Offset _offset = const Offset(20, 20); // Initial position (relative to bottom-right or just default)
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      // Initialize position to bottom center-ish
      final size = MediaQuery.of(context).size;
      _offset = Offset(size.width * 0.05, size.height - 180); 
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GeminiColors.background(context),
      body: SafeArea(
        child: Stack(
          children: [
            // Layer 1: Message List
            Positioned.fill(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatLoaded && state.messages.isNotEmpty) {
                    final latestMessage = state.messages.first;
                    if (_latestMessageId != latestMessage.id) {
                      _latestMessageId = latestMessage.id;
                      _scrollToBottom();
                    }
                  }
                },
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
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
                      // Add padding at bottom for the floating widget
                      padding: const EdgeInsets.only(bottom: 100), 
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            
            // Layer 2: Floating Draggable Input
            Positioned(
              left: _offset.dx,
              top: _offset.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _offset += details.delta;
                    // Ideally clamp to screen bounds here
                  });
                },
                child: FloatingChatInput(
                  botId: widget.botId,
                  botColor: AppTheme.getBotColor(widget.botId),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomSheet removed
    );
  }
}
