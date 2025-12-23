import 'package:feature_chat/constants/chat_strings.dart';

class ChatStringsImpl implements ChatStrings {
  const ChatStringsImpl();

  @override
  String get inputPlaceholder => 'Ask about your finances...';
  @override
  String get inputPlaceholderGeneral => 'What do you want to write?';
  @override
  String get sendMessage => 'Send';

  @override
  ChatBotPrompts get prompts => const ChatBotPromptsImpl();

  @override
  String get attachFile => 'Attach File';
  @override
  String get camera => 'Camera';
  @override
  String get gallery => 'Gallery';
  @override
  String get files => 'Files';
  @override
  String get drive => 'Drive';

  @override
  String get suggestionBill => 'Add Electricity Bill';
  @override
  String get suggestionIncome => 'Log Salary';
  @override
  String get suggestionBudget => 'Set Monthly Budget';
  @override
  String get suggestionAnalyze => 'Analyze Spending';

  @override
  String get emptyStateTitle => 'Start a conversation';
  @override
  String get emptyStateSubtitle =>
      'I can help track expenses, set budgets, or analyze your spending.';

  @override
  String get feedbackThanks => 'Thanks for the feedback!';
  @override
  String get regenerating => 'Regenerating response';
  @override
  String get thinking => 'Thinking';

  @override
  String get changeActionType => 'Change Action Type';
  @override
  String get recordedIncome => 'Recorded Income';
  @override
  String get recordedExpense => 'Recorded Expense';
  @override
  String get change => 'Change';
  @override
  String get copyMessage => 'Copy';
  @override
  String get regenerate => 'Regenerate';
  @override
  String get like => 'Like';
  @override
  String get dislike => 'Dislike';

  @override
  String get attachmentTitle => 'Attach File';
  @override
  String get selectImage => 'Select Image';
  @override
  String get selectDocument => 'Select Document';
  @override
  String get takePhoto => 'Take Photo';

  @override
  String imagePickFailed(String error) => 'Failed to pick image: $error';
  @override
  String photoFailed(String error) => 'Failed to take photo: $error';
  @override
  String get micPermissionDenied =>
      'Microphone permission denied. Enable it in Settings to use voice input.';
  @override
  String get cameraPermissionDenied =>
      'Camera permission denied. Enable it in Settings to take photos.';
  @override
  String get storagePermissionDenied =>
      'Storage permission denied. Enable it in Settings to attach files.';
  @override
  String get sentMedia => 'Sent media';
  @override
  String get messageLimitReached =>
      'Daily message limit reached. Resets at midnight or upgrade your plan.';
  @override
  String nearMessageLimit(int remaining) =>
      'You have $remaining messages tokens today';
  @override
  String get limitReached => 'Limit Reached';

  @override
  String errorRenderingChart(String error) => 'Error rendering chart: $error';
  @override
  String errorRenderingTable(String error) => 'Error rendering table: $error';
  @override
  String errorRenderingSummary(String error) =>
      'Error rendering summary card: $error';
  @override
  String errorRenderingActionList(String error) =>
      'Error rendering action list: $error';
  @override
  String errorRenderingMetric(String error) =>
      'Error rendering metric card: $error';
  @override
  String errorRenderingProgress(String error) =>
      'Error rendering progress: $error';
  @override
  String errorRenderingActionButtons(String error) =>
      'Error rendering action buttons: $error';
  @override
  String errorRenderingStats(String error) => 'Error rendering stats: $error';
  @override
  String errorRenderingInsight(String error) =>
      'Error rendering insight card: $error';
  @override
  String get errorMissingChartType =>
      'Error rendering chart: Missing or invalid chart type';
  @override
  String actionTriggered(String action) => 'Action triggered: $action';
  @override
  String get comingSoon => 'Coming soon!';

  @override
  String get botNotResponding =>
      'AI assistant is not responding. Please try again in a moment.';
  @override
  String get messageQueuedOffline => 'Message queued. Will send when online.';
  @override
  String get voiceRecordingFailed =>
      'Voice recording failed. Check microphone permission.';
  @override
  String get imageUploadFailed =>
      'Image upload failed. Try a smaller file (max 10MB).';
  @override
  String get chatHistoryCleared => 'Chat history cleared';

