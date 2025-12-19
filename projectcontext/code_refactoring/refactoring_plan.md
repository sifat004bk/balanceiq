# BalanceIQ - Master Refactoring Plan

## 1. Executive Summary

**Objective:** Transform BalanceIQ into an industry-standard, secure, testable, and maintainable Flutter application.

**Target Metrices:**
*   **Code Quality:** 9/10
*   **Test Coverage:** 70%+
*   **Security:** Zero P0/P1 vulnerabilities
*   **Performance:** 60 FPS consistent rendering

**Core Policies:**
1.  **Strict Widget Decomposition:** No widget > 15 lines. No file > 150 lines.
2.  **Minimal Comments:** Comments < 5% of code. Only explain "Why", never "What".
3.  **Zero Console Noise:** No `print()` statements. Use structured logging.
4.  **User-Centric Errors:** Application errors displayed via nice Snackbars, not crashes.
5.  **Clean Code:** `dart format` and strict linter rules applied globally.

---

## 2. Refactoring Principles & Policies

### 2.1 Code Style & Standards (Strict)

*   **File Size Limit:** **Soft limit: 150 lines**. Any file exceeding this MUST be candidates for immediate splitting.
*   **Comment Policy:**
    *   **Maximum 5% comment-to-code ratio** (approx 5 lines of comments per 100 lines of code).
    *   **Rule:** Delete comments that explain what code does. Keep only those explaining complex business logic decisions.
*   **Logging:**
    *   **FORBIDDEN:** `print('something')`
    *   **REQUIRED:** `log('message', name: 'AuthCubit')` or `AppLogger.info(...)`
*   **Formatting:** Run `dart format .` before every commit.
*   **Linting:** Fix ALL linter warnings. No `ignore_for_file` unless absolutely necessary and documented.
*   **Imports Organization:**
    1.  Dart SDK (`dart:async`)
    2.  Flutter (`package:flutter`)
    3.  Third-party (`package:dio`)
    4.  Core (`package:balance_iq/core/...`)
    5.  Features/Relative (`../widgets/button.dart`)

### 2.2 Widget Composition Guidelines

*   **The 15-Line Rule:** Extract UI logic into sub-widgets if it exceeds 15-20 lines.
*   **Sibling Directory Pattern:**
    ```
    presentation/
      pages/
        home_page.dart         # The composed page
        home_page_widgets/     # Directory for its parts
          balance_header.dart
          transactions_list.dart
    ```
*   **Build Method Limit:** `build()` methods must be declarative pipelines, not logic dumps.

### 2.3 Error Handling & User Feedback

*   **User Facing:** Use **Snackbars** for operational errors (e.g., "No internet", "Invalid login").
*   **System Internal:** Log to crash reporting (Crashlytics) silently.
*   **UI Resilience:** Never show grey screen (Red Screen of Death). Use `ErrorWidget.builder` override or local error boundaries.

---

## 3. Phase 1: Security Hardening (P0 - Critical)

### 3.1 Input Validation
*   **Rule:** NEVER trust user input or API responses.
*   **Action:** Implement `InputValidator` class in Core.
    *   Validate Emails (RegExp).
    *   Sanitize Strings (prevent XSS/Injection).
    *   Validate Numbers (non-negative currency).

### 3.2 Secure Storage
*   **Migration:** Replace `SharedPreferences` with `flutter_secure_storage` for:
    *   Auth Tokens (Access/Refresh)
    *   User IDs
    *   PII (Personally Identifiable Information)

### 3.3 Logs & leaking
*   **Audit:** Grep codebase for `print(token)`. Remove all sensitive data logging.

---

## 4. Phase 2: Core Layer & Infrastructure

### 4.1 Accessibility (A11y)
*   **Semantics:** Wrap interactive elements in `Semantics` widgets where purpose isn't obvious.
*   **Tap Targets:** Enforce minimum 44x44px for all touch targets.
*   **Scale:** Ensure UI doesn't break on Text Scale Factor > 1.0.

### 4.2 Localization (l10n)
*   **Migration:** Move hardcoded strings to `AppStrings` (Step 1) and then to ARB files (Step 2) for true localization support.

### 4.3 CI/CD & Automation
*   **Hooks:** Set up pre-commit hook to run:
    1.  `dart format .`
    2.  `flutter analyze`
    3.  `flutter test`

---

## 5. Phase 3: Feature Refactoring

### 5.1 Auth Feature
*   **Refactor `AuthCubit`:** Split into `LoginCubit`, `SignupCubit`, `SessionCubit`.
*   **UI:** ensure `LoginPage` is just a scaffold for `LoginForm` widget.

### 5.2 Chat Feature (High Complexity)
*   **Input Widget:** Breaking `FloatingChatInput` (800+ lines) into:
    *   `ChatInputContainer`
    *   `ChatTextField`
    *   `ChatAttachmentButton`
    *   `ChatMicButton`
*   **Messages:** Breaking `MessageBubble` into `TextMessage`, `AudioMessage`, `ImageMessage`.

### 5.3 Home Feature
*   **dashboard:** Isolate "Tour" logic into a `TourController` mixin or separate controller, removing clutter from `HomePage` state.
*   **Transactions:** Move filter logic out of UI into `TransactionFilterCubit`.

---

## 6. Detailed Implementation Strategy

### 6.1 Directory Structure
```
lib/
  core/
    constants/
    di/
    error/
      error_handler.dart  # Centralized error mapping
      failures.dart
    theme/
    utils/
      input_validator.dart
      app_logger.dart
  features/
    [feature_name]/
      data/
      domain/
      presentation/
        cubit/
        pages/
          [page_name].dart
          [page_name]_widgets/  <-- Sibling folder
            component_a.dart
            component_b.dart
```

### 6.2 Testing Strategy
*   **Unit Tests:** Focus on Repositories, UseCases, and InputValidator.
*   **Widget Tests:** Focus on smallest decomposed widgets (e.g. `ChatMicButton`).
*   **Integration:** Test full Login flow and Chat sending flow.

----
**Status:** Approved for execution.
**Version:** 3.0 (Strict Policies Added)
