import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/tour/tour.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_shimmer.dart';
import '../widgets/message_list.dart';
import '../widgets/simple_chat_input.dart';
import '../widgets/suggested_prompts.dart';
import '../widgets/message_usage_button.dart';
import '../widgets/chat_page_widgets/chat_error_widget.dart';

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
  TutorialCoachMark? _tutorialCoachMark;
  bool _chatTourShown = false;
  final GlobalKey _chatInputKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowChatTour();
    });
  }

  @override
  void dispose() {
    _tutorialCoachMark?.finish();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkAndShowChatTour() {
    final tourCubit = context.read<ProductTourCubit>();
    if (tourCubit.isAtStep(TourStep.chatInputHint)) {
      _showChatInputTour();
    }
  }

  void _showChatInputTour() {
    if (_chatTourShown) return;
    if (_chatInputKey.currentContext == null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _showChatInputTour();
      });
      return;
    }

    _chatTourShown = true;
    final tourCubit = context.read<ProductTourCubit>();

    final targets = [
      TargetFocus(
        identify: 'chat_input',
        keyTarget: _chatInputKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: false,
        enableTargetTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 30,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return ChatInputTourTooltip(
                onDismiss: () {
                  controller.next();
                  tourCubit.completeTour();
                },
                onSkip: () {
                  tourCubit.skipTour();
                  controller.skip();
                },
              );
            },
          ),
        ],
      ),
    ];

    _tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      hideSkip: true,
      onClickOverlay: (target) {},
      onClickTarget: (target) {
        tourCubit.completeTour();
      },
      onFinish: () {
        tourCubit.completeTour();
      },
      onSkip: () {
        tourCubit.skipTour();
        return true;
      },
    );

    _tutorialCoachMark!.show(context: context);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<ChatCubit>().loadMoreMessages();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
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
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<ProductTourCubit, ProductTourState>(
      listener: (context, tourState) {
        if (tourState is TourActive &&
            tourState.currentStep == TourStep.chatInputHint &&
            !tourState.isTransitioning) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showChatInputTour();
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
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
                    final topPadding = MediaQuery.of(context).padding.top + 60;
                    const bottomPadding = 80.0;

                    if (state is ChatLoading) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: topPadding, bottom: bottomPadding),
                        child: const ChatShimmer(),
                      );
                    } else if (state is ChatLoaded) {
                      if (state.messages.isEmpty && !state.isSending) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: topPadding, bottom: bottomPadding),
                          child: SuggestedPrompts(
                            botId: widget.botId,
                            onPromptSelected: (prompt) {
                              context.read<ChatCubit>().sendNewMessage(
                                    botId: widget.botId,
                                    content: prompt,
                                  );
                            },
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: MessageList(
                          messages: state.messages,
                          botId: widget.botId,
                          botName: widget.botName,
                          isSending: state.isSending,
                          hasMore: state.hasMore,
                          isLoadingMore: state.isLoadingMore,
                          scrollController: _scrollController,
                          padding: EdgeInsets.only(
                            top: topPadding,
                            bottom: bottomPadding + 8,
                          ),
                        ),
                      );
                    } else if (state is ChatError) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: topPadding, bottom: bottomPadding),
                        child: ChatErrorWidget(
                          state: state,
                          botId: widget.botId,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              _GlassHeaderBackground(),
              _GlassFooterBackground(),
              _BackButton(),
              const _UsageButton(),
              _ChatInputContainer(
                chatInputKey: _chatInputKey,
                keyboardHeight: keyboardHeight,
                botId: widget.botId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassHeaderBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).padding.top + 10,
      child: ClipRect(
        child: Container(
          color:
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _GlassFooterBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: MediaQuery.of(context).padding.bottom + 16,
      child: ClipRect(
        child: Container(
          color:
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _UsageButton extends StatelessWidget {
  const _UsageButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 16,
      child: const MessageUsageButton(),
    );
  }
}

class _ChatInputContainer extends StatelessWidget {
  final GlobalKey chatInputKey;
  final double keyboardHeight;
  final String botId;

  const _ChatInputContainer({
    required this.chatInputKey,
    required this.keyboardHeight,
    required this.botId,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        key: chatInputKey,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: keyboardHeight > 0 ? 8 : 16,
        ),
        child: SimpleChatInput(
          botId: botId,
          botColor: AppTheme.getBotColor(botId),
          width: MediaQuery.of(context).size.width - 32,
          isCollapsed: false,
        ),
      ),
    );
  }
}
