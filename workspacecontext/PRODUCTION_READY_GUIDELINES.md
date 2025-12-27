# Dolfin Workspace - Production-Ready Development Guidelines

> **Version:** 1.0
> **Last Updated:** December 28, 2025
> **Purpose:** State-of-art, scalable, maintainable, and production-grade codebase standards

---

## Table of Contents

1. [Architecture Principles](#1-architecture-principles)
2. [Code Quality Standards](#2-code-quality-standards)
3. [Testing Strategy](#3-testing-strategy)
4. [Security Best Practices](#4-security-best-practices)
5. [Performance Optimization](#5-performance-optimization)
6. [State Management](#6-state-management)
7. [Dependency Injection](#7-dependency-injection)
8. [Error Handling](#8-error-handling)
9. [Logging & Monitoring](#9-logging--monitoring)
10. [Database & Offline-First](#10-database--offline-first)
11. [API Integration](#11-api-integration)
12. [UI/UX Standards](#12-uiux-standards)
13. [Accessibility](#13-accessibility)
14. [Internationalization](#14-internationalization)
15. [Build & Deployment](#15-build--deployment)
16. [Documentation](#16-documentation)
17. [Code Review Checklist](#17-code-review-checklist)
18. [Continuous Improvement](#18-continuous-improvement)

---

## 1. Architecture Principles

### 1.1 Clean Architecture (Mandatory)

**Three-Layer Separation:**

```
Domain Layer (Pure Dart)
    ↓ depends on
Data Layer (Implementation)
    ↓ used by
Presentation Layer (Flutter UI)
```

**Rules:**
- ✅ Domain layer MUST NOT depend on Flutter or external packages
- ✅ Data layer implements interfaces defined in domain
- ✅ Presentation layer consumes domain use cases via dependency injection
- ❌ NEVER bypass use cases to call repositories directly from UI

**Example Structure:**
```
lib/
├── domain/
│   ├── entities/              # Pure Dart business objects
│   ├── repositories/          # Abstract interfaces
│   └── usecases/             # Business logic operations
├── data/
│   ├── datasources/          # API/DB implementations
│   ├── models/               # DTOs with JSON serialization
│   └── repositories/         # Repository implementations
└── presentation/
    ├── pages/                # Screen widgets
    ├── widgets/              # Reusable components
    └── cubit/                # State management
```

### 1.2 Feature-First Monorepo

**Package Organization:**

```
workspace/
├── packages/
│   ├── core/                 # Shared foundation
│   │   ├── dolfin_core/     # Utils, error handling, DB
│   │   └── dolfin_ui_kit/   # Design system
│   └── features/             # Business features
│       ├── feature_auth/
│       ├── feature_chat/
│       └── feature_subscription/
└── apps/                     # Application entry points
    ├── dolfin_ai/           # Main app
    └── dolfin_test/         # Development app
```

**Dependency Rules:**
- Apps depend on Features
- Features depend on Core
- Core depends on External packages only
- Features MUST NOT depend on other features
- No circular dependencies

### 1.3 Interface-Based Design

**All contracts defined as abstracts:**

```dart
// ✅ Good: Abstract contract in domain
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> logout();
}

// ✅ Good: Implementation in data layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    // Implementation
  }
}
```

**Benefits:**
- Easy to swap implementations (mock ↔ real)
- Testability (inject mocks)
- Clear contracts

### 1.4 Single Responsibility Principle

**Use Cases:**
```dart
// ✅ Good: One use case = one operation
class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Either<Failure, User>> call(String email, String password) {
    return repository.login(email, password);
  }
}

// ❌ Bad: Use case doing multiple things
class AuthUseCase {
  Future<User> login() {}
  Future<void> logout() {}
  Future<void> resetPassword() {}  // Too many responsibilities
}
```

**Rules:**
- One use case per business operation
- Name use cases as actions (Login, GetMessages, UpdateProfile)
- Keep use cases focused and testable

---

## 2. Code Quality Standards

### 2.1 Linting Configuration

**Strict analysis_options.yaml:**

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

  errors:
    # Treat warnings as errors in CI
    missing_required_param: error
    missing_return: error
    invalid_annotation_target: ignore

  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

linter:
  rules:
    # Style
    - always_declare_return_types
    - prefer_single_quotes
    - require_trailing_commas
    - sort_pub_dependencies

    # Performance
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables

    # Documentation
    - public_member_api_docs
    - package_api_docs

    # Code quality
    - avoid_print
    - avoid_dynamic_calls
    - prefer_final_locals
    - prefer_final_fields
    - unnecessary_this
    - use_key_in_widget_constructors

    # Error handling
    - only_throw_errors
    - use_rethrow_when_possible

    # Async
    - unawaited_futures
    - cancel_subscriptions
    - close_sinks
```

### 2.2 Const Usage (Target: 90%+)

**Enforce immutability:**

```dart
// ✅ Good: const everywhere possible
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Hello'),
    );
  }
}

// ❌ Bad: Missing const
class MyWidget extends StatelessWidget {
  MyWidget({Key? key}) : super(key: key);  // Missing const

  Widget build(BuildContext context) {
    return Padding(                         // Missing const
      padding: EdgeInsets.all(16),          // Missing const
      child: Text('Hello'),                 // Missing const
    );
  }
}
```

**Auto-fix:**
```bash
dart fix --apply --code=prefer_const_constructors
dart fix --apply --code=prefer_const_declarations
```

### 2.3 Null Safety

**Strict null safety:**

```dart
// ✅ Good: Explicit null handling
String? getUserName(User? user) {
  return user?.name;
}

void displayName(String? name) {
  final displayName = name ?? 'Guest';
  print(displayName);
}

// ❌ Bad: Force unwrapping without null check
void displayName(String? name) {
  print(name!);  // Can crash if null
}
```

### 2.4 Immutability

**Use @immutable and Equatable:**

```dart
// ✅ Good: Immutable entity
@immutable
class User extends Equatable {
  final String id;
  final String email;
  final String name;

  const User({
    required this.id,
    required this.email,
    required this.name,
  });

  @override
  List<Object?> get props => [id, email, name];

  // CopyWith for updates
  User copyWith({String? name}) {
    return User(
      id: id,
      email: email,
      name: name ?? this.name,
    );
  }
}
```

### 2.5 Code Formatting

**dartfmt standard:**

```bash
# Format all files
dart format .

# Format with 80-character line limit
dart format --line-length 80 .

# Check formatting (CI)
dart format --set-exit-if-changed .
```

**Pre-commit hook:**
```bash
#!/bin/bash
# .git/hooks/pre-commit
dart format --set-exit-if-changed .
if [ $? -ne 0 ]; then
  echo "❌ Code formatting issues found. Run 'dart format .'"
  exit 1
fi
```

---

## 3. Testing Strategy

### 3.1 Test Coverage Targets

**Minimum Coverage Requirements:**

| Layer | Target Coverage | Priority |
|-------|----------------|----------|
| Domain (Use Cases) | 100% | P0 |
| Domain (Entities) | 90% | P0 |
| Data (Repositories) | 90% | P0 |
| Data (Models) | 100% | P0 |
| Presentation (Cubits) | 100% | P0 |
| Presentation (Widgets) | 80% | P1 |
| Integration Tests | Key flows | P1 |
| **Overall** | **80%+** | **P0** |

### 3.2 Test Pyramid

```
        /\
       /  \  E2E Tests (5%)
      /____\
     /      \  Integration Tests (15%)
    /________\
   /          \  Widget Tests (30%)
  /____________\
 /              \ Unit Tests (50%)
/______________\
```

**Distribution:**
- 50% Unit tests (use cases, repositories, models, cubits)
- 30% Widget tests (UI components)
- 15% Integration tests (API, database, feature flows)
- 5% E2E tests (critical user journeys)

### 3.3 Unit Testing

**Use Case Tests:**

```dart
// test/domain/usecases/login_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Login useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = Login(mockRepository);
  });

  group('Login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'Password123!';
    const tUser = User(id: '1', email: tEmail, name: 'Test User');

    test('should return User when login is successful', () async {
      // arrange
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => const Right(tUser));

      // act
      final result = await useCase(tEmail, tPassword);

      // assert
      expect(result, const Right(tUser));
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when login fails', () async {
      // arrange
      const tFailure = ServerFailure(message: 'Invalid credentials');
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tEmail, tPassword);

      // assert
      expect(result, const Left(tFailure));
    });
  });
}
```

**Cubit Tests:**

```dart
// test/presentation/cubit/login_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

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

  group('LoginCubit', () {
    blocTest<LoginCubit, LoginState>(
      'emits [loading, success] when login succeeds',
      build: () {
        when(() => mockLogin(any(), any()))
            .thenAnswer((_) async => const Right(tUser));
        return cubit;
      },
      act: (cubit) => cubit.login('test@example.com', 'Password123!'),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        const LoginState(status: LoginStatus.success, user: tUser),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loading, error] when login fails',
      build: () {
        when(() => mockLogin(any(), any()))
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        return cubit;
      },
      act: (cubit) => cubit.login('test@example.com', 'wrong'),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        const LoginState(status: LoginStatus.error, errorMessage: 'Error'),
      ],
    );
  });
}
```

### 3.4 Widget Testing

```dart
// test/presentation/widgets/login_form_test.dart
void main() {
  testWidgets('LoginForm displays email and password fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginForm(),
        ),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('shows error when email is invalid',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginForm()));

    await tester.enterText(find.byKey(const Key('email_field')), 'invalid');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });
}
```

### 3.5 Integration Testing

```dart
// integration_test/auth_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Test', () {
    testWidgets('complete login to dashboard flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Should show login screen
      expect(find.text('Login'), findsOneWidget);

      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'Password123!',
      );

      // Tap login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Should navigate to dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
```

### 3.6 Golden Tests (Visual Regression)

```dart
// test/presentation/widgets/message_bubble_golden_test.dart
void main() {
  testWidgets('MessageBubble golden test - user message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageBubble(
            message: const Message(
              id: '1',
              content: 'Hello, this is a test message',
              isUser: true,
              timestamp: '2025-12-28T10:00:00Z',
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MessageBubble),
      matchesGoldenFile('goldens/message_bubble_user.png'),
    );
  });
}
```

---

## 4. Security Best Practices

### 4.1 Secure Storage

**ALWAYS use SecureStorageService for sensitive data:**

```dart
// ✅ Good: Secure token storage
class AuthRepositoryImpl implements AuthRepository {
  final SecureStorageService secureStorage;

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await secureStorage.saveToken(accessToken);
    await secureStorage.saveRefreshToken(refreshToken);
  }

  Future<String?> getToken() => secureStorage.getToken();
}

