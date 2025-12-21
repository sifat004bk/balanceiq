import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A single row showing a labeled detail with icon
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int delayMs;
  final bool isLast;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.delayMs = 0,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delayMs), duration: 300.ms)
        .slideX(
            begin: 0.05,
            end: 0,
            delay: Duration(milliseconds: delayMs),
            duration: 300.ms);
  }
}
