import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import '../../../chat/presentation/pages/chat_page.dart';

/// Modern floating chat button for homepage
/// Matches the chat input design but acts as a navigation button
class FloatingChatButton extends StatelessWidget {
  final GlobalKey? targetKey;

  const FloatingChatButton({super.key, this.targetKey});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      key: targetKey,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatPage(
              botId: "nai kichu",
              botName: 'BalanceIQ',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [
                    AppPalette.surfaceDark,
                    AppPalette.surfaceDark.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    AppPalette.surfaceLight,
                    AppPalette.surfaceLight.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isDark
                ? AppPalette.trustBlue.withOpacity(0.3)
                : AppPalette.trustBlue.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppPalette.trustBlue : AppPalette.trustBlue)
                  .withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
            if (isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            // Chat icon with gradient
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppPalette.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.trustBlue.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),

            // Placeholder text
            Expanded(
              child: Text(
                AppStrings.chat.inputPlaceholder,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPalette.neutralGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
              ),
            ),

            const SizedBox(width: 12),

            // Send button with gradient
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppPalette.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.trustBlue.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