// ❌ Bad: Insecure storage
class AuthRepositoryImpl {
  Future<void> saveToken(String token) async {
    await SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('token', token));  // NOT encrypted!
  }
}
```

**What to store securely:**
- Authentication tokens (access, refresh)
- API keys
- User credentials (if cached)
- Encryption keys
- Session identifiers

### 4.2 Input Validation

**Use InputValidator for all user input:**

```dart
// ✅ Good: Validate all inputs
class LoginCubit extends Cubit<LoginState> {
  Future<void> login(String email, String password) async {
    // Validate
    if (!InputValidator.isValidEmail(email)) {
      emit(state.copyWith(
        status: LoginStatus.error,
        errorMessage: 'Invalid email format',
      ));
      return;
    }

    if (!InputValidator.isValidPassword(password)) {
      emit(state.copyWith(
        status: LoginStatus.error,
        errorMessage: 'Password must be at least 8 characters',
      ));
      return;
    }

    // Sanitize
    final sanitizedEmail = InputValidator.sanitizeInput(email);

    // Proceed with login
    emit(state.copyWith(status: LoginStatus.loading));
    final result = await _loginUseCase(sanitizedEmail, password);
    // ...
  }
}
```

**Validation Rules:**
- Email: RFC-compliant regex
- Password: 8+ chars, uppercase, lowercase, number, special char
- Name: 2-50 chars, letters only
- Amount: >0, max 999,999,999.99
- General input: XSS/SQL injection protection

### 4.3 API Security

**Certificate Pinning (Production):**

```dart
// lib/core/network/dio_client.dart
class DioClient {
  Dio createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: EnvironmentConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // Certificate pinning for production
    if (kReleaseMode) {
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          // Verify certificate SHA-256 fingerprint
          return cert.sha256.toString() == _expectedCertFingerprint;
        };
        return client;
      };
    }

    return dio;
  }
}
```

**Request Security:**

```dart
// Add auth headers
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  },
));

// HTTPS only
dio.options.baseUrl = 'https://api.example.com';  // ✅
// Never http in production
```

### 4.4 Database Encryption

**Encrypt sensitive local data:**

```yaml
# pubspec.yaml
dependencies:
  sqflite_sqlcipher: ^2.2.0  # Encrypted SQLite
