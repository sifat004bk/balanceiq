import 'package:dolfin_core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    group('ServerFailure', () {
      test('creates with message', () {
        const failure = ServerFailure('Server error');
        expect(failure.message, 'Server error');
      });

      test('equals another ServerFailure with same message', () {
        const failure1 = ServerFailure('Server error');
        const failure2 = ServerFailure('Server error');
        expect(failure1, failure2);
      });

      test('not equal to ServerFailure with different message', () {
        const failure1 = ServerFailure('Server error 1');
        const failure2 = ServerFailure('Server error 2');
        expect(failure1, isNot(failure2));
      });

      test('props contains message', () {
        const failure = ServerFailure('Server error');
        expect(failure.props, ['Server error']);
      });
    });

    group('NetworkFailure', () {
      test('creates with message', () {
        const failure = NetworkFailure('No internet connection');
        expect(failure.message, 'No internet connection');
      });

      test('equals another NetworkFailure with same message', () {
        const failure1 = NetworkFailure('No internet');
        const failure2 = NetworkFailure('No internet');
        expect(failure1, failure2);
      });
    });

    group('CacheFailure', () {
      test('creates with message', () {
        const failure = CacheFailure('Cache read error');
        expect(failure.message, 'Cache read error');
      });

      test('equals another CacheFailure with same message', () {
        const failure1 = CacheFailure('Cache error');
        const failure2 = CacheFailure('Cache error');
        expect(failure1, failure2);
      });
    });

    group('AuthFailure', () {
      test('creates with message', () {
        const failure = AuthFailure('Authentication failed');
        expect(failure.message, 'Authentication failed');
      });

      test('equals another AuthFailure with same message', () {
        const failure1 = AuthFailure('Auth error');
        const failure2 = AuthFailure('Auth error');
        expect(failure1, failure2);
      });
    });

    group('ValidationFailure', () {
      test('creates with message', () {
        const failure = ValidationFailure('Invalid input');
        expect(failure.message, 'Invalid input');
      });

      test('equals another ValidationFailure with same message', () {
        const failure1 = ValidationFailure('Validation error');
        const failure2 = ValidationFailure('Validation error');
        expect(failure1, failure2);
      });
    });

    group('PermissionFailure', () {
      test('creates with message', () {
        const failure = PermissionFailure('Permission denied');
        expect(failure.message, 'Permission denied');
      });

      test('equals another PermissionFailure with same message', () {
        const failure1 = PermissionFailure('Permission error');
        const failure2 = PermissionFailure('Permission error');
        expect(failure1, failure2);
      });
    });

    group('NotFoundFailure', () {
      test('creates with message', () {
        const failure = NotFoundFailure('Resource not found');
        expect(failure.message, 'Resource not found');
      });

      test('equals another NotFoundFailure with same message', () {
        const failure1 = NotFoundFailure('Not found');
        const failure2 = NotFoundFailure('Not found');
        expect(failure1, failure2);
      });
    });

    group('ChatApiFailure', () {
      test('creates with message and default failure type', () {
        const failure = ChatApiFailure('Chat error');
        expect(failure.message, 'Chat error');
        expect(failure.failureType, ChatFailureType.general);
      });

      test('creates with message and specific failure type', () {
        const failure = ChatApiFailure(
          'Email not verified',
          failureType: ChatFailureType.emailNotVerified,
        );
        expect(failure.message, 'Email not verified');
        expect(failure.failureType, ChatFailureType.emailNotVerified);
      });

      test('equals another ChatApiFailure with same message and type', () {
        const failure1 = ChatApiFailure(
          'Rate limit exceeded',
          failureType: ChatFailureType.rateLimitExceeded,
        );
        const failure2 = ChatApiFailure(
          'Rate limit exceeded',
          failureType: ChatFailureType.rateLimitExceeded,
        );
        expect(failure1, failure2);
      });

      test('not equal when failure types differ', () {
        const failure1 = ChatApiFailure(
          'Error',
          failureType: ChatFailureType.rateLimitExceeded,
        );
        const failure2 = ChatApiFailure(
          'Error',
          failureType: ChatFailureType.tokenLimitExceeded,
        );
        expect(failure1, isNot(failure2));
      });

      test('props contains message and failure type', () {
        const failure = ChatApiFailure(
          'Subscription required',
          failureType: ChatFailureType.subscriptionRequired,
        );
        expect(failure.props, ['Subscription required', ChatFailureType.subscriptionRequired]);
      });
    });

    group('ChatFailureType', () {
      test('has all expected values', () {
        expect(ChatFailureType.values, [
          ChatFailureType.emailNotVerified,
          ChatFailureType.subscriptionRequired,
          ChatFailureType.subscriptionExpired,
          ChatFailureType.tokenLimitExceeded,
          ChatFailureType.rateLimitExceeded,
          ChatFailureType.general,
        ]);
      });

      test('emailNotVerified has correct index', () {
        expect(ChatFailureType.emailNotVerified.index, 0);
      });

      test('subscriptionRequired has correct index', () {
        expect(ChatFailureType.subscriptionRequired.index, 1);
      });

      test('subscriptionExpired has correct index', () {
        expect(ChatFailureType.subscriptionExpired.index, 2);
      });

      test('tokenLimitExceeded has correct index', () {
        expect(ChatFailureType.tokenLimitExceeded.index, 3);
      });

      test('rateLimitExceeded has correct index', () {
        expect(ChatFailureType.rateLimitExceeded.index, 4);
      });

      test('general has correct index', () {
        expect(ChatFailureType.general.index, 5);
      });
    });

    group('Failure inheritance', () {
      test('all failures extend Failure', () {
        expect(const ServerFailure(''), isA<Failure>());
        expect(const NetworkFailure(''), isA<Failure>());
        expect(const CacheFailure(''), isA<Failure>());
        expect(const AuthFailure(''), isA<Failure>());
        expect(const ValidationFailure(''), isA<Failure>());
        expect(const PermissionFailure(''), isA<Failure>());
        expect(const NotFoundFailure(''), isA<Failure>());
        expect(const ChatApiFailure(''), isA<Failure>());
      });

      test('different failure types are not equal', () {
        const serverFailure = ServerFailure('error');
        const networkFailure = NetworkFailure('error');
        expect(serverFailure, isNot(networkFailure));
      });
    });
  });
}
