import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../domain/entities/message.dart';
import '../../../../core/theme/app_theme.dart';

class MessageBubble extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: botColor,
              child: Icon(
                AppTheme.getBotIcon(message.botId),
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Sender name
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
                  child: Text(
                    isUser ? 'You' : botName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                // Message bubble
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppTheme.userMessageColor
                        : isDark
                            ? AppTheme.botMessageDarkColor
                            : AppTheme.botMessageLightColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message text
                      if (message.content.isNotEmpty)
                        isUser
                            ? Text(
                                message.content,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                    ),
                              )
                            : MarkdownBody(
                                data: message.content,
                                selectable: true,
                                styleSheet: MarkdownStyleSheet(
                                  p: Theme.of(context).textTheme.bodyMedium,
                                  h1: Theme.of(context).textTheme.headlineLarge,
                                  h2: Theme.of(context).textTheme.headlineMedium,
                                  h3: Theme.of(context).textTheme.headlineSmall,
                                  h4: Theme.of(context).textTheme.titleLarge,
                                  h5: Theme.of(context).textTheme.titleMedium,
                                  h6: Theme.of(context).textTheme.titleSmall,
                                  code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontFamily: 'monospace',
                                        backgroundColor: isDark
                                            ? Colors.grey[800]
                                            : Colors.grey[200],
                                      ),
                                  codeblockDecoration: BoxDecoration(
                                    color: isDark ? Colors.grey[900] : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                  blockquoteDecoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey[800]?.withValues(alpha: 0.3)
                                        : Colors.grey[200]?.withValues(alpha: 0.3),
                                    border: Border(
                                      left: BorderSide(
                                        color: botColor,
                                        width: 4,
                                      ),
                                    ),
                                  ),
                                  listBullet: Theme.of(context).textTheme.bodyMedium,
                                  tableBody: Theme.of(context).textTheme.bodyMedium,
                                  tableHead: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  a: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: botColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                  em: const TextStyle(fontStyle: FontStyle.italic),
                                  strong: const TextStyle(fontWeight: FontWeight.bold),
                                  horizontalRuleDecoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      // Image if available
                      if (message.imageUrl != null &&
                          message.imageUrl!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildImage(message.imageUrl!),
                        ),
                      ],
                    ],
                  ),
                ),
                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(
                    _formatTimestamp(message.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                        ),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            const CircleAvatar(
              child: Icon(Icons.person, size: 20),
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
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        ),
      );
    } else {
      // Local file
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 200,
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        ),
      );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('HH:mm').format(timestamp)}';
    } else {
      return DateFormat('MMM dd, HH:mm').format(timestamp);
    }
  }
}
