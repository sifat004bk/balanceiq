import 'package:balance_iq/core/constants/app_constants.dart';
import 'package:balance_iq/core/theme/app_palette.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated welcome icon (2025 redesign)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppPalette.trustBlue,
                        AppPalette.trustBlue.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.trustBlue.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          // Welcome text with fade-in
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child: Column(
              children: [
                Text(
                  'How can I help you today?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppPalette.neutralWhite
                            : AppPalette.neutralBlack,
                        letterSpacing: -0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose a prompt or type your own question',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppPalette.neutralGrey,
                        fontSize: 14,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Suggested prompts with staggered animation
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(
              prompts.length,
              (index) => TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 400 + (index * 100)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: _buildPromptChip(context, prompts[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(BuildContext context, PromptChip chip) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onPromptSelected(chip.prompt),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppPalette.trustBlue.withOpacity(0.15),
                AppPalette.trustBlue.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppPalette.trustBlue.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.trustBlue.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppPalette.trustBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  chip.icon,
                  size: 16,
                  color: AppPalette.trustBlue,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                chip.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppPalette.neutralWhite
                          : AppPalette.neutralBlack,
                      letterSpacing: 0.2,
                    ),
              ),
            ],
          ),
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
