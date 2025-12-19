# BalanceIQ - Comprehensive Code Refactoring Plan

## Executive Summary

**Objective:** Transform BalanceIQ into an industry-standard, secure, testable, and maintainable Flutter application.

**Current State:** 158 Dart files, 6.5/10 code quality score, 2 test files (minimal coverage)
**Target State:** 9/10 code quality with 70%+ test coverage

---

## Table of Contents

1. [Refactoring Principles](#1-refactoring-principles)
2. [Phase 1: Security Hardening](#2-phase-1-security-hardening-critical)
3. [Phase 2: Core Layer Refactoring](#3-phase-2-core-layer-refactoring)
4. [Phase 3: Feature-wise Refactoring](#4-phase-3-feature-wise-refactoring)
5. [Phase 4: Testing Implementation](#5-phase-4-testing-implementation)
6. [Widget Composition Guidelines](#6-widget-composition-guidelines)
7. [Code Style & Standards](#7-code-style--standards)
8. [File Structure Conventions](#8-file-structure-conventions)
9. [Performance Optimization](#9-performance-optimization)
10. [Appendix: Detailed File Issues](#10-appendix-detailed-file-issues)

---

## 1. Refactoring Principles

### SOLID Principles Application

| Principle | Implementation Strategy |
|-----------|------------------------|
| **Single Responsibility** | Each class/widget does ONE thing. Cubits handle ONE feature. |
| **Open/Closed** | Use composition over inheritance. Abstract interfaces for extensions. |
| **Liskov Substitution** | Mock data sources interchangeable with real ones. |
| **Interface Segregation** | Small, focused interfaces. Split large data source interfaces. |
| **Dependency Inversion** | Depend on abstractions. Inject dependencies via GetIt. |

### DRY (Don't Repeat Yourself)

- Extract shared logic into mixins, base classes, or utility functions
- Create reusable widgets for common UI patterns
- Centralize error handling, validation, and conversion logic

### Widget Composition Rules

```
Rule 1: No widget build() method exceeds 50 lines
Rule 2: Extract widgets >15 lines to separate classes/methods
Rule 3: Composed widgets live in sibling directory with same name
Rule 4: One widget per file (exceptions: private helper widgets)
```

### Comment Philosophy

```dart
// BAD: Comments that explain WHAT
// Get the user name
final name = user.name;

// GOOD: Comments that explain WHY (for complex scenarios only)
// Using exponential backoff to prevent API rate limiting
// after consecutive failures. Max 3 retries with 2^n seconds delay.
await _retryWithBackoff(apiCall);
```

---

## 2. Phase 1: Security Hardening (CRITICAL)

### Priority: P0 - Must complete before any release

### 2.1 Secure Token Storage

**Current Issue:** Tokens stored in `SharedPreferences` (world-readable on rooted devices)

**Files to Modify:**
- `lib/core/network/auth_interceptor.dart`
- `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `lib/core/di/injection_container.dart`

**Implementation:**

```dart
// Add to pubspec.yaml
dependencies:
  flutter_secure_storage: ^9.0.0

// Create: lib/core/storage/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearAllTokens();
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId = 'user_id';

  SecureStorageServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        );

  @override
  Future<String?> getToken() => _storage.read(key: _keyAccessToken);

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _keyAccessToken, value: token);

  @override
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _keyRefreshToken, value: token);

  @override
  Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefreshToken);

  @override
  Future<void> clearAllTokens() => _storage.deleteAll();

  @override
  Future<void> saveUserId(String userId) =>
      _storage.write(key: _keyUserId, value: userId);

  @override
  Future<String?> getUserId() => _storage.read(key: _keyUserId);
}
```

**Migration Steps:**
1. Create `SecureStorageService` abstraction
2. Register in DI container
3. Update `AuthInterceptor` to use `SecureStorageService`
4. Update all data sources using SharedPreferences for tokens
5. Add migration logic for existing users (move tokens on first launch)

### 2.2 Remove Token Logging

**Files:** `lib/core/network/auth_interceptor.dart`

**Current (INSECURE):**
```dart
if (kDebugMode) {
  print('Token being used: ${token.substring(0, 20)}...');
}
```

**Fixed:**
```dart
// NEVER log tokens - log only what's needed for debugging
if (kDebugMode) {
  print('[AuthInterceptor] Token attached to: ${options.path}');
}
```

### 2.3 Input Validation Layer

**Create:** `lib/core/validation/input_validator.dart`

```dart
abstract class InputValidator {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .trim();
  }
}
```

### 2.4 Security Checklist

- [ ] Migrate tokens from SharedPreferences to flutter_secure_storage
- [ ] Remove ALL token logging (even partial tokens)
- [ ] Add input validation before all API calls
- [ ] Implement certificate pinning (optional, P2)
- [ ] Validate all user input on client side
- [ ] Use HTTPS only, reject HTTP connections

---

## 3. Phase 2: Core Layer Refactoring

### 3.1 Theme System Overhaul

**Current Issues:**
- Hardcoded colors in widgets (`Colors.green`, `Colors.red`)
- Theme values not centralized
- GenUI charts use non-theme colors

**Directory Structure:**
```
lib/core/theme/
├── app_theme.dart              # Main theme configuration
├── app_palette.dart            # Color definitions (refactored)
├── app_typography.dart         # Text styles
├── app_dimensions.dart         # Spacing, radius, elevation
└── theme_extensions/
    ├── chart_theme.dart        # Chart-specific colors
    └── component_theme.dart    # Custom component themes
```

**Refactored `app_palette.dart`:**

```dart
import 'package:flutter/material.dart';

class AppPalette {
  // Semantic colors - use these in widgets
  static const Color income = Color(0xFF4CAF50);
  static const Color expense = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // Chart color palette - theme-aware
  static List<Color> getChartColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? _darkChartColors : _lightChartColors;
  }

  static const List<Color> _lightChartColors = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
  ];

  static const List<Color> _darkChartColors = [
    Color(0xFF818CF8),
    Color(0xFFA78BFA),
    Color(0xFFF472B6),
    Color(0xFFFBBF24),
    Color(0xFF34D399),
    Color(0xFF60A5FA),
  ];

  // Category colors - deterministic by name
  static Color getCategoryColor(String categoryName, BuildContext context) {
    final colors = getChartColors(context);
    final index = categoryName.hashCode.abs() % colors.length;
    return colors[index];
  }
}
```

### 3.2 Dependency Injection Refactoring

**Current Issue:** Monolithic `injection_container.dart` with conditional logic

**New Structure:**
```
lib/core/di/
├── injection_container.dart      # Main entry point
├── modules/
│   ├── network_module.dart       # Dio, interceptors
│   ├── storage_module.dart       # Database, secure storage
│   ├── auth_module.dart          # Auth feature DI
│   ├── chat_module.dart          # Chat feature DI
│   └── home_module.dart          # Home feature DI
└── environments/
    ├── production_module.dart    # Production data sources
    └── mock_module.dart          # Mock data sources
```

**Example Module:**

```dart
// lib/core/di/modules/auth_module.dart
import 'package:get_it/get_it.dart';

class AuthModule {
  static void register(GetIt sl, {bool useMocks = false}) {
    // Data Sources
    if (useMocks) {
      sl.registerLazySingleton<AuthRemoteDataSource>(
        () => MockAuthRemoteDataSource(),
      );
    } else {
      sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
          dio: sl(),
          secureStorage: sl(),
        ),
      );
    }

    // Repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()),
    );

    // Use Cases
    sl.registerLazySingleton(() => Login(sl()));
    sl.registerLazySingleton(() => SignUp(sl()));
    sl.registerLazySingleton(() => SignOut(sl()));

    // Cubits - Factory for fresh instances
    sl.registerFactory(() => AuthCubit(
      login: sl(),
      signUp: sl(),
      signOut: sl(),
    ));
  }
}
```

### 3.3 Error Handling Standardization

**Create:** `lib/core/error/app_exception.dart`

```dart
sealed class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalError});
}

