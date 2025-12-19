# BalanceIQ - Refactoring Task Plan

## Overview

This document breaks down the Master Refactoring Plan into actionable tasks with clear acceptance criteria, dependencies, and tracking.

**Legend:**
- `[ ]` - Not started
- `[~]` - In progress
- `[x]` - Completed
- `[!]` - Blocked

---

## Phase 1: Security Hardening (P0 - Critical)

### Task 1.1: Create Secure Storage Service

**Priority:** P0 | **Status:** `[ ]`

**Description:** Replace SharedPreferences with flutter_secure_storage for all sensitive data.

**Sub-tasks:**
- [x] 1.1.1 Add `flutter_secure_storage: ^9.0.0` to pubspec.yaml
- [x] 1.1.2 Create `lib/core/storage/secure_storage_service.dart` (abstract interface)
- [x] 1.1.3 Create `lib/core/storage/secure_storage_service_impl.dart` (implementation)
- [x] 1.1.4 Register in `lib/core/di/injection_container.dart`
- [x] 1.1.5 Write unit tests for SecureStorageService

**Files to Create:**
```
lib/core/storage/
├── secure_storage_service.dart
└── secure_storage_service_impl.dart
```

**Acceptance Criteria:**
- [ ] Abstract interface defined with methods: `getToken()`, `saveToken()`, `getRefreshToken()`, `saveRefreshToken()`, `getUserId()`, `saveUserId()`, `clearAll()`
- [ ] Implementation uses `FlutterSecureStorage` with Android encrypted shared preferences
- [ ] iOS configured with `KeychainAccessibility.first_unlock`
- [ ] Unit tests cover all methods with 100% coverage
- [ ] No compile errors after integration

**Dependencies:** None

---

### Task 1.2: Migrate Token Storage from SharedPreferences

**Priority:** P0 | **Status:** `[ ]`

**Description:** Update all files using SharedPreferences for tokens to use SecureStorageService.

