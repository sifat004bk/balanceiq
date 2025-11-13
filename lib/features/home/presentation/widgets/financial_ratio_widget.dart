import 'package:flutter/material.dart';

class FinancialRatiosWidget extends StatelessWidget {
  final double expenseRatio;
  final double savingsRate;

  const FinancialRatiosWidget({
    super.key,
    required this.expenseRatio,
    required this.savingsRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildRatioCard(
            title: 'Expense Ratio',
            value: expenseRatio,
            backgroundColor:
                Colors.red.withOpacity(0.15).withRed(150), // red-900/40
            textColor: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildRatioCard(
            title: 'Savings Rate',
            value: savingsRate,
            backgroundColor: const Color(0xFF2BEE4B)
                .withOpacity(0.15)
                .withGreen(150), // green-900/60
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildRatioCard({
    required String title,
    required double value,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7), // gray-500/300
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${value.toStringAsFixed(1)}%',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
