import 'dart:ui';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppTheme.primaryGradientDark
                      : AppTheme.primaryGradientLight,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  '${sortedCategories.length}',
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
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
      width: 160,
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [
                  AppTheme.surfaceDark.withOpacity(0.6),
                  AppTheme.surfaceDark.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  AppTheme.surfaceLight,
                  AppTheme.surfaceVariantLight.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : accentColor.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: isDark ? 10 : 0, sigmaY: isDark ? 10 : 0),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor,
                            accentColor.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: textTheme.labelSmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
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
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'BDT ${amount.abs().toStringAsFixed(0)}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category, int index) {
    final name = category.toLowerCase();
    if (name.contains('food') || name.contains('dining')) return const Color(0xFFFF9800);
    if (name.contains('transport')) return const Color(0xFF2196F3);
    if (name.contains('shop')) return const Color(0xFFE91E63);
    if (name.contains('bill') || name.contains('util')) return const Color(0xFF00BCD4);
    if (name.contains('rent') || name.contains('house')) return const Color(0xFF3F51B5);
    if (name.contains('health') || name.contains('med')) return const Color(0xFFF44336);
    if (name.contains('entertain')) return const Color(0xFF9C27B0);
    
    // Fallback palette with vibrant colors
    final colors = [
      const Color(0xFF009688), // Teal
      const Color(0xFFCDDC39), // Lime
      const Color(0xFFFFC107), // Amber
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF03A9F4), // Light Blue
    ];
    return colors[index % colors.length];
  }

  IconData _getCategoryIcon(String category) {
    final name = category.toLowerCase();
    if (name.contains('food') || name.contains('dining')) return Icons.restaurant_rounded;
    if (name.contains('transport')) return Icons.directions_car_rounded;
    if (name.contains('shop')) return Icons.shopping_bag_rounded;
    if (name.contains('bill') || name.contains('util')) return Icons.receipt_long_rounded;
    if (name.contains('rent') || name.contains('house')) return Icons.home_rounded;
    if (name.contains('health') || name.contains('med')) return Icons.medical_services_rounded;
    if (name.contains('entertain')) return Icons.movie_rounded;
    
    return Icons.category_rounded;
  }
}
