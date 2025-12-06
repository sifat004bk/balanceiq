import 'package:balance_iq/core/constants/gemini_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/message.dart';
import '../chat_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chat_cubit.dart';
import 'gen_ui/gen_ui_builder.dart';

/// Gemini-style message bubble with animations
class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isUser;
  final String botName;
  final Color botColor;
  final bool isLastMessage;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.botName,
    required this.botColor,
    this.isLastMessage = false,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // Slightly longer for smoothness
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Slide up from bottom
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildMessageContent(context),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Reduced vertical padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isUser) ...[
            Padding(
              padding: const EdgeInsets.only(top: 0), // Align with top of text
              child: CircleAvatar(
                radius: 14, // Smaller avatar
                backgroundColor: Colors.transparent, // Transparent bg
                child: Icon(
                  Icons.auto_awesome, // Gemini sparkle icon
                  color: widget.botColor, // Use bot specific color
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Row(
            mainAxisAlignment:
                widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message content
              Flexible(
                child: Column(
                  crossAxisAlignment: widget.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Message bubble
                    widget.isUser
                        ? _buildUserMessage(context)
                        : _buildAiMessage(context),
                    // Timestamp (User only, or bottom for AI?) - Keeping as is for now
                    if (widget.isUser)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Text(
                          _formatTimestamp(widget.message.timestamp),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                color: GeminiColors.textSecondary(context),
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// User message with dark grey background
  Widget _buildUserMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: GeminiColors.userMessageBg, // Dark Grey
        borderRadius: const BorderRadius.all(
          Radius.circular(24), // Rounded
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GeminiColors.userMessageText, // White
                  fontSize: 16,
                  height: 1.4,
                ),
          ),
          if (widget.message.imageUrl != null &&
              widget.message.imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(widget.message.imageUrl!),
            ),
          ],
        ],
      ),
    );
  }

  /// AI message with header, actions, and disclaimer
  Widget _buildAiMessage(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Name - REMOVED (Moved avatar to outer row)
          // Row(
          //   children: [
          //     CircleAvatar(
          //       radius: 16,
          //       backgroundColor: GeminiColors.botAvatarBg,
          //       child: const Icon(
          //         Icons.auto_awesome, // Gemini sparkle icon
          //         color: GeminiColors.botAvatarIcon,
          //         size: 18,
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: Text(
          //         'BalanceIQ', // App Name
          //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //               color: GeminiColors.textSecondary(context),
          //               fontSize: 14,
          //               fontWeight: FontWeight.w500,
          //             ),
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 16),
          
          // Content
          if (widget.message.content.isNotEmpty)
            MarkdownBody(
              data: widget.message.content,
              selectable: true,
              builders: {
                'ui:chart': GenUIChartBuilder(),
                'ui:table': GenUITableBuilder(),
                'ui:summary_card': GenUISummaryCardBuilder(),
                'ui:action_list': GenUIActionListBuilder(),
                'ui:metric': GenUIMetricCardBuilder(),
                'ui:progress': GenUIProgressBuilder(),
                'ui:actions': GenUIActionButtonsBuilder(),
                'ui:stats': GenUIStatsBuilder(),
                'ui:insight': GenUIInsightCardBuilder(),
              },
              styleSheet: MarkdownStyleSheet(
                p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                      fontSize: 16,
                      height: 1.5,
                    ),
                h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                      fontWeight: FontWeight.bold,
                    ),
                h2: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                      fontWeight: FontWeight.bold,
                    ),
                h3: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                      fontWeight: FontWeight.w600,
                    ),
                h4: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                      fontWeight: FontWeight.w600,
                    ),
                h5: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                      fontWeight: FontWeight.w600,
                    ),
                h6: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                      fontWeight: FontWeight.w600,
                    ),
                code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Google Sans Mono',
                      backgroundColor:
                          isDark ? const Color(0xFF1e1f20) : const Color(0xFFf5f5f5),
                      color: GeminiColors.aiMessageText(context),
                      fontSize: 13,
                    ),
                codeblockDecoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1e1f20) : const Color(0xFFf5f5f5),
                  borderRadius: BorderRadius.circular(8),
                ),
                blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GeminiColors.textSecondary(context),
                      fontStyle: FontStyle.italic,
                    ),
                blockquoteDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    left: BorderSide(
                      color: GeminiColors.primaryColor(context),
                      width: 4,
                    ),
                  ),
                ),
                listBullet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                    ),
                tableBody: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                    ),
                tableHead: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: GeminiColors.aiMessageText(context),
                    ),
                a: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GeminiColors.primaryColor(context),
                      decoration: TextDecoration.underline,
                    ),
                em: const TextStyle(fontStyle: FontStyle.italic),
                strong: const TextStyle(fontWeight: FontWeight.bold),
                horizontalRuleDecoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: GeminiColors.divider(context),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            
          const SizedBox(height: 16),

          // Action Type Display & Change Button
          if (widget.message.actionType != null && widget.message.actionType!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2a2a2e) : const Color(0xFFf0f0f0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GeminiColors.divider(context),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Recorded as '${widget.message.actionType}'",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: GeminiColors.textSecondary(context),
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  if (widget.isLastMessage) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showActionTypeOptions(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: GeminiColors.primaryColor(context).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: GeminiColors.primaryColor(context),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Change',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: GeminiColors.primaryColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Action Row: Like, Dislike, Select Text, Copy, Regenerate
          Row(
            children: [
              if (ChatConfig.showFeedbackButtons) ...[
                IconButton(
                  icon: Icon(Icons.thumb_up_outlined, color: GeminiColors.icon(context), size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thanks for the feedback!')),
                    );
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.thumb_down_outlined, color: GeminiColors.icon(context), size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thanks for the feedback!')),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
              
              // Select Text (Replaces Filter/Tune)
              if (ChatConfig.showSelectTextButton) ...[
                IconButton(
                  icon: Icon(Icons.select_all, color: GeminiColors.icon(context), size: 20),
                  onPressed: () {
                     // Placeholder for select text functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Select text mode')),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],

              if (ChatConfig.showCopyButton) ...[
                IconButton(
                  icon: Icon(Icons.content_copy, color: GeminiColors.icon(context), size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.message.content));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],

              // Regenerate Button
              if (ChatConfig.showRegenerateButton)
                IconButton(
                  icon: Icon(Icons.refresh, color: GeminiColors.icon(context), size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Regenerating response...')),
                    );
                    // Trigger regeneration logic here if available
                  },
                ),
              // Disclaimer
              if (ChatConfig.bottomDisclaimerText != null)
                Center(
                  child: Text(
                    ChatConfig.bottomDisclaimerText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: GeminiColors.textSecondary(context),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),



          // Image logic
          if (widget.message.imageUrl != null &&
              widget.message.imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(widget.message.imageUrl!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 200,
          color: GeminiColors.divider(context),
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: GeminiColors.divider(context),
          child: Icon(
            Icons.error,
            color: GeminiColors.textSecondary(context),
          ),
        ),
      );
    } else {
      // Local file
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 200,
          color: GeminiColors.divider(context),
          child: Icon(
            Icons.error,
            color: GeminiColors.textSecondary(context),
          ),
        ),
      );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(timestamp); // Gemini time format
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('h:mm a').format(timestamp)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }

  void _showActionTypeOptions(BuildContext context) {
    // Capture the cubit from the current context (where the provider is available)
    // before showing the bottom sheet (which pushes a new route without the provider)
    final chatCubit = context.read<ChatCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: GeminiColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Change Action Type',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.arrow_downward, color: Colors.green),
                  title: const Text('Income'),
                  onTap: () {
                    Navigator.pop(context);
                    _sendCorrectionMessage(chatCubit, 'income');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_upward, color: Colors.red),
                  title: const Text('Expense'),
                  onTap: () {
                    Navigator.pop(context);
                    _sendCorrectionMessage(chatCubit, 'expense');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendCorrectionMessage(ChatCubit chatCubit, String newType) {
    final correctionText = "change the actiontype of the last entry as $newType";
    chatCubit.sendNewMessage(
          botId: widget.message.botId,
          content: correctionText,
        );
  }
}