class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.originalError});
}

class ValidationException extends AppException {
  final Map<String, String> fieldErrors;
  const ValidationException(super.message, {this.fieldErrors = const {}});
}

class StorageException extends AppException {
  const StorageException(super.message, {super.code, super.originalError});
}
```

**Create:** `lib/core/error/error_handler.dart`

```dart
import 'package:dio/dio.dart';

class ErrorHandler {
  static AppException handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    if (error is AppException) {
      return error;
    }
    return NetworkException(
      'An unexpected error occurred',
      originalError: error,
    );
  }

  static NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timed out');
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);
      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');
      default:
        return NetworkException('Network error: ${error.message}');
    }
  }

  static NetworkException _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 401:
        return const AuthException('Session expired. Please login again.');
      case 403:
        return const AuthException('Access denied');
      case 404:
        return const NetworkException('Resource not found');
      case 500:
        return const NetworkException('Server error. Please try again.');
      default:
        return NetworkException('Error: $statusCode');
    }
  }
}
```

---

## 4. Phase 3: Feature-wise Refactoring

### 4.1 Auth Feature

#### Current Issues:
1. `AuthCubit` has 11 use case dependencies (violates SRP)
2. Token storage insecure
3. Presentation layer handles business logic

#### Refactored Structure:
```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   └── auth_local_datasource.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   └── auth_response_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── user.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login.dart
│       ├── signup.dart
│       ├── logout.dart
│       ├── google_signin.dart
│       ├── apple_signin.dart
│       └── refresh_token.dart
└── presentation/
    ├── cubits/
    │   ├── auth_cubit.dart              # Login/Signup/Logout only
    │   ├── password_reset_cubit.dart    # Password reset flow
    │   └── email_verification_cubit.dart # Email verification
    ├── pages/
    │   ├── login_page.dart
    │   ├── signup_page.dart
    │   ├── forgot_password_page.dart
    │   └── verify_email_page.dart
    └── widgets/
        ├── login_form/
        │   ├── login_form.dart
        │   ├── email_field.dart
        │   └── password_field.dart
        ├── social_auth/
        │   ├── social_auth_buttons.dart
        │   ├── google_signin_button.dart
        │   └── apple_signin_button.dart
        └── common/
            ├── auth_text_field.dart
            └── auth_submit_button.dart
