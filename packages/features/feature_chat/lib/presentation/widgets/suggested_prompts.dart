import 'package:dolfin_core/constants/app_constants.dart';
import 'package:dolfin_core/constants/app_strings.dart';
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
            label: AppStrings.chatPrompts.trackExpenseLabel,
            prompt: AppStrings.chatPrompts.trackExpensePrompt,
          ),
          PromptChip(
            icon: Icons.account_balance_wallet,
            label: AppStrings.chatPrompts.checkBalanceLabel,
            prompt: AppStrings.chatPrompts.checkBalancePrompt,
          ),
          PromptChip(
            icon: Icons.trending_up,
            label: AppStrings.chatPrompts.monthlySummaryLabel,
            prompt: AppStrings.chatPrompts.monthlySummaryPrompt,
          ),
          PromptChip(
            icon: Icons.savings,
            label: AppStrings.chatPrompts.addIncomeLabel,
            prompt: AppStrings.chatPrompts.addIncomePrompt,
          ),
        ];
      case AppConstants.investmentGuruID:
        return [
          PromptChip(
            icon: Icons.show_chart,
            label: AppStrings.chatPrompts.investmentTipsLabel,
            prompt: AppStrings.chatPrompts.investmentTipsPrompt,
          ),
          PromptChip(
            icon: Icons.account_balance,
            label: AppStrings.chatPrompts.stockAdviceLabel,
            prompt: AppStrings.chatPrompts.stockAdvicePrompt,
          ),
          PromptChip(
            icon: Icons.pie_chart,
            label: AppStrings.chatPrompts.portfolioReviewLabel,
            prompt: AppStrings.chatPrompts.portfolioReviewPrompt,
          ),
          PromptChip(
            icon: Icons.trending_up,
            label: AppStrings.chatPrompts.marketTrendsLabel,
            prompt: AppStrings.chatPrompts.marketTrendsPrompt,
          ),
        ];
      case AppConstants.budgetPlannerID:
        return [
          PromptChip(
            icon: Icons.calendar_today,
            label: AppStrings.chatPrompts.createBudgetLabel,
            prompt: AppStrings.chatPrompts.createBudgetPrompt,
          ),
          PromptChip(
            icon: Icons.category,
            label: AppStrings.chatPrompts.budgetCategoriesLabel,
            prompt: AppStrings.chatPrompts.budgetCategoriesPrompt,
          ),
          PromptChip(
            icon: Icons.savings,
            label: AppStrings.chatPrompts.saveMoneyLabel,
            prompt: AppStrings.chatPrompts.saveMoneyPrompt,
          ),
          PromptChip(
            icon: Icons.warning,
            label: AppStrings.chatPrompts.budgetAlertsLabel,
            prompt: AppStrings.chatPrompts.budgetAlertsPrompt,
          ),
        ];
      case AppConstants.finTipsID:
        return [
          PromptChip(
            icon: Icons.lightbulb,
            label: AppStrings.chatPrompts.moneyTipsLabel,
            prompt: AppStrings.chatPrompts.moneyTipsPrompt,
          ),
          PromptChip(
            icon: Icons.school,
            label: AppStrings.chatPrompts.learnFinanceLabel,
            prompt: AppStrings.chatPrompts.learnFinancePrompt,
          ),
          PromptChip(
            icon: Icons.security,
            label: AppStrings.chatPrompts.emergencyFundLabel,
            prompt: AppStrings.chatPrompts.emergencyFundPrompt,
          ),
          PromptChip(
            icon: Icons.credit_card,
            label: AppStrings.chatPrompts.creditAdviceLabel,
            prompt: AppStrings.chatPrompts.creditAdvicePrompt,
          ),
        ];
      default:
        return [
          PromptChip(
            icon: Icons.help,
            label: AppStrings.chatPrompts.getStartedLabel,
            prompt: AppStrings.chatPrompts.getStartedPrompt,
          ),
          PromptChip(
            icon: Icons.info,
            label: AppStrings.chatPrompts.learnMoreLabel,
            prompt: AppStrings.chatPrompts.learnMorePrompt,
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
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 56,
                    color: Theme.of(context).colorScheme.onPrimary,
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
                  AppStrings.chatPrompts.howCanIHelp,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.chatPrompts.choosePrompt,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
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
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
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
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  chip.icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                chip.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
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
