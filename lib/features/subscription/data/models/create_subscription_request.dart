/// Request model for creating a subscription
/// Endpoint: POST /api/subscriptions/
class CreateSubscriptionRequest {
  final String planName;
  final bool autoRenew;

  CreateSubscriptionRequest({
    required this.planName,
    required this.autoRenew,
  });

  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'autoRenew': autoRenew,
    };
  }
}
