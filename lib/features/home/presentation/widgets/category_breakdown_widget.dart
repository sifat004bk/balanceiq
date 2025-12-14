import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:balance_iq/features/home/presentation/pages/transactions_page.dart';
import 'package:flutter/material.dart';

class CategoryBreakdownWidget extends StatelessWidget {
  final Map<String, double> categories;

  const CategoryBreakdownWidget({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    final sortedCategories = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Calculate total for percentage
    final total = sortedCategories.fold<double>(
      0,
      (sum, entry) => sum + entry.value.abs(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spending by Category',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${sortedCategories.length}',
                  style: textTheme.labelMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120, // Slightly smaller height than accounts
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sortedCategories.length,
            itemBuilder: (context, index) {
              final entry = sortedCategories[index];
              final percentage = total > 0 ? (entry.value.abs() / total * 100) : 0.0;

              return Padding(
                padding: EdgeInsets.only(
                  right: index == sortedCategories.length - 1 ? 0 : 12,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TransactionsPage(category: entry.key),
                      ),
                    );
                  },
                  child: _buildCategoryCard(
                    context,
                    categoryName: entry.key,
                    amount: entry.value,
                    percentage: percentage,
                    index: index,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String categoryName,
    required double amount,
    required double percentage,
    required int index,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = _getCategoryColor(categoryName, index);
    final icon = _getCategoryIcon(categoryName);

    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surface.withOpacity(0.05)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? colorScheme.onSurface.withOpacity(0.1)
              : colorScheme.onSurface.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 18,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: textTheme.labelSmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppTheme.textSubtleDark
                        : AppTheme.textSubtleLight,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'BDT ${amount.abs().toStringAsFixed(0)}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category, int index) {
    final name = category.toLowerCase();
    if (name.contains('food') || name.contains('dining')) return Colors.orange;
    if (name.contains('transport')) return Colors.blue;
    if (name.contains('shop')) return Colors.pink;
    if (name.contains('bill') || name.contains('util')) return Colors.cyan;
    if (name.contains('rent') || name.contains('house')) return Colors.indigo;
    if (name.contains('health') || name.contains('med')) return Colors.red;
    if (name.contains('entertain')) return Colors.purple;
    
    // Fallback palette
    final colors = [
      Colors.teal,
      Colors.lime,
      Colors.amber,
      Colors.deepOrange,
      Colors.lightBlue,
    ];
    return colors[index % colors.length];
  }

  IconData _getCategoryIcon(String category) {
    final name = category.toLowerCase();
    if (name.contains('food') || name.contains('dining')) return Icons.restaurant;
    if (name.contains('transport')) return Icons.directions_car;
    if (name.contains('shop')) return Icons.shopping_bag;
    if (name.contains('bill') || name.contains('util')) return Icons.receipt_long;
    if (name.contains('rent') || name.contains('house')) return Icons.home;
    if (name.contains('health') || name.contains('med')) return Icons.medical_services;
    if (name.contains('entertain')) return Icons.movie;
    
    return Icons.category;
  }
}
