import 'package:dolfin_core/error/app_exception.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/data/models/auth_request_models.dart';
import 'package:feature_auth/data/models/user_model.dart';
import 'package:feature_auth/data/repositories/auth_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

// Fallback values for mocktail's any() matcher
class FakeLoginRequest extends Fake implements LoginRequest {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(FakeLoginRequest());
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tUserModel = UserModel(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    photoUrl: null,
    authProvider: 'email',
    createdAt: DateTime(2023, 1, 1),
    isEmailVerified: true,
  );

  group('signInWithGoogle', () {
    test('should return User when remote call is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.signInWithGoogle())
          .thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.saveUser(tUserModel))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.signInWithGoogle();

      // Assert
      expect(result, Right(tUserModel));
      verify(() => mockRemoteDataSource.signInWithGoogle()).called(1);
      verify(() => mockLocalDataSource.saveUser(tUserModel)).called(1);
    });

    test('should return ServerFailure when remote call throws ServerException',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.signInWithGoogle())
          .thenThrow(ServerException('Server Error'));

      // Act
      final result = await repository.signInWithGoogle();

      // Assert
      expect(result, const Left(ServerFailure('Server Error')));
      verify(() => mockRemoteDataSource.signInWithGoogle()).called(1);
      verifyNever(() => mockLocalDataSource.saveUser(any()));
    });
  });

  group('login', () {
    const tUsername = 'testuser';
    const tPassword = 'password';
    final tLoginResponse = LoginResponse(
      success: true,
      message: 'Success',
      timestamp: 1234567890,
      data: LoginData(
        username: 'Test User',
        email: 'test@example.com',
        token: 'token',
        refreshToken: 'refresh_token',
        role: 'USER',
        userId: 1,
        isEmailVerified: true,
      ),
    );

    test('should return LoginResponse and save user when call is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.login(any()))
          .thenAnswer((_) async => tLoginResponse);
      when(() => mockLocalDataSource.saveUser(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.login(
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(result, Right(tLoginResponse));
      verify(() => mockRemoteDataSource.login(any())).called(1);
      verify(() => mockLocalDataSource.saveUser(any())).called(1);
    });

    test('should return ServerFailure when call fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.login(any()))
          .thenThrow(ServerException('Failed'));

      // Act
      final result = await repository.login(
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(result, const Left(ServerFailure('Failed')));
      verify(() => mockRemoteDataSource.login(any())).called(1);
      verifyNever(() => mockLocalDataSource.saveUser(any()));
    });
  });

  group('getCurrentUser', () {
    test('should return User when local data source has data', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, Right(tUserModel));
      verify(() => mockLocalDataSource.getCachedUser()).called(1);
    });

    test('should return CacheFailure when local data source throws', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenThrow(Exception('Cache Error'));

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(
          result,
          const Left(CacheFailure(
              'Failed to get current user: Exception: Cache Error')));
    });
  });

  group('signOut', () {
    test('should call remote and local sign out', () async {
      // Arrange
      // Using thenAnswer with async void for best compatibility with mocked void methods
      when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async {});
      when(() => mockLocalDataSource.clearUser()).thenAnswer((_) async {});

      // Act
      final result = await repository.signOut();

      // Assert
      expect(result, const Right(null));
      verify(() => mockRemoteDataSource.signOut()).called(1);
      verify(() => mockLocalDataSource.clearUser()).called(1);
    });
  });
}
