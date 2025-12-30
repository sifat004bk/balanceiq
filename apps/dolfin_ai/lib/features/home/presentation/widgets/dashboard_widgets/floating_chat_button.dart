import 'package:get_it/get_it.dart';
import 'package:feature_chat/constants/chat_strings.dart';
import 'package:flutter/material.dart';
import 'package:feature_chat/presentation/pages/chat_page.dart';
import 'package:balance_iq/core/icons/app_icons.dart';
import 'dart:ui';
import 'package:dolfin_ui_kit/dolfin_ui_kit.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'add_transaction_bottom_sheet.dart';

/// Modern floating chat button for homepage
/// Matches the chat input design but acts as a navigation button
class FloatingChatButton extends StatelessWidget {
  final GlobalKey? targetKey;
  final VoidCallback? onReturn;

  const FloatingChatButton({super.key, this.targetKey, this.onReturn});

  void _navigateToChat(BuildContext context, {String? initialMessage}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          botId: "nai kichu",
          botName: 'Donfin AI',
          initialMessage: initialMessage,
        ),
      ),
    );
    // Refresh dashboard when returning from chat
    onReturn?.call();
  }

  void _showAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionBottomSheet(
        onSuccess: () {
          // Refresh dashboard when transaction is added
          onReturn?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Main chat button (expanded)
          Expanded(
            child: GestureDetector(
              key: targetKey,
              onTap: () => _navigateToChat(context),
              child: Container(
                // 1. The Outer Container (Gradient Border)
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.5),
                      Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.3),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.5),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black : Colors.white)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: Colors.white
                              .withValues(alpha: 0.1), // Subtle inner shine
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primary,
                              ]),
                              shape: BoxShape.circle,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withValues(alpha: 0.9),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Send button
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: GetIt.I<AppIcons>().navigation.arrowUp(
                                  size: 22,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Add transaction button
          GestureDetector(
            onTap: () => _showAddTransactionSheet(context),
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.5),
                    Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.3),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.plus,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
