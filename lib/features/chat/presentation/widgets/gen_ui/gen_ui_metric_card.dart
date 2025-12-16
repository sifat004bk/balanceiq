import 'package:flutter/material.dart';
import 'package:balance_iq/core/theme/app_palette.dart';

class GenUIMetricCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenUIMetricCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String;
    final value = data['value'] as String;
    final change = data['change'] as String?;
    final trend = data['trend'] as String?; // 'up', 'down', 'neutral'
    final icon = data['icon'] as String?;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppPalette.trustBlue.withOpacity(0.1),
            AppPalette.trustBlue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppPalette.trustBlue.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppPalette.trustBlue.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                _buildIcon(icon, context),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              if (trend != null) _buildTrendIndicator(trend, context),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppPalette.trustBlue,
                ),
          ),
          if (change != null) ...[
            const SizedBox(height: 8),
            Text(
              change,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getChangeColor(change, context),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon(String iconName, BuildContext context) {
    IconData iconData;
    switch (iconName) {
      case 'wallet':
        iconData = Icons.account_balance_wallet;
        break;
      case 'trending_up':
        iconData = Icons.trending_up;
        break;
      case 'savings':
        iconData = Icons.savings;
        break;
      case 'account_balance':
        iconData = Icons.account_balance;
        break;
      case 'payment':
        iconData = Icons.payment;
        break;
      case 'attach_money':
        iconData = Icons.attach_money;
        break;
      default:
        iconData = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppPalette.trustBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        size: 24,
        color: AppPalette.trustBlue,
      ),
    );
  }

  Widget _buildTrendIndicator(String trend, BuildContext context) {
    IconData icon;
    Color color;

    switch (trend) {
      case 'up':
        icon = Icons.arrow_upward;
        color = AppPalette.incomeGreen;
        break;
      case 'down':
        icon = Icons.arrow_downward;
        color = AppPalette.expenseRed;
        break;
      default:
        icon = Icons.remove;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }

  Color _getChangeColor(String change, BuildContext context) {
    if (change.startsWith('+')) {
      return AppPalette.incomeGreen;
    } else if (change.startsWith('-')) {
      return AppPalette.expenseRed;
    }
    return Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
  }
}
