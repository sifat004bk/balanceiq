import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/domain/usecases/sign_out.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late SignOut signOut;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signOut = SignOut(mockAuthRepository);
  });

  group('SignOut', () {
    test('should return void when sign out is successful', () async {
      // Arrange
      when(() => mockAuthRepository.signOut())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await signOut();

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.signOut()).called(1);
    });

    test('should return ServerFailure when sign out fails', () async {
      // Arrange
      when(() => mockAuthRepository.signOut())
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await signOut();

      // Assert
      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return CacheFailure when clearing cache fails', () async {
      // Arrange
      when(() => mockAuthRepository.signOut()).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to clear cache')));

      // Act
      final result = await signOut();

      // Assert
      expect(result, const Left(CacheFailure('Failed to clear cache')));
    });
  });
}
