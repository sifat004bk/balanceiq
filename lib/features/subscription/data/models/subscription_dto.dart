import 'plan_dto.dart';

/// Subscription DTO for API response
/// Maps to: SubscriptionDto from backend
class SubscriptionDto {
  final int userId;
  final PlanDto plan;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int daysRemaining;

  SubscriptionDto({
    required this.userId,
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.daysRemaining,
  });

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) {
    return SubscriptionDto(
      userId: json['userId'] as int,
      plan: PlanDto.fromJson(json['plan'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? false,
      daysRemaining: json['daysRemaining'] as int? ?? 0,
    );
  }
}

/// Subscription status DTO for API response
/// Maps to: GET /api/subscriptions/status
class SubscriptionStatusDto {
  final bool hasActiveSubscription;
  final SubscriptionDto? subscription;

  SubscriptionStatusDto({
    required this.hasActiveSubscription,
    this.subscription,
  });

  factory SubscriptionStatusDto.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatusDto(
      hasActiveSubscription: json['hasActiveSubscription'] as bool? ?? false,
      subscription: json['subscription'] != null
          ? SubscriptionDto.fromJson(json['subscription'] as Map<String, dynamic>)
          : null,
    );
  }
}
