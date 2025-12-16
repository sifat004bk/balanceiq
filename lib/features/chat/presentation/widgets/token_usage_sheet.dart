import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/token_usage.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

/// Bottom sheet displaying detailed token usage information
class TokenUsageSheet extends StatelessWidget {
  const TokenUsageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1e1f20) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          int currentUsage = 0;
          int limit = AppConstants.tokenLimitPer12Hours;
          TokenUsage? tokenUsage;

          if (state is ChatLoaded) {
            currentUsage = state.currentTokenUsage;
            limit = state.dailyTokenLimit;
            tokenUsage = state.tokenUsage;
          }

          final percentage =
              limit > 0 ? (currentUsage / limit).clamp(0.0, 1.0) : 0.0;
          final remainingTokens = (limit - currentUsage).clamp(0, limit);

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
                        color: isDark ? Colors.grey[600] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Token Usage',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your usage resets every 12 hours',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Usage Progress Card
                  _buildUsageProgressCard(
                    context,
                    currentUsage: currentUsage,
                    limit: limit,
                    percentage: percentage,
                    remainingTokens: remainingTokens,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),

                  // Stats Row
                  _buildStatsRow(
                    context,
                    currentUsage: currentUsage,
                    totalUsage: tokenUsage?.totalUsage ?? 0,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),

                  // Recent Activity
                  if (tokenUsage != null && tokenUsage.history.isNotEmpty) ...[
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActivityList(
                      context,
                      history: tokenUsage.history,
                      isDark: isDark,
                    ),
                  ],

                  const SizedBox(height: 16),
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
    required int currentUsage,
    required int limit,
    required double percentage,
    required int remainingTokens,
    required bool isDark,
  }) {
    final isNearLimit = percentage > 0.9;
    final isLimitReached = percentage >= 1.0;

    Color progressColor;
    if (isLimitReached) {
      progressColor = AppPalette.expenseRed;
    } else if (isNearLimit) {
      progressColor = AppPalette.sparkOrange;
    } else {
      progressColor = AppPalette.trustBlue;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2a2a2e) : const Color(0xFFF8F9FA),
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
                      '${(percentage * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      'used',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTokenCount(currentUsage),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
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
                    _formatTokenCount(limit),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
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
                    _formatTokenCount(remainingTokens),
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
    required int currentUsage,
    required int totalUsage,
    required bool isDark,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Today',
            value: _formatTokenCount(currentUsage),
            icon: Icons.today_outlined,
            color: AppPalette.trustBlue,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Total',
            value: _formatTokenCount(totalUsage),
            icon: Icons.analytics_outlined,
            color: Colors.purple,
            isDark: isDark,
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
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2a2a2e) : const Color(0xFFF8F9FA),
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
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(
    BuildContext context, {
    required List<TokenUsageHistoryItem> history,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2a2a2e) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: history.length > 5 ? 5 : history.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: isDark ? Colors.grey[700] : Colors.grey[300],
        ),
        itemBuilder: (context, index) {
          final item = history[index];
          return _buildActivityItem(
            context,
            item: item,
            isDark: isDark,
          );
        },
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required TokenUsageHistoryItem item,
    required bool isDark,
  }) {
    // Format action name for display
    final actionDisplay = _formatActionName(item.action);

    // Format timestamp to local time
    final localTime = item.timestamp;
    final timeString =
        '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';
    final dateString = '${localTime.day}/${localTime.month}/${localTime.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppPalette.trustBlue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getActionIcon(item.action),
              color: AppPalette.trustBlue,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actionDisplay,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$dateString at $timeString',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${_formatTokenCount(item.amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTokenCount(int count) {
    if (count >= 1000000) {
      final mValue = count / 1000000;
      return '${mValue.toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      final kValue = count / 1000;
      if (kValue == kValue.truncateToDouble()) {
        return '${kValue.toInt()}K';
      }
      return '${kValue.toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatActionName(String action) {
    // Convert snake_case or SCREAMING_SNAKE_CASE to Title Case
    return action
        .toLowerCase()
        .split('_')
        .map((word) =>
            word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  IconData _getActionIcon(String action) {
    final actionLower = action.toLowerCase();
    if (actionLower.contains('income')) {
      return Icons.trending_up_rounded;
    } else if (actionLower.contains('expense')) {
      return Icons.trending_down_rounded;
    } else if (actionLower.contains('chat') ||
        actionLower.contains('message')) {
      return Icons.chat_bubble_outline_rounded;
    } else if (actionLower.contains('log')) {
      return Icons.receipt_long_outlined;
    }
    return Icons.token_outlined;
  }
}
