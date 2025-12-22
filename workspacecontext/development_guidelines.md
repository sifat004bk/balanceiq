# Development Guidelines

This document provides detailed guidelines for developing within the Dolfin Workspace monorepo.

## 1. String Architecture & Localization

We follow a **Clean Architecture-compliant, centralized string management** strategy. We use Dependency Injection (DI) to inject string implementations, allowing for easy testing, localization updates, and A/B testing variations.

### Core Principles
- **No Hardcoded Strings**: All user-facing text must be extracted.
- **Dependency Injection**: Features define string *interfaces*, and Apps provide *implementations*.
- **Separation**: Core strings are separate from Feature strings and App-specific strings.

### String Layers

| Layer | Location | Purpose |
| :--- | :--- | :--- |
| **Common/Core** | `dolfin_core/lib/constants/core_strings.dart` | Shared terms (e.g., "Save", "Cancel", "Error") used globally. |
| **Feature** | `packages/features/<feature>/lib/constants/` | Feature-specific terms (e.g., "Login", "Welcome back"). |
| **App-Specific** | `apps/<app>/lib/core/strings/` | Strings unique to a specific app (e.g., "Dashboard", "Home"). |

### How to Add New Strings

#### 1. Define the Interface
- **If Shared**: Add getter to `CommonStrings` or `CoreStrings` in `dolfin_core`.
- **If Feature-Specific**: Add getter to `FeatureStrings` abstract class in the feature package.
- **If App-Specific**: Create/Update `DashboardStrings` (or similar) interface in `apps/<app>/lib/core/strings/`.

```dart
// Example: packages/features/feature_examples/lib/constants/example_strings.dart
abstract class ExampleStrings {
  String get exampleTitle;
  String get clickMe;
}
```

#### 2. Implement in App(s)
- Create or update the implementation class in `apps/<app>/lib/core/strings/`.
- Ensure you implement *all* getters from the interface.

```dart
// Example: apps/dolfin_ai/lib/core/strings/example_strings_impl.dart
class ExampleStringsImpl implements ExampleStrings {
  @override
  String get exampleTitle => 'Dolfin Examples';
  @override
  String get clickMe => 'Tap to Continue';
}
```

#### 3. Register in DI
- Register the implementation as a `LazySingleton` in the app's injection container.

```dart
// apps/dolfin_ai/lib/core/di/injection_container.dart
sl.registerLazySingleton<ExampleStrings>(() => ExampleStringsImpl());
```

#### 4. Usage in Code
- Inject the interface into your Widgets, Cubits, or UseCases.
- Or use `GetIt.I<ExampleStrings>()` directly in widgets if constructor injection is too verbose for simple UI strings.

```dart
Text(GetIt.I<ExampleStrings>().exampleTitle)
```

## 2. Theming & App Palette

We use a **centralized Palette system** to enforce design consistency.

### Location
- **Interface**: `dolfin_ui_kit/lib/theme/app_palette.dart` defines the abstract `AppPalette`.
- **Implementation**: Apps provide concrete implementations (e.g., `DolfinAiPalette`) in `apps/<app>/lib/core/theme/`.

### How to Use
- **Do NOT** use `Colors.red` or `Color(0xFF...)` directly.
- Use `AppPalette` via `Theme.of(context)` extension (if available) or direct injection/access.
- **Text Styles**: Use `Theme.of(context).textTheme`.

```dart
Container(
  color: GetIt.I<AppPalette>().primaryLight,
  child: Text('Hello', style: Theme.of(context).textTheme.bodyLarge),
)
```

## 3. App Constants & Config

Global configuration values are managed via `AppConstants`.

### Location
- **Interface**: `dolfin_core/lib/constants/app_constants.dart`
- **Implementation**: `apps/<app>/lib/core/config/app_constants_impl.dart`

### Guidelines
- Store non-secret configuration here (Timers, Limits, Feature Flags).
- **Secrets** (API Keys) should be handled via `flutter_dotenv` or Environment Variables, NOT committed directly in `AppConstants` if possible (though `AppConstants` often exposes them after reading from Env).

## 4. Network Configuration & API Endpoints

### Network Config
- managed by `dolfin_core`'s `NetworkModule` or similar.
- Base URLs and timeouts are configured in `apps/<app>/lib/core/config/app_network_config.dart`.

### API Endpoints
- Define endpoints in `dolfin_core/lib/constants/api_endpoints.dart` if shared.
- Or in Feature constants if specific to a feature.

```dart
// dolfin_core/lib/constants/api_endpoints.dart
class ApiEndpoints {
  static const String login = '/auth/login';
}
```
