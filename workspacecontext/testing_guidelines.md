# Dolfin Workspace - Testing Guidelines

> **Last Updated:** December 2024
> **Test Coverage Target:** 80%+
> **Current Coverage:** ~60%+ (after implementation)

---

## Quick Start

### Running Tests

```bash
# Run all tests in the monorepo
melos run test

# Run tests for a specific package
cd packages/features/feature_auth
flutter test

# Run tests with coverage
flutter test --coverage

# Run a specific test file
flutter test test/domain/usecases/login_test.dart

# Run tests matching a pattern
flutter test --name "should return"
```

### Generate Coverage Report

```bash
# Generate coverage
flutter test --coverage

# View HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Test Structure

### Directory Organization

```
packages/features/feature_xxx/test/
├── mocks.dart                     # Shared mocks for the feature
├── data/
│   ├── datasources/
│   │   └── xxx_datasource_test.dart
│   ├── models/
│   │   └── xxx_model_test.dart
│   └── repositories/
│       └── xxx_repository_impl_test.dart
├── domain/
│   └── usecases/
│       └── xxx_usecase_test.dart
└── presentation/
    ├── cubit/
    │   └── xxx_cubit_test.dart
    └── pages/
        └── xxx_page_test.dart
```

---

## Test Patterns

### 1. Use Case Tests

```dart
import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/domain/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late Login login;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    login = Login(mockAuthRepository);
  });

  group('Login', () {
    test('should return LoginResponse when login is successful', () async {
      // Arrange
      when(() => mockAuthRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Right(testLoginResponse));

      // Act
      final result = await login(username: 'user', password: 'pass');

      // Assert
      expect(result, Right(testLoginResponse));
      verify(() => mockAuthRepository.login(
            username: 'user',
            password: 'pass',
          )).called(1);
    });

    test('should return AuthFailure when credentials are invalid', () async {
      // Arrange
      when(() => mockAuthRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(AuthFailure('Invalid')));

      // Act
      final result = await login(username: 'user', password: 'wrong');

      // Assert
      expect(result, const Left(AuthFailure('Invalid')));
    });
  });
}
```

### 2. Cubit/Bloc Tests

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late LoginCubit cubit;
  late MockLogin mockLogin;

  setUp(() {
    mockLogin = MockLogin();
    cubit = LoginCubit(login: mockLogin);
  });

  tearDown(() {
    cubit.close();
  });

  blocTest<LoginCubit, LoginState>(
    'emits [loading, success] when login succeeds',
    build: () {
      when(() => mockLogin(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Right(testResponse));
      return cubit;
    },
    act: (cubit) => cubit.loginWithEmail(
      username: 'test',
      password: 'Password1!',
    ),
    expect: () => [
      const LoginState(status: LoginStatus.loading),
      isA<LoginState>().having(
        (s) => s.status,
        'status',
        LoginStatus.success,
      ),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [loading, failure] when login fails',
    build: () {
      when(() => mockLogin(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(AuthFailure('Error')));
      return cubit;
    },
    act: (cubit) => cubit.loginWithEmail(
      username: 'test',
      password: 'wrong',
    ),
    expect: () => [
      const LoginState(status: LoginStatus.loading),
      isA<LoginState>()
          .having((s) => s.status, 'status', LoginStatus.failure),
    ],
  );
}
```

### 3. Model Tests (JSON Serialization)

```dart
void main() {
  group('UserModel', () {
    final testJson = {
      'id': 'user_123',
      'email': 'test@example.com',
      'name': 'Test User',
    };

    test('fromJson should create valid model', () {
      final result = UserModel.fromJson(testJson);

      expect(result.id, 'user_123');
      expect(result.email, 'test@example.com');
      expect(result.name, 'Test User');
    });

    test('toJson should return valid map', () {
      final model = UserModel(
        id: 'user_123',
        email: 'test@example.com',
        name: 'Test User',
      );

      final result = model.toJson();

      expect(result['id'], 'user_123');
      expect(result['email'], 'test@example.com');
    });

    test('roundtrip should preserve data', () {
      final original = UserModel.fromJson(testJson);
      final json = original.toJson();
      final restored = UserModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.email, original.email);
    });
  });
}
```

### 4. Widget Tests

```dart
void main() {
  testWidgets('LoginPage shows form fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => MockLoginCubit(),
          child: const LoginPage(),
        ),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('shows error message on failure', (tester) async {
    final cubit = MockLoginCubit();
    whenListen(
      cubit,
      Stream.fromIterable([
        const LoginState(status: LoginStatus.failure, error: 'Error'),
      ]),
      initialState: const LoginState(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const LoginPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
  });
}
```

---

## Creating Mocks

### Feature Mocks File

Each feature should have a `test/mocks.dart` file:

```dart
import 'package:feature_auth/data/datasources/auth_local_datasource.dart';
import 'package:feature_auth/data/datasources/auth_remote_datasource.dart';
import 'package:feature_auth/domain/repositories/auth_repository.dart';
import 'package:feature_auth/domain/usecases/login.dart';
import 'package:feature_auth/domain/usecases/signup.dart';
import 'package:mocktail/mocktail.dart';

// Data Sources
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

// Repositories
class MockAuthRepository extends Mock implements AuthRepository {}

// Use Cases
class MockLogin extends Mock implements Login {}
class MockSignup extends Mock implements Signup {}
```

