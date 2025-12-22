# Directory Structure

This document outlines the file structure of the **Dolfin Workspace** monorepo.

## Root Directory (`/`)
- `melos.yaml`: Monorepo configuration file defining packages and scripts.
- `pubspec.yaml`: Root dependencies (mostly dev_dependencies like `melos`).
- `apps/`: Container for executable Flutter applications.
- `packages/`: Container for shared libraries and feature packages.

## Apps (`apps/`)

### `dolfin_test`
A test harness application used for integrating and testing features in isolation during development.
- `lib/main.dart`: Entry point, DI initialization.
- `lib/core/di/`: Dependency injection setup (`injection_container.dart`).
- `lib/features/`: App-specific feature integration pages (e.g., `test_home_page.dart`).

### `dolfin_ai`
*Likely main application (based on structure)*.

## Packages (`packages/`)

### Core (`packages/core/`)
Shared utilities and UI components used by multiple features.

- **`dolfin_core`**:
  - `base/`: Base classes for UseCases, ViewModels.
  - `constants/`: App-wide constants (Asset paths, API keys configurations).
  - `network/`: Dio setup, Interceptors, API clients.
  - `storage/`: SecureStorage and SharedPreferences wrappers.
  - `utils/`: Helper functions (Date formatting, String manipulation).

- **`dolfin_ui_kit`**:
  - `theme/`: App theme definitions (Light/Dark mode).
  - `widgets/`: Reusable UI components (Buttons, Inputs, Dialogs).

### Features (`packages/features/`)
Self-contained functional modules implementing Clean Architecture.

- **`feature_auth`**: Authentication logic (Login, Signup, Profile).
- **`feature_chat`**: AI Chat functionality (Messaging, History, Audio/Image support).
- **`feature_subscription`**: In-app purchases and plan management.

#### Standard Feature Structure (e.g., inside `feature_chat`)
```text
lib/
├── data/                  # Data Layer implementation
│   ├── datasources/       # API clients and DB DAOs
│   ├── models/            # JSON serializable objects (DTOs)
│   └── repositories/      # Repository implementation
├── domain/                # Business Logic (Pure Dart)
│   ├── entities/          # Core business objects
│   ├── repositories/      # Interfaces for data access
│   └── usecases/          # Application-specific business rules
└── presentation/          # UI Layer (Flutter)
    ├── cubit/             # State management (Bloc/Cubit)
    ├── pages/             # Full screen widgets
    └── widgets/           # Feature-specific components
```
