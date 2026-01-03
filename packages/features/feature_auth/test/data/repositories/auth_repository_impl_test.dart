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
    // Reuse tLoginResponse from login group, but define it here or move it up
    final tGoogleLoginResponse = LoginResponse(
      success: true,
      message: 'Success',
      timestamp: 1234567890,
      data: LoginData(
        username: tUserModel.name,
        email: tUserModel.email,
        token: 'token',
        refreshToken: 'refresh_token',
        role: 'USER',
        userId: int.parse(tUserModel.id),
        isEmailVerified: true,
      ),
    );

    test('should return User when remote call is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.signInWithGoogle())
          .thenAnswer((_) async => tGoogleLoginResponse);
      when(() => mockLocalDataSource.saveAuthToken(any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.saveRefreshToken(any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.saveUser(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.signInWithGoogle();

      // Assert
      // We expect a user that matches tUserModel but we must ensure properties match what we put in tGoogleLoginResponse
      // tUserModel has 'email' auth provider, expected will have 'google'
      // tUserModel has 'email' auth provider, expected will have 'google'

      // Since userModel.createdAt uses DateTime.now(), we can't assert exact equality on the whole object easily
      // unless we mock DateTime or check specific fields.
      // However, Equatable should handle equality if fields match.
      // But createdAt will differ.
      // Relax assert to check Right(User) type and properties.

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.email, tUserModel.email);
          expect(r.authProvider, 'google');
        },
      );

      verify(() => mockRemoteDataSource.signInWithGoogle()).called(1);
      verify(() => mockLocalDataSource.saveAuthToken('token')).called(1);
      verify(() => mockLocalDataSource.saveRefreshToken('refresh_token'))
          .called(1);
      verify(() => mockLocalDataSource.saveUser(any())).called(1);
    });

    test('should return ServerFailure when remote call throws ServerException',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.signInWithGoogle())
          .thenThrow(const ServerException('Server Error'));

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
          .thenThrow(const ServerException('Failed'));

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

  group('updateCurrency', () {
    const tCurrency = 'USD';

    test('should call remote data source updateCurrency', () async {
      // Arrange
      when(() => mockRemoteDataSource.updateCurrency(any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.updateCurrency(tCurrency);

      // Assert
      expect(result, const Right(null));
      verify(() => mockRemoteDataSource.updateCurrency(tCurrency)).called(1);
    });

    test('should return ServerFailure when remote call fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.updateCurrency(any()))
          .thenThrow(const ServerException('Failed'));

      // Act
      final result = await repository.updateCurrency(tCurrency);

      // Assert
      expect(result, const Left(ServerFailure('Failed')));
      verify(() => mockRemoteDataSource.updateCurrency(tCurrency)).called(1);
    });
  });
}
