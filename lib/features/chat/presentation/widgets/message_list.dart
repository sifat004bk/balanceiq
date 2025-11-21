import 'package:flutter/material.dart';
import '../../domain/entities/message.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import 'message_bubble.dart';
import 'typing_indicator.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final String botId;
  final String botName;
  final bool isSending;
  final ScrollController? scrollController;

  const MessageList({
    super.key,
    required this.messages,
    required this.botId,
    required this.botName,
    this.isSending = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    print('📜 [MessageList] Building with ${messages.length} messages, isSending: $isSending');

    // Print all messages with serial numbers
    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      final preview = msg.content.length > 30 ? msg.content.substring(0, 30) + '...' : msg.content;
      print('  📝 [MessageList] Message #${i + 1}/${messages.length} - ${msg.sender}: "$preview" (id: ${msg.id.substring(0, 8)})');
    }

    if (messages.isEmpty && !isSending) {
      print('💬 [MessageList] No messages, showing welcome screen');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppTheme.getBotIcon(botId),
              size: 80,
              color: AppTheme.getBotColor(botId).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Hi! I\'m your $botName.',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _getWelcomeMessage(botId),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    print('🔨 [MessageList] Building ListView with ${messages.length + (isSending ? 1 : 0)} items');
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      reverse: true, // Start from bottom
      itemCount: messages.length + (isSending ? 1 : 0),
      itemBuilder: (context, index) {
        // Reverse the index since list is reversed
        final reversedIndex = messages.length - 1 - index + (isSending ? 1 : 0);

        if (isSending && index == 0) {
          // Show typing indicator at top (which is bottom visually)
          print('⏱️ [MessageList] Rendering typing indicator at index $index');
          return _buildTypingIndicator(context);
        }

        final actualIndex = isSending ? reversedIndex - 1 : reversedIndex;
        if (actualIndex < 0 || actualIndex >= messages.length) {
          return const SizedBox.shrink();
        }

        final message = messages[actualIndex];
        final isUser = message.sender == AppConstants.senderUser;

        return MessageBubble(
          message: message,
          isUser: isUser,
          botName: botName,
          botColor: AppTheme.getBotColor(botId),
        );
      },
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TypingIndicator(),
    );
  }

  String _getWelcomeMessage(String botId) {
    switch (botId) {
      case AppConstants.balanceTrackerID:
        return 'I can help you track your expenses and monitor your financial position.';
      case AppConstants.investmentGuruID:
        return 'I can provide insights and tips on investment options and strategies.';
      case AppConstants.budgetPlannerID:
        return 'I can assist you in creating budgets and managing your finances.';
      case AppConstants.finTipsID:
        return 'I can share financial literacy tips and smart money habits.';
      default:
        return 'How can I help you today?';
    }
  }
}
