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
  final bool hasStartedConversation;
  final ScrollController? scrollController;

  const MessageList({
    super.key,
    required this.messages,
    required this.botId,
    required this.botName,
    this.isSending = false,
    this.hasStartedConversation = false,
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
    print('🔨 [MessageList] Building CustomScrollView with ${messages.length + (isSending ? 1 : 0)} items');
    return CustomScrollView(
      controller: scrollController,
      reverse: true,
      slivers: [
        // Bottom Spacer (pushes content up, but safe for large messages)
        SliverToBoxAdapter(
          child: SizedBox(
            height: hasStartedConversation ? MediaQuery.of(context).size.height * 0.4 : 16,
          ),
        ),
        
        // Message List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Logic to handle Gap
                // Index 0: Typing Indicator (if isSending)
                // Index 1: New User Message (if isSending)
                // Index 2: GAP (if isSending)
                // Index 3+: Old Messages
                
                if (isSending) {
                  if (index == 0) {
                     print('⏱️ [MessageList] Rendering typing indicator at index $index');
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
                  if (index == 2) {
                    // GAP to hide history
                    return SizedBox(height: MediaQuery.of(context).size.height * 0.6);
                  }
                  
                  // Old Messages (index 3 corresponds to messages[length - 2])
                  // reversedIndex logic needs adjustment
                  // We consumed 3 items (Typing, NewMsg, Gap).
                  // Remaining items in 'messages' are length - 1 (excluding new msg).
                  // We want to show them in reverse order.
                  // Visual Index 3 -> Message[length - 2]
                  // Visual Index 4 -> Message[length - 3]
                  
                  final remainingIndex = index - 3;
                  final messageIndex = messages.length - 2 - remainingIndex;
                  
                  if (messageIndex < 0) return null;
                  
                  final message = messages[messageIndex];
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
              childCount: isSending ? messages.length + 2 : messages.length, // +1 for Typing, +1 for Gap
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
