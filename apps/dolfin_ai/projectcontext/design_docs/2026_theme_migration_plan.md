# 2026 Theme Implementation & Centralization Plan

**Status**: Planning
**Target**: Centralize Colors, Styles, Assets, Texts and apply 2026 Minimalist Theme.

## 1. Centralization Strategy

### 1.1 Color System (`lib/core/theme`)
**Current State**: Scattered between `AppTheme` and `GeminiColors`.
**Goal**: Unified `AppPalette` and `AppTheme`.

*   **Step 1**: Create `lib/core/theme/app_palette.dart`.
    *   Define the "Core 5" static colors (`trustBlue`, `vibrantOrange`, etc.).
    *   Define the "Glass" properties.
*   **Step 2**: Update `lib/core/theme/app_theme.dart`.
    *   Remove legacy semantic colors.
    *   Implement `ThemeExtension` for custom 2026 properties (e.g., `glassTransparency`, `bentoGap`).
    *   Create distinct `lightTheme` and `darkTheme` factories using strictly the `AppPalette` colors.

### 1.2 Text Style System (`lib/core/theme`)
**Current State**: `textTheme` inside `AppTheme`.
**Goal**: `AppTypography` class.

*   **Step 1**: Create `lib/core/theme/app_typography.dart`.
    *   Define `hero`, `heading`, `body`, `detail` text styles.
    *   Ensure they use `GoogleFonts` (or fallback).
*   **Step 2**: Wire into `AppTheme.textTheme`.

### 1.3 Asset Centralization (`lib/core/constants`)
**Current State**: Raw strings (e.g., `'assets/images/google_logo.png'`).
**Goal**: `AppAssets` class.

*   **Step 1**: Create `lib/core/constants/app_assets.dart`.
    *   **Structure**:
        ```dart
        class AppAssets {
          static const _iconPath = 'assets/icons';
          static const _imagePath = 'assets/images';

          // Icons
          static const googleLogo = '$_imagePath/google_logo.png';
          // ...
          
          // 2026 Assets
          static const emptyState3D = '$_imagePath/empty_state_3d.png';
        }
        ```

### 1.4 Text Centralization (`lib/core/constants`)
**Current State**: Hardcoded strings in widgets.
**Goal**: `AppStrings` class organized by feature.

*   **Step 1**: Create `lib/core/constants/app_strings.dart`.
    *   **Structure**:
        ```dart
        class AppStrings {
          static const appName = 'BalanceIQ';
          
          static const auth = _AuthStrings();
          static const chat = _ChatStrings();
          static const dashboard = _DashboardStrings();
        }

        class _AuthStrings {
          const _AuthStrings();
          final welcome = 'Your AI-powered personal finance assistant';
          final continueGoogle = 'Continue with Google';
        }
        ```

---

## 2. Implementation Roadmap

### Phase 1: Infrastructure (The "Foundation")
1.  Create `AppPalette`, `AppTypography`, `AppAssets`, `AppStrings` files.
2.  Update `AppTheme` to consume `AppPalette` and `AppTypography`.

### Phase 2: Refactoring (The "Cleanup")
3.  **Auth Feature**: `OnboardingPage` -> Replace hardcoded strings/assets with `AppStrings.auth` and `AppAssets`.
4.  **Chat Feature**: `ChatPage`, `MessageBubble`, `ChatInput` -> Replace colors with `AppTheme.colorScheme` and strings with `AppStrings.chat`.
5.  **Home Feature**: `Dashboard` -> Apply Bento Grid layout and new colors.

### Phase 3: The 2026 Polish
6.  Apply "Flat-Glass" decoration to `ChatInput`.
7.  Replace Icons with "Fine-Line" versions (using `Heroicons` package or comparable).
8.  Insert "Abstract 3D" assets into Empty States.

---

## 3. Verification
*   **Compile Safety**: Ensure no missing consts.
*   **Visual Check**: Verify Dark Mode "True Black" and Light Mode "Clean White".
*   **Consistency**: Search codebase for any remaining `Color(0x...)` or `'string'` usage.
