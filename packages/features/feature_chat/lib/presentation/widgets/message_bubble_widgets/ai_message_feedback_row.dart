import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:feature_chat/constants/chat_strings.dart';
import 'package:dolfin_core/constants/core_strings.dart';
import 'package:dolfin_core/utils/snackbar_utils.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/chat_feedback.dart';
import '../../chat_config.dart';
import '../../cubit/chat_cubit.dart';

class AiMessageFeedbackRow extends StatelessWidget {
  final Message message;

  const AiMessageFeedbackRow({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final chatConfig = GetIt.instance<ChatConfig>();

    return Row(
      children: [
        if (chatConfig.showFeedbackButtons) ...[
          _buildActionButton(
            context,
            icon: message.feedback == 'LIKE'
                ? Icons.thumb_up
                : Icons.thumb_up_outlined,
            color: message.feedback == 'LIKE'
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            onPressed: () {
              final newFeedback = message.feedback == 'LIKE'
                  ? FeedbackType.none
                  : FeedbackType.like;

              context
                  .read<ChatCubit>()
                  .submitMessageFeedback(message.id, newFeedback);

              if (newFeedback == FeedbackType.like) {
                SnackbarUtils.showInfo(
                    context, GetIt.I<ChatStrings>().feedbackThanks);
              }
            },
          ),
          const SizedBox(width: 4),
          _buildActionButton(
            context,
            icon: message.feedback == 'DISLIKE'
                ? Icons.thumb_down
                : Icons.thumb_down_outlined,
            color: message.feedback == 'DISLIKE'
                ? colorScheme.error
                : colorScheme.onSurface.withValues(alpha: 0.6),
            onPressed: () {
              final newFeedback = message.feedback == 'DISLIKE'
                  ? FeedbackType.none
                  : FeedbackType.dislike;

              context
                  .read<ChatCubit>()
                  .submitMessageFeedback(message.id, newFeedback);

              if (newFeedback == FeedbackType.dislike) {
                SnackbarUtils.showInfo(
                    context, GetIt.I<ChatStrings>().feedbackThanks);
              }
            },
          ),
          const SizedBox(width: 4),
        ],

        // Select Text (Replaces Filter/Tune)
        if (chatConfig.showSelectTextButton) ...[
          _buildActionButton(
            context,
            icon: Icons.select_all,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            onPressed: () {
              SnackbarUtils.showInfo(
                  context, GetIt.I<CoreStrings>().common.selectTextMode);
            },
          ),
          const SizedBox(width: 4),
        ],

        if (chatConfig.showCopyButton) ...[
          _buildActionButton(
            context,
            icon: Icons.content_copy,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message.content));
              SnackbarUtils.showInfo(
                  context, GetIt.I<CoreStrings>().common.copied);
            },
          ),
          const SizedBox(width: 4),
        ],

        // Regenerate Button
        if (chatConfig.showRegenerateButton)
          _buildActionButton(
            context,
            icon: Icons.refresh,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            onPressed: () {
              SnackbarUtils.showInfo(
                  context, GetIt.I<ChatStrings>().regenerating);
            },
          ),
        // Disclaimer
        if (chatConfig.bottomDisclaimerText?.isNotEmpty ?? false)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  chatConfig.bottomDisclaimerText!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: 12,
                      ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Modern action button with proper touch targets (2025 design)
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
      ),
    );
  }
}
