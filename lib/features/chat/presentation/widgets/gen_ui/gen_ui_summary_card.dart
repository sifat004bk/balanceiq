import 'package:flutter/material.dart';
import '../../../../../core/constants/gemini_colors.dart';

class GenUISummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenUISummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String?;
    final value = data['value'] as String?;
    final trend = data['trend'] as String?;
    final trendColorString = data['trendColor'] as String?;
    final iconName = data['icon'] as String?;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Determine trend color
    Color trendColor = Colors.green;
    if (trendColorString == 'red') trendColor = Colors.red;
    if (trendColorString == 'grey') trendColor = Colors.grey;

    // Resolve Icon
    IconData icon = Icons.account_balance;
    if (iconName == 'shopping_bag') icon = Icons.shopping_bag;
    if (iconName == 'trending_up') icon = Icons.trending_up;
    if (iconName == 'savings') icon = Icons.savings;
    if (iconName == 'credit_card') icon = Icons.credit_card;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2A2A2E), const Color(0xFF1E1E20)]
              : [const Color(0xFFFFFFFF), const Color(0xFFF5F5F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: GeminiColors.primaryColor(context).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: GeminiColors.primaryColor(context),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? 'Summary',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: GeminiColors.textSecondary(context),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? '',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: GeminiColors.aiMessageText(context),
                      ),
                ),
              ],
            ),
          ),
          if (trend != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: trendColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    trend.startsWith('+') ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: trendColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: TextStyle(
                      color: trendColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
