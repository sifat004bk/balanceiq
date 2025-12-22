import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Header section with transaction icon, title, and edit button
class DetailHeader extends StatelessWidget {
  final bool isIncome;
  final bool isEditMode;
  final String transactionId;
  final VoidCallback onToggleEdit;

  const DetailHeader({
    super.key,
    required this.isIncome,
    required this.isEditMode,
    required this.transactionId,
    required this.onToggleEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isIncome
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red,
              size: 28,
            ),
          ).animate().fadeIn(duration: 300.ms).scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
              duration: 300.ms),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditMode ? 'Edit Transaction' : 'Transaction Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Transaction ID: #$transactionId',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ],
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 300.ms)
                .slideX(begin: 0.1, end: 0, delay: 100.ms, duration: 300.ms),
          ),
          IconButton(
            onPressed: onToggleEdit,
            icon: Icon(
              isEditMode ? Icons.close : Icons.edit_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            style: IconButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
        ],
      ),
    );
  }
}
