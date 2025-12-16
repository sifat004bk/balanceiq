import 'package:balance_iq/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatShimmer extends StatelessWidget {
  const ChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // AI message (left aligned)
        _buildMessageShimmer(context, isUser: false, width: 0.75),
        const SizedBox(height: 16),

        // User message (right aligned)
        _buildMessageShimmer(context, isUser: true, width: 0.5),
        const SizedBox(height: 16),

        // AI message with longer content
        _buildMessageShimmer(context, isUser: false, width: 0.85),
        const SizedBox(height: 16),

        // User message
        _buildMessageShimmer(context, isUser: true, width: 0.4),
        const SizedBox(height: 16),

        // AI message
        _buildMessageShimmer(context, isUser: false, width: 0.65),
        const SizedBox(height: 16),

        // User message
        _buildMessageShimmer(context, isUser: true, width: 0.55),
      ],
    );
  }

  Widget _buildMessageShimmer(
    BuildContext context, {
    required bool isUser,
    required double width,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: colorScheme.onSurface.withOpacity(0.05),
      highlightColor: colorScheme.onSurface.withOpacity(0.1),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            // AI avatar
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          // Message bubble
          Container(
            width: screenWidth * width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.onSurface,
              borderRadius: BorderRadius.circular(isUser ? 24 : 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text line 1
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                if (width > 0.5) ...[
                  const SizedBox(height: 8),
                  // Text line 2
                  Container(
                    height: 14,
                    width: double.infinity * 0.8,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
                if (width > 0.7) ...[
                  const SizedBox(height: 8),
                  // Text line 3
                  Container(
                    height: 14,
                    width: double.infinity * 0.6,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isUser) ...[
            const SizedBox(height: 8),
            // Action buttons placeholder
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
