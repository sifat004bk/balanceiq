import 'package:feature_subscription/constants/subscription_strings.dart';

class SubscriptionStringsImpl implements SubscriptionStrings {
  const SubscriptionStringsImpl();

  @override
  String get choosePlan => 'Choose Your Plan';
  @override
  String get choosePlanTitle => 'Choose Your Plan';
  @override
  String get choosePlanSubtitle => 'Select the plan that works best for you';
  @override
  String get currentPlan => 'Current Plan';
  @override
  String get upgradePlan => 'Upgrade Plan';
  @override
  String get subscribeToPlan => 'Subscribe';
  @override
  String get subscribeButton => 'Subscribe';
  @override
  String get yearlySavings => 'Save 20% with yearly billing';
  @override
  String get termsOfService => 'Terms of Service';
  @override
  String get privacyPolicy => 'Privacy Policy';
  @override
  String get monthly => 'Monthly';
  @override
  String get yearly => 'Yearly';
  @override
  String get perMonth => '/ month';
  @override
  String get mostPopular => 'Most Popular';

  @override
  String get freePlan => 'Free';
  @override
  String get basicPlan => 'Basic';
  @override
  String get proPlan => 'Pro';
  @override
  String get premiumPlan => 'Premium';

  @override
  String get unlimitedTransactions => 'Unlimited Transactions';
  @override
  String get aiInsights => 'AI-Powered Insights';
  @override
  String get budgetTracking => 'Budget Tracking';
  @override
  String get categoryAnalysis => 'Category Analysis';
  @override
  String get exportData => 'Export Data';
  @override
  String get prioritySupport => 'Priority Support';
  @override
  String get advancedReports => 'Advanced Reports';
  @override
  String get customCategories => 'Custom Categories';

  @override
  String get mySubscription => 'My Subscription';
  @override
  String get manageSubscriptionTitle => 'Manage Subscription';
  @override
  String get noActiveSubscription => 'No Active Subscription';
  @override
  String get subscribeMessage =>
      'Subscribe to a plan to unlock premium features';
  @override
  String get viewPlans => 'View Plans';
  @override
  String get subscriptionDetails => 'Subscription Details';
  @override
  String get activePlan => 'Active Plan';
  @override
  String get inactive => 'Inactive';
  @override
  String nextBillingDate(String date) => 'Next billing date: $date';
  @override
  String expiresIn(int days) => 'Expires in $days days';
  @override
  String get changePlan => 'Change Plan';
  @override
  String get startDate => 'Start Date';
  @override
  String get endDate => 'End Date';
  @override
  String get daysRemaining => 'Days Remaining';
  @override
  String get status => 'Status';
  @override
  String get autoRenewal => 'Auto-renewal';
  @override
  String get autoRenewalDescription => 'Automatically renew subscription';
  @override
  String get cancelConfirmation =>
      'Are you sure you want to cancel your subscription? You will lose access to premium features at the end of your current billing period.';
  @override
  String get cancelButton => 'Cancel Subscription';
  @override
  String get planDetails => 'Plan Details';
  @override
  String get renewsOn => 'Renews on';
  @override
  String get expiresOn => 'Expires on';
  @override
  String get daysLeft => 'days left';
  @override
  String get managePlan => 'Manage Plan';
  @override
  String get cancelSubscription => 'Cancel Subscription';
  @override
  String get renewSubscription => 'Renew Subscription';

  @override
  String get downgradePlanTitle => 'Downgrade Plan';
  @override
  String downgradePlanConfirm(String features) =>
      'Downgrading will disable: $features. Continue?';
  @override
  String get upgradePlanTitle => 'Upgrade Plan';
  @override
  String get upgradePlanMessage => 'Unlock more features with a higher plan';

  @override
  String get paymentFailed => 'Payment Failed';
  @override
  String get paymentFailedMessage =>
      'Payment could not be processed. Please update your payment method and try again.';
  @override
  String get updatePaymentMethod => 'Update Payment Method';
  @override
  String get subscriptionPaused => 'Subscription Paused';
  @override
  String get subscriptionPausedMessage =>
      'Your subscription is paused. Renew to access premium features.';

  @override
  String get trialEnding => 'Trial Ending Soon';
  @override
  String trialEndingMessage(int days) =>
      'Your trial ends in $days days. Subscribe to continue enjoying premium features.';

  @override
  String get active => 'Active';
  @override
  String get expired => 'Expired';
  @override
  String get cancelled => 'Cancelled';
  @override
  String get trial => 'Trial';

  @override
  String get noActivePlan => 'No Active Plan';
  @override
  String get subscriptionSuccess => 'Subscription successful!';
  @override
  String get subscriptionFailed => 'Subscription failed. Please try again.';
  @override
  String get cancellationSuccess => 'Subscription cancelled successfully';

  @override
  String get whyCancelling => 'Why are you cancelling?';
  @override
  String get cancelReasonTooExpensive => 'Too expensive';
  @override
  String get cancelReasonNotUsing => 'Not using enough';
  @override
  String get cancelReasonMissingFeatures => 'Missing features I need';
  @override
  String get cancelReasonFoundAlternative => 'Found a better alternative';
  @override
  String get cancelReasonTechnicalIssues => 'Technical issues';
  @override
  String get cancelReasonOther => 'Other';
  @override
  String get pleaseSpecifyReason => 'Please specify your reason';
  @override
  String get reasonRequired => 'Reason is required';
  @override
  String get submitCancellation => 'Submit Cancellation';
}
