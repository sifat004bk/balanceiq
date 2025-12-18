import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/tour/tour.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_shimmer.dart';
import '../widgets/floating_chat_input.dart';
import '../widgets/message_list.dart';
import '../widgets/simple_chat_input.dart';
import '../widgets/suggested_prompts.dart';
import '../widgets/message_usage_button.dart';

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

  // Tour related
  TutorialCoachMark? _tutorialCoachMark;
  bool _chatTourShown = false;
  final GlobalKey _chatInputKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Check if we should show tour after frame is built
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
        // User tapped on input, complete tour
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

  Widget _buildErrorWidget(BuildContext context, ChatError state) {
    // Determine error details based on error type
    String title;
    String description;
    IconData icon;
    Color iconColor;
    String buttonText;
    VoidCallback onButtonPressed;
    final colorScheme = Theme.of(context).colorScheme;

    switch (state.errorType) {
      case ChatErrorType.emailNotVerified:
        title = AppStrings.chat.emailVerificationRequired;
        description = AppStrings.chat.emailVerificationMessage;
        icon = Icons.email_outlined;
        iconColor = Theme.of(context).colorScheme.tertiary;
        buttonText = AppStrings.chat.verifyEmailButton;
        onButtonPressed = () => Navigator.pushNamed(context, '/profile');
        break;
      case ChatErrorType.subscriptionRequired:
        title = AppStrings.chat.subscriptionRequired;
        description = AppStrings.chat.subscriptionRequiredMessage;
        icon = Icons.card_membership_outlined;
        iconColor = colorScheme.primary;
        buttonText = AppStrings.chat.viewPlans;
        onButtonPressed =
            () => Navigator.pushNamed(context, '/subscription-plans');
        break;
      case ChatErrorType.subscriptionExpired:
        title = AppStrings.chat.subscriptionExpired;
        description = AppStrings.chat.subscriptionExpiredMessage;
        icon = Icons.timer_off_outlined;
        iconColor = colorScheme.error;
        buttonText = AppStrings.chat.renewSubscription;
        onButtonPressed =
            () => Navigator.pushNamed(context, '/manage-subscription');
        break;
      case ChatErrorType.messageLimitExceeded:
        title = AppStrings.chat.messageLimitExceeded;
        description = state.message.isNotEmpty
            ? state.message
            : AppStrings.chat.messageLimitExceededMessage;
        icon = Icons.token_outlined;
        iconColor = Theme.of(context).colorScheme.secondary;
        buttonText = AppStrings.chat.upgradePlan;
        onButtonPressed =
            () => Navigator.pushNamed(context, '/subscription-plans');
        break;
      case ChatErrorType.rateLimitExceeded:
        title = AppStrings.chat.tooManyRequests;
        description = AppStrings.chat.rateLimitMessage;
        icon = Icons.schedule_outlined;
        iconColor = colorScheme.primary;
        buttonText = AppStrings.common.gotIt;
        onButtonPressed =
            () => context.read<ChatCubit>().loadChatHistory(widget.botId);
        break;
      default:
        title = AppStrings.errors.somethingWentWrong;
        description = state.message.isNotEmpty
            ? state.message
            : AppStrings.errors.tryAgainLater;
        icon = Icons.error_outline;
        iconColor = colorScheme.error;
        buttonText = AppStrings.common.retry;
        onButtonPressed =
            () => context.read<ChatCubit>().loadChatHistory(widget.botId);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTypography.titleLargeBold.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: AppTypography.buttonMedium,
              ),
            ),
            if (state.messages?.isNotEmpty == true) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Return to showing messages if available
                  context.read<ChatCubit>().loadChatHistory(widget.botId);
                },
                child: Text(
                  AppStrings.chat.backToChat,
                  style: AppTypography.bodyMedium.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<ProductTourCubit, ProductTourState>(
      listener: (context, tourState) {
        // Show tour when state changes to chatInputHint step
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
              // Message List (Base Layer)
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
                    // Input is always at the bottom, so we need constant padding
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
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top,
                          bottom: 16,
                        ),
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
                        child: _buildErrorWidget(context, state),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Top Left: Back Button
              Positioned(
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
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
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
              ),

              // Top Right: Usage Button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 16,
                child: const MessageUsageButton(),
              ),

              // Bottom: Chat Input
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  key: _chatInputKey,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: keyboardHeight > 0 ? 8 : 16,
                  ),
                  child: SimpleChatInput(
                    botId: widget.botId,
                    botColor: AppTheme.getBotColor(widget.botId),
                    width: MediaQuery.of(context).size.width - 32,
                    isCollapsed: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
