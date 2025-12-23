import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/domain/entities/user.dart';
import 'package:feature_auth/domain/usecases/get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late GetCurrentUser getCurrentUser;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getCurrentUser = GetCurrentUser(mockAuthRepository);
  });

  group('GetCurrentUser', () {
    final testUser = User(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: null,
      authProvider: 'email',
      createdAt: DateTime.now(),
      isEmailVerified: true,
    );

    test('should return User when user is logged in', () async {
      // Arrange
      when(() => mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => Right(testUser));

      // Act
      final result = await getCurrentUser();

      // Assert
      expect(result, Right(testUser));
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
    });

    test('should return null when no user is logged in', () async {
      // Arrange
      when(() => mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await getCurrentUser();

      // Assert
      expect(result, const Right(null));
    });

    test('should return CacheFailure when cache read fails', () async {
      // Arrange
      when(() => mockAuthRepository.getCurrentUser()).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to read cache')));

      // Act
      final result = await getCurrentUser();

      // Assert
      expect(result, const Left(CacheFailure('Failed to read cache')));
    });
  });
}