```

```dart
// Initialize encrypted database
final database = await openDatabase(
  path,
  password: await _getEncryptionKey(),
  version: 7,
  onCreate: _createDB,
);
```

### 4.5 Code Obfuscation

**Build configuration:**

```bash
# Android release build with obfuscation
flutter build apk \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols

# iOS release build
flutter build ios \
  --release \
  --obfuscate \
  --split-debug-info=build/ios/outputs/symbols
```

**ProGuard rules (android/app/proguard-rules.pro):**

```proguard
# Keep model classes
-keep class com.dolfinmind.dolfin_ai.** { *; }

# Keep JSON serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
```

### 4.6 Logging Security

**NEVER log sensitive data:**

```dart
// ✅ Good: Safe logging
AppLogger.d('User login attempt', tag: 'Auth');

// ❌ Bad: Logging sensitive data
AppLogger.d('Login with email: $email, password: $password');  // NEVER!
AppLogger.d('Access token: $token');  // NEVER!

// ✅ Good: Log sanitized data
AppLogger.d('Login attempt for user: ${email.substring(0, 3)}***');
```

**Production logging:**

```dart
// Only log errors in production
if (kDebugMode) {
  AppLogger.d('Debug info: $data');
} else {
  // Only errors sent to crash reporting
  AppLogger.e('Error occurred', error: e, stackTrace: stackTrace);
}
```

---

## 5. Performance Optimization

### 5.1 Widget Performance

**const constructors everywhere:**

```dart
// ✅ Good: Const widgets don't rebuild
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Static content'),
        Icon(Icons.check),
      ],
    );
  }
}
```

**RepaintBoundary for expensive widgets:**

```dart
ListView.builder(
  itemCount: messages.length,
  itemBuilder: (context, index) {
    return RepaintBoundary(  // ✅ Isolates repaints
      child: MessageBubble(message: messages[index]),
    );
  },
)
```

**Keys for list performance:**

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return MessageBubble(
      key: ValueKey(messages[index].id),  // ✅ Helps Flutter reuse widgets
      message: messages[index],
    );
  },
)
```

### 5.2 Image Optimization

**CachedNetworkImage with size limits:**

```dart
CachedNetworkImage(
  imageUrl: url,
  memCacheHeight: 400,      // Resize for memory
  maxHeightDiskCache: 800,  // Disk cache limit
  placeholder: (context, url) => const ShimmerPlaceholder(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

### 5.3 Database Performance

**Indexes on frequently queried columns:**

```sql
CREATE INDEX idx_messages_user_bot_timestamp
ON messages(user_id, bot_id, timestamp DESC);

CREATE INDEX idx_messages_sync_status
ON messages(user_id, is_synced);
```

**Pagination for large datasets:**

```dart
Future<List<Message>> getMessages({
  required String userId,
  required String botId,
  int limit = 50,
  int offset = 0,
}) async {
  final result = await db.query(
    'messages',
    where: 'user_id = ? AND bot_id = ?',
    whereArgs: [userId, botId],
    orderBy: 'timestamp DESC',
    limit: limit,
    offset: offset,
  );
  return result.map((json) => Message.fromJson(json)).toList();
}
```

### 5.4 Build Performance

**Lazy loading with deferred imports:**

```dart
// Import heavy features lazily
import 'package:feature_subscription/feature_subscription.dart' deferred as subscription;

// Load when needed
ElevatedButton(
  onPressed: () async {
    await subscription.loadLibrary();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => subscription.SubscriptionPage()),
    );
  },
  child: const Text('Subscription'),
)
```

### 5.5 Memory Management

**Dispose resources:**

```dart
class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ScrollController _scrollController;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();  // ✅ Prevent memory leaks
    _textController.dispose();    // ✅
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

---

## 6. State Management

### 6.1 Cubit Pattern (Standard)

**State class:**

```dart
@immutable
class ChatState extends Equatable {
  final List<Message> messages;
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.errorMessage,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, isSending, errorMessage];
}
```

**Cubit:**

```dart
class ChatCubit extends Cubit<ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;

  ChatCubit({
    required this.getMessages,
    required this.sendMessage,
  }) : super(const ChatState());

  Future<void> loadMessages(String botId) async {
    emit(state.copyWith(isLoading: true));

    final result = await getMessages(botId);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (messages) => emit(state.copyWith(
        isLoading: false,
        messages: messages,
        errorMessage: null,
      )),
    );
  }

  Future<void> sendMessageToBot(String content, String botId) async {
    // Optimistic update
    final tempMessage = Message(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      isUser: true,
      timestamp: DateTime.now().toIso8601String(),
    );

    emit(state.copyWith(
      messages: [...state.messages, tempMessage],
      isSending: true,
    ));

    final result = await sendMessage(SendMessageParams(
      content: content,
      botId: botId,
    ));

    result.fold(
      (failure) {
        // Remove temp message
        final messages = state.messages.where((m) => m.id != tempMessage.id).toList();
        emit(state.copyWith(
          messages: messages,
          isSending: false,
          errorMessage: failure.message,
        ));
      },
      (response) {
        // Replace temp with real message
        final messages = state.messages
            .where((m) => m.id != tempMessage.id)
            .toList()
          ..add(response.userMessage)
          ..add(response.botMessage);

        emit(state.copyWith(
          messages: messages,
          isSending: false,
        ));
      },
    );
  }
}
```

**BlocProvider:**

```dart
// Provide cubit
BlocProvider(
  create: (context) => sl<ChatCubit>()..loadMessages(botId),
  child: ChatPage(),
)

// Consume in widget
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const ChatShimmer();
        }

        if (state.errorMessage != null) {
          return ErrorWidget(message: state.errorMessage!);
        }

        return MessageList(messages: state.messages);
      },
    );
  }
}
```

### 6.2 BlocListener for Side Effects

```dart
BlocListener<ChatCubit, ChatState>(
  listenWhen: (previous, current) =>
      previous.errorMessage != current.errorMessage,
  listener: (context, state) {
    if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage!)),
      );
    }
  },
  child: BlocBuilder<ChatCubit, ChatState>(
    builder: (context, state) {
      // Build UI
    },
  ),
)
```

---

## 7. Dependency Injection

### 7.1 Feature Initialization Pattern

**Explicit configuration:**