  @override
  String get emailVerificationRequired => 'Email Verification Required';
  @override
  String get emailVerificationMessage =>
      'Please verify your email address to use the chat feature.';
  @override
  String get verifyEmailButton => 'Verify Email';
  @override
  String get subscriptionRequired => 'Subscription Required';
  @override
  String get subscriptionRequiredMessage =>
      'You need an active subscription plan to use the chat feature.';
  @override
  String get viewPlans => 'View Plans';
  @override
  String get subscriptionExpired => 'Subscription Expired';
  @override
  String get subscriptionExpiredMessage =>
      'Your subscription has expired. Please renew to continue using the chat feature.';
  @override
  String get renewSubscription => 'Renew Subscription';
  @override
  String get messageLimitExceeded => 'Message Limit Exceeded';
  @override
  String get messageLimitExceededMessage =>
      'You have reached your daily message limit. Resets at midnight.';
  @override
  String get upgradePlan => 'Upgrade Plan';
  @override
  String get tooManyRequests => 'Too Many Requests';
  @override
  String get rateLimitMessage =>
      'Please wait a moment before sending more messages.';
  @override
  String get backToChat => 'Back to Chat';

  @override
  String get currencyRequired => 'Currency Required';
  @override
  String get currencyRequiredMessage =>
      'Please set your preferred currency in your profile settings before using the chat feature.';
  @override
  String get setCurrency => 'Set Currency';
}

class ChatBotPromptsImpl implements ChatBotPrompts {
  const ChatBotPromptsImpl();

  @override
  String get trackExpenseLabel => 'Track expense';
  @override
  String get trackExpensePrompt => 'I spent 500 taka on groceries';
  @override
  String get checkBalanceLabel => 'Check balance';
  @override
  String get checkBalancePrompt => 'What is my current balance?';
  @override
  String get monthlySummaryLabel => 'Monthly summary';
  @override
  String get monthlySummaryPrompt =>
      'Show me my spending summary for this month';
  @override
  String get addIncomeLabel => 'Add income';
  @override
  String get addIncomePrompt => 'I received salary of 50,000 taka';

  @override
  String get investmentTipsLabel => 'Investment tips';
  @override
  String get investmentTipsPrompt =>
      'What are some good investment options for beginners?';
  @override
  String get stockAdviceLabel => 'Stock advice';
  @override
  String get stockAdvicePrompt => 'Should I invest in stocks or mutual funds?';
  @override
  String get portfolioReviewLabel => 'Portfolio review';
  @override
  String get portfolioReviewPrompt =>
      'How should I diversify my investment portfolio?';
  @override
  String get marketTrendsLabel => 'Market trends';
  @override
  String get marketTrendsPrompt => 'What are the current market trends?';

  @override
  String get createBudgetLabel => 'Create budget';
  @override
  String get createBudgetPrompt => 'Help me create a monthly budget plan';
  @override
  String get budgetCategoriesLabel => 'Budget categories';
  @override
  String get budgetCategoriesPrompt => 'Show me my spending by category';
  @override
  String get saveMoneyLabel => 'Save money';
  @override
  String get saveMoneyPrompt => 'How can I save 20% of my income?';
  @override
  String get budgetAlertsLabel => 'Budget alerts';
  @override
  String get budgetAlertsPrompt => 'Am I overspending in any category?';

  @override
  String get moneyTipsLabel => 'Money tips';
  @override
  String get moneyTipsPrompt => 'Give me some practical money management tips';
  @override
  String get learnFinanceLabel => 'Learn finance';
  @override
  String get learnFinancePrompt => 'Explain the concept of compound interest';
  @override
  String get emergencyFundLabel => 'Emergency fund';
  @override
  String get emergencyFundPrompt =>
      'How much should I keep in my emergency fund?';
  @override
  String get creditAdviceLabel => 'Credit advice';
  @override
  String get creditAdvicePrompt =>
      'What are the best practices for using credit cards?';

  @override
  String get getStartedLabel => 'Get started';
  @override
  String get getStartedPrompt => 'How can you help me with my finances?';
  @override
  String get learnMoreLabel => 'Learn more';
  @override
  String get learnMorePrompt => 'Tell me what you can do';

  @override
  String get howCanIHelp => 'How can I help you today?';
  @override
  String get choosePrompt => 'Choose a prompt or type your own question';
}
