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
                  if (index == 1) {
                    // New User Message (messages.last)
                    final message = messages.last;
                    return MessageBubble(
                      message: message,
                      isUser: true,
                      botName: botName,
                      botColor: AppTheme.getBotColor(botId),
                    );
                  }

                  // Old Messages
                  final reversedIndex = messages.length - 2 - (index - 2);
                  if (reversedIndex < 0) return null;

                  final message = messages[reversedIndex];
                  final isUser = message.sender == AppConstants.senderUser;
                  return MessageBubble(
                    message: message,
                    isUser: isUser,
                    botName: botName,
                    botColor: AppTheme.getBotColor(botId),
                  );
                }

                // Normal behavior (not sending)
                final reversedIndex = messages.length - 1 - index;
                if (reversedIndex < 0) return null;

                final message = messages[reversedIndex];
                final isUser = message.sender == AppConstants.senderUser;

                return MessageBubble(
                  message: message,
                  isUser: isUser,
                  botName: botName,
                  botColor: AppTheme.getBotColor(botId),
                );
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
