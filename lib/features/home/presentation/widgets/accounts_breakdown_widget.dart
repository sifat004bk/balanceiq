import 'package:flutter/material.dart';

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

    final sortedAccounts = accountsBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Accounts Breakdown',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 96,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemCount: sortedAccounts.length,
                    itemBuilder: (context, index) {
                      final entry = sortedAccounts[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == sortedAccounts.length - 1 ? 0 : 16,
                        ),
                        child: _buildAccountCard(
                          accountName: entry.key,
                          balance: entry.value,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountCard({
    required String accountName,
    required double balance,
  }) {
    final isNegative = balance < 0;

    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5B21B6)
            .withOpacity(0.4), // purple-500/10 dark:purple-900/40
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '\$${balance.abs().toStringAsFixed(2)}',
            style: TextStyle(
              color: isNegative ? Colors.red.shade300 : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            accountName,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
