import 'package:flutter/material.dart';

class GenUIInsightCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenUIInsightCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String;
    final description = data['description'] as String?;
    final icon = data['icon'] as String?;
    final items = data['items'] as List?;
    final type = data['type'] as String? ??
        'default'; // default, success, warning, error, info

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getTypeColor(type, context).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _getTypeColor(type, context).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTypeColor(type, context).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIcon(icon),
                    color: _getTypeColor(type, context),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getTypeColor(type, context),
                      ),
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
            ),
          ],
          if (items != null && items.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...items.map((item) => _buildItem(context, item, type)).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, dynamic item, String type) {
    if (item is String) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _getTypeColor(type, context),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      );
    } else if (item is Map<String, dynamic>) {
      final itemTitle = item['title'] as String?;
      final itemValue = item['value'] as String?;
      final itemIcon = item['icon'] as String?;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            if (itemIcon != null) ...[
              Icon(
                _getIcon(itemIcon),
                size: 20,
                color: _getTypeColor(type, context),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                itemTitle ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (itemValue != null)
              Text(
                itemValue,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getTypeColor(type, context),
                    ),
              ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Color _getTypeColor(String type, BuildContext context) {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Theme.of(context).colorScheme.secondary;
      case 'error':
        return Theme.of(context).colorScheme.error;
      case 'info':
        return Theme.of(context).colorScheme.primary;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'lightbulb':
        return Icons.lightbulb_outline;
      case 'check':
        return Icons.check_circle_outline;
      case 'warning':
        return Icons.warning_amber_outlined;
      case 'info':
        return Icons.info_outline;
      case 'savings':
        return Icons.savings_outlined;
      case 'trending_up':
        return Icons.trending_up;
      case 'trending_down':
        return Icons.trending_down;
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      case 'chart':
        return Icons.bar_chart;
      case 'target':
        return Icons.track_changes;
      case 'star':
        return Icons.star_outline;
      default:
        return Icons.info_outline;
    }
  }
}
