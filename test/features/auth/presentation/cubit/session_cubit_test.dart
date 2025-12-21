import 'package:balance_iq/core/error/failures.dart';
import 'package:balance_iq/core/storage/secure_storage_service.dart';
import 'package:balance_iq/features/auth/domain/entities/user.dart';
import 'package:balance_iq/features/auth/domain/usecases/get_current_user.dart';
import 'package:balance_iq/features/auth/domain/usecases/get_profile.dart';
import 'package:balance_iq/features/auth/domain/usecases/sign_out.dart';
import 'package:balance_iq/features/auth/presentation/cubit/session/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockSignOut extends Mock implements SignOut {}

class MockGetProfile extends Mock implements GetProfile {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late SessionCubit sessionCubit;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockSignOut mockSignOut;
  late MockGetProfile mockGetProfile;
  late MockSecureStorageService mockSecureStorage;

  setUp(() {
    mockGetCurrentUser = MockGetCurrentUser();
    mockSignOut = MockSignOut();
    mockGetProfile = MockGetProfile();
    mockSecureStorage = MockSecureStorageService();

    sessionCubit = SessionCubit(
      getCurrentUser: mockGetCurrentUser,
      signOutUseCase: mockSignOut,
      getProfile: mockGetProfile,
      secureStorage: mockSecureStorage,
    );
  });

  tearDown(() {
    sessionCubit.close();
  });

  group('SessionCubit', () {
    final testUser = User(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: null,
      authProvider: 'email',
      createdAt: DateTime(2024, 1, 1),
      isEmailVerified: true,
    );

    test('initial state is SessionInitial', () {
      expect(sessionCubit.state, isA<SessionInitial>());
    });

    blocTest<SessionCubit, SessionState>(
      'emits [SessionLoading, Authenticated] when checkAuthStatus finds a user',
      build: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => Right(testUser));
        return sessionCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        isA<SessionLoading>(),
        isA<Authenticated>(),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'emits [SessionLoading, Unauthenticated] when checkAuthStatus finds no user',
      build: () {
        when(() => mockGetCurrentUser()).thenAnswer((_) async => Right(null));
        return sessionCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        isA<SessionLoading>(),
        isA<Unauthenticated>(),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'emits [SessionLoading, Unauthenticated] when checkAuthStatus fails',
      build: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => const Left(CacheFailure('No token')));
        return sessionCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        isA<SessionLoading>(),
        isA<Unauthenticated>(),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'emits [SessionLoading, Unauthenticated] when logout succeeds',
      build: () {
        when(() => mockSignOut()).thenAnswer((_) async => const Right(null));
        return sessionCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<SessionLoading>(),
        isA<Unauthenticated>(),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'emits [SessionLoading, SessionError] when logout fails',
      build: () {
        when(() => mockSignOut()).thenAnswer(
            (_) async => const Left(ServerFailure('Logout failed')));
        return sessionCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<SessionLoading>(),
        isA<SessionError>(),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'updateUser emits Authenticated with the provided user',
      build: () => sessionCubit,
      act: (cubit) => cubit.updateUser(testUser),
      expect: () => [
        isA<Authenticated>(),
      ],
    );
  });
}