```

#### Split AuthCubit:

**Before:** Single AuthCubit with 11 dependencies
**After:** 3 focused cubits

```dart
// lib/features/auth/presentation/cubits/auth_cubit.dart
class AuthCubit extends Cubit<AuthState> {
  final Login _login;
  final SignUp _signUp;
  final SignOut _signOut;
  final GoogleSignIn _googleSignIn;
  final AppleSignIn _appleSignIn;
  final GetCurrentUser _getCurrentUser;

  AuthCubit({
    required Login login,
    required SignUp signUp,
    required SignOut signOut,
    required GoogleSignIn googleSignIn,
    required AppleSignIn appleSignIn,
    required GetCurrentUser getCurrentUser,
  })  : _login = login,
        _signUp = signUp,
        _signOut = signOut,
        _googleSignIn = googleSignIn,
        _appleSignIn = appleSignIn,
        _getCurrentUser = getCurrentUser,
        super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _login(LoginParams(email: email, password: password));
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      )),
    );
  }
}
```

```dart
// lib/features/auth/presentation/cubits/password_reset_cubit.dart
class PasswordResetCubit extends Cubit<PasswordResetState> {
  final ForgotPassword _forgotPassword;
  final ResetPassword _resetPassword;
  final VerifyResetOtp _verifyResetOtp;

  // Handles ONLY password reset flow
}
```

### 4.2 Chat Feature

#### Current Issues:
1. `FloatingChatInput` (842 lines) - too complex, handles text + audio + image
2. `SimpleChatInput` (781 lines) - duplicates 80% of FloatingChatInput
3. `MessageBubble` (674 lines) - handles rendering + feedback + actions

#### Refactored Structure:
```
lib/features/chat/
└── presentation/
    └── widgets/
        ├── chat_input/
        │   ├── chat_input.dart             # Main input (composed)
        │   ├── chat_input_mixin.dart       # Shared logic
        │   ├── text_input_field.dart
        │   ├── audio_recorder/
        │   │   ├── audio_recorder_button.dart
        │   │   ├── recording_indicator.dart
        │   │   └── audio_preview.dart
        │   ├── image_picker/
        │   │   ├── image_picker_button.dart
        │   │   └── image_preview.dart
        │   └── send_button.dart
        ├── message_bubble/
        │   ├── message_bubble.dart         # Main bubble (composed)
        │   ├── text_message.dart
        │   ├── image_message.dart
        │   ├── audio_message.dart
        │   ├── feedback_buttons.dart
        │   └── message_actions.dart
        └── message_list/
            ├── message_list.dart
            └── message_item.dart
