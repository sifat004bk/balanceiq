# Project Context

## 1. Project Identity
- **Name**: Dolfin Workspace
- **Type**: Monorepo (Managed by Melos)
- **Primary Domain**: Mobile Application (Likely Fintech/Utility/AI Assistant based on "Finance Guru", "AI", "Subscription" keywords).

## 2. Technology Stack

### Core
- **Framework**: Flutter (Dart)
- **Monorepo Tool**: Melos
- **Architecture**: Modular Feature-First Clean Architecture

### State Management & DI
- **State Management**: `flutter_bloc` (Cubits used extensively)
- **Dependency Injection**: `get_it` (Service Locator pattern)

### Data & Networking
- **Local Database**: `sqflite` (SQLite)
- **Key-Value Storage**: `flutter_secure_storage` / `shared_preferences`
- **Networking**: `dio` (with Interceptors)
- **Functional Utils**: `dartz` (Either<Failure, Success>)

### AI & Features
- **Generative AI**: `google_generative_ai` (Gemini API)
- **Voice/Audio**: `record` package

## 3. Key Workflows

### creating a new Feature
1. Create a new package in `packages/features/`.
2. Determine dependencies (usually `dolfin_core`, `dolfin_ui_kit`).
3. Implement Clean Architecture layers (Data, Domain, Presentation).
4. Register dependencies in a new `initFeatureName` function.
5. Call this init function in the main App's DI container.

### Running the App
- **Test App**: `dolfin_test` (Entry: `apps/dolfin_test/lib/main.dart`)
  - Used for isolated feature testing.
  - Mock data sources can be toggled via `useMockDataSource` flag in config.
- **Main App**: `dolfin_ai` (Likely entry: `apps/dolfin_ai/lib/main.dart`)

## 4. Coding Standards
- **Linter**: `flutter_lints` enabled.
- **Formatting**: Standard Dart formatting (80 chars line length).
- **Naming**: Snake_case for files, PascalCase for classes, camelCase for variables.
- **Error Handling**: Use `Either<Failure, Type>` for all Repository returns.

## 5. Environment Variables
- Handled via `flutter_dotenv`.
- `.env` file required for sensitive keys (e.g., API keys).
