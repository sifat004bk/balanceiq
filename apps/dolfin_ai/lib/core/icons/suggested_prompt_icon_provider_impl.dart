import 'package:flutter/widgets.dart';
import 'package:feature_chat/presentation/widgets/suggested_prompt_icon_provider.dart';
import 'app_icons.dart';

/// Adapter that bridges AppIcons.suggestedPrompts to the SuggestedPromptIconProvider interface
/// required by the feature_chat package.
class SuggestedPromptIconProviderImpl implements SuggestedPromptIconProvider {
  final SuggestedPromptIcons _icons;

  const SuggestedPromptIconProviderImpl(this._icons);

  // Balance Tracker prompts
  @override
  Widget trackExpense({double size = 24, Color? color}) =>
      _icons.trackExpense(size: size, color: color);

  @override
  Widget checkBalance({double size = 24, Color? color}) =>
      _icons.checkBalance(size: size, color: color);

  @override
  Widget monthlySummary({double size = 24, Color? color}) =>
      _icons.monthlySummary(size: size, color: color);

  @override
  Widget addIncome({double size = 24, Color? color}) =>
      _icons.addIncome(size: size, color: color);

  // Investment Guru prompts
  @override
  Widget investmentTips({double size = 24, Color? color}) =>
      _icons.investmentTips(size: size, color: color);

  @override
  Widget stockAdvice({double size = 24, Color? color}) =>
      _icons.stockAdvice(size: size, color: color);

  @override
  Widget portfolioReview({double size = 24, Color? color}) =>
      _icons.portfolioReview(size: size, color: color);

  @override
  Widget marketTrends({double size = 24, Color? color}) =>
      _icons.marketTrends(size: size, color: color);

  // Budget Planner prompts
  @override
  Widget createBudget({double size = 24, Color? color}) =>
      _icons.createBudget(size: size, color: color);

  @override
  Widget budgetCategories({double size = 24, Color? color}) =>
      _icons.budgetCategories(size: size, color: color);

  @override
  Widget saveMoney({double size = 24, Color? color}) =>
      _icons.saveMoney(size: size, color: color);

  @override
  Widget budgetAlerts({double size = 24, Color? color}) =>
      _icons.budgetAlerts(size: size, color: color);

  // Fin Tips prompts
  @override
  Widget moneyTips({double size = 24, Color? color}) =>
      _icons.moneyTips(size: size, color: color);

  @override
  Widget learnFinance({double size = 24, Color? color}) =>
      _icons.learnFinance(size: size, color: color);

  @override
  Widget emergencyFund({double size = 24, Color? color}) =>
      _icons.emergencyFund(size: size, color: color);

  @override
  Widget creditAdvice({double size = 24, Color? color}) =>
      _icons.creditAdvice(size: size, color: color);

  // Default prompts
  @override
  Widget getStarted({double size = 24, Color? color}) =>
      _icons.getStarted(size: size, color: color);

  @override
  Widget learnMore({double size = 24, Color? color}) =>
      _icons.learnMore(size: size, color: color);
}