```dart
// packages/features/feature_auth/lib/feature_auth.dart

class AuthFeatureConfig {
  final AuthConfig authConfig;
  final SecureStorageService secureStorage;
  final SharedPreferences sharedPreferences;
  final Dio dio;
  final GoogleSignIn? googleSignIn;
  final Uuid? uuid;
  final bool useMockDataSource;

  const AuthFeatureConfig({
    required this.authConfig,
    required this.secureStorage,
    required this.sharedPreferences,
    required this.dio,
    this.googleSignIn,
    this.uuid,
    this.useMockDataSource = false,
  });
}

Future<void> initAuthFeature(GetIt sl, AuthFeatureConfig config) async {
  // 1. Register config
  sl.registerSingleton<AuthConfig>(config.authConfig);

  // 2. Data sources (conditional)
  if (config.useMockDataSource) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthMockDataSource(uuid: config.uuid ?? const Uuid()),
    );
  } else {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        dio: config.dio,
        authConfig: config.authConfig,
      ),
    );
  }

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: config.secureStorage,
      sharedPreferences: config.sharedPreferences,
    ),
  );

  // 3. Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // 4. Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => VerifyEmail(sl()));

  // 5. Cubits (factory - new instance each time)
  sl.registerFactory(() => LoginCubit(login: sl()));
  sl.registerFactory(() => SignupCubit(signup: sl()));
  sl.registerFactory(() => SessionCubit(
    getCurrentUser: sl(),
    logout: sl(),
    updateProfile: sl(),
  ));
  sl.registerFactory(() => ForgotPasswordCubit(forgotPassword: sl()));
  sl.registerFactory(() => ResetPasswordCubit(resetPassword: sl()));
  sl.registerFactory(() => VerifyEmailCubit(verifyEmail: sl()));
}
```

**App initialization:**

```dart
// apps/dolfin_ai/lib/core/di/injection_container.dart

Future<void> init() async {
  final sl = GetIt.instance;

  // 1. Core dependencies
  final secureStorage = await _initSecureStorage();
  final sharedPrefs = await SharedPreferences.getInstance();
  final dio = _createDio();
  final database = await _initDatabase();

  // 2. Register core
  sl.registerSingleton<SecureStorageService>(secureStorage);
  sl.registerSingleton<SharedPreferences>(sharedPrefs);
  sl.registerSingleton<Dio>(dio);
  sl.registerSingleton<DatabaseHelper>(database);

  // 3. Register strings
  sl.registerLazySingleton<CoreStrings>(() => const CoreStringsImpl());
  sl.registerLazySingleton<AuthStrings>(() => const AuthStringsImpl());
  sl.registerLazySingleton<ChatStrings>(() => const ChatStringsImpl());

  // 4. Initialize features
  await initAuthFeature(sl, AuthFeatureConfig(
    authConfig: AuthConfig(baseUrl: EnvironmentConfig.baseUrl),
    secureStorage: sl(),
    sharedPreferences: sl(),
    dio: sl(),
    googleSignIn: GoogleSignIn(),
    useMockDataSource: EnvironmentConfig.useMockData,
  ));

  await initChatFeature(sl, ChatFeatureConfig(
    chatConfig: ChatConfig(baseUrl: EnvironmentConfig.baseUrl),
    dio: sl(),
    database: sl(),
    secureStorage: sl(),
    useMockDataSource: EnvironmentConfig.useMockData,
  ));

  await initSubscriptionFeature(sl, SubscriptionFeatureConfig(
    subscriptionConfig: SubscriptionConfig(baseUrl: EnvironmentConfig.baseUrl),
    dio: sl(),
    secureStorage: sl(),
    useMockDataSource: EnvironmentConfig.useMockData,
  ));

  // 5. Initialize app-specific modules
  await _initDashboardModule(sl);
}
```

### 7.2 Registration Patterns

**Singleton vs Factory:**

```dart
// ✅ Singleton for stateless services
sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(...));

// ✅ Factory for stateful widgets/cubits
sl.registerFactory(() => LoginCubit(...));

// ✅ Singleton for config/constants
sl.registerSingleton<AuthConfig>(AuthConfig(...));
```

**DI Validation Test:**

```dart
// test/core/di/injection_container_test.dart
void main() {
  test('all dependencies can be resolved', () async {
    await init();
    final sl = GetIt.instance;

    // Verify critical dependencies
    expect(() => sl<AuthRepository>(), returnsNormally);
    expect(() => sl<ChatRepository>(), returnsNormally);
    expect(() => sl<DatabaseHelper>(), returnsNormally);
    expect(() => sl<SecureStorageService>(), returnsNormally);

    // Verify cubits can be created
    expect(() => sl<LoginCubit>(), returnsNormally);
    expect(() => sl<ChatCubit>(), returnsNormally);
  });
}
```

---

## 8. Error Handling

### 8.1 Functional Error Handling (Dartz Either)

**Define failure types:**

```dart
// lib/core/error/failures.dart
@immutable
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required String message, int? statusCode})
      : super(message, statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection');
}

class CacheFailure extends Failure {
  const CacheFailure() : super('Failed to load cached data');
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('Session expired. Please login again.', 401);
}
```

**Use Either in repositories:**

```dart
// ✅ Good: Return Either<Failure, Success>
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // Validate input
      if (!InputValidator.isValidEmail(email)) {
        return const Left(ValidationFailure('Invalid email format'));
      }

      // Call API
      final response = await _remoteDataSource.login(email, password);

      // Save to local storage
      await _localDataSource.saveUser(response);

      return Right(response.toEntity());

    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } on SocketException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return const UnauthorizedFailure();
        }
        return ServerFailure(
          message: e.response?.data['message'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      default:
        return const NetworkFailure();
    }
  }
}
```

**Handle in Cubit:**

```dart
Future<void> login(String email, String password) async {
  emit(state.copyWith(status: LoginStatus.loading));

  final result = await _loginUseCase(email, password);

  result.fold(
    (failure) {
      // Handle different failure types
      String errorMessage;
      if (failure is ValidationFailure) {
        errorMessage = failure.message;
      } else if (failure is UnauthorizedFailure) {
        errorMessage = 'Invalid credentials';
      } else if (failure is NetworkFailure) {
        errorMessage = 'No internet connection';
      } else {
        errorMessage = failure.message;
      }

      emit(state.copyWith(
        status: LoginStatus.error,
        errorMessage: errorMessage,
      ));
    },
    (user) {
      emit(state.copyWith(
        status: LoginStatus.success,
        user: user,
      ));
    },
  );
}
```

### 8.2 Global Error Handler

