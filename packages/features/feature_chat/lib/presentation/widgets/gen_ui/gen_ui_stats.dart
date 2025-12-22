import 'package:flutter/material.dart';

class GenUIStats extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenUIStats({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final stats = (data['stats'] as List).cast<Map<String, dynamic>>();
    final columns = data['columns'] as int? ?? 2;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final stat = stats[index];
          return _buildStatCard(context, stat);
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, Map<String, dynamic> stat) {
    final label = stat['label'] as String;
    final value = stat['value'] as String;
    final icon = stat['icon'] as String?;
    final trend = stat['trend'] as String?;
    final colorHex = stat['color'] as String?;

    final cardColor = colorHex != null
        ? _parseColor(colorHex)
        : Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cardColor.withValues(alpha: 0.15),
            cardColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cardColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null)
                Icon(
                  _getIcon(icon),
                  color: cardColor,
                  size: 24,
                ),
              if (trend != null) _buildTrendIcon(context, trend),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIcon(BuildContext context, String trend) {
    IconData icon;
    Color color;

    switch (trend) {
      case 'up':
        icon = Icons.trending_up;
        color = Colors.green;
        break;
      case 'down':
        icon = Icons.trending_down;
        color = Theme.of(context).colorScheme.error;
        break;
      default:
        icon = Icons.trending_flat;
        color = Colors.grey;
    }

    return Icon(icon, size: 20, color: color);
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'trending_up':
        return Icons.trending_up;
      case 'trending_down':
        return Icons.trending_down;
      case 'savings':
        return Icons.savings;
      case 'account_balance':
        return Icons.account_balance;
      case 'payment':
        return Icons.payment;
      case 'attach_money':
        return Icons.attach_money;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'home':
        return Icons.home;
      default:
        return Icons.show_chart;
    }
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }
}