```

#### Extract Shared Logic with Mixin:

```dart
// lib/features/chat/presentation/widgets/chat_input/chat_input_mixin.dart
mixin ChatInputMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController textController;
  late final FocusNode focusNode;

  bool get hasText => textController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void clearInput() {
    textController.clear();
  }

  String getAndClearText() {
    final text = textController.text.trim();
    clearInput();
    return text;
  }
}
```

### 4.3 Home Feature

#### Current Issues:
1. `HomePage` has complex initialization in `initState`
2. `TransactionsPage` handles filter logic in view
3. `TransactionDetailModal` (790 lines) too large

#### Refactored Structure:
```
lib/features/home/
└── presentation/
    ├── cubits/
    │   ├── dashboard_cubit.dart
    │   ├── transactions_cubit.dart
    │   └── transactions_filter_cubit.dart  # NEW - handles filter logic
    └── widgets/
        ├── dashboard/
        │   ├── dashboard_header.dart
        │   ├── balance_card.dart
        │   ├── spending_chart.dart
        │   └── quick_actions.dart
        ├── transactions/
        │   ├── transaction_list.dart
        │   ├── transaction_item.dart
        │   ├── transaction_filters/
        │   │   ├── filter_bar.dart
        │   │   ├── date_filter.dart
        │   │   └── category_filter.dart
        │   └── transaction_detail/
        │       ├── transaction_detail_modal.dart  # ~80 lines
        │       ├── detail_header.dart
        │       ├── detail_body.dart
        │       └── detail_actions.dart
```

---

## 5. Phase 4: Testing Implementation

### 5.1 Test Structure

```
test/
├── core/
│   ├── network/
│   │   ├── auth_interceptor_test.dart
│   │   └── dio_client_test.dart
│   ├── storage/
│   │   └── secure_storage_test.dart
│   └── validation/
│       └── input_validator_test.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource_test.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl_test.dart
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── login_test.dart
│   │   │       └── signup_test.dart
│   │   └── presentation/
│   │       ├── cubits/
│   │       │   └── auth_cubit_test.dart
│   │       └── widgets/
│   │           └── login_form_test.dart
│   ├── chat/
│   │   └── ... (same structure)
│   └── home/
│       └── ... (same structure)
├── mocks/
│   ├── mock_repositories.dart
│   ├── mock_datasources.dart
│   └── mock_cubits.dart
└── helpers/
    ├── pump_app.dart
    └── test_fixtures.dart
```

### 5.2 Test Templates

#### Cubit Test Template:

```dart
// test/features/auth/presentation/cubits/auth_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLogin extends Mock implements Login {}

void main() {
  late AuthCubit authCubit;
  late MockLogin mockLogin;

  setUp(() {
    mockLogin = MockLogin();
    authCubit = AuthCubit(login: mockLogin, /* other deps */);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state is AuthState.initial', () {
      expect(authCubit.state, const AuthState.initial());
    });

    blocTest<AuthCubit, AuthState>(
      'emits [loading, authenticated] when login succeeds',
      build: () {
        when(() => mockLogin(any())).thenAnswer(
          (_) async => Right(testUser),
        );
        return authCubit;
      },
      act: (cubit) => cubit.login('test@email.com', 'password'),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        AuthState(status: AuthStatus.authenticated, user: testUser),
      ],
    );
  });
}
```

### 5.3 Test Coverage Targets

| Layer | Current | Target | Priority |
|-------|---------|--------|----------|
| Domain (Use Cases) | 0% | 90% | P1 |
| Data (Repositories) | 5% | 80% | P1 |
| Data (Data Sources) | 5% | 70% | P2 |
| Presentation (Cubits) | 0% | 85% | P1 |
| Presentation (Widgets) | 0% | 60% | P2 |
| Core (Utils) | 0% | 90% | P1 |

---

## 6. Widget Composition Guidelines

### Directory Structure for Composed Widgets

```
widgets/
├── feature_widget.dart           # Main widget (entry point)
└── feature_widget/               # Sibling directory with same name
    ├── sub_widget_a.dart
    ├── sub_widget_b.dart
    └── sub_widget_c.dart
