import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_palette.dart';
import 'app_typography.dart';

class AppTheme {
  // --- 2026 Light Theme ---
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Core Palette
      primaryColor: AppPalette.trustBlue,
      scaffoldBackgroundColor: AppPalette.surfaceLight,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppPalette.trustBlue,
        onPrimary: AppPalette.neutralWhite,
        secondary: AppPalette.sparkOrange,
        // Accent
        onSecondary: AppPalette.neutralWhite,
        surface: AppPalette.surfaceLight,
        onSurface: AppPalette.neutralBlack,
        error: AppPalette.expenseRed,
        onError: AppPalette.neutralWhite,
      ),

      // Typography
      fontFamily: 'Manrope',
      // Sourced from GoogleFonts in Typography class, but set here for default.
      textTheme: AppTypography.textTheme.copyWith(
        displayLarge:
            AppTypography.hero.copyWith(color: AppPalette.neutralBlack),
        titleLarge:
            AppTypography.heading.copyWith(color: AppPalette.neutralBlack),
        bodyLarge: AppTypography.body.copyWith(color: AppPalette.neutralWhite),
        bodySmall: AppTypography.detail,
        bodyMedium: AppTypography.detail,
        headlineSmall: AppTypography.detail,
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppPalette.surfaceLight,
        foregroundColor: AppPalette.neutralBlack,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Input Decoration (Flat-Glass Base)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.neutralGrey.withOpacity(0.05),
        // Extremely subtle
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.neutralGrey.withOpacity(0.2), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.neutralGrey.withOpacity(0.2), width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.trustBlue.withOpacity(0.5), width: 0.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.trustBlue,
          foregroundColor: AppPalette.neutralWhite,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  // --- 2026 Dark Theme (True Black) ---
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Core Palette
      primaryColor: AppPalette.fuchsia,
      scaffoldBackgroundColor: AppPalette.deepSpace,
      // Nebula Glass

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AppPalette.fuchsia,
        onPrimary: AppPalette.neutralWhite,
        secondary: AppPalette.cyan,
        onSecondary: AppPalette.neutralWhite,
        surface: AppPalette.glassPlum,
        onSurface: AppPalette.mist,
        error: AppPalette.expenseRed,
        onError: AppPalette.neutralWhite,
      ),

      // Typography
      fontFamily: 'Manrope',
      textTheme: AppTypography.textTheme.copyWith(
        displayLarge: AppTypography.hero.copyWith(color: AppPalette.mist),
        titleLarge: AppTypography.heading.copyWith(color: AppPalette.mist),
        bodyLarge: AppTypography.body.copyWith(color: AppPalette.mist),
        bodyMedium: AppTypography.body.copyWith(color: AppPalette.mist),
        bodySmall: AppTypography.detail.copyWith(color: AppPalette.periwinkle),
        headlineSmall:
            AppTypography.heading.copyWith(color: AppPalette.neutralGrey),
        headlineLarge:
            AppTypography.heading.copyWith(color: AppPalette.neutralGrey),
        headlineMedium:
            AppTypography.heading.copyWith(color: AppPalette.neutralGrey),
        titleMedium: AppTypography.body.copyWith(color: AppPalette.neutralGrey),
        titleSmall:
            AppTypography.detail.copyWith(color: AppPalette.neutralGrey),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppPalette.deepSpace,
        foregroundColor: AppPalette.mist,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Input Decoration (Dark Glass)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.glassPlum,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.neutralGrey.withOpacity(0.2), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.neutralGrey.withOpacity(0.2), width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.fuchsia.withOpacity(0.5), width: 0.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.fuchsia,
          foregroundColor: AppPalette.neutralWhite,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  // --- Legacy Compatibility (Mappings to 2026 Codebase) ---
  // These allow existing widgets to build while we refactor them in Phase 2.
  static const Color primaryColor = Color(0xFF2E5CFF); // Trust Blue
  static const Color primaryLight = Color(0xFF2E5CFF);
  static const Color primaryDark = Color(0xFF2E5CFF);

  static const Color secondaryLight = Color(0xFFFF6F00); // Spark Orange
  static const Color secondaryDark = Color(0xFFFF6F00);

  static const Color backgroundLight = Color(0xFFFAFBFC);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color surfaceLight = Color(0xFFFAFBFC);
  static const Color surfaceDark = Color(0xFF000000);
  static const Color surfaceVariantLight = Color(0xFFF0F0F5);
  static const Color surfaceVariantDark = Color(0xFF121212);

  static const Color textLightTheme = Color(0xFF1C1C1E);
  static const Color textDarkTheme = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1C1C1E); // Legacy alias
  static const Color textLight = Color(0xFFFFFFFF); // Legacy alias
  static const Color textSubtleLight = Color(0xFF8E8E93);
  static const Color textSubtleDark = Color(0xFF8E8E93);

  static const Color incomeLight = Color(0xFF00C853);
  static const Color incomeDark = Color(0xFF00C853);
  static const Color expenseLight = Color(0xFFD32F2F);
  static const Color expenseDark = Color(0xFFD32F2F);

  static const Color primaryContainerLight = Color(0xFFE3EFFF);
  static const Color primaryContainerDark = Color(0xFF1A2A4D);

  // Gradients
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [Color(0xFF2E5CFF), Color(0xFF0039CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFF2E5CFF), Color(0xFF5C85FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient accentGradientLight = LinearGradient(
    colors: [Color(0xFF2E5CFF), Color(0xFF5E8FD9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient accentGradientDark = LinearGradient(
    colors: [Color(0xFF2E5CFF), Color(0xFFEFB8C8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color getBotColor(String botId) {
    switch (botId) {
      case 'balance_tracker':
        return AppPalette.incomeGreen;
      case 'investment_guru':
        return AppPalette.trustBlue;
      case 'budget_planner':
        return AppPalette.sparkOrange;
      case 'fin_tips':
        return Colors.amber;
      default:
        return AppPalette.trustBlue;
    }
  }

  static IconData getBotIcon(String botId) {
    switch (botId) {
      case 'balance_tracker':
        return Icons.account_balance_wallet;
      case 'investment_guru':
        return Icons.trending_up;
      case 'budget_planner':
        return Icons.receipt_long;
      case 'fin_tips':
        return Icons.lightbulb;
      default:
        return Icons.chat;
    }
  }
}
