import 'package:flutter/material.dart';
import '../../../../../core/constants/gemini_colors.dart';

class GenUIProgress extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenUIProgress({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String;
    final current = (data['current'] as num).toDouble();
    final target = (data['target'] as num).toDouble();
    final percentage = (current / target * 100).clamp(0, 100);
    final label = data['label'] as String?;
    final showValue = data['showValue'] as bool? ?? true;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GeminiColors.divider(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getProgressColor(percentage, context),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: percentage / 100),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                  backgroundColor:
                      GeminiColors.primaryColor(context).withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(percentage, context),
                  ),
                ),
              );
            },
          ),
          if (showValue) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_formatNumber(current)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  '${_formatNumber(target)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.6),
                      ),
                ),
              ],
            ),
          ],
          if (label != null) ...[
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.8),
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage, BuildContext context) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 50) return GeminiColors.primaryColor(context);
    if (percentage >= 25) return Colors.orange;
    return Colors.red;
  }

  String _formatNumber(double number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toStringAsFixed(0);
  }
}
