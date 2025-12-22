import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/interactive_onboarding_cubit.dart';
import '../../widgets/simulated_chat_bubble.dart';
import '../../widgets/celebration_animation.dart';

/// Try It Yourself screen - user practices with a sample transaction
class TryItYourselfScreen extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const TryItYourselfScreen({
    super.key,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  State<TryItYourselfScreen> createState() => _TryItYourselfScreenState();
}

class _TryItYourselfScreenState extends State<TryItYourselfScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _submitInput(String text) {
    if (text.trim().isEmpty) return;
    context.read<InteractiveOnboardingCubit>().submitPractice(text);
    _textController.clear();
    _focusNode.unfocus();
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
        _scrollToBottom();
      },
      builder: (context, state) {
        return CelebrationAnimation(
          show: state.showCelebration,
          child: Padding(
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
                        color: colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 16,
                            color: colorScheme.tertiary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Your Turn',
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),

                const SizedBox(height: 16),

                // Prompt
                Text(
                  '🎯 Try It Yourself!',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  state.userPracticed
                      ? 'That\'s all it takes! Ready to start?'
                      : 'What did you last spend money on?',
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
                        color:
                            colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          // Message List
                          Expanded(
                            child: state.messages.isEmpty
                                ? _buildEmptyState(context, colorScheme)
                                : ListView.builder(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    itemCount: state.messages.length,
                                    itemBuilder: (context, index) {
                                      final message = state.messages[index];
                                      return SimulatedChatBubble(
                                        content: message.content,
                                        isUser: message.isUser,
                                        isTyping: message.isTyping,
                                        animate: true,
                                      );
                                    },
                                  ),
                          ),

                          // Input Area (hidden after practice)
                          if (!state.userPracticed) ...[
                            // Suggestion Chips
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: [
                                  _buildSuggestionChip(
                                    context,
                                    '🛺 50 taka rickshaw',
                                  ),
                                  _buildSuggestionChip(
                                    context,
                                    '☕ 100 taka chai',
                                  ),
                                  _buildSuggestionChip(
                                    context,
                                    '🍛 500 taka lunch',
                                  ),
                                ],
                              ),
                            ),

                            // Text Input
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: colorScheme.outlineVariant
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _textController,
                                      focusNode: _focusNode,
                                      decoration: InputDecoration(
                                        hintText: 'Type your expense...',
                                        hintStyle: TextStyle(
                                          color: colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.6),
                                        ),
                                        filled: true,
                                        fillColor:
                                            colorScheme.surfaceContainerHigh,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      onSubmitted: _submitInput,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton.filled(
                                    onPressed: () =>
                                        _submitInput(_textController.text),
                                    icon: const Icon(Icons.send_rounded),
                                    style: IconButton.styleFrom(
                                      backgroundColor: colorScheme.primary,
                                      foregroundColor: colorScheme.onPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Complete Button (shown after practice)
                AnimatedOpacity(
                  opacity: state.userPracticed ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: state.userPracticed ? 56 : 0,
                    child: state.userPracticed
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: widget.onComplete,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.rocket_launch_rounded,
                                    size: 20,
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
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.keyboard_alt_outlined,
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Type or tap a suggestion below',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _submitInput(text),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
