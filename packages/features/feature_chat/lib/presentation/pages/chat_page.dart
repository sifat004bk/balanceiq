import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:get_it/get_it.dart';
import 'package:dolfin_core/tour/product_tour_cubit.dart';
import 'package:dolfin_core/tour/product_tour_state.dart';
import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:dolfin_core/tour/tour_widget_factory.dart';
import 'package:feature_chat/presentation/cubit/chat_cubit.dart';
import 'package:feature_chat/presentation/cubit/chat_state.dart';
import 'package:feature_chat/presentation/widgets/chat_shimmer.dart';
import 'package:feature_chat/presentation/widgets/message_list.dart';
import 'package:feature_chat/presentation/widgets/suggested_prompts.dart';
import 'package:feature_chat/presentation/widgets/chat_page_widgets/chat_error_widget.dart';
import 'package:feature_chat/presentation/widgets/chat_page_widgets/chat_input_container.dart';
import 'package:feature_chat/presentation/widgets/chat_page_widgets/chat_back_button.dart';
import 'package:feature_chat/presentation/widgets/chat_page_widgets/chat_usage_button.dart';
import 'package:feature_chat/presentation/widgets/chat_page_widgets/glass_header_background.dart';
import 'package:feature_chat/presentation/widgets/chat_page_widgets/glass_footer_background.dart';

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
    return BlocProvider<ChatCubit>(
      create: (_) => GetIt.instance<ChatCubit>()..loadChatHistory(botId),
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
              return GetIt.instance<TourWidgetFactory>().createChatInputHint(
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

    return MultiBlocListener(
      listeners: [
        BlocListener<ProductTourCubit, ProductTourState>(
          listener: (context, tourState) {
            if (tourState is TourActive &&
                tourState.currentStep == TourStep.chatInputHint &&
                !tourState.isTransitioning) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showChatInputTour();
              });
            }
          },
        ),
        BlocListener<CurrencyCubit, CurrencyState>(
          bloc: GetIt.instance<CurrencyCubit>(),
          listenWhen: (previous, current) {
            // Listen when currency changes from not set to set
            final wasSet = previous.isCurrencySet;
            final isNowSet = current.isCurrencySet;
            return !wasSet && isNowSet;
          },
          listener: (context, state) {
            // Currency was just set, reload chat to remove restriction
            debugPrint('[ChatDebug] Currency set, reloading chat');
            context.read<ChatCubit>().loadChatHistory(widget.botId);
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Message List and Loading State (Bottom Layer)
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
                    debugPrint('[ChatDebug] ChatPage builder state: $state');
                    final topPadding = MediaQuery.of(context).padding.top + 60;
                    double bottomPadding = 80.0; // Base padding for input

                    // Adjust padding if near limit or if input needs more space
                    if (state is ChatLoaded) {
                      final isLimitReached = state.isMessageLimitReached;
                      final isNearLimit = state.messagesUsedToday >=
                          (state.dailyMessageLimit * 0.8);
                      if (isLimitReached || isNearLimit) {
                        bottomPadding += 68.0;
                      }
                    }

                    if (state is ChatLoading) {
                      debugPrint('[ChatDebug] Rendering ChatShimmer');
                      return Padding(
                        padding: EdgeInsets.only(
                            top: topPadding, bottom: bottomPadding),
                        child: const ChatShimmer(),
                      );
                    } else if (state is ChatLoaded) {
                      debugPrint('[ChatDebug] Rendering ChatLoaded');
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
                    }

                    // For ChatError, we don't render content here as it is overlayed.
                    // But we might want to show empty space or previous messages if available?
                    // Implementation plan implies replacing content.
                    // However, blocking errors like Currency/Sub usually replace content.
                    // If we just return SizedBox, the background is empty.
                    debugPrint(
                        '[ChatDebug] Rendering SizedBox.shrink (State: $state)');
                    return const SizedBox.shrink();
                  },
                ),
              ),

              const GlassHeaderBackground(),
              const GlassFooterBackground(),
              const ChatBackButton(),
              const ChatUsageButton(),

              // 2. Chat Input (Middle Layer - Always Visible)
              ChatInputContainer(
                chatInputKey: _chatInputKey,
                keyboardHeight: keyboardHeight,
                botId: widget.botId,
              ),

              // 3. Error Overlay (Top Layer)
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatError) {
                    return Positioned.fill(
                      child: ChatErrorWidget(
                        state: state,
                        botId: widget.botId,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
