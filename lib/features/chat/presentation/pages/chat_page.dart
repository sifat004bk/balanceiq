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

  // Horizontal offset for dragging (vertical is handled by keyboard-aware positioning)
  double _horizontalOffset = 20;
  // Bottom offset from the keyboard/bottom of screen
  double _bottomOffset = 20;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenWidth = MediaQuery.of(context).size.width;

    // Clamp horizontal offset to keep input on screen
    final clampedHorizontalOffset = _horizontalOffset.clamp(0.0, screenWidth - 350);

    return Scaffold(
      backgroundColor: GeminiColors.background(context),
      resizeToAvoidBottomInset: false, // We handle keyboard manually
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
                      // Add padding at bottom for the floating widget + keyboard
                      padding: EdgeInsets.only(bottom: 120 + keyboardHeight),
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Layer 2: Floating Back Button
            Positioned(
              top: 8,
              left: 8,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Layer 3: Floating Draggable Input - positioned from bottom
            Positioned(
              left: clampedHorizontalOffset,
              right: clampedHorizontalOffset,
              bottom: _bottomOffset + keyboardHeight,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _horizontalOffset += details.delta.dx;
                    _bottomOffset -= details.delta.dy; // Invert because we're using bottom
                    // Clamp bottom offset
                    _bottomOffset = _bottomOffset.clamp(10.0, 200.0);
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
    );
  }
}
