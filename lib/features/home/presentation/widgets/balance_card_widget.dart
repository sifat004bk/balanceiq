import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double netBalance;
  final double totalIncome;
  final double totalExpense;
  final String period;
  final String userName;

  const BalanceCard({
    super.key,
    required this.netBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.period,
    this.userName = 'User',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with profile and notification
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile Picture
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2BEE4B).withOpacity(0.3),
                      const Color(0xFF2BEE4B).withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2BEE4B),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              // Hello Name
              Text(
                'Hello $userName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.27, // tracking-[0.015em]
                ),
              ),

              // Notification Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Net Balance Section
        Text(
          'Net Balance',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6), // gray-500
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${_formatCurrency(netBalance)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            height: 1.2,
            letterSpacing: -0.8, // tracking-tight
          ),
        ),
        const SizedBox(height: 32),

        // Income and Expense Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildIncomeExpenseCard(
                  icon: Icons.south,
                  label: 'Income',
                  amount: totalIncome,
                  backgroundColor: const Color(0xFF2BEE4B).withOpacity(0.2),
                  darkBackgroundColor:
                      const Color(0xFF2BEE4B).withOpacity(0.15).withGreen(150),
                  iconColor: const Color(0xFF2BEE4B),
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildIncomeExpenseCard(
                  icon: Icons.north,
                  label: 'Expense',
                  amount: totalExpense,
                  backgroundColor: Colors.red.withOpacity(0.2),
                  darkBackgroundColor:
                      Colors.red.withOpacity(0.15).withRed(150),
                  iconColor: Colors.red,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseCard({
    required IconData icon,
    required String label,
    required double amount,
    required Color backgroundColor,
    required Color darkBackgroundColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_formatCurrency(amount)}',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)}K';
    }
    return amount.toStringAsFixed(2);
  }
}
