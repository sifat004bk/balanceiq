import 'package:balance_iq/core/constants/gemini_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/message.dart';

/// Gemini-style message bubble with animations
class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isUser;
  final String botName;
  final Color botColor;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.botName,
    required this.botColor,
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
      duration: const Duration(milliseconds: 300), // Gemini animation duration
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.75; // 75% of screen width (Gemini style)

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bot avatar (only for AI messages)
          if (!widget.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: GeminiColors.botAvatarBg,
              child: const Icon(
                Icons.auto_awesome, // Gemini sparkle icon
                color: GeminiColors.botAvatarIcon,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Message content
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: widget.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Message bubble
                  widget.isUser
                      ? _buildUserMessage(context)
                      : _buildAiMessage(context),
                  // Timestamp
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _formatTimestamp(widget.message.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: GeminiColors.textSecondary(context),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// User message with purple background
  Widget _buildUserMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: GeminiColors.userMessageBg, // Purple
        borderRadius: BorderRadius.all(
          Radius.circular(24), // Gemini border radius
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GeminiColors.userMessageText, // White
                  fontSize: 14,
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

  /// AI message with light background and markdown support
  Widget _buildAiMessage(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: GeminiColors.aiMessageBackground(context),
        borderRadius: const BorderRadius.all(
          Radius.circular(24), // Gemini border radius
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.message.content.isNotEmpty)
            MarkdownBody(
              data: widget.message.content,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                      fontSize: 14,
                    ),
                h1: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                    ),
                h2: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                    ),
                h3: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                    ),
                h4: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                    ),
                h5: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                    ),
                h6: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                    ),
                code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      backgroundColor:
                          isDark ? Colors.grey[800] : Colors.grey[200],
                      color: GeminiColors.aiMessageText(context),
                    ),
                codeblockDecoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GeminiColors.textSecondary(context),
                      fontStyle: FontStyle.italic,
                    ),
                blockquoteDecoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey[800]?.withValues(alpha: 0.3)
                      : Colors.grey[200]?.withValues(alpha: 0.3),
                  border: Border(
                    left: BorderSide(
                      color: GeminiColors.primary,
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
                      color: GeminiColors.primary,
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
}