```dart
// lib/main.dart
void main() {
  // Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);

    if (kReleaseMode) {
      // Send to crash reporting
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    } else {
      // Log in debug mode
      AppLogger.e(
        'Flutter Error',
        error: details.exception,
        stackTrace: details.stack,
      );
    }
  };

  // Catch async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      AppLogger.e('Async Error', error: error, stackTrace: stack);
    }
    return true;
  };

  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const MyApp());
    },
    (error, stack) {
      if (kReleaseMode) {
        FirebaseCrashlytics.instance.recordError(error, stack);
      } else {
        AppLogger.e('Zone Error', error: error, stackTrace: stack);
      }
    },
  );
}
```

### 8.3 Retry Logic

```dart
// lib/core/utils/retry.dart
class RetryConfig {
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffMultiplier;

  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
  });
}

Future<Either<Failure, T>> withRetry<T>(
  Future<Either<Failure, T>> Function() action, {
  RetryConfig config = const RetryConfig(),
}) async {
  int attempt = 0;
  Duration delay = config.initialDelay;

  while (attempt < config.maxAttempts) {
    final result = await action();

    // Success
    if (result.isRight()) {
      return result;
    }

    // Check if retryable
    final failure = result.getLeft();
    if (failure is! NetworkFailure && failure is! ServerFailure) {
      return result;  // Don't retry validation errors
    }

    attempt++;
    if (attempt >= config.maxAttempts) {
      return result;  // Max retries reached
    }

    // Exponential backoff
    await Future.delayed(delay);
    delay *= config.backoffMultiplier;
  }

  return const Left(ServerFailure(message: 'Max retries exceeded'));
}

// Usage
Future<Either<Failure, User>> login(String email, String password) {
  return withRetry(() => _repository.login(email, password));
}
```

---

## 9. Logging & Monitoring

### 9.1 AppLogger Utility

**Structured logging:**

```dart
// lib/core/utils/app_logger.dart
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  // Debug (only in debug mode)
  static void d(String message, {String? tag, Object? data}) {
    if (kDebugMode) {
      _logger.d('[$tag] $message', data);
    }
  }

  // Info
  static void i(String message, {String? tag}) {
    _logger.i('[$tag] $message');
  }

  // Warning
  static void w(String message, {String? tag, Object? data}) {
    _logger.w('[$tag] $message', data);
  }

  // Error
  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e('[$tag] $message', error, stackTrace);

    // Send to crash reporting in production
    if (kReleaseMode && error != null) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }
}
```

**Usage:**

```dart
// ✅ Good logging
class ChatRepository {
  Future<Either<Failure, List<Message>>> getMessages(String botId) async {
    AppLogger.d('Fetching messages for bot: $botId', tag: 'ChatRepository');

    try {
      final messages = await _remoteDataSource.getMessages(botId);
      AppLogger.i('Fetched ${messages.length} messages', tag: 'ChatRepository');
      return Right(messages);
    } catch (e, stackTrace) {
      AppLogger.e(
        'Failed to fetch messages',
        tag: 'ChatRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

### 9.2 Network Logging

**Dio logging interceptor:**

```dart
dio.interceptors.add(LogInterceptor(
  requestHeader: kDebugMode,
  requestBody: kDebugMode,
  responseHeader: kDebugMode,
  responseBody: kDebugMode,
  error: true,
  logPrint: (obj) => AppLogger.d(obj.toString(), tag: 'Network'),
));
```

### 9.3 Performance Monitoring

**Track critical operations:**

```dart
class PerformanceMonitor {
  static Future<T> track<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await operation();
      stopwatch.stop();

      final duration = stopwatch.elapsedMilliseconds;
      AppLogger.i(
        '$operationName completed in ${duration}ms',
        tag: 'Performance',
      );

      // Send to analytics if slow
      if (duration > 2000) {
        FirebasePerformance.instance
            .newTrace(operationName)
            ..start()
            ..setMetric('duration_ms', duration)
            ..stop();
      }

      return result;
    } catch (e) {
      stopwatch.stop();
      AppLogger.e(
        '$operationName failed after ${stopwatch.elapsedMilliseconds}ms',
        tag: 'Performance',
        error: e,
      );
      rethrow;
    }
  }
}

// Usage
final messages = await PerformanceMonitor.track(
  'fetch_chat_messages',
  () => _repository.getMessages(botId),
);
```

---

## 10. Database & Offline-First

### 10.1 Database Schema Design

**Normalization & Indexes:**

```sql
-- Messages table
CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  bot_id TEXT NOT NULL,
  content TEXT NOT NULL,
  is_user INTEGER NOT NULL,
  timestamp TEXT NOT NULL,
  server_created_at TEXT,
  is_synced INTEGER DEFAULT 0,
  sync_status TEXT DEFAULT 'pending',
  UNIQUE(id, user_id)
);

-- Indexes for performance
CREATE INDEX idx_messages_user_bot_timestamp
ON messages(user_id, bot_id, timestamp DESC);

CREATE INDEX idx_messages_sync
ON messages(user_id, is_synced, sync_status);

-- User table
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

### 10.2 Progressive Migrations

```dart
class DatabaseHelper {
  static const int _currentVersion = 7;

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    AppLogger.i('Upgrading database from v$oldVersion to v$newVersion');

    // Progressive migrations
    if (oldVersion < 2) await _migrateToV2(db);
    if (oldVersion < 3) await _migrateToV3(db);
    if (oldVersion < 4) await _migrateToV4(db);
    if (oldVersion < 5) await _migrateToV5(db);
    if (oldVersion < 6) await _migrateToV6(db);
    if (oldVersion < 7) await _migrateToV7(db);
  }

  Future<void> _migrateToV3(Database db) async {
    // Add user_id for multi-user support
    await db.execute('ALTER TABLE messages ADD COLUMN user_id TEXT');
    await db.execute('UPDATE messages SET user_id = "default"');
    await db.execute('CREATE INDEX idx_messages_user ON messages(user_id)');
  }

  Future<void> _migrateToV7(Database db) async {
    // Add chart data support
    await db.execute('ALTER TABLE messages ADD COLUMN chart_data TEXT');
    await db.execute('ALTER TABLE messages ADD COLUMN table_data TEXT');
  }
}
```

### 10.3 Offline-First Pattern

**Write to local DB first:**

