import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import 'message_usage_sheet.dart';

/// Floating button that displays current message usage
/// Shows "X/Y" format (e.g., "3/10" for 3 messages used of 10 daily limit)
/// Positioned in the top right corner of the chat page
class MessageUsageButton extends StatelessWidget {
  const MessageUsageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        int messagesUsed = 0;
        int limit = AppConstants.dailyMessageLimit;

        if (state is ChatLoaded) {
          messagesUsed = state.messagesUsedToday;
          limit = state.dailyMessageLimit;
        }

        final percentage =
            limit > 0 ? (messagesUsed / limit).clamp(0.0, 1.0) : 0.0;
        final isNearLimit = percentage > 0.8;
        final isLimitReached = percentage >= 1.0;

        // Determine colors based on usage
        Color progressColor;
        Color backgroundColor;
        if (isLimitReached) {
          progressColor = Theme.of(context).colorScheme.error;
          backgroundColor =
              Theme.of(context).colorScheme.error.withOpacity(0.15);
        } else if (isNearLimit) {
          progressColor = Theme.of(context).colorScheme.secondary;
          backgroundColor =
              Theme.of(context).colorScheme.secondary.withOpacity(0.15);
        } else {
          progressColor = Theme.of(context).colorScheme.primary;
          backgroundColor =
              Theme.of(context).colorScheme.primary.withOpacity(0.15);
        }

        return GestureDetector(
          onTap: () => _showMessageUsageSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: progressColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular progress indicator
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: percentage,
                        strokeWidth: 3,
                        backgroundColor: backgroundColor,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                      Icon(
                        isLimitReached
                            ? Icons.warning_rounded
                            : Icons.chat_bubble_outline,
                        size: 12,
                        color: progressColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Message count text (e.g., "3/10")
                Text(
                  '$messagesUsed/$limit',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMessageUsageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<ChatCubit>(),
        child: const MessageUsageSheet(),
      ),
    );
  }
}
