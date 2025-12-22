import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/interactive_onboarding_cubit.dart';
import '../../widgets/simulated_chat_bubble.dart';

/// Salary Day Story screen - simulated chat demo
class SalaryDayStoryScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  const SalaryDayStoryScreen({
    super.key,
    required this.onContinue,
    required this.onSkip,
  });

  @override
  State<SalaryDayStoryScreen> createState() => _SalaryDayStoryScreenState();
}

class _SalaryDayStoryScreenState extends State<SalaryDayStoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<InteractiveOnboardingCubit, InteractiveOnboardingState>(
      listener: (context, state) {
        // Scroll to bottom when new messages arrive
        _scrollToBottom();
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_circle_filled_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Demo',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (state.storyPlaying)
                    TextButton(
                      onPressed: () {
                        context.read<InteractiveOnboardingCubit>().skipStory();
                      },
                      child: Text(
                        'Skip Demo',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Story Header
              Text(
                '💰 Salary Day!',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Watch how easy it is to track your finances',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Chat Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _buildMessageList(state),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Continue Button (shown when story completes)
              AnimatedOpacity(
                opacity: state.storyCompleted ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: state.storyCompleted ? 56 : 0,
                  child: state.storyCompleted
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.onContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Now You Try!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                  color: colorScheme.onPrimary,
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageList(InteractiveOnboardingState state) {
    if (state.messages.isEmpty && !state.storyPlaying) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];

        // Check if this is a narrator message (detected by emoji and style)
        if (message.content.contains('💰') ||
            message.content.contains('...') && message.content.length < 50) {
          return NarratorText(
            text: message.content,
            animate: true,
          );
        }

        return SimulatedChatBubble(
          content: message.content,
          isUser: message.isUser,
          isTyping: message.isTyping,
          animate: true,
        );
      },
    );
  }
}
