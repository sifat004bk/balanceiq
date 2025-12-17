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

  // Chat input dimensions
  double _inputWidth = 350.0;
  bool _isCollapsed = false;
  bool _isInputFocused = false;

  // Offset for the floating chat input position (top, left)
  Offset _inputPosition = const Offset(20, 500);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Check if we should show tour and init position after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowChatTour();

      // Set initial position to bottom center
      final size = MediaQuery.of(context).size;
      final padding = MediaQuery.of(context).padding;
      setState(() {
        // Initialize dynamic width (screen width - 32px padding)
        _inputWidth = size.width - 32;

        // Default to bottom center
        _inputPosition = Offset(
          16.0, // Fixed 16px left padding initially
          size.height - 180 - padding.bottom, // Near bottom
        );
      });
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
    // Used for bounds checking
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final padding = mediaQuery.padding;
    final keyboardHeight = mediaQuery.viewInsets.bottom;

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
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        return const ChatShimmer();
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
                          // Add padding at bottom to avoid floating widget overlap
                          padding:
                              EdgeInsets.only(bottom: 120 + keyboardHeight),
                        );
                      } else if (state is ChatError) {
                        return _buildErrorWidget(context, state);
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
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.1),
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

                // Layer 2.5: Floating Token Usage Button (Top Right)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: MessageUsageButton(),
                ),

                // Layer 2.5: Backend Blur (Spotlight Mode)
                if (_isInputFocused)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        // Dismiss focus when tapping background
                        FocusScope.of(context).unfocus();
                      },
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isInputFocused ? 0.7 : 0.0,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            color: Theme.of(context)
                                .colorScheme
                                .scrim
                                .withOpacity(0.3), // Dim background
                          ),
                        ),
                      ),
                    ),
                  ),

                // Layer 3: Floating Draggable Input - Free Movement
                Positioned(
                  left: _inputPosition.dx,
                  top: () {
                    // Calculate clamping for keyboard
                    // If keyboard is open, ensure top is not below (screenHeight - keyboardHeight - widgetHeight)
                    // We estimate widgetHeight as 100 or use dynamic if available
                    final renderBox = _chatInputKey.currentContext
                        ?.findRenderObject() as RenderBox?;
                    final widgetHeight = renderBox?.size.height ?? 120.0;

                    // Since Positioned is inside SafeArea, we must subtract padding.top from screen coordinates
                    final maxVisibleTop = screenSize.height -
                        widgetHeight -
                        keyboardHeight -
                        padding.top -
                        20;

                    // Use minimum of current position and max visible top
                    // This pushes the widget up when keyboard appears, and lets it come back down
                    // when keyboard closes (since we don't modify _inputPosition state)
                    return _inputPosition.dy.clamp(50.0, maxVisibleTop);
                  }(),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        // Update position based on drag delta
                        double newLeft = _inputPosition.dx + details.delta.dx;
                        double newTop = _inputPosition.dy + details.delta.dy;

                        // Get actual widget size if available
                        final renderBox = _chatInputKey.currentContext
                            ?.findRenderObject() as RenderBox?;
                        final widgetSize =
                            renderBox?.size ?? const Size(350, 100);

                        // Clamp to screen boundaries (SafeArea)
                        // Keep fully on screen:
                        final minLeft = 0.0;
                        final maxLeft = screenSize.width - widgetSize.width;

                        final minTop = padding.top + 10; // Below status bar
                        final maxTop = screenSize.height -
                            widgetSize.height -
                            keyboardHeight -
                            10;

                        // Edge-based auto-collapse logic
                        // If near top or bottom edge, narrow the width until collapse
                        if (newTop <= minTop + 50 || newTop >= maxTop - 50) {
                          // Shrink width
                          if (_inputWidth > 100) {
                            _inputWidth -= 5;
                            // Recenter slightly
                            newLeft += 2.5;
                          } else if (!_isCollapsed) {
                            // Collapse if too small
                            _isCollapsed = true;
                          }
                        } else {
                          // Expand back if moving away from edges and was auto-shrunk (optional, or manual expand?)
                          // User asked: "scrolling ... to the top or botom ... gradually decrease the width and finally collapse"
                          // This implies if we move back to center it might NOT auto-expand?
                          // But usually users expect recovery.
                          // For now, let's keep it manual expand or just let them resize.
                        }

                        _inputPosition = Offset(
                          newLeft.clamp(minLeft, maxLeft),
                          newTop.clamp(minTop, maxTop),
                        );
                      });
                    },
                    child: Container(
                      key: _chatInputKey,
                      child: FloatingChatInput(
                        botId: widget.botId,
                        botColor: AppTheme.getBotColor(widget.botId),
                        width: _inputWidth,
                        isCollapsed: _isCollapsed,
                        onFocusChanged: (hasFocus) {
                          setState(() {
                            _isInputFocused = hasFocus;
                          });
                        },
                        onToggleCollapse: () {
                          setState(() {
                            _isCollapsed = !_isCollapsed;
                            if (!_isCollapsed) {
                              // Reset width on expand if it was shrunk
                              if (_inputWidth < 300) _inputWidth = 350.0;
                            }
                          });
                        },
                        onWidthChanged: (dx) {
                          setState(() {
                            // Symmetric resize: grow/shrink on both sides to keep center aligned with handle
                            // If dx > 0 (drag right), grow
                            // If dx < 0 (drag left), shrink

                            double newWidth = _inputWidth + (dx * 2);
                            double newLeft = _inputPosition.dx - dx;

                            // Clamp width
                            if (newWidth >= 250 &&
                                newWidth <= screenSize.width - 20) {
                              _inputWidth = newWidth;
                              _inputPosition =
                                  Offset(newLeft, _inputPosition.dy);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
