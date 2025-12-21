import 'package:flutter/material.dart';
import '../../../domain/entities/message.dart';
import 'chat_message_image_view.dart';

class UserMessageBubble extends StatelessWidget {
  final Message message;

  const UserMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  height: 1.4,
                ),
          ),
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
