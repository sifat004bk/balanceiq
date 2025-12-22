# Monorepo Migration Specification

**Version:** 1.0 (Agent-Ready)
**Date:** 2025-12-22
**Objective:** Transform `balanceIQ` into a Melos Monorepo with reusable packages.

---

## 1. Target Workspace Structure

```
workspace/
├── melos.yaml
├── pubspec.yaml                # Workspace dev_dependencies (lints)
├── apps/
│   └── balance_iq/             # The Product (Thin Client)
└── packages/
    ├── core/
    │   ├── balance_core/       # Pure Dart logic (Errors, Network, Utils)
    │   └── balance_ui_kit/     # Flutter Widgets, Theme, Design System
    │
    └── features/
        ├── feature_auth/       # Configurable Auth Flow
        ├── feature_chat/       # AI Chat Engine (Configurable Persona)
        └── feature_subscription/# Subscriptions & Paywalls
```

---

## 2. Package Extraction Map

### 📦 Package: `balance_core`
**Path:** `packages/core/balance_core`
**Type:** Pure Dart (mostly)
**Description:** Foundation layer with no feature logic.

**Files to Move:**
- `lib/core/error/**` -> `lib/error/`
- `lib/core/network/**` -> `lib/network/`
- `lib/core/storage/**` -> `lib/storage/`
- `lib/core/utils/**` -> `lib/utils/`
- `lib/core/usecases/**` -> `lib/usecases/`
- `lib/core/constants/app_strings.dart` -> `lib/constants/` (Base strings only)

**New Core Components:**
- Create `lib/config/environment_config.dart` (Abstract interface for Base URLs).

**Dependencies:**
- `dio`, `flutter_secure_storage`, `dartz`, `equatable`, `logger`

---

### 📦 Package: `balance_ui_kit`
**Path:** `packages/core/balance_ui_kit`
**Type:** Flutter Package
**Description:** Shared design system, theme, and dumb widgets.

**Files to Move:**
- `lib/core/theme/**` -> `lib/theme/`
- `lib/core/widgets/**` -> `lib/widgets/`
- `lib/features/chat/presentation/widgets/gen_ui/**` (Generic UI components) -> `lib/gen_ui/`

**Dependencies:**
- `flutter`, `google_fonts`

---

### 📦 Package: `feature_auth`
**Path:** `packages/features/feature_auth`
**Type:** Flutter Package
**Description:** Configurable authentication flows (Login, Signup, Session).

**Files to Move:**
- `lib/features/auth/**` -> `lib/`
- `lib/core/di/modules/auth_module.dart` -> `lib/di/`

**Key Refactor:**
- Create `class AuthConfig` interface to inject API endpoints and branding.
- Remove hardcoded `GoRouter` paths. Return `auth_routes` list instead.
- **Refactor `ApiEndpoints` usage:** Replace static `ApiEndpoints` calls with `EnvironmentConfig` paths injected from Core.

---

### 📦 Package: `feature_chat`
**Path:** `packages/features/feature_chat`
**Type:** Flutter Package
**Description:** The AI Chat Engine.

**Files to Move:**
- `lib/features/chat/**` -> `lib/`
- `lib/core/di/modules/chat_module.dart` -> `lib/di/`

**Key Refactor:**
- Create `class ChatConfig` (AiName, AiAvatar, SystemPrompt).

---

## 3. Configuration Templates

### `melos.yaml`
```yaml
name: balance_iq_workspace
repository: https://github.com/TODO/balance_iq

packages:
  - apps/*
  - packages/core/*
  - packages/features/*

command:
  bootstrap:
    usePubspecOverrides: true
```

### `apps/balance_iq/pubspec.yaml` (Update)
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Workspace Packages
  balance_core:
    path: ../../packages/core/balance_core
  balance_ui_kit:
    path: ../../packages/core/balance_ui_kit
  feature_auth:
    path: ../../packages/features/feature_auth
  feature_chat:
    path: ../../packages/features/feature_chat
```

---

## 4. Execution Plan (Step-by-Step)

### Phase 1: Workspace Init
1. Create root directory `workspace_root`.
2. Generate `melos.yaml`.
3. Move `balanceIQ` project into `apps/balance_iq`.

### Phase 2: Core Extraction
1. **Create `packages/core/balance_core`**.
   - Run `flutter create --template=package balance_core`.
   - Copy files per map.
   - Copy dependencies from main pubspec.
2. **Refactor `apps/balance_iq` imports**.
   - Change `import 'package:balance_iq/core/error/...'` to `import 'package:balance_core/error/...'`.
   - Add dependency to pubspec.

3. **Create `packages/core/balance_ui_kit`**.
   - Run `flutter create --template=package balance_ui_kit`.
   - Copy theme/widgets.
   - Refactor app imports.

### Phase 3: Feature Extraction
1. **Create `packages/features/feature_auth`**.
   - Move Auth feature code.
   - Fix imports to rely on `balance_core` and `balance_ui_kit`.
   - **Verification:** Run `melos analyze` to find broken references.

2. **Create `packages/features/feature_chat`**.
   - Move Chat feature code.
   - This is the heavily coupled feature, expect strict dependency issues.

### Phase 4: Verification
1. Run `melos bootstrap`.
2. Run `flutter test` in `balance_core`.
3. Run `flutter run` in `apps/balance_iq`.

---

## 5. Critical Rules for Agent
1. **One Package at a Time:** Do not try to extract everything at once.
2. **Fix Imports Immediately:** When moving files, run a script to find/replace imports in the main app to keep it compiling.
3. **Preserve History if possible:** Ideally use `git mv`, but copying is acceptable if git is complex in this environment.

---
**Status:** Ready to Execute
**Approved By:** User