```

### Breaking Down Large Widgets

**Before (transaction_detail_modal.dart - 790 lines):**
```dart
class TransactionDetailModal extends StatefulWidget {
  // 790 lines of mixed concerns
}
```

**After:**
```
widgets/
├── transaction_detail_modal.dart         # ~80 lines
└── transaction_detail/
    ├── detail_header.dart                # ~40 lines
    ├── detail_amount_section.dart        # ~50 lines
    ├── detail_info_section.dart          # ~60 lines
    ├── detail_notes_section.dart         # ~45 lines
    ├── detail_actions.dart               # ~50 lines
    └── edit_transaction_form.dart        # ~100 lines
```

**Refactored Main Widget:**

```dart
// widgets/transaction_detail_modal.dart
class TransactionDetailModal extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onClose;
  final Function(Transaction) onEdit;
  final VoidCallback onDelete;

  const TransactionDetailModal({
    super.key,
    required this.transaction,
    required this.onClose,
    required this.onEdit,
    required this.onDelete,
  });

  static Future<void> show(BuildContext context, Transaction transaction) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TransactionDetailModal(
        transaction: transaction,
        onClose: () => Navigator.pop(context),
        onEdit: (t) => Navigator.pop(context, t),
        onDelete: () => Navigator.pop(context, 'delete'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DetailHeader(transaction: transaction, onClose: onClose),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DetailAmountSection(transaction: transaction),
                  DetailInfoSection(transaction: transaction),
                  DetailNotesSection(transaction: transaction),
                ],
              ),
            ),
          ),
          DetailActions(onEdit: () => onEdit(transaction), onDelete: onDelete),
        ],
      ),
    );
  }
}
```

### Widget Size Guidelines

| Widget Type | Max Lines | Action if Exceeded |
|-------------|-----------|-------------------|
| StatelessWidget.build() | 50 | Extract sub-widgets |
| StatefulWidget.build() | 50 | Extract sub-widgets |
| Helper method | 15 | Extract to widget |
| initState() | 10 | Create initialization cubit |
| dispose() | 10 | Use mixin for cleanup |

---

## 7. Code Style & Standards

### Naming Conventions

```dart
// Files: snake_case
auth_cubit.dart
login_page.dart

// Classes: PascalCase
class AuthCubit {}
class LoginPage {}

// Variables/Methods: camelCase
final userName = 'John';
void getUserData() {}

// Constants: camelCase or SCREAMING_SNAKE_CASE
const maxRetries = 3;
const API_TIMEOUT = Duration(seconds: 30);

// Private: prefix with underscore
String _privateField;
void _privateMethod() {}
```

### Import Order

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:io';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Third-party packages (alphabetical)
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 4. Project imports - Core
import 'package:balance_iq/core/constants/app_strings.dart';

// 5. Project imports - Features (relative when in same feature)
import '../cubits/auth_cubit.dart';
```

### Documentation Rules

**DO document:**
- Complex algorithms with non-obvious logic
- Public API methods that will be used by other modules
- Non-standard workarounds with reasoning

**DON'T document:**
- Obvious code (getters, setters, simple methods)
- What the code does (code should be self-explanatory)
- Standard patterns that are clear from context

---

## 8. File Structure Conventions

### Feature Module Template

```
lib/features/{feature_name}/
├── data/
│   ├── datasources/
│   │   ├── {feature}_remote_datasource.dart
│   │   ├── {feature}_local_datasource.dart
│   │   └── {feature}_mock_datasource.dart
│   ├── models/
│   │   └── {entity}_model.dart
│   └── repositories/
│       └── {feature}_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── {entity}.dart
│   ├── repositories/
│   │   └── {feature}_repository.dart
│   └── usecases/
│       ├── get_{entity}.dart
│       ├── create_{entity}.dart
│       └── update_{entity}.dart
└── presentation/
    ├── cubits/
    │   ├── {feature}_cubit.dart
    │   └── {feature}_state.dart
    ├── pages/
    │   └── {feature}_page.dart
    └── widgets/
        ├── {main_widget}.dart
        └── {main_widget}/
            ├── sub_widget_a.dart
            └── sub_widget_b.dart
```

