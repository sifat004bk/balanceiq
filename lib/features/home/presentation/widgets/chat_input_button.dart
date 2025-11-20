import 'package:balance_iq/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter/material.dart';

class ChatInputButton extends StatelessWidget {
  const ChatInputButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatPage(
                  botId: "balance_tracker",
                  botName: 'BalanceIQ',
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.white,
              border: Border.all(
                color: isDark
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Chat with AI to track your finance...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade500,
                        ),
                  ),
                ),
                Icon(
                  Icons.send,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
