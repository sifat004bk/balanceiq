abstract class SubscriptionStrings {
  // Plans Page
  String get choosePlan;
  String get choosePlanTitle;
  String get choosePlanSubtitle;
  String get currentPlan;
  String get upgradePlan;
  String get subscribeToPlan;
  String get subscribeButton;
  String get yearlySavings;
  String get termsOfService;
  String get privacyPolicy;
  String get monthly;
  String get yearly;
  String get perMonth;
  String get mostPopular;

  // Plan Names
  String get freePlan;
  String get basicPlan;
  String get proPlan;
  String get premiumPlan;

  // Features
  String get unlimitedTransactions;
  String get aiInsights;
  String get budgetTracking;
  String get categoryAnalysis;
  String get exportData;
  String get prioritySupport;
  String get advancedReports;
  String get customCategories;

  // Manage Subscription
  String get mySubscription;
  String get manageSubscriptionTitle;
  String get noActiveSubscription;
  String get subscribeMessage;
  String get viewPlans;
  String get subscriptionDetails;
  String get activePlan;
  String get inactive;
  String nextBillingDate(String date);
  String expiresIn(int days);
  String get changePlan;
  String get startDate;
  String get endDate;
  String get daysRemaining;
  String get status;
  String get autoRenewal;
  String get autoRenewalDescription;
  String get cancelConfirmation;
  String get cancelButton;
  String get planDetails;
  String get renewsOn;
  String get expiresOn;
  String get daysLeft;
  String get managePlan;
  String get cancelSubscription;
  String get renewSubscription;

  // Plan Changes
  String get downgradePlanTitle;
  String downgradePlanConfirm(String features);
  String get upgradePlanTitle;
  String get upgradePlanMessage;

  // Payment
  String get paymentFailed;
  String get paymentFailedMessage;
  String get updatePaymentMethod;
  String get subscriptionPaused;
  String get subscriptionPausedMessage;

  // Trial
  String get trialEnding;
  String trialEndingMessage(int days);

  // Status
  String get active;
  String get expired;
  String get cancelled;
  String get trial;

  // Messages
  String get noActivePlan;
  String get subscriptionSuccess;
  String get subscriptionFailed;
  String get cancellationSuccess;

  // Cancellation Reasons
  String get whyCancelling;
  String get cancelReasonTooExpensive;
  String get cancelReasonNotUsing;
  String get cancelReasonMissingFeatures;
  String get cancelReasonFoundAlternative;
  String get cancelReasonTechnicalIssues;
  String get cancelReasonOther;
  String get pleaseSpecifyReason;
  String get reasonRequired;
  String get submitCancellation;
}
