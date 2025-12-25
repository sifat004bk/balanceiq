import 'package:feature_subscription/data/models/subscription_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriptionDto', () {
    final testPlanJson = {
      'id': 2,
      'name': 'PREMIUM',
      'displayName': 'Premium Plan',
      'description': 'All features unlocked',
      'price': 9.99,
      'billingCycle': 'MONTHLY',
      'tier': 2,
      'maxProjects': 10,
      'maxStorageGb': 100,
      'maxApiCallsPerMonth': 10000,
      'maxTeamMembers': 5,
      'features': [],
      'isActive': true,
    };

    test('fromJson should parse valid subscription', () {
      // Arrange
      final json = {
        'userId': 123,
        'plan': testPlanJson,
        'startDate': '2024-01-01T00:00:00.000Z',
        'endDate': '2024-02-01T00:00:00.000Z',
        'isActive': true,
        'daysRemaining': 15,
      };

      // Act
      final result = SubscriptionDto.fromJson(json);

      // Assert
      expect(result.userId, 123);
      expect(result.plan!.name, 'PREMIUM');
      expect(result.plan!.price, 9.99);
      expect(result.startDate, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(result.endDate, DateTime.parse('2024-02-01T00:00:00.000Z'));
      expect(result.isActive, true);
      expect(result.daysRemaining, 15);
    });

    test('fromJson should handle inactive subscription', () {
      // Arrange
      final json = {
        'userId': 123,
        'plan': testPlanJson,
        'startDate': '2023-12-01T00:00:00.000Z',
        'endDate': '2024-01-01T00:00:00.000Z',
        'isActive': false,
        'daysRemaining': 0,
      };

      // Act
      final result = SubscriptionDto.fromJson(json);

      // Assert
      expect(result.isActive, false);
      expect(result.daysRemaining, 0);
    });

    test('fromJson should handle missing optional fields with defaults', () {
      // Arrange
      final json = {
        'userId': 456,
        'plan': testPlanJson,
        'startDate': '2024-01-01T00:00:00.000Z',
        'endDate': '2024-02-01T00:00:00.000Z',
      };

      // Act
      final result = SubscriptionDto.fromJson(json);

      // Assert
      expect(result.userId, 456);
      expect(result.isActive, false);
      expect(result.daysRemaining, 0);
    });
  });

  group('SubscriptionStatusDto', () {
    final testPlanJson = {
      'id': 2,
      'name': 'PREMIUM',
      'displayName': 'Premium Plan',
      'description': 'All features unlocked',
      'price': 9.99,
      'billingCycle': 'MONTHLY',
      'tier': 2,
      'maxProjects': 10,
      'maxStorageGb': 100,
      'maxApiCallsPerMonth': 10000,
      'maxTeamMembers': 5,
      'features': [],
      'isActive': true,
    };

    test('fromJson should parse status with active subscription', () {
      // Arrange
      final json = {
        'hasActiveSubscription': true,
        'subscription': {
          'userId': 123,
          'plan': testPlanJson,
          'startDate': '2024-01-01T00:00:00.000Z',
          'endDate': '2024-02-01T00:00:00.000Z',
          'isActive': true,
          'daysRemaining': 15,
        },
      };

      // Act
      final result = SubscriptionStatusDto.fromJson(json);

      // Assert
      expect(result.hasActiveSubscription, true);
      expect(result.subscription, isNotNull);
      expect(result.subscription!.userId, 123);
      expect(result.subscription!.plan!.name, 'PREMIUM');
      expect(result.subscription!.daysRemaining, 15);
    });

    test('fromJson should parse status without subscription', () {
      // Arrange
      final json = {
        'hasActiveSubscription': false,
        'subscription': null,
      };

      // Act
      final result = SubscriptionStatusDto.fromJson(json);

      // Assert
      expect(result.hasActiveSubscription, false);
      expect(result.subscription, isNull);
    });

    test('fromJson should handle missing hasActiveSubscription', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = SubscriptionStatusDto.fromJson(json);

      // Assert
      expect(result.hasActiveSubscription, false);
      expect(result.subscription, isNull);
    });

    test('fromJson should parse yearly subscription correctly', () {
      // Arrange
      final yearlyPlanJson = {
        'id': 3,
        'name': 'PREMIUM_YEARLY',
        'displayName': 'Premium Yearly',
        'description': 'Premium plan billed yearly',
        'price': 99.99,
        'billingCycle': 'YEARLY',
        'tier': 2,
        'maxProjects': 10,
        'maxStorageGb': 100,
        'maxApiCallsPerMonth': 10000,
        'maxTeamMembers': 5,
        'features': [],
        'isActive': true,
      };

      final json = {
        'hasActiveSubscription': true,
        'subscription': {
          'userId': 456,
          'plan': yearlyPlanJson,
          'startDate': '2024-01-01T00:00:00.000Z',
          'endDate': '2025-01-01T00:00:00.000Z',
          'isActive': true,
          'daysRemaining': 365,
        },
      };

      // Act
      final result = SubscriptionStatusDto.fromJson(json);

      // Assert
      expect(result.hasActiveSubscription, true);
      expect(result.subscription!.plan!.billingCycle, 'YEARLY');
      expect(result.subscription!.plan!.price, 99.99);
      expect(result.subscription!.daysRemaining, 365);
    });

    test('fromJson should handle expiring subscription', () {
      // Arrange
      final json = {
        'hasActiveSubscription': true,
        'subscription': {
          'userId': 789,
          'plan': testPlanJson,
          'startDate': '2024-01-01T00:00:00.000Z',
          'endDate': '2024-01-05T00:00:00.000Z',
          'isActive': true,
          'daysRemaining': 1,
        },
      };

      // Act
      final result = SubscriptionStatusDto.fromJson(json);

      // Assert
      expect(result.hasActiveSubscription, true);
      expect(result.subscription!.daysRemaining, 1);
    });
  });
}
