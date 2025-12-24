abstract class ChatStrings {
  // Input
  String get inputPlaceholder;
  String get inputPlaceholderGeneral;
  String get inputPlaceholderEmailVerification;
  String get inputPlaceholderSubscriptionRequired;
  String get inputPlaceholderCurrencyRequired;
  String get sendMessage;
  String get attachFile;
  String get camera;
  String get gallery;
  String get files;
  String get drive;

  // Prompts
  ChatBotPrompts get prompts;

  // Suggestions
  String get suggestionBill;
  String get suggestionIncome;
  String get suggestionBudget;
  String get suggestionAnalyze;

  // Empty State
  String get emptyStateTitle;
  String get emptyStateSubtitle;

  // Feedback
  String get feedbackThanks;
  String get regenerating;
  String get thinking;

  // Actions
  String get changeActionType;
  String get recordedIncome;
  String get recordedExpense;
  String get change;
  String get copyMessage;
  String get regenerate;
  String get like;
  String get dislike;

  // Attachment
  String get attachmentTitle;
  String get selectImage;
  String get selectDocument;
  String get takePhoto;

  // Errors & Messages
  String imagePickFailed(String error);
  String photoFailed(String error);
  String get micPermissionDenied;
  String get cameraPermissionDenied;
  String get storagePermissionDenied;
  String get sentMedia;
  String get messageLimitReached;
  String nearMessageLimit(int remaining);
  String get limitReached;

  // GenUI Errors
  String errorRenderingChart(String error);
  String errorRenderingTable(String error);
  String errorRenderingSummary(String error);
  String errorRenderingActionList(String error);
  String errorRenderingMetric(String error);
  String errorRenderingProgress(String error);
  String errorRenderingActionButtons(String error);
  String errorRenderingStats(String error);
  String errorRenderingInsight(String error);
  String get errorMissingChartType;
  String actionTriggered(String action);
  String get comingSoon;

  // Bot Status
  String get botNotResponding;
  String get messageQueuedOffline;
  String get voiceRecordingFailed;
  String get imageUploadFailed;
  String get chatHistoryCleared;

  // Access Control
  String get emailVerificationRequired;
  String get emailVerificationMessage;
  String get verifyEmailButton;
  String get subscriptionRequired;
  String get subscriptionRequiredMessage;
  String get viewPlans;
  String get subscriptionExpired;
  String get subscriptionExpiredMessage;
  String get renewSubscription;
  String get messageLimitExceeded;
  String get messageLimitExceededMessage;
  String get upgradePlan;
  String get tooManyRequests;
  String get rateLimitMessage;
  String get backToChat;

  // Currency
  String get currencyRequired;
  String get currencyRequiredMessage;
  String get setCurrency;
}

abstract class ChatBotPrompts {
  // Balance Tracker
  String get trackExpenseLabel;
  String get trackExpensePrompt;
  String get checkBalanceLabel;
  String get checkBalancePrompt;
  String get monthlySummaryLabel;
  String get monthlySummaryPrompt;
  String get addIncomeLabel;
  String get addIncomePrompt;

  // Investment Guru
  String get investmentTipsLabel;
  String get investmentTipsPrompt;
  String get stockAdviceLabel;
  String get stockAdvicePrompt;
  String get portfolioReviewLabel;
  String get portfolioReviewPrompt;
  String get marketTrendsLabel;
  String get marketTrendsPrompt;

  // Budget Planner
  String get createBudgetLabel;
  String get createBudgetPrompt;
  String get budgetCategoriesLabel;
  String get budgetCategoriesPrompt;
  String get saveMoneyLabel;
  String get saveMoneyPrompt;
  String get budgetAlertsLabel;
  String get budgetAlertsPrompt;

  // FinTips
  String get moneyTipsLabel;
  String get moneyTipsPrompt;
  String get learnFinanceLabel;
  String get learnFinancePrompt;
  String get emergencyFundLabel;
  String get emergencyFundPrompt;
  String get creditAdviceLabel;
  String get creditAdvicePrompt;

  // Default / General
  String get getStartedLabel;
  String get getStartedPrompt;
  String get learnMoreLabel;
  String get learnMorePrompt;

  // UI Text
  String get howCanIHelp;
  String get choosePrompt;
}
