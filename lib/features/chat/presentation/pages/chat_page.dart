import 'package:balance_iq/core/constants/gemini_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/tour/tour.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_shimmer.dart';
import '../widgets/floating_chat_input.dart';
import '../widgets/message_list.dart';
import '../widgets/suggested_prompts.dart';
import '../widgets/token_usage_button.dart';

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
        // Default to bottom center
        _inputPosition = Offset(
          (size.width - 350) / 2, // Center horizontally
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine error details based on error type
    String title;
    String description;
    IconData icon;
    Color iconColor;
    String buttonText;
    VoidCallback onButtonPressed;

    switch (state.errorType) {
      case ChatErrorType.emailNotVerified:
        title = 'Email Verification Required';
        description =
            'Please verify your email address to use the chat feature.';
        icon = Icons.email_outlined;
        iconColor = Colors.orange;
        buttonText = 'Verify Email';
        onButtonPressed = () => Navigator.pushNamed(context, '/profile');
        break;
      case ChatErrorType.subscriptionRequired:
        title = 'Subscription Required';
        description =
            'You need an active subscription plan to use the chat feature.';
        icon = Icons.card_membership_outlined;
        iconColor = GeminiColors.primary;
        buttonText = 'View Plans';
        onButtonPressed =
            () => Navigator.pushNamed(context, '/subscription-plans');
        break;
      case ChatErrorType.subscriptionExpired:
        title = 'Subscription Expired';
        description =
            'Your subscription has expired. Please renew to continue using the chat feature.';
        icon = Icons.timer_off_outlined;
        iconColor = Colors.red;
        buttonText = 'Renew Subscription';
        onButtonPressed =
            () => Navigator.pushNamed(context, '/manage-subscription');
        break;
      case ChatErrorType.tokenLimitExceeded:
        title = 'Token Limit Exceeded';
        description = state.message.isNotEmpty
            ? state.message
            : 'You have reached your daily token limit.';
        icon = Icons.token_outlined;
        iconColor = Colors.amber;
        buttonText = 'Upgrade Plan';
        onButtonPressed =
            () => Navigator.pushNamed(context, '/subscription-plans');
        break;
      case ChatErrorType.rateLimitExceeded:
        title = 'Too Many Requests';
        description = 'Please wait a moment before sending more messages.';
        icon = Icons.schedule_outlined;
        iconColor = Colors.blue;
        buttonText = 'Got it';
        onButtonPressed =
            () => context.read<ChatCubit>().loadChatHistory(widget.botId);
        break;
      default:
        title = 'Something went wrong';
        description = state.message.isNotEmpty
            ? state.message
            : 'An error occurred. Please try again.';
        icon = Icons.error_outline;
        iconColor = Colors.red;
        buttonText = 'Retry';
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: GeminiColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
                  'Back to Chat',
                  style: TextStyle(
                    color: GeminiColors.primary,
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

                // Layer 2.5: Floating Token Usage Button (Top Right)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: TokenUsageButton(),
                ),

                // Layer 3: Floating Draggable Input - Free Movement
                Positioned(
                  left: _inputPosition.dx,
                  top: _inputPosition.dy,
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
