import 'package:dolfin_core/constants/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:feature_chat/constants/chat_strings.dart';
import 'package:flutter/material.dart';
import 'suggested_prompt_icon_provider.dart';
import 'package:dolfin_ui_kit/dolfin_ui_kit.dart';

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
    final constants = GetIt.instance<AppConstants>();
    final icons = GetIt.I<SuggestedPromptIconProvider>();

    if (botId == constants.balanceTrackerID) {
      return [
        PromptChip(
          iconBuilder: (size, color) =>
              icons.trackExpense(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.trackExpenseLabel,
          prompt: GetIt.I<ChatStrings>().prompts.trackExpensePrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.checkBalance(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.checkBalanceLabel,
          prompt: GetIt.I<ChatStrings>().prompts.checkBalancePrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.monthlySummary(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.monthlySummaryLabel,
          prompt: GetIt.I<ChatStrings>().prompts.monthlySummaryPrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.addIncome(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.addIncomeLabel,
          prompt: GetIt.I<ChatStrings>().prompts.addIncomePrompt,
        ),
      ];
    } else if (botId == constants.investmentGuruID) {
      return [
        PromptChip(
          iconBuilder: (size, color) =>
              icons.investmentTips(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.investmentTipsLabel,
          prompt: GetIt.I<ChatStrings>().prompts.investmentTipsPrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.stockAdvice(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.stockAdviceLabel,
          prompt: GetIt.I<ChatStrings>().prompts.stockAdvicePrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.portfolioReview(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.portfolioReviewLabel,
          prompt: GetIt.I<ChatStrings>().prompts.portfolioReviewPrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.marketTrends(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.marketTrendsLabel,
          prompt: GetIt.I<ChatStrings>().prompts.marketTrendsPrompt,
        ),
      ];
    } else if (botId == constants.budgetPlannerID) {
      return [
        PromptChip(
          iconBuilder: (size, color) =>
              icons.createBudget(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.createBudgetLabel,
          prompt: GetIt.I<ChatStrings>().prompts.createBudgetPrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.budgetCategories(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.budgetCategoriesLabel,
          prompt: GetIt.I<ChatStrings>().prompts.budgetCategoriesPrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.saveMoney(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.saveMoneyLabel,
          prompt: GetIt.I<ChatStrings>().prompts.saveMoneyPrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.budgetAlerts(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.budgetAlertsLabel,
          prompt: GetIt.I<ChatStrings>().prompts.budgetAlertsPrompt,
        ),
      ];
    } else if (botId == constants.finTipsID) {
      return [
        PromptChip(
          iconBuilder: (size, color) =>
              icons.moneyTips(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.moneyTipsLabel,
          prompt: GetIt.I<ChatStrings>().prompts.moneyTipsPrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.learnFinance(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.learnFinanceLabel,
          prompt: GetIt.I<ChatStrings>().prompts.learnFinancePrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.emergencyFund(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.emergencyFundLabel,
          prompt: GetIt.I<ChatStrings>().prompts.emergencyFundPrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.creditAdvice(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.creditAdviceLabel,
          prompt: GetIt.I<ChatStrings>().prompts.creditAdvicePrompt,
        ),
      ];
    } else {
      return [
        PromptChip(
          iconBuilder: (size, color) =>
              icons.getStarted(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.getStartedLabel,
          prompt: GetIt.I<ChatStrings>().prompts.getStartedPrompt,
        ),
        PromptChip(
          iconBuilder: (size, color) =>
              icons.learnMore(size: size, color: color),
          label: GetIt.I<ChatStrings>().prompts.learnMoreLabel,
          prompt: GetIt.I<ChatStrings>().prompts.learnMorePrompt,
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
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: AppLogo(
                      size: 48,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
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
                  GetIt.I<ChatStrings>().prompts.howCanIHelp,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  GetIt.I<ChatStrings>().prompts.choosePrompt,
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
                child:
                    chip.iconBuilder(16, Theme.of(context).colorScheme.primary),
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
  final Widget Function(double size, Color? color) iconBuilder;
  final String label;
  final String prompt;

  PromptChip({
    required this.iconBuilder,
    required this.label,
    required this.prompt,
  });
}
