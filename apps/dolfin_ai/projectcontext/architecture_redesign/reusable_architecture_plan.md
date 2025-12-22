# Reusable Architecture Strategy for AI Assistant Apps

## 1. Executive Summary

**Objective:** Restructure `balanceIQ` into a modular, reusable ecosystem to rapidly build similar AI-based applications (Diet Assistant, Habit Tracker, Co-Chef) sharing core capabilities (Auth, Chat, Subscription).

**Recommended Approach:** **Monorepo Workspace using Melos**.
While your initial idea of using Git references is valid, a Monorepo with Melos is significantly superior for a suite of closely related apps developed by the same team/person.

### Comparison: Git References vs. Monorepo (Melos)

| Feature | Git Package References (Your Idea) | Monorepo with Melos (Recommended) |
| :--- | :--- | :--- |
| **Setup Cost** | Low initially, High complexity later | Moderate initially, Low maintenance |
| **Dev Velocity** | **Slow**: Change package -> Commit -> Push -> Update Ref -> I/O fetch | **Instant**: Local path linking means changes in `chat` package are instantly visible in `app`. |
| **Versioning** | Hard: "Dependency Hell" if versions drift across apps | Easy: Synchronized versioning of all packages. |
| **Refactoring** | Painful: Breaking changes require updating multiple repos | Easy: Atomic commits across the entire workspace. |
| **CI/CD** | Complex: Needs multiple pipelines | Unified: Build/Test all apps in one pipeline. |

---

## 2. Proposed Architecture: The "Core-Feature-App" Layering

We will transition from a Monolithic App to a **Layered Package Architecture**.

### 🏗️ Workspace Structure
```
workspace/
├── melos.yaml                  # Workspace manager config
├── apps/                       # The concrete applications
│   ├── balance_iq/             # Current App
│   ├── ai_diet_assistant/      # Future App
│   └── ai_co_chef/             # Future App
│
└── packages/
    ├── core/                   # Utilities, Base Classes, Theme Interfaces
    │   ├── balance_core/
    │   └── balance_ui_kit/     # Shared Design System (Buttons, Inputs)
    │
    └── features/               # Smart Business Logic Modules
        ├── feature_auth/       # Login, Signup, Session
        ├── feature_chat/       # The complex Chat UI & Logic
        ├── feature_subscription/# Paywall & Plan Management
        └── feature_ai_client/  # Shared Gemini/LLM Client wrapper
```

### 🔁 Dependency Graph
> Apps depend on Features. Features depend on Core. Core has no dependencies.

`App (BalanceIQ)` -> `[Feature Auth, Feature Chat, Feature Subscription]` -> `[Core, UI Kit]`

---

## 3. Package Design: "The Configuration Pattern"

To make features reusable, they must not hardcode app-specifics. We will use a **Configuration Interface** pattern.

### Example: Feature Auth
Instead of hardcoding "BalanceIQ", the Auth package will accept an `AuthConfig`.

```dart
// In package: feature_auth
class AuthConfig {
  final String appName;
  final String logoAsset;
  final Color primaryColor;
  final Function(BuildContext) onLoginSuccess; // Routing callback

  const AuthConfig({...});
}

### 3.1 Network & API Configuration (Handling Different Base URLs)
To solve the "Different Apps, Different URLs" problem, we will pull `ApiEndpoints` out of global scope and into an injected configuration.

**1. Define Interface in Core:**
```dart
// packages/core/balance_core/lib/config/environment_config.dart
abstract class EnvironmentConfig {
  String get apiBaseUrl;
  String get authBaseUrl;
  // ... other environment specific variables
}
```

**2. Inject in App:**
```dart
// apps/ai_diet_assistant/lib/main.dart
class DietAppEnv implements EnvironmentConfig {
  @override
  String get apiBaseUrl => "https://api.diet-assistant.com";
}

void main() {
  // Config is passed to the core module during init
  initCore(environment: DietAppEnv());
}
```

**3. Use in Features:**
Features will access `GetIt.I<EnvironmentConfig>().apiBaseUrl` instead of a static `ApiEndpoints` class. This allows every app to have completely different backends while using the exact same Chat/Auth code.
// In package: feature_auth extraction
class LoginScreen extends StatelessWidget {
  // It gets config from a Provider/GetIt defined at App level
  ...
}
```

### Example: Feature Chat
The chat environment is the same, but the "Persona" changes.

```dart
// In package: feature_chat
class ChatConfig {
  final String aiName; // "BalanceIQ" vs "Chef Gordan"
  final String welcomeMessage;
  final AiAvatarBuilder avatarBuilder;
  ...
}
```

---

## 4. Migration Plan

We will perform this migration in stages to avoid breaking the current app entirely.

### Phase 1: Workspace Setup (Monorepo)
1.  Initialize `melos` workspace.
2.  Move current `balanceIQ` code into `apps/balance_iq`.
3.  Set up top-level linting and analysis.

### Phase 2: Core Extraction
1.  **Extract `balance_core`**:
    *   `lib/core/error/` (Failures, Exceptions)
    *   `lib/core/storage/` (Secure Storage)
    *   `lib/core/network/` (Dio client - generic)
    *   `lib/core/utils/` (Logger, Validators)
2.  **Extract `balance_ui_kit`**:
    *   `lib/core/theme/` (Extensions, Palette interfaces)
    *   Generic widgets (that don't depend on features).

### Phase 3: Feature Extraction (The "Hard" Part)
1.  **Feature Auth**: Move `lib/features/auth` to `packages/features/feature_auth`.
    *   *Challenge*: Routing.
    *   *Solution*: Remove GoRouter specific routes from the package. Expose `LoginScreen`, `SignupScreen` widgets. Let the App handle navigation mapping.
2.  **Feature Chat**: Move `lib/features/chat`.
    *   *Challenge*: Dependency Injection.
    *   *Solution*: Package defines its own `ChatModule` that the app registers in GetIt.
3.  **Feature Subscription**: Move `lib/features/subscription`.

### Phase 4: App Re-integration
1.  Update `apps/balance_iq/pubspec.yaml` to rely on local path dependencies.
    ```yaml
    dependencies:
      feature_auth:
        path: ../../packages/features/feature_auth
    ```
2.  Wire up the `AppConfig` and Dependency Injection in `main.dart`.

---

## 5. Directory Structure for Redesign Task

I have created `projectcontext/architecture_redesign/` to track this specific effort.

**Files:**
*   `reusable_architecture_plan.md` (This file)
*   `migration_checklist.md` (Checklist for executing the migration)

## 6. Next Steps

1.  Review this plan.
2.  If approved, we start with Phase 1 (moving files to `apps/balance_iq` and init melos).
