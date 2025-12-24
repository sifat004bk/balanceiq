import 'package:get_it/get_it.dart';
import 'package:feature_chat/constants/chat_strings.dart';
import 'package:flutter/material.dart';
import 'package:feature_chat/presentation/pages/chat_page.dart';
import 'package:balance_iq/core/icons/app_icons.dart';
import 'package:dolfin_ui_kit/dolfin_ui_kit.dart';

/// Modern floating chat button for homepage
/// Matches the chat input design but acts as a navigation button
class FloatingChatButton extends StatelessWidget {
  final GlobalKey? targetKey;
  final VoidCallback? onReturn;

  const FloatingChatButton({super.key, this.targetKey, this.onReturn});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      key: targetKey,
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatPage(
              botId: "nai kichu",
              botName: 'Donfin AI',
            ),
          ),
        );
        // Refresh dashboard when returning from chat
        onReturn?.call();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).cardColor.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
            if (isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
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
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary,
                ]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: AppLogo(
                  size: 18,
                  fit: BoxFit.cover,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Placeholder text
            Expanded(
              child: Text(
                GetIt.I<ChatStrings>().inputPlaceholder,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).hintColor,
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
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary,
                ]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: GetIt.I<AppIcons>().navigation.arrowUp(
                    size: 22,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
