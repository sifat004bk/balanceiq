import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/message_usage.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class MessageUsageSheet extends StatelessWidget {
  const MessageUsageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor ??
            Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          int messagesUsed = 0;
          int limit = AppConstants.dailyMessageLimit;
          MessageUsage? messageUsage;

          if (state is ChatLoaded) {
            messagesUsed = state.messagesUsedToday;
            limit = state.dailyMessageLimit;
            messageUsage = state.messageUsage;
          }

          final percentage =
              limit > 0 ? (messagesUsed / limit).clamp(0.0, 1.0) : 0.0;
          final remainingMessages = (limit - messagesUsed).clamp(0, limit);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Message Usage',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    messageUsage != null
                        ? 'Resets on ${messageUsage.formattedResetDateTime}'
                        : 'Your usage resets daily at midnight UTC',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Usage Progress Card
                  _buildUsageProgressCard(
                    context,
                    messagesUsed: messagesUsed,
                    limit: limit,
                    percentage: percentage,
                    remainingMessages: remainingMessages,
                  ),
                  const SizedBox(height: 24),

                  // Stats Row
                  _buildStatsRow(
                    context,
                    messagesUsed: messagesUsed,
                    limit: limit,
                    messageUsage: messageUsage,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUsageProgressCard(
    BuildContext context, {
    required int messagesUsed,
    required int limit,
    required double percentage,
    required int remainingMessages,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isNearLimit = percentage > 0.8;
    final isLimitReached = percentage >= 1.0;

    Color progressColor;
    if (isLimitReached) {
      progressColor = Theme.of(context).colorScheme.error;
    } else if (isNearLimit) {
      progressColor = Theme.of(context).colorScheme.secondary;
    } else {
      progressColor = Theme.of(context).colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: progressColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Circular progress with percentage
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 10,
                    backgroundColor: progressColor.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$messagesUsed/$limit',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'messages',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Usage details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Used',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$messagesUsed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Limit',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$limit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Remaining',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$remainingMessages',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: progressColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context, {
    required int messagesUsed,
    required int limit,
    required MessageUsage? messageUsage,
  }) {
    final usagePercentage = messageUsage?.usagePercentage ??
        (limit > 0 ? (messagesUsed / limit * 100) : 0.0);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Used Today',
            value: '$messagesUsed',
            icon: Icons.chat_bubble_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Usage',
            value: '${usagePercentage.toStringAsFixed(0)}%',
            icon: Icons.pie_chart_outline,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
