import 'package:equatable/equatable.dart';
import 'plan.dart';

/// Subscription entity
class Subscription extends Equatable {
  final int userId;
  final Plan plan;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int daysRemaining;

  const Subscription({
    required this.userId,
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.daysRemaining,
  });

  @override
  List<Object?> get props => [
        userId,
        plan,
        startDate,
        endDate,
        isActive,
        daysRemaining,
      ];

  /// Check if subscription is expired
  bool get isExpired => daysRemaining <= 0;

  /// Check if subscription is expiring soon (within 7 days)
  bool get isExpiringSoon => daysRemaining > 0 && daysRemaining <= 7;

  /// Format end date for display
  String get formattedEndDate {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[endDate.month - 1]} ${endDate.day}, ${endDate.year}';
  }
}
