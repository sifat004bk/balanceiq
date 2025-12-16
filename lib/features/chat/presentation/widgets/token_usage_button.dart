import 'package:balance_iq/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/gemini_colors.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import 'token_usage_sheet.dart';

/// Floating button that displays current token usage
/// Positioned in the top right corner of the chat page
class TokenUsageButton extends StatelessWidget {
  const TokenUsageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        int currentUsage = 0;
        int limit = AppConstants.tokenLimitPer12Hours;

        if (state is ChatLoaded) {
          currentUsage = state.currentTokenUsage;
          limit = state.dailyTokenLimit;
        }

        final percentage = limit > 0 ? (currentUsage / limit).clamp(0.0, 1.0) : 0.0;
        final isNearLimit = percentage > 0.9;
        final isLimitReached = percentage >= 1.0;

        // Determine colors based on usage
        Color progressColor;
        Color backgroundColor;
        if (isLimitReached) {
          progressColor = AppPalette.expenseRed;
          backgroundColor = AppPalette.expenseRed.withOpacity(0.15);
        } else if (isNearLimit) {
          progressColor = AppPalette.sparkOrange;
          backgroundColor = AppPalette.sparkOrange.withOpacity(0.15);
        } else {
          progressColor = GeminiColors.primary;
          backgroundColor = GeminiColors.primary.withOpacity(0.15);
        }

        return GestureDetector(
          onTap: () => _showTokenUsageSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? AppPalette.neutralBlack.withValues(alpha: 0.54)
                  : AppPalette.neutralWhite.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.neutralBlack.withValues(alpha: 0.1),
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
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                      Icon(
                        isLimitReached
                            ? Icons.warning_rounded
                            : Icons.token_outlined,
                        size: 12,
                        color: progressColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Token count text
                Text(
                  _formatTokenCount(currentUsage),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppPalette.neutralWhite : AppPalette.neutralBlack,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Formats token count for display (e.g., 1.5K, 35K)
  String _formatTokenCount(int count) {
    if (count >= 1000) {
      final kValue = count / 1000;
      if (kValue == kValue.truncateToDouble()) {
        return '${kValue.toInt()}K';
      }
      return '${kValue.toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _showTokenUsageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<ChatCubit>(),
        child: const TokenUsageSheet(),
      ),
    );
  }
}
