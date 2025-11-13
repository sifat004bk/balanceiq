import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Minimalist Neumorphism Style - Clean and Modern
class AccountsBreakdownWidget extends StatelessWidget {
  final Map<String, double> accountsBreakdown;

  const AccountsBreakdownWidget({
    super.key,
    required this.accountsBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    if (accountsBreakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    final sortedAccounts = accountsBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Calculate total
    final total = sortedAccounts.fold<double>(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Accounts',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total: BDT $total',
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${sortedAccounts.length}',
                  style: textTheme.titleMedium?.copyWith(
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
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sortedAccounts.length,
            itemBuilder: (context, index) {
              final entry = sortedAccounts[index];
              final percentage = (entry.value.abs() / total * 100);

              return Padding(
                padding: EdgeInsets.only(
                  right: index == sortedAccounts.length - 1 ? 0 : 12,
                ),
                child: _buildMinimalCard(
                  context,
                  accountName: entry.key,
                  balance: entry.value,
                  percentage: percentage,
                  index: index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalCard(
    BuildContext context, {
    required String accountName,
    required double balance,
    required double percentage,
    required int index,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isNegative = balance < 0;

    final accentColor = _getAccentColor(accountName, index);
    final accountIcon = _getAccountIcon(accountName);

    return Container(
      width: 180,
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
          // Neumorphism effect
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: isDark
                ? colorScheme.surface.withOpacity(0.05)
                : colorScheme.surface.withOpacity(0.7),
            offset: const Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top section: Icon and percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    accountIcon,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: accentColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: textTheme.bodySmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            // Bottom section: Account info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountName,
                  style: textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppTheme.textSubtleDark
                        : AppTheme.textSubtleLight,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (isNegative)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          size: 14,
                          color: colorScheme.error,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        'BDT ${(balance)}',
                        style: textTheme.titleLarge?.copyWith(
                          color: isNegative
                              ? colorScheme.error
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAccentColor(String accountName, int index) {
    final lowerName = accountName.toLowerCase();

    if (lowerName.contains('cash') || lowerName.contains('wallet')) {
      return const Color(0xFF10B981); // Green
    } else if (lowerName.contains('bank') || lowerName.contains('saving')) {
      return const Color(0xFF3B82F6); // Blue
    } else if (lowerName.contains('credit') || lowerName.contains('card')) {
      return const Color(0xFF8B5CF6); // Purple
    } else if (lowerName.contains('invest') || lowerName.contains('stock')) {
      return const Color(0xFFF97316); // Orange
    }

    // Fallback colors
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFFEC4899), // Pink
      const Color(0xFF14B8A6), // Teal
      const Color(0xFFF59E0B), // Amber
    ];

    return colors[index % colors.length];
  }

  IconData _getAccountIcon(String accountName) {
    final lowerName = accountName.toLowerCase();

    if (lowerName.contains('cash') || lowerName.contains('wallet')) {
      return Icons.account_balance_wallet_rounded;
    } else if (lowerName.contains('bank') || lowerName.contains('saving')) {
      return Icons.account_balance_rounded;
    } else if (lowerName.contains('credit') || lowerName.contains('card')) {
      return Icons.credit_card_rounded;
    } else if (lowerName.contains('invest') || lowerName.contains('stock')) {
      return Icons.trending_up_rounded;
    } else if (lowerName.contains('paypal') || lowerName.contains('venmo')) {
      return Icons.payment_rounded;
    }

    return Icons.wallet_rounded;
  }
}