**Sub-tasks:**
- [x] 1.2.1 Update `lib/core/network/auth_interceptor.dart`
- [x] 1.2.2 Update `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- [x] 1.2.3 Update `lib/features/auth/data/repositories/auth_repository_impl.dart`
- [x] 1.2.4 Update `lib/features/chat/presentation/cubit/chat_cubit.dart` (userId retrieval)
- [x] 1.2.5 Search for any other SharedPreferences token usage: `grep -r "getString.*token" lib/`
- [ ] 1.2.6 Add migration logic for existing users (one-time token transfer)

**Files to Modify:**
```
lib/core/network/auth_interceptor.dart
lib/features/auth/data/datasources/auth_remote_datasource.dart
lib/features/auth/data/repositories/auth_repository_impl.dart
lib/features/chat/presentation/cubit/chat_cubit.dart
```

**Acceptance Criteria:**
- [ ] Zero references to SharedPreferences for tokens remain
- [ ] Existing logged-in users don't get logged out (migration works)
- [ ] Auth interceptor attaches token correctly to requests
- [ ] Token refresh flow works with new storage

**Dependencies:** Task 1.1

---

### Task 1.3: Remove Sensitive Data Logging

**Priority:** P0 | **Status:** `[ ]`

**Description:** Audit and remove all token/sensitive data logging from codebase.

**Sub-tasks:**
- [ ] 1.3.1 Search: `grep -rn "print.*token" lib/`
- [ ] 1.3.2 Search: `grep -rn "print.*password" lib/`
- [ ] 1.3.3 Search: `grep -rn "print.*key" lib/`
- [ ] 1.3.4 Update `auth_interceptor.dart` - remove token substring logging
- [ ] 1.3.5 Review all `kDebugMode` blocks for sensitive data exposure
- [ ] 1.3.6 Replace with safe logging (path only, no values)

**Files to Audit:**
```
lib/core/network/auth_interceptor.dart
lib/features/auth/data/datasources/*.dart
lib/features/chat/data/datasources/*.dart
```

**Acceptance Criteria:**
- [ ] `grep -rn "print.*token" lib/` returns zero results
- [ ] No partial token logging (e.g., `token.substring(0, 20)`)
- [ ] Debug logs only show: request path, status code, timing

**Dependencies:** None

---

### Task 1.4: Create Input Validation Layer

**Priority:** P0 | **Status:** `[ ]`

**Description:** Implement centralized input validation for security and UX.

**Sub-tasks:**
- [x] 1.4.1 Create `lib/core/utils/input_validator.dart`
- [x] 1.4.2 Implement email validation (RFC 5322 compliant regex)
- [x] 1.4.3 Implement password validation (min 8 chars, complexity rules)
- [ ] 1.4.4 Implement string sanitization (XSS prevention)
- [ ] 1.4.5 Implement amount validation (non-negative, max value)
- [ ] 1.4.6 Write comprehensive unit tests
- [ ] 1.4.7 Integrate with auth forms

**File to Create:**
```
lib/core/utils/input_validator.dart
test/core/utils/input_validator_test.dart
```

**Acceptance Criteria:**
- [ ] Email validator rejects: `test`, `test@`, `@test.com`, accepts: `test@email.com`
- [ ] Password validator enforces: min 8 chars
- [ ] Sanitizer removes: `<script>`, HTML tags, SQL injection attempts
- [ ] 100% test coverage on validator
- [ ] Login/Signup forms use validator

**Dependencies:** None

---

### Task 1.5: Create Structured Logging System

**Priority:** P0 | **Status:** `[ ]`

**Description:** Replace all `print()` statements with structured logging.

**Sub-tasks:**
- [x] 1.5.1 Create `lib/core/utils/app_logger.dart`
- [x] 1.5.2 Implement log levels: `debug`, `info`, `warning`, `error`
- [x] 1.5.3 Add log filtering for release builds
- [x] 1.5.4 Search and replace all `print()`: `grep -rn "print(" lib/` (Critical paths done)
- [ ] 1.5.5 Add Crashlytics integration for error level (optional)

**File to Create:**
```
lib/core/utils/app_logger.dart
```

**Implementation:**
```dart
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void debug(String message, {String? name}) {
    if (kDebugMode) {
      dev.log(message, name: name ?? 'DEBUG');
    }
  }

  static void info(String message, {String? name}) {
    dev.log(message, name: name ?? 'INFO');
  }

  static void warning(String message, {String? name}) {
    dev.log('⚠️ $message', name: name ?? 'WARNING');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace, String? name}) {
    dev.log('❌ $message', name: name ?? 'ERROR', error: error, stackTrace: stackTrace);
  }
}
```

**Acceptance Criteria:**
- [ ] `grep -rn "print(" lib/` returns zero results (except AppLogger internals)
- [ ] All logs include component name for filtering
- [ ] Release builds don't log debug messages
- [ ] Errors include stack traces

**Dependencies:** None

---

## Phase 2: Core Layer & Infrastructure (P1)

### Task 2.1: Refactor Theme System

**Priority:** P1 | **Status:** `[ ]`

**Description:** Centralize all colors and remove hardcoded values.

**Sub-tasks:**
- [x] 2.1.1 Audit hardcoded colors: `grep -rn "Color(0x" lib/features/`
- [x] 2.1.2 Audit hardcoded colors: `grep -rn "Colors\." lib/features/`
- [x] 2.1.3 Add semantic colors to `app_palette.dart`: `income`, `expense`, `warning`, `info`
- [x] 2.1.4 Create theme-aware chart colors in `app_palette.dart`
- [x] 2.1.5 Update `gen_ui_chart.dart` to use `AppPalette.getChartColors(context)`
- [x] 2.1.6 Update `transactions_page.dart` to use `AppPalette.income/expense`
- [x] 2.1.7 Update `date_selector_bottom_sheet.dart` to use theme colors

**Files to Modify:**
```
lib/core/theme/app_palette.dart
lib/features/chat/presentation/widgets/gen_ui/gen_ui_chart.dart
lib/features/home/presentation/pages/transactions_page.dart
lib/features/home/presentation/widgets/date_selector_bottom_sheet.dart
```

**Acceptance Criteria:**
- [ ] `grep -rn "Colors\.(green|red|white)" lib/features/` returns zero results
- [ ] All charts respect dark/light theme
- [ ] Income always shows in semantic green, expense in semantic red
- [ ] No visual regression in existing UI

**Dependencies:** None

---

### Task 2.2: Standardize Error Handling

**Priority:** P1 | **Status:** `[ ]`

**Description:** Create unified error handling with user-friendly feedback.

**Sub-tasks:**
- [x] 2.2.1 Create `lib/core/error/app_exception.dart` with sealed classes
- [x] 2.2.2 Create `lib/core/error/error_handler.dart` for Dio error mapping
- [x] 2.2.3 Upgrade `lib/core/utils/snackbar_utils.dart` for user feedback
- [x] 2.2.4 Update repositories to use new error types
- [x] 2.2.5 Update cubits to show snackbars on errors
- [x] 2.2.6 Override `ErrorWidget.builder` in main.dart for graceful error screens

**Files to Create:**
```
lib/core/error/app_exception.dart
lib/core/error/error_handler.dart
lib/core/utils/snackbar_helper.dart
```

**Acceptance Criteria:**
- [ ] Network errors show: "No internet connection" snackbar
- [ ] Auth errors show: "Session expired" and redirect to login
- [ ] Server errors show: "Something went wrong" generic message
- [ ] No red error screens visible to users
- [ ] All error messages use AppStrings (localization ready)

**Dependencies:** Task 1.5 (for error logging)

---

### Task 2.3: Split Dependency Injection into Modules

**Priority:** P1 | **Status:** `[ ]`

**Description:** Break monolithic injection_container.dart into feature modules.

**Sub-tasks:**
- [ ] 2.3.1 Create `lib/core/di/modules/` directory
- [ ] 2.3.2 Create `network_module.dart` (Dio, interceptors)
- [ ] 2.3.3 Create `storage_module.dart` (DB, secure storage)
- [ ] 2.3.4 Create `auth_module.dart` (auth feature DI)
- [ ] 2.3.5 Create `chat_module.dart` (chat feature DI)
- [ ] 2.3.6 Create `home_module.dart` (home feature DI)
- [ ] 2.3.7 Refactor `injection_container.dart` to call modules
- [ ] 2.3.8 Remove conditional mock logic (move to separate mock module)

**Files to Create:**
```
lib/core/di/modules/
├── network_module.dart
├── storage_module.dart
├── auth_module.dart
├── chat_module.dart
└── home_module.dart
```

**Acceptance Criteria:**
- [ ] `injection_container.dart` < 50 lines
- [ ] Each module is self-contained and testable
- [ ] Mock mode handled via environment, not conditionals
- [ ] All existing functionality works after refactor

**Dependencies:** Task 1.1 (SecureStorageService must exist)

---

### Task 2.4: Set Up Pre-commit Hooks

**Priority:** P1 | **Status:** `[ ]`

**Description:** Automate code quality checks before commits.

**Sub-tasks:**
- [ ] 2.4.1 Create `.githooks/pre-commit` script
- [ ] 2.4.2 Add `dart format --set-exit-if-changed .` check
- [ ] 2.4.3 Add `flutter analyze --fatal-infos` check
- [ ] 2.4.4 Add `flutter test` execution
- [ ] 2.4.5 Update `README.md` with setup instructions
- [ ] 2.4.6 Add to CLAUDE.md workflow instructions

**File to Create:**
```
.githooks/pre-commit
```

**Script Content:**
```bash
#!/bin/sh
echo "Running pre-commit checks..."

echo "1/3 Checking formatting..."
dart format --set-exit-if-changed . || exit 1

echo "2/3 Running analyzer..."
flutter analyze --fatal-infos || exit 1

echo "3/3 Running tests..."
flutter test || exit 1

echo "All checks passed!"
```

**Acceptance Criteria:**
- [ ] `git config core.hooksPath .githooks` works
- [ ] Unformatted code blocks commit
- [ ] Analyzer warnings block commit
- [ ] Failing tests block commit

**Dependencies:** None

---

## Phase 3: Feature Refactoring (P1)

### Task 3.1: Split AuthCubit

**Priority:** P1 | **Status:** `[ ]`

**Description:** Break AuthCubit into focused, single-responsibility cubits.

**Sub-tasks:**
- [ ] 3.1.1 Create `lib/features/auth/presentation/cubit/login_cubit.dart`
- [ ] 3.1.2 Create `lib/features/auth/presentation/cubit/signup_cubit.dart`
- [ ] 3.1.3 Create `lib/features/auth/presentation/cubit/session_cubit.dart`
- [ ] 3.1.4 Create corresponding state files
- [ ] 3.1.5 Move login logic from AuthCubit to LoginCubit
- [ ] 3.1.6 Move signup logic from AuthCubit to SignupCubit
- [ ] 3.1.7 Move session management to SessionCubit
- [ ] 3.1.8 Update DI registration
- [ ] 3.1.9 Update pages to use new cubits
- [ ] 3.1.10 Write unit tests for each cubit
- [ ] 3.1.11 Delete old AuthCubit (if fully migrated)

**Files to Create:**
```
lib/features/auth/presentation/cubit/
├── login_cubit.dart
├── login_state.dart
├── signup_cubit.dart
├── signup_state.dart
├── session_cubit.dart
└── session_state.dart
```

**Acceptance Criteria:**
- [ ] Each cubit has ≤ 5 dependencies
- [ ] LoginCubit handles: login, googleSignIn, appleSignIn
- [ ] SignupCubit handles: signup, email verification
- [ ] SessionCubit handles: getCurrentUser, logout, session persistence
- [ ] Unit tests cover all state transitions
- [ ] No regression in auth flows

**Dependencies:** Task 1.2 (secure storage migration)

---

### Task 3.2: Decompose FloatingChatInput Widget

**Priority:** P1 | **Status:** `[ ]`

**Description:** Break down 842-line widget into composable parts.

**Sub-tasks:**
- [ ] 3.2.1 Create directory `lib/features/chat/presentation/widgets/chat_input/`
- [ ] 3.2.2 Extract `ChatInputMixin` for shared state logic
- [ ] 3.2.3 Create `chat_text_field.dart` (text input component)
- [ ] 3.2.4 Create `chat_attachment_button.dart` (image picker)
- [ ] 3.2.5 Create `chat_mic_button.dart` (audio recorder trigger)
- [ ] 3.2.6 Create `chat_send_button.dart` (send action)
- [ ] 3.2.7 Create `recording_indicator.dart` (audio recording UI)
- [ ] 3.2.8 Create `chat_input_container.dart` (main composed widget)
- [ ] 3.2.9 Refactor `FloatingChatInput` to use composed widgets
- [ ] 3.2.10 Delete `SimpleChatInput` (merge with floating using props)
- [ ] 3.2.11 Update all usages in chat_page.dart

**Files to Create:**
```
lib/features/chat/presentation/widgets/chat_input/
├── chat_input_container.dart      # Main widget (~50 lines)
├── chat_input_mixin.dart          # Shared logic
├── chat_text_field.dart           # Text input (~40 lines)
├── chat_attachment_button.dart    # Image picker (~30 lines)
├── chat_mic_button.dart           # Mic button (~30 lines)
├── chat_send_button.dart          # Send button (~25 lines)
└── recording_indicator.dart       # Recording UI (~35 lines)
```

**Acceptance Criteria:**
- [ ] No single file > 80 lines
- [ ] `FloatingChatInput` replaced with `ChatInputContainer`
- [ ] `SimpleChatInput` deleted (unified into one component)
- [ ] All existing functionality preserved
- [ ] Widget tests for each component

**Dependencies:** None

---

### Task 3.3: Decompose MessageBubble Widget

**Priority:** P1 | **Status:** `[ ]`

**Description:** Break down 674-line widget into message type components.

**Sub-tasks:**
- [ ] 3.3.1 Create directory `lib/features/chat/presentation/widgets/message_bubble/`
- [ ] 3.3.2 Create `text_message.dart`
- [ ] 3.3.3 Create `image_message.dart`
- [ ] 3.3.4 Create `audio_message.dart`
- [ ] 3.3.5 Create `feedback_buttons.dart` (thumbs up/down)
- [ ] 3.3.6 Create `message_actions.dart` (copy, retry, etc.)
- [ ] 3.3.7 Create `message_bubble_container.dart` (main wrapper)
- [ ] 3.3.8 Refactor original to compose sub-widgets
- [ ] 3.3.9 Write widget tests

**Files to Create:**
```
lib/features/chat/presentation/widgets/message_bubble/
├── message_bubble_container.dart  # Main widget (~60 lines)
├── text_message.dart              # Text content (~40 lines)
├── image_message.dart             # Image content (~50 lines)
├── audio_message.dart             # Audio player (~60 lines)
├── feedback_buttons.dart          # Feedback UI (~35 lines)
└── message_actions.dart           # Action buttons (~40 lines)
```

**Acceptance Criteria:**
- [ ] No single file > 80 lines
- [ ] Message types render correctly
- [ ] Animation still works smoothly
- [ ] Feedback buttons functional
- [ ] Widget tests pass

**Dependencies:** None

---

### Task 3.4: Decompose TransactionDetailModal

**Priority:** P1 | **Status:** `[ ]`

**Description:** Break down 790-line modal into sections.

**Sub-tasks:**
- [ ] 3.4.1 Create directory `lib/features/home/presentation/widgets/transaction_detail/`
- [ ] 3.4.2 Create `detail_header.dart` (title, close button)
- [ ] 3.4.3 Create `detail_amount_section.dart` (amount display)
- [ ] 3.4.4 Create `detail_info_section.dart` (category, date, account)
- [ ] 3.4.5 Create `detail_notes_section.dart` (notes/description)
- [ ] 3.4.6 Create `detail_actions.dart` (edit, delete buttons)
- [ ] 3.4.7 Create `edit_transaction_form.dart` (edit mode)
- [ ] 3.4.8 Create `transaction_detail_modal.dart` (composed main)
- [ ] 3.4.9 Write widget tests

**Files to Create:**
```
lib/features/home/presentation/widgets/transaction_detail/
├── transaction_detail_modal.dart  # Main (~60 lines)
├── detail_header.dart             # (~35 lines)
├── detail_amount_section.dart     # (~40 lines)
├── detail_info_section.dart       # (~50 lines)
├── detail_notes_section.dart      # (~35 lines)
├── detail_actions.dart            # (~40 lines)
└── edit_transaction_form.dart     # (~80 lines)
```

**Acceptance Criteria:**
- [ ] No single file > 100 lines
- [ ] Modal displays correctly
- [ ] Edit mode works
- [ ] Delete confirmation works
- [ ] Widget tests pass

**Dependencies:** Task 2.1 (theme colors for amount display)

---

### Task 3.5: Create TransactionFilterCubit

**Priority:** P1 | **Status:** `[ ]`

**Description:** Move filter logic from TransactionsPage UI to dedicated cubit.

**Sub-tasks:**
- [ ] 3.5.1 Create `lib/features/home/presentation/cubit/transaction_filter_cubit.dart`
- [ ] 3.5.2 Create `transaction_filter_state.dart`
- [ ] 3.5.3 Implement filter logic: date range, category, type
- [ ] 3.5.4 Register in DI
- [ ] 3.5.5 Update `TransactionsPage` to use cubit
- [ ] 3.5.6 Remove filter state from page's StatefulWidget
- [ ] 3.5.7 Write unit tests

**Files to Create:**
```
lib/features/home/presentation/cubit/
├── transaction_filter_cubit.dart
└── transaction_filter_state.dart
```

**Acceptance Criteria:**
- [ ] TransactionsPage is stateless (or minimal state)
- [ ] Filter changes reflected immediately
- [ ] Filter state persists during navigation
- [ ] Unit tests cover all filter combinations

**Dependencies:** None

---

### Task 3.6: Extract Tour Logic from HomePage

**Priority:** P2 | **Status:** `[ ]`

**Description:** Remove tour/onboarding logic clutter from HomePage.

**Sub-tasks:**
- [ ] 3.6.1 Create `lib/features/home/presentation/mixins/tour_mixin.dart`
- [ ] 3.6.2 Move GlobalKey declarations to mixin
- [ ] 3.6.3 Move tour initialization logic to mixin
- [ ] 3.6.4 Move tour step definitions to mixin
- [ ] 3.6.5 Apply mixin to HomePage
- [ ] 3.6.6 Simplify HomePage initState

**File to Create:**
```
lib/features/home/presentation/mixins/tour_mixin.dart
```

**Acceptance Criteria:**
- [ ] HomePage initState < 15 lines
- [ ] Tour still functions correctly
- [ ] Tour logic isolated and testable

**Dependencies:** None

---

## Phase 4: Testing (P2)

### Task 4.1: Set Up Test Infrastructure

**Priority:** P2 | **Status:** `[ ]`

**Description:** Create test helpers and mocks for consistent testing.

**Sub-tasks:**
- [ ] 4.1.1 Add `mocktail: ^1.0.0` and `bloc_test: ^9.0.0` to dev_dependencies
- [ ] 4.1.2 Create `test/mocks/mock_repositories.dart`
- [ ] 4.1.3 Create `test/mocks/mock_datasources.dart`
- [ ] 4.1.4 Create `test/mocks/mock_cubits.dart`
- [ ] 4.1.5 Create `test/helpers/pump_app.dart` (test widget wrapper)
- [ ] 4.1.6 Create `test/helpers/test_fixtures.dart` (sample data)

**Files to Create:**
```
test/
├── mocks/
│   ├── mock_repositories.dart
│   ├── mock_datasources.dart
│   └── mock_cubits.dart
└── helpers/
    ├── pump_app.dart
    └── test_fixtures.dart
```

**Acceptance Criteria:**
- [ ] All repositories have mock implementations
- [ ] pumpApp helper handles theme, localization, DI
- [ ] Test fixtures provide realistic sample data

**Dependencies:** None

---

### Task 4.2: Write Cubit Unit Tests

**Priority:** P2 | **Status:** `[ ]`

**Description:** Achieve 85% coverage on presentation layer cubits.

**Sub-tasks:**
- [ ] 4.2.1 Write tests for `LoginCubit`
- [ ] 4.2.2 Write tests for `SignupCubit`
- [ ] 4.2.3 Write tests for `SessionCubit`
- [ ] 4.2.4 Write tests for `ChatCubit`
- [ ] 4.2.5 Write tests for `DashboardCubit`
- [ ] 4.2.6 Write tests for `TransactionsCubit`
- [ ] 4.2.7 Write tests for `TransactionFilterCubit`

**Files to Create:**
```
test/features/
├── auth/presentation/cubit/
│   ├── login_cubit_test.dart
│   ├── signup_cubit_test.dart
│   └── session_cubit_test.dart
├── chat/presentation/cubit/
│   └── chat_cubit_test.dart
└── home/presentation/cubit/
    ├── dashboard_cubit_test.dart
    ├── transactions_cubit_test.dart
    └── transaction_filter_cubit_test.dart
```

**Acceptance Criteria:**
- [ ] Each cubit has > 85% line coverage
- [ ] All state transitions tested
- [ ] Error states tested
- [ ] Edge cases covered

**Dependencies:** Task 3.1 (split cubits), Task 4.1 (mocks)

---

### Task 4.3: Write Repository Tests

**Priority:** P2 | **Status:** `[ ]`

**Description:** Test repository implementations with mocked data sources.

**Sub-tasks:**
- [ ] 4.3.1 Write tests for `AuthRepositoryImpl`
- [ ] 4.3.2 Write tests for `ChatRepositoryImpl`
- [ ] 4.3.3 Write tests for `DashboardRepositoryImpl`
- [ ] 4.3.4 Write tests for `TransactionsRepositoryImpl`

**Files to Create:**
```
test/features/
├── auth/data/repositories/auth_repository_impl_test.dart
├── chat/data/repositories/chat_repository_impl_test.dart
└── home/data/repositories/
    ├── dashboard_repository_impl_test.dart
    └── transactions_repository_impl_test.dart
```

**Acceptance Criteria:**
- [ ] Each repository has > 80% coverage
- [ ] Success and failure paths tested
- [ ] Error mapping tested

**Dependencies:** Task 4.1 (mocks)

---

### Task 4.4: Write Core Utility Tests

**Priority:** P2 | **Status:** `[ ]`

**Description:** Test core utilities with 90%+ coverage.

**Sub-tasks:**
- [ ] 4.4.1 Write tests for `InputValidator`
- [ ] 4.4.2 Write tests for `SecureStorageService`
- [ ] 4.4.3 Write tests for `ErrorHandler`
- [ ] 4.4.4 Write tests for `AppLogger` (mock logging)

**Files to Create:**
```
test/core/
├── utils/input_validator_test.dart
├── storage/secure_storage_service_test.dart
├── error/error_handler_test.dart
└── utils/app_logger_test.dart
```

**Acceptance Criteria:**
- [ ] InputValidator: 100% coverage
- [ ] SecureStorageService: 90% coverage
- [ ] ErrorHandler: 90% coverage

**Dependencies:** Tasks 1.1, 1.4, 2.2

---

### Task 4.5: Write Widget Tests

**Priority:** P2 | **Status:** `[ ]`

**Description:** Test decomposed widgets in isolation.

**Sub-tasks:**
- [ ] 4.5.1 Write tests for `ChatTextField`
- [ ] 4.5.2 Write tests for `ChatSendButton`
- [ ] 4.5.3 Write tests for `TextMessage`
- [ ] 4.5.4 Write tests for `DetailHeader`
- [ ] 4.5.5 Write tests for `DetailActions`
- [ ] 4.5.6 Write tests for `LoginForm`

**Files to Create:**
```
test/features/
├── chat/presentation/widgets/
│   ├── chat_text_field_test.dart
│   ├── chat_send_button_test.dart
│   └── text_message_test.dart
└── home/presentation/widgets/
    ├── detail_header_test.dart
    └── detail_actions_test.dart
```

**Acceptance Criteria:**
- [ ] Each widget renders correctly
- [ ] User interactions trigger callbacks
- [ ] Accessibility labels present
- [ ] No overflow errors

**Dependencies:** Tasks 3.2, 3.3, 3.4 (widget decomposition)

---

## Phase 5: Code Quality & Polish (P2)

### Task 5.1: Remove Unnecessary Comments

**Priority:** P2 | **Status:** `[ ]`

**Description:** Audit and remove comments that explain "what" instead of "why".

**Sub-tasks:**
- [ ] 5.1.1 Audit `lib/core/` - remove obvious comments
- [ ] 5.1.2 Audit `lib/features/auth/` - remove obvious comments
- [ ] 5.1.3 Audit `lib/features/chat/` - remove obvious comments
- [ ] 5.1.4 Audit `lib/features/home/` - remove obvious comments
- [ ] 5.1.5 Keep only comments explaining business logic decisions
- [ ] 5.1.6 Verify < 5% comment-to-code ratio

**Acceptance Criteria:**
- [ ] No comments like `// Get user`, `// Set loading true`
- [ ] Complex algorithms have explanatory comments
- [ ] TODO comments either actioned or tracked in issues

**Dependencies:** All feature refactoring complete

---

### Task 5.2: Enforce File Size Limits

**Priority:** P2 | **Status:** `[ ]`

**Description:** Ensure no file exceeds 150 lines.

**Sub-tasks:**
- [ ] 5.2.1 Run: `find lib -name "*.dart" -exec wc -l {} + | sort -rn | head -20`
- [ ] 5.2.2 Split any file > 150 lines
- [ ] 5.2.3 Add lint rule or script to check in CI

**Acceptance Criteria:**
- [ ] No Dart file in `lib/` exceeds 150 lines
- [ ] CI check fails on oversized files

**Dependencies:** All decomposition tasks

---

### Task 5.3: Format and Lint Entire Codebase

**Priority:** P2 | **Status:** `[ ]`

**Description:** Apply consistent formatting and fix all linter warnings.

**Sub-tasks:**
- [ ] 5.3.1 Run `dart format .`
- [ ] 5.3.2 Run `flutter analyze` and fix all warnings
- [ ] 5.3.3 Review and update `analysis_options.yaml`
- [ ] 5.3.4 Add strict rules: `prefer_const_constructors`, `avoid_print`
- [ ] 5.3.5 Fix any new warnings from strict rules

**Acceptance Criteria:**
- [ ] `flutter analyze` returns zero warnings
- [ ] `dart format --set-exit-if-changed .` passes
- [ ] `avoid_print` lint rule enabled

**Dependencies:** Task 1.5 (logging system to replace prints)

---

## Summary: Task Execution Order

### Critical Path (P0 - Security)
```
1.1 SecureStorageService → 1.2 Migrate Token Storage → 1.3 Remove Logging
                        ↘
1.4 Input Validation      → 1.5 Structured Logging
```

### Core Infrastructure (P1)
```
2.1 Theme Refactor
2.2 Error Handling → 2.3 DI Modules
2.4 Pre-commit Hooks
```

### Feature Decomposition (P1)
```
3.1 Split AuthCubit
3.2 Decompose ChatInput
3.3 Decompose MessageBubble
3.4 Decompose TransactionDetail
3.5 TransactionFilterCubit
3.6 Tour Mixin
```

### Testing (P2)
```
4.1 Test Infrastructure → 4.2 Cubit Tests → 4.3 Repository Tests
                       ↘ 4.4 Core Tests → 4.5 Widget Tests
```

### Polish (P2)
```
5.1 Remove Comments
5.2 File Size Limits
5.3 Format & Lint
```

---

## Progress Tracking

| Phase | Total Tasks | Completed | Progress |
|-------|-------------|-----------|----------|
| Phase 1: Security | 5 | 0 | 0% |
| Phase 2: Core | 4 | 0 | 0% |
| Phase 3: Features | 6 | 0 | 0% |
| Phase 4: Testing | 5 | 0 | 0% |
| Phase 5: Polish | 3 | 0 | 0% |
| **Total** | **23** | **0** | **0%** |

---

**Document Version:** 1.0
**Created:** 2025-12-20
**Last Updated:** 2025-12-20