---

## 9. Performance Optimization

### Isolates for Heavy Operations

```dart
// Use compute() for CPU-intensive tasks
import 'package:flutter/foundation.dart';

Future<List<Transaction>> parseTransactions(String jsonData) async {
  return compute(_parseTransactionsIsolate, jsonData);
}

List<Transaction> _parseTransactionsIsolate(String jsonData) {
  final decoded = jsonDecode(jsonData) as List;
  return decoded.map((e) => Transaction.fromJson(e)).toList();
}
```

### ListView Optimization

```dart
// DO: Use ListView.builder for long lists
ListView.builder(
  itemCount: messages.length,
  itemBuilder: (context, index) {
    return MessageItem(
      key: ValueKey(messages[index].id),
      message: messages[index],
    );
  },
)

// DO: Use const constructors where possible
const MessageDivider()
```

### Image Optimization

```dart
// Cache and compress images
CachedNetworkImage(
  imageUrl: url,
  memCacheHeight: 300,
)

// Compress before upload
final compressedImage = await FlutterImageCompress.compressWithFile(
  file.path,
  quality: 80,
  minHeight: 1024,
  minWidth: 1024,
);
```

### Memory Management

- Dispose all controllers in StatefulWidgets
- Cancel subscriptions in dispose()
- Reuse Dio instances (singleton pattern)
- Use weak references for large cached objects

---

## 10. Appendix: Detailed File Issues

### Critical Files Requiring Immediate Attention

| File | Lines | Issues | Priority |
|------|-------|--------|----------|
| `auth_interceptor.dart` | 194 | Token logging, SharedPreferences | P0 |
| `auth_remote_datasource.dart` | 100+ | Token storage insecure | P0 |
| `floating_chat_input.dart` | 842 | SRP violation, duplication | P1 |
| `simple_chat_input.dart` | 781 | 80% duplicate of floating | P1 |
| `message_bubble.dart` | 674 | Too many responsibilities | P1 |
| `transaction_detail_modal.dart` | 790 | Too large, mixed concerns | P1 |
| `auth_cubit.dart` | 150+ | 11 dependencies, SRP violation | P1 |
| `gen_ui_chart.dart` | ~200 | Hardcoded colors | P2 |
| `transactions_page.dart` | ~400 | Hardcoded colors | P2 |

### Files with Hardcoded Values to Fix

| File | Issue | Fix |
|------|-------|-----|
| `gen_ui_chart.dart:18-27` | Hardcoded color palette | Use `AppPalette.getChartColors(context)` |
| `transactions_page.dart` | `Colors.green`, `Colors.red` | Use `AppPalette.income`, `AppPalette.expense` |
| `date_selector_bottom_sheet.dart` | `Colors.white` | Use `Theme.of(context).colorScheme.surface` |
| `app_theme.dart` | Hardcoded radius `24` | Use `DesignConstants.radiusL` |

---

## Execution Checklist

### Phase 1: Security (P0)
- [ ] Create `SecureStorageService` abstraction
- [ ] Migrate token storage to flutter_secure_storage
- [ ] Remove all token logging
- [ ] Add input validation layer

### Phase 2: Core (P1)
- [ ] Refactor theme system with theme extensions
- [ ] Split `injection_container.dart` into modules
- [ ] Standardize error handling with `AppException`

### Phase 3: Features (P1)
- [ ] Split `AuthCubit` into 3 focused cubits
- [ ] Extract shared chat input logic with mixin
- [ ] Break down large widgets:
  - [ ] `FloatingChatInput` → 5+ widgets
  - [ ] `MessageBubble` → 6+ widgets
  - [ ] `TransactionDetailModal` → 6+ widgets
- [ ] Create `TransactionsFilterCubit`

### Phase 4: Testing (P2)
- [ ] Add Cubit tests (6 files)
- [ ] Add Repository tests (3 files)
- [ ] Add Use Case tests (10+ files)
- [ ] Add critical Widget tests (10 files)
- [ ] Achieve 60% overall coverage

---

**Document Version:** 2.0
**Created:** 2025-12-20
**Author:** Claude (AI Assistant)
**Last Updated:** 2025-12-20