```dart
class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<Either<Failure, SendMessageResponse>> sendMessage(
    SendMessageParams params,
  ) async {
    try {
      // 1. Save to local DB immediately (optimistic)
      final localMessage = Message(
        id: const Uuid().v4(),
        content: params.content,
        isUser: true,
        timestamp: DateTime.now().toIso8601String(),
        isSynced: false,
        syncStatus: 'pending',
      );

      await _localDataSource.saveMessage(localMessage);

      // 2. Try to send to server
      try {
        final response = await _remoteDataSource.sendMessage(params);

        // 3. Update local DB with server response
        await _localDataSource.updateMessageSyncStatus(
          localMessage.id,
          isSynced: true,
          serverId: response.userMessage.id,
        );

        // Save bot response
        await _localDataSource.saveMessage(response.botMessage);

        return Right(response);

      } on DioException catch (e) {
        if (_isNetworkError(e)) {
          // 4. Network error - keep in local queue for later sync
          AppLogger.w('Message saved locally, will sync when online');
          return Right(SendMessageResponse(
            userMessage: localMessage,
            botMessage: Message.pendingBotMessage(),
          ));
        }
        rethrow;
      }

    } catch (e, stackTrace) {
      AppLogger.e('Send message error', error: e, stackTrace: stackTrace);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String botId) async {
    try {
      // 1. Load from local DB first (cache-first)
      final cachedMessages = await _localDataSource.getMessages(botId);

      // 2. Return cached immediately
      if (cachedMessages.isNotEmpty) {
        // Fetch new messages in background
        _fetchAndUpdateMessages(botId);
        return Right(cachedMessages);
      }

      // 3. No cache - fetch from server
      final serverMessages = await _remoteDataSource.getMessages(botId);

      // 4. Save to local DB
      await _localDataSource.saveMessages(serverMessages);

      return Right(serverMessages);

    } catch (e, stackTrace) {
      AppLogger.e('Get messages error', error: e, stackTrace: stackTrace);

      // Try to return cached data even on error
      final cachedMessages = await _localDataSource.getMessages(botId);
      if (cachedMessages.isNotEmpty) {
        return Right(cachedMessages);
      }

      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

### 10.4 Background Sync

```dart
// Setup WorkManager for background sync
void setupBackgroundSync() {
  Workmanager().initialize(callbackDispatcher);

  Workmanager().registerPeriodicTask(
    'sync-messages',
    'syncPendingMessages',
    frequency: const Duration(hours: 1),
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
    ),
  );
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'syncPendingMessages':
        await _syncPendingMessages();
        return true;
      default:
        return false;
    }
  });
}

Future<void> _syncPendingMessages() async {
  final pendingMessages = await _localDataSource.getPendingMessages();

  for (final message in pendingMessages) {
    try {
      final response = await _remoteDataSource.sendMessage(
        SendMessageParams.fromMessage(message),
      );

      await _localDataSource.updateMessageSyncStatus(
        message.id,
        isSynced: true,
        serverId: response.userMessage.id,
      );

      AppLogger.i('Synced message: ${message.id}');
    } catch (e) {
      AppLogger.e('Failed to sync message: ${message.id}', error: e);
    }
  }
}
```

### 10.5 Cache Eviction

```dart
// Prevent database bloat
class CacheManager {
  static const int _maxMessagesPerBot = 1000;
  static const int _maxAgeDays = 90;

  Future<void> evictOldMessages() async {
    final db = await DatabaseHelper.instance.database;
    final cutoffDate = DateTime.now()
        .subtract(const Duration(days: _maxAgeDays))
        .toIso8601String();

    // Keep only recent messages per bot
    await db.execute('''
      DELETE FROM messages
      WHERE id NOT IN (
        SELECT id FROM messages
        WHERE user_id = ?
        ORDER BY timestamp DESC
        LIMIT ?
      )
      AND timestamp < ?
    ''', [userId, _maxMessagesPerBot, cutoffDate]);

    AppLogger.i('Evicted old messages');
  }
}
```

---

## 11. API Integration

### 11.1 API Client Configuration

**Dio setup with interceptors:**

```dart
class DioClient {
  static Dio createDio({
    required String baseUrl,
    required SecureStorageService secureStorage,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Auth interceptor
    dio.interceptors.add(AuthInterceptor(secureStorage));

    // Logging interceptor (debug only)
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => AppLogger.d(obj.toString(), tag: 'API'),
      ));
    }

    // Retry interceptor
    dio.interceptors.add(RetryInterceptor(dio: dio));

    return dio;
  }
}
```

**Auth interceptor with token refresh:**

```dart
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth header
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 - refresh token
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _secureStorage.getRefreshToken();
        if (refreshToken != null) {
          // Refresh token
          final newToken = await _refreshAccessToken(refreshToken);
          await _secureStorage.saveToken(newToken);

          // Retry original request
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          final response = await Dio().fetch(options);
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed - logout user
        AppLogger.e('Token refresh failed', error: e);
        // Navigate to login
      }
    }

    handler.next(err);
  }

  Future<String> _refreshAccessToken(String refreshToken) async {
    final response = await Dio().post(
      '/api/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    return response.data['accessToken'];
  }
}
```

### 11.2 API Response Handling

**Standardized response models:**

```dart
// Base response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }
}

// Usage in data source
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );

    final apiResponse = ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw ServerException(apiResponse.message ?? 'Login failed');
    }

    return apiResponse.data!;
  }
}
```

### 11.3 Pagination

**Cursor-based pagination:**

```dart
class PaginatedResponse<T> {
  final List<T> data;
  final String? nextCursor;
  final bool hasMore;
  final int total;

  const PaginatedResponse({
    required this.data,
    this.nextCursor,
    required this.hasMore,
    required this.total,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginatedResponse(
      data: (json['data'] as List)
          .map((item) => fromJsonT(item))
          .toList(),
      nextCursor: json['nextCursor'],
      hasMore: json['hasMore'] ?? false,
      total: json['total'] ?? 0,
    );
  }
}

// Usage
Future<PaginatedResponse<MessageModel>> getMessages({
  required String botId,
  String? cursor,
  int limit = 50,
}) async {
  final response = await _dio.get(
    '/api/chat/messages',
    queryParameters: {
      'botId': botId,
      'limit': limit,
      if (cursor != null) 'cursor': cursor,
    },
  );

  return PaginatedResponse.fromJson(
    response.data,
    (json) => MessageModel.fromJson(json as Map<String, dynamic>),
  );
}
```

---

## 12. UI/UX Standards

### 12.1 Design System

**AppPalette (Centralized Colors):**

```dart
// lib/core/theme/app_palette.dart
class AppPalette {
  // Primary colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);

  // Semantic colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Neutral colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF94A3B8);

  // Never use raw colors in widgets!
  // ❌ Color(0xFF6366F1)
  // ✅ AppPalette.primary
}
```

**AppTypography:**

```dart
class AppTypography {
  static const String fontFamily = 'Inter';

  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.25,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Labels
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
}
```

### 12.2 Responsive Design

**Screen size breakpoints:**

```dart
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }
}

