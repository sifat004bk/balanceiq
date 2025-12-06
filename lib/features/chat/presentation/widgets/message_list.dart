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
  final bool hasMore;
  final bool isLoadingMore;
  final ScrollController? scrollController;

  const MessageList({
    super.key,
    required this.messages,
    required this.botId,
    required this.botName,
    this.isSending = false,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.scrollController,
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

    return CustomScrollView(
      controller: scrollController,
      reverse: true,
      slivers: [
        // Bottom Spacer
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),

        // Message List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (isSending) {
                  if (index == 0) {
                     return _buildTypingIndicator(context);
                  }
                  // Adjust index for typing indicator
                  final messageIndex = index - 1;
                  if (messageIndex < messages.length) {
                    final message = messages[messageIndex];
                    final isUser = message.sender == AppConstants.senderUser;
                    // When sending, the first message (index 0) is typing indicator, 
                    // so index 1 (messageIndex 0) is the last message.
                    final isLastMessage = messageIndex == 0;
                    
                    return MessageBubble(
                      message: message,
                      isUser: isUser,
                      botName: botName,
                      botColor: AppTheme.getBotColor(botId),
                      isLastMessage: isLastMessage,
                    );
                  }
                  return null;
                }

                // Normal behavior (not sending)
                if (index < messages.length) {
                  final message = messages[index];
                  final isUser = message.sender == AppConstants.senderUser;
                  // In reversed list, index 0 is the last message
                  final isLastMessage = index == 0;

                  return MessageBubble(
                    message: message,
                    isUser: isUser,
                    botName: botName,
                    botColor: AppTheme.getBotColor(botId),
                    isLastMessage: isLastMessage,
                  );
                }
                return null;
              },
              childCount: isSending ? messages.length + 1 : messages.length, // +1 for Typing indicator
            ),
          ),
        ),

        // Pagination Loading Indicator (at top when scrolling up)
        if (isLoadingMore)
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.getBotColor(botId),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Top Padding
        const SliverPadding(padding: EdgeInsets.only(top: 16)),
      ],
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
