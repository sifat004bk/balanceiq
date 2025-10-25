import 'package:flutter/material.dart';
import '../../domain/entities/message.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import 'message_bubble.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final String botId;
  final String botName;
  final bool isSending;

  const MessageList({
    super.key,
    required this.messages,
    required this.botId,
    required this.botName,
    this.isSending = false,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty && !isSending) {
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isSending) {
          // Show typing indicator
          return _buildTypingIndicator(context);
        }

        final message = messages[index];
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.getBotColor(botId),
            child: Icon(
              AppTheme.getBotIcon(botId),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.botMessageDarkColor
                  : AppTheme.botMessageLightColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(),
                const SizedBox(width: 4),
                _buildDot(delay: 150),
                const SizedBox(width: 4),
                _buildDot(delay: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.4 + (value * 0.4)),
            shape: BoxShape.circle,
          ),
        );
      },
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