// Usage
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (Breakpoints.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
```

### 12.3 Loading States

**Shimmer placeholders:**

```dart
class MessageShimmer extends StatelessWidget {
  const MessageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppPalette.surfaceLight,
      highlightColor: AppPalette.surfaceLight.withOpacity(0.5),
      child: Column(
        children: List.generate(
          5,
          (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### 12.4 Error States

**Standardized error widget:**

```dart
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppPalette.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTypography.bodyLarge.copyWith(
                color: AppPalette.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## 13. Accessibility

### 13.1 Semantic Labels

```dart
// ✅ Good: Semantic labels for screen readers
Semantics(
  label: 'Login button',
  button: true,
  enabled: true,
  child: ElevatedButton(
    onPressed: _login,
    child: const Text('Login'),
  ),
)

// Form fields
TextField(
  decoration: InputDecoration(
    labelText: sl<AuthStrings>().emailLabel,
    hintText: sl<AuthStrings>().emailHint,
    semanticCounterText: 'Email address input field',
  ),
)
```

### 13.2 Contrast Ratios

**Ensure WCAG AA compliance (4.5:1 for normal text):**

```dart
// ✅ Good contrast
const textColor = Color(0xFF0F172A);  // Dark text
const backgroundColor = Color(0xFFFFFFFF);  // White background
// Contrast ratio: 16.1:1 ✅

// ❌ Bad contrast
const textColor = Color(0xFFCCCCCC);  // Light gray text
const backgroundColor = Color(0xFFFFFFFF);  // White background
// Contrast ratio: 1.6:1 ❌ (fails WCAG)
```

### 13.3 Touch Target Sizes

```dart
// Minimum 48x48 dp touch targets
const minTouchTargetSize = 48.0;

InkWell(
  onTap: _onTap,
  child: Container(
    constraints: const BoxConstraints(
      minWidth: minTouchTargetSize,
      minHeight: minTouchTargetSize,
    ),
    child: const Icon(Icons.close),
  ),
)
```

---

## 14. Internationalization

### 14.1 String Architecture

**Interface-based approach:**

```dart
// Abstract contract
abstract class AuthStrings {
  String get loginTitle;
  String get emailLabel;
  String get passwordLabel;
  String get loginButton;
  String loginError(String error);
}

// English implementation
class AuthStringsEn implements AuthStrings {
  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String loginError(String error) => 'Login failed: $error';
}

// Bangla implementation
class AuthStringsBn implements AuthStrings {
  @override
  String get loginTitle => 'স্বাগতম';

  @override
  String get emailLabel => 'ইমেইল';

  @override
  String get passwordLabel => 'পাসওয়ার্ড';

  @override
  String get loginButton => 'লগইন';

  @override
  String loginError(String error) => 'লগইন ব্যর্থ: $error';
}
```

**Register in DI:**

```dart
// Determine language
final locale = PlatformDispatcher.instance.locale;
final isBangla = locale.languageCode == 'bn';

// Register appropriate implementation
if (isBangla) {
  sl.registerLazySingleton<AuthStrings>(() => const AuthStringsBn());
} else {
  sl.registerLazySingleton<AuthStrings>(() => const AuthStringsEn());
}
```

**Usage in widgets:**

```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final strings = sl<AuthStrings>();

    return Scaffold(
      appBar: AppBar(title: Text(strings.loginTitle)),
      body: Column(
        children: [
          TextField(decoration: InputDecoration(
            labelText: strings.emailLabel,
          )),
          TextField(decoration: InputDecoration(
            labelText: strings.passwordLabel,
          )),
          ElevatedButton(
            onPressed: _login,
            child: Text(strings.loginButton),
          ),
        ],
      ),
    );
  }
}
```

---

## 15. Build & Deployment

### 15.1 Flavors (Dev/Staging/Prod)

**Build flavors:**

```bash
# Development
flutter run --flavor dev -t lib/main_dev.dart

# Staging
flutter run --flavor staging -t lib/main_staging.dart

# Production
flutter run --flavor prod -t lib/main_prod.dart
```

**Environment config:**

```dart
// lib/core/config/environment_config.dart
enum Environment { dev, staging, prod }

class EnvironmentConfig {
  static Environment _env = Environment.prod;

  static void setEnvironment(Environment env) {
    _env = env;
  }

  static String get baseUrl {
    switch (_env) {
      case Environment.dev:
        return 'https://dev-api.dolfin.ai';
      case Environment.staging:
        return 'https://staging-api.dolfin.ai';
      case Environment.prod:
        return 'https://api.dolfin.ai';
    }
  }

  static bool get useMockData => _env == Environment.dev;
  static bool get enableLogging => _env != Environment.prod;
}

// lib/main_dev.dart
void main() {
  EnvironmentConfig.setEnvironment(Environment.dev);
  runApp(const MyApp());
}
```

### 15.2 Release Build

**Android:**

```bash
# Build APK
flutter build apk \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols \
  --target-platform android-arm64

# Build App Bundle (for Play Store)
flutter build appbundle \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

**iOS:**

```bash
# Build IPA
flutter build ipa \
  --release \
  --obfuscate \
  --split-debug-info=build/ios/outputs/symbols
```

### 15.3 CI/CD Pipeline

**GitHub Actions:**

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.27.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Run analyzer
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info | grep -oP 'lines......: \K\d+')
          echo "Coverage: $COVERAGE%"
          if [ $COVERAGE -lt 80 ]; then
            echo "❌ Coverage $COVERAGE% is below 80% threshold"
            exit 1
          fi

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: coverage/lcov.info

  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2

      - name: Build APK
        run: flutter build apk --release

      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## 16. Documentation

### 16.1 Code Documentation

**Public API documentation:**

```dart
/// Authenticates a user with email and password.
///
/// This use case validates the input, calls the repository,
/// and returns either a [User] on success or a [Failure].
///
/// Example:
/// ```dart
/// final result = await login('user@example.com', 'password123');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (user) => print('Logged in: ${user.name}'),
/// );
/// ```
///
/// Throws:
/// - [ValidationFailure] if email/password is invalid
/// - [NetworkFailure] if no internet connection
/// - [ServerFailure] for server errors
class Login {
  final AuthRepository repository;

  Login(this.repository);

  /// Calls the login operation.
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password
  ///
  /// Returns:
  /// - [Right(User)] on successful login
  /// - [Left(Failure)] on error
  Future<Either<Failure, User>> call(String email, String password) {
    return repository.login(email, password);
  }
}
```

### 16.2 Feature README

**Example: packages/features/feature_auth/README.md**

```markdown
# Feature Auth

Authentication feature module for Dolfin AI.

## Features

- Email/Password login
- Google Sign-In
- Email verification
- Password reset
- Profile management

## Architecture

Clean Architecture with 3 layers:

```
feature_auth/
├── domain/          # Business logic
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/            # Data access
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/    # UI
    ├── cubits/
    ├── pages/
    └── widgets/
```

## Usage

### Installation

```yaml
dependencies:
  feature_auth:
    path: ../packages/features/feature_auth
```

### Initialization

```dart
await initAuthFeature(sl, AuthFeatureConfig(
  authConfig: AuthConfig(baseUrl: 'https://api.example.com'),
  secureStorage: sl(),
  sharedPreferences: sl(),
  dio: sl(),
));
```

### Navigation

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const LoginPage()),
);
```

## Testing

Run tests:
```bash
cd packages/features/feature_auth
flutter test
```

Coverage: 90%+ (22 tests)

## API

See [API_ENDPOINTS.md](API_ENDPOINTS.md) for backend integration details.
```

