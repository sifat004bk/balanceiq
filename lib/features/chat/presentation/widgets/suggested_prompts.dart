import 'package:balance_iq/core/constants/app_constants.dart';
import 'package:balance_iq/core/constants/gemini_colors.dart';
import 'package:flutter/material.dart';

/// Gemini-style suggested prompts shown in empty chat state
class SuggestedPrompts extends StatelessWidget {
  final String botId;
  final Function(String) onPromptSelected;

  const SuggestedPrompts({
    super.key,
    required this.botId,
    required this.onPromptSelected,
  });

  List<PromptChip> _getPromptsForBot(String botId) {
    switch (botId) {
      case AppConstants.balanceTrackerID:
        return [
          PromptChip(
            icon: Icons.receipt_long,
            label: 'Track expense',
            prompt: 'I spent 500 taka on groceries',
          ),
          PromptChip(
            icon: Icons.account_balance_wallet,
            label: 'Check balance',
            prompt: 'What is my current balance?',
          ),
          PromptChip(
            icon: Icons.trending_up,
            label: 'Monthly summary',
            prompt: 'Show me my spending summary for this month',
          ),
          PromptChip(
            icon: Icons.savings,
            label: 'Add income',
            prompt: 'I received salary of 50,000 taka',
          ),
        ];
      case AppConstants.investmentGuruID:
        return [
          PromptChip(
            icon: Icons.show_chart,
            label: 'Investment tips',
            prompt: 'What are some good investment options for beginners?',
          ),
          PromptChip(
            icon: Icons.account_balance,
            label: 'Stock advice',
            prompt: 'Should I invest in stocks or mutual funds?',
          ),
          PromptChip(
            icon: Icons.pie_chart,
            label: 'Portfolio review',
            prompt: 'How should I diversify my investment portfolio?',
          ),
          PromptChip(
            icon: Icons.trending_up,
            label: 'Market trends',
            prompt: 'What are the current market trends?',
          ),
        ];
      case AppConstants.budgetPlannerID:
        return [
          PromptChip(
            icon: Icons.calendar_today,
            label: 'Create budget',
            prompt: 'Help me create a monthly budget plan',
          ),
          PromptChip(
            icon: Icons.category,
            label: 'Budget categories',
            prompt: 'Show me my spending by category',
          ),
          PromptChip(
            icon: Icons.savings,
            label: 'Save money',
            prompt: 'How can I save 20% of my income?',
          ),
          PromptChip(
            icon: Icons.warning,
            label: 'Budget alerts',
            prompt: 'Am I overspending in any category?',
          ),
        ];
      case AppConstants.finTipsID:
        return [
          PromptChip(
            icon: Icons.lightbulb,
            label: 'Money tips',
            prompt: 'Give me some practical money management tips',
          ),
          PromptChip(
            icon: Icons.school,
            label: 'Learn finance',
            prompt: 'Explain the concept of compound interest',
          ),
          PromptChip(
            icon: Icons.security,
            label: 'Emergency fund',
            prompt: 'How much should I keep in my emergency fund?',
          ),
          PromptChip(
            icon: Icons.credit_card,
            label: 'Credit advice',
            prompt: 'What are the best practices for using credit cards?',
          ),
        ];
      default:
        return [
          PromptChip(
            icon: Icons.help,
            label: 'Get started',
            prompt: 'How can you help me with my finances?',
          ),
          PromptChip(
            icon: Icons.info,
            label: 'Learn more',
            prompt: 'Tell me what you can do',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final prompts = _getPromptsForBot(botId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Welcome icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: GeminiColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 48,
              color: GeminiColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          // Welcome text
          Text(
            'How can I help you today?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: GeminiColors.aiMessageText(context),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Suggested prompts as chips
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: prompts
                .map((prompt) => _buildPromptChip(context, prompt))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(BuildContext context, PromptChip chip) {
    return InkWell(
      onTap: () => onPromptSelected(chip.prompt),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: GeminiColors.chipBackground(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: GeminiColors.chipBorder(context),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              chip.icon,
              size: 18,
              color: GeminiColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              chip.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: GeminiColors.aiMessageText(context),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromptChip {
  final IconData icon;
  final String label;
  final String prompt;

  PromptChip({
    required this.icon,
    required this.label,
    required this.prompt,
  });
}