### Registering Fallback Values

For custom types used with `any()`:

```dart
setUpAll(() {
  registerFallbackValue(Message(
    id: 'fallback',
    userId: 'user',
    botId: 'bot',
    sender: 'user',
    content: 'fallback',
    timestamp: DateTime.now(),
  ));
});
```

---

## Test Categories

### Unit Tests

- Test individual classes/functions in isolation
- Mock all dependencies
- Fast execution (<1ms per test)
- High coverage target (90%+)

**Files to Test:**
- Use cases
- Repository implementations
- Data models (JSON serialization)
- Cubits/Blocs
- Utility functions
- Validators

### Widget Tests

- Test UI components with mocked dependencies
- Verify widget rendering
- Test user interactions
- Medium execution speed

**Files to Test:**
- All pages
- Custom widgets
- Form components

### Integration Tests

- Test complete user flows
- Real or semi-mocked dependencies
- Slower execution

**Flows to Test:**
- Login → Dashboard
- Send message → Receive response
- Signup → Email verification

---

## Best Practices

### DO

- Use descriptive test names
- Follow Arrange-Act-Assert pattern
- Test edge cases and error scenarios
- Group related tests
- Use `setUp` for common initialization
- Clean up in `tearDown`
- Mock external dependencies

### DON'T

- Test implementation details
- Create flaky tests
- Skip error case testing
- Use real network calls in unit tests
- Couple tests to each other

---

## Coverage Requirements

| Test Type       | Target Coverage |
|-----------------|-----------------|
| Use Cases       | 100%            |
| Cubits/Blocs    | 90%+            |
| Repositories    | 85%+            |
| Models          | 100%            |
| Widgets         | 80%+            |
| Utilities       | 100%            |
| **Overall**     | **80%+**        |

---

## CI Integration

### GitHub Actions Example

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test --coverage

      - name: Check coverage
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | cut -d':' -f2 | cut -d'%' -f1 | tr -d ' ')
          if [ "$COVERAGE" -lt 80 ]; then
            echo "Coverage $COVERAGE% is below 80%"
            exit 1
          fi
```

---

## Test Files Created

### Phase 1: Infrastructure & Cubits
- `feature_auth/test/mocks.dart`
- `feature_subscription/test/mocks.dart`
- `dolfin_core/test/mocks/core_mocks.dart`
- `feature_auth/test/presentation/cubit/login_cubit_test.dart`
- `feature_auth/test/presentation/cubit/session_cubit_test.dart`
- `feature_auth/test/presentation/cubit/signup_cubit_test.dart`
- `feature_auth/test/presentation/cubit/password_cubit_test.dart`
- `feature_subscription/test/presentation/cubit/subscription_cubit_test.dart`

### Phase 2: Use Cases (20 files)
- `feature_auth/test/domain/usecases/login_test.dart`
- `feature_auth/test/domain/usecases/signup_test.dart`
- `feature_auth/test/domain/usecases/sign_out_test.dart`
- `feature_auth/test/domain/usecases/get_current_user_test.dart`
- `feature_auth/test/domain/usecases/change_password_test.dart`
- `feature_auth/test/domain/usecases/forgot_password_test.dart`
- `feature_auth/test/domain/usecases/reset_password_test.dart`
- `feature_auth/test/domain/usecases/get_profile_test.dart`
- `feature_auth/test/domain/usecases/sign_in_with_google_test.dart`
- `feature_auth/test/domain/usecases/send_verification_email_test.dart`
- `feature_auth/test/domain/usecases/resend_verification_email_test.dart`
- `feature_chat/test/domain/usecases/send_message_test.dart`
- `feature_chat/test/domain/usecases/get_messages_test.dart`
- `feature_chat/test/domain/usecases/get_chat_history_test.dart`
- `feature_chat/test/domain/usecases/update_message_test.dart`
- `feature_chat/test/domain/usecases/get_message_usage_test.dart`
- `feature_chat/test/domain/usecases/submit_feedback_test.dart`
- `feature_subscription/test/domain/usecases/get_all_plans_test.dart`
- `feature_subscription/test/domain/usecases/get_subscription_status_test.dart`
- `feature_subscription/test/domain/usecases/create_subscription_test.dart`

### Phase 3: Models
- `feature_auth/test/data/models/user_model_test.dart`
- `feature_auth/test/data/models/auth_request_models_test.dart`
- `feature_chat/test/data/models/message_model_test.dart`
- `feature_chat/test/data/models/chat_feedback_model_test.dart`
- `feature_subscription/test/data/models/plan_dto_test.dart`
- `feature_subscription/test/data/models/subscription_dto_test.dart`

### Phase 4: Core Package
- `dolfin_core/test/error/failures_test.dart`
- `dolfin_core/test/error/app_exception_test.dart`
- `dolfin_core/test/utils/input_validator_test.dart`
- `dolfin_core/test/currency/currency_state_test.dart`
- `dolfin_core/test/config/environment_config_test.dart`

---

## References

- [flutter_test documentation](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)
- [bloc_test package](https://pub.dev/packages/bloc_test)
- [mocktail package](https://pub.dev/packages/mocktail)
- [Effective Dart: Testing](https://dart.dev/effective-dart/usage#testing)

---

*Testing Guidelines v1.0 - December 2024*
