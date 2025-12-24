import 'package:flutter/widgets.dart';

/// Abstract interface for suggested prompt icons.
/// This allows the feature package to define icons without depending on lucide_icons.
abstract class SuggestedPromptIconProvider {
  // Balance Tracker prompts
  Widget trackExpense({double size, Color? color});
  Widget checkBalance({double size, Color? color});
  Widget monthlySummary({double size, Color? color});
  Widget addIncome({double size, Color? color});

  // Investment Guru prompts
  Widget investmentTips({double size, Color? color});
  Widget stockAdvice({double size, Color? color});
  Widget portfolioReview({double size, Color? color});
  Widget marketTrends({double size, Color? color});

  // Budget Planner prompts
  Widget createBudget({double size, Color? color});
  Widget budgetCategories({double size, Color? color});
  Widget saveMoney({double size, Color? color});
  Widget budgetAlerts({double size, Color? color});

  // Fin Tips prompts
  Widget moneyTips({double size, Color? color});
  Widget learnFinance({double size, Color? color});
  Widget emergencyFund({double size, Color? color});
  Widget creditAdvice({double size, Color? color});

  // Default prompts
  Widget getStarted({double size, Color? color});
  Widget learnMore({double size, Color? color});
}
