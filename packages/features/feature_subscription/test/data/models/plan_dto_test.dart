import 'package:feature_subscription/data/models/plan_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureDto', () {
    test('fromJson should parse valid feature', () {
      // Arrange
      final json = {
        'id': 1,
        'code': 'FEATURE_1',
        'name': 'Feature One',
        'description': 'This is feature one',
        'category': 'CORE',
        'requiresPermission': false,
        'isActive': true,
      };

      // Act
      final result = FeatureDto.fromJson(json);

      // Assert
      expect(result.id, 1);
      expect(result.code, 'FEATURE_1');
      expect(result.name, 'Feature One');
      expect(result.description, 'This is feature one');
      expect(result.category, 'CORE');
      expect(result.requiresPermission, false);
      expect(result.isActive, true);
    });

    test('fromJson should handle missing optional fields with defaults', () {
      // Arrange
      final json = {'id': 2};

      // Act
      final result = FeatureDto.fromJson(json);

      // Assert
      expect(result.id, 2);
      expect(result.code, '');
      expect(result.name, '');
      expect(result.description, '');
      expect(result.category, '');
      expect(result.requiresPermission, false);
      expect(result.isActive, true);
    });

    test('fromJson should parse requiresPermission correctly', () {
      // Arrange
      final json = {
        'id': 3,
        'code': 'PREMIUM_FEATURE',
        'name': 'Premium Feature',
        'description': 'Requires special permission',
        'category': 'PREMIUM',
        'requiresPermission': true,
        'isActive': true,
      };

      // Act
      final result = FeatureDto.fromJson(json);

      // Assert
      expect(result.requiresPermission, true);
    });
  });

  group('PlanDto', () {
    test('fromJson should parse valid plan', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'FREE',
        'displayName': 'Free Plan',
        'description': 'Basic features for getting started',
        'price': 0.0,
        'billingCycle': 'MONTHLY',
        'tier': 1,
        'maxProjects': 1,
        'maxStorageGb': 1,
        'maxApiCallsPerMonth': 100,
        'maxTeamMembers': 1,
        'features': [
          {
            'id': 1,
            'code': 'BASIC_CHAT',
            'name': 'Basic Chat',
            'description': 'Basic chat functionality',
            'category': 'CORE',
            'requiresPermission': false,
            'isActive': true,
          }
        ],
        'isActive': true,
      };

      // Act
      final result = PlanDto.fromJson(json);

      // Assert
      expect(result.id, 1);
      expect(result.name, 'FREE');
      expect(result.displayName, 'Free Plan');
      expect(result.description, 'Basic features for getting started');
      expect(result.price, 0.0);
      expect(result.billingCycle, 'MONTHLY');
      expect(result.tier, 1);
      expect(result.maxProjects, 1);
      expect(result.maxStorageGb, 1);
      expect(result.maxApiCallsPerMonth, 100);
      expect(result.maxTeamMembers, 1);
      expect(result.features.length, 1);
      expect(result.isActive, true);
    });

    test('fromJson should parse premium plan with multiple features', () {
      // Arrange
      final json = {
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
        'features': [
          {
            'id': 1,
            'code': 'BASIC_CHAT',
            'name': 'Basic Chat',
            'description': 'Basic chat functionality',
            'category': 'CORE',
            'requiresPermission': false,
            'isActive': true,
          },
          {
            'id': 2,
            'code': 'ADVANCED_ANALYTICS',
            'name': 'Advanced Analytics',
            'description': 'Detailed analytics',
            'category': 'PREMIUM',
            'requiresPermission': true,
            'isActive': true,
          }
        ],
        'isActive': true,
      };

      // Act
      final result = PlanDto.fromJson(json);

      // Assert
      expect(result.name, 'PREMIUM');
      expect(result.price, 9.99);
      expect(result.features.length, 2);
      expect(result.features[0].code, 'BASIC_CHAT');
      expect(result.features[1].code, 'ADVANCED_ANALYTICS');
    });

    test('fromJson should handle missing optional fields with defaults', () {
      // Arrange
      final json = {'id': 3};

      // Act
      final result = PlanDto.fromJson(json);

      // Assert
      expect(result.id, 3);
      expect(result.name, '');
      expect(result.displayName, '');
      expect(result.description, '');
      expect(result.price, 0.0);
      expect(result.billingCycle, 'MONTHLY');
      expect(result.tier, 0);
      expect(result.maxProjects, 0);
      expect(result.maxStorageGb, 0);
      expect(result.maxApiCallsPerMonth, 0);
      expect(result.maxTeamMembers, 0);
      expect(result.features, isEmpty);
      expect(result.isActive, true);
    });

    test('fromJson should parse price from integer', () {
      // Arrange
      final json = {
        'id': 4,
        'name': 'BASIC',
        'displayName': 'Basic Plan',
        'description': 'Basic plan',
        'price': 5, // Integer instead of double
        'billingCycle': 'MONTHLY',
        'tier': 1,
        'maxProjects': 5,
        'maxStorageGb': 10,
        'maxApiCallsPerMonth': 1000,
        'maxTeamMembers': 2,
        'features': [],
        'isActive': true,
      };

      // Act
      final result = PlanDto.fromJson(json);

      // Assert
      expect(result.price, 5.0);
    });

    test('fromJson should handle null features list', () {
      // Arrange
      final json = {
        'id': 5,
        'name': 'TEST',
        'displayName': 'Test Plan',
        'description': 'Test plan',
        'price': 1.99,
        'billingCycle': 'YEARLY',
        'tier': 1,
        'maxProjects': 3,
        'maxStorageGb': 5,
        'maxApiCallsPerMonth': 500,
        'maxTeamMembers': 1,
        'features': null,
        'isActive': true,
      };

      // Act
      final result = PlanDto.fromJson(json);

      // Assert
      expect(result.features, isEmpty);
    });

    test('fromJson should handle inactive plan', () {
      // Arrange
      final json = {
        'id': 6,
        'name': 'DEPRECATED',
        'displayName': 'Deprecated Plan',
        'description': 'No longer available',
        'price': 4.99,
        'billingCycle': 'MONTHLY',
        'tier': 1,
        'maxProjects': 1,
        'maxStorageGb': 1,
        'maxApiCallsPerMonth': 100,
        'maxTeamMembers': 1,
        'features': [],
        'isActive': false,
      };

      // Act
      final result = PlanDto.fromJson(json);

      // Assert
      expect(result.isActive, false);
    });
  });
}