### 16.3 ADR (Architecture Decision Records)

**Example: docs/adr/0001-use-clean-architecture.md**

```markdown
# ADR 0001: Use Clean Architecture

## Status

Accepted

## Context

We need a scalable, testable architecture for a multi-feature finance app.

## Decision

We will use Clean Architecture with 3 layers: Domain, Data, Presentation.

## Consequences

### Positive
- ✅ Testability: Domain layer is pure Dart
- ✅ Maintainability: Clear separation of concerns
- ✅ Scalability: Easy to add features
- ✅ Team collaboration: Clear boundaries

### Negative
- ❌ Initial complexity: More files and abstractions
- ❌ Learning curve: Team needs training

## Alternatives Considered

- MVC: Too coupled, hard to test
- MVVM: Better, but lacks strict layering
- Feature-first only: No domain abstraction

## Implementation

See: `workspacecontext/project_architecture.md`

## Date

2024-12-01

## Authors

- Tech Lead
```

---

## 17. Code Review Checklist

### 17.1 Architecture Review

- [ ] Clean Architecture layers respected (domain → data → presentation)
- [ ] No circular dependencies
- [ ] Use cases have single responsibility
- [ ] Repository interfaces in domain, implementations in data
- [ ] No Flutter imports in domain layer

### 17.2 Code Quality

- [ ] All public APIs documented
- [ ] Null safety enforced
- [ ] `const` constructors used where possible
- [ ] No hardcoded strings (use string architecture)
- [ ] No hardcoded colors (use AppPalette)
- [ ] `@override` annotations present
- [ ] `@immutable` on state classes
- [ ] Equatable for value equality

### 17.3 Testing

- [ ] Unit tests for use cases (100% target)
- [ ] Unit tests for cubits (100% target)
- [ ] Unit tests for repositories (90% target)
- [ ] Widget tests for new UI components
- [ ] Integration tests for critical flows
- [ ] Mocks properly implemented

### 17.4 Security

- [ ] Sensitive data stored in SecureStorageService
- [ ] All user input validated with InputValidator
- [ ] API errors handled properly
- [ ] No sensitive data in logs
- [ ] Auth tokens refreshed correctly

### 17.5 Performance

- [ ] `const` constructors used
- [ ] RepaintBoundary for expensive widgets
- [ ] ListView.builder for lists
- [ ] Proper dispose() calls
- [ ] No memory leaks

### 17.6 UI/UX

- [ ] Follows design system (AppPalette, AppTypography)
- [ ] Loading states implemented (shimmer)
- [ ] Error states implemented (ErrorView)
- [ ] Responsive design (mobile/tablet/desktop)
- [ ] Accessibility labels present
- [ ] Touch targets ≥48dp

### 17.7 Documentation

- [ ] Code documented (public APIs)
- [ ] README updated if needed
- [ ] ADR created for major decisions
- [ ] CHANGELOG updated

---

## 18. Continuous Improvement

### 18.1 Technical Debt Management

**Track and prioritize debt:**

```markdown
# Technical Debt Log

## P0 - Critical
- [ ] Increase widget test coverage to 80%
- [ ] Add certificate pinning for production

## P1 - High
- [ ] Migrate to injectable for DI
- [ ] Add golden tests for critical UI
- [ ] Implement database encryption

## P2 - Medium
- [ ] Add code splitting for features
- [ ] Optimize image loading
- [ ] Add performance budgets
```

### 18.2 Code Metrics Dashboard

**Track quality metrics:**

- Test coverage (target: 80%+)
- Code duplication (target: <5%)
- Cyclomatic complexity (target: <10 per method)
- Build time (target: <5min)
- APK size (target: <50MB)

### 18.3 Regular Audits

**Quarterly reviews:**

- Security audit
- Performance profiling
- Dependency updates
- Architecture review
- Test coverage audit

### 18.4 Learning & Training

- Architecture workshops
- Testing best practices
- Flutter updates training
- Security awareness
- Code review standards

---

## Appendix

### A. Useful Commands

```bash
# Analysis
flutter analyze
dart fix --dry-run
dart fix --apply

# Testing
flutter test
flutter test --coverage
flutter test test/features/auth/

# Build
flutter build apk --release
flutter build appbundle --release
flutter build ios --release

# Clean
flutter clean
flutter pub get

# Melos (monorepo)
melos bootstrap
melos run analyze
melos run test
melos run format
```

### B. Key File Locations

```
workspacecontext/
├── codebase_assessment.md          # Quality metrics
├── project_architecture.md         # Architecture docs
├── development_guidelines.md       # Dev standards
└── PRODUCTION_READY_GUIDELINES.md  # This file

apps/dolfin_ai/
├── lib/core/di/injection_container.dart  # DI setup
├── lib/core/theme/app_palette.dart       # Colors
├── lib/core/utils/app_logger.dart        # Logging
└── lib/core/database/database_helper.dart # Database

packages/core/dolfin_core/
├── lib/storage/secure_storage_service.dart  # Secure storage
├── lib/utils/input_validator.dart           # Validation
└── lib/error/failures.dart                  # Error types
```

### C. External Resources

- [Flutter Best Practices](https://flutter.dev/docs/perf/best-practices)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [WCAG Accessibility](https://www.w3.org/WAI/WCAG21/quickref/)
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)

---

**Document Version:** 1.0
**Last Updated:** December 28, 2025
**Maintained By:** Dolfin AI Tech Team
