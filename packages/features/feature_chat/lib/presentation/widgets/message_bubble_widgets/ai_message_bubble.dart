import 'package:flutter/material.dart';

import '../../../domain/entities/message.dart';
import 'ai_message_header.dart';
import 'ai_message_content.dart';
import 'ai_message_feedback_row.dart';
import 'chat_message_image_view.dart';

class AiMessageBubble extends StatelessWidget {
  final Message message;
  final String botName;
  final Color botColor;
  final bool isLastMessage;

  const AiMessageBubble({
    super.key,
    required this.message,
    required this.botName,
    required this.botColor,
    this.isLastMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      // Wider for AI responses
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bot header with avatar
          AiMessageHeader(
            botName: botName,
            botColor: botColor,
          ),

          // Content
          AiMessageContent(
            message: message,
            isLastMessage: isLastMessage,
          ),

          // Action Row: Like, Dislike, Select Text, Copy, Regenerate
          const SizedBox(height: 4),
          AiMessageFeedbackRow(message: message),
          const SizedBox(height: 8),

          // Image logic (if AI sends an image?)
          if (message.imageUrl != null && message.imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ChatMessageImageView(imageUrl: message.imageUrl!),
            ),
          ],
        ],
      ),
    );
  }
}
