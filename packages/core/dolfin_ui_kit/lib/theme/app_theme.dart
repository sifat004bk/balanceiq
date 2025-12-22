import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_palette.dart';
import 'app_typography.dart';

class AppTheme {
  // --- Light Theme ---
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Core Palette
      primaryColor: AppPalette.primaryLight,
      scaffoldBackgroundColor: AppPalette.backgroundLight,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppPalette.primaryLight,
        onPrimary: AppPalette.white,
        primaryContainer: AppPalette.primaryLight.withValues(alpha: 0.1),
        onPrimaryContainer: AppPalette.primaryLight,
        secondary: AppPalette.secondaryLight,
        onSecondary: AppPalette.white,
        secondaryContainer: AppPalette.secondaryLight.withValues(alpha: 0.1),
        onSecondaryContainer: AppPalette.secondaryLight,
        surface: AppPalette.surfaceLight,
        onSurface: AppPalette.textPrimaryLight,
        surfaceContainerHighest:
            AppPalette.textSecondaryLight.withValues(alpha: 0.05),
        error: AppPalette.expense,
        onError: AppPalette.white,
        outline: AppPalette.textSecondaryLight.withValues(alpha: 0.2),
        outlineVariant: AppPalette.textSecondaryLight.withValues(alpha: 0.1),
      ),

      // Typography
      fontFamily: 'Manrope',
      textTheme: AppTypography.textTheme.copyWith(
        displayLarge:
            AppTypography.hero.copyWith(color: AppPalette.textPrimaryLight),
        titleLarge:
            AppTypography.heading.copyWith(color: AppPalette.textPrimaryLight),
        bodyLarge:
            AppTypography.body.copyWith(color: AppPalette.textPrimaryLight),
        bodyMedium:
            AppTypography.body.copyWith(color: AppPalette.textPrimaryLight),
        bodySmall: AppTypography.detail,
        headlineSmall: AppTypography.detail,
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppPalette.surfaceLight,
        foregroundColor: AppPalette.textPrimaryLight,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        scrolledUnderElevation: 0,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.textSecondaryLight.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.textSecondaryLight.withValues(alpha: 0.2),
              width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.textSecondaryLight.withValues(alpha: 0.2),
              width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.primaryLight.withValues(alpha: 0.5),
              width: 0.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.primaryLight,
          foregroundColor: AppPalette.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  // --- Dark Theme ---
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Core Palette
      primaryColor: AppPalette.primaryDark,
      scaffoldBackgroundColor: AppPalette.backgroundDark,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AppPalette.primaryDark,
        onPrimary: AppPalette.white,
        primaryContainer: AppPalette.primaryDark.withValues(alpha: 0.1),
        onPrimaryContainer: AppPalette.primaryDark,
        secondary: AppPalette.secondaryDark,
        onSecondary: AppPalette.white,
        secondaryContainer: AppPalette.secondaryDark.withValues(alpha: 0.1),
        onSecondaryContainer: AppPalette.secondaryDark,
        surface: AppPalette.surfaceDark,
        onSurface: AppPalette.textPrimaryDark,
        surfaceContainer: AppPalette.surfaceContainerDark,
        error: AppPalette.expense,
        onError: AppPalette.white,
        outline: AppPalette.textSecondaryDark.withValues(alpha: 0.2),
        outlineVariant: AppPalette.textSecondaryDark.withValues(alpha: 0.1),
      ),

      // Typography
      fontFamily: 'Manrope',
      textTheme: AppTypography.textTheme.copyWith(
        displayLarge:
            AppTypography.hero.copyWith(color: AppPalette.textPrimaryDark),
        titleLarge:
            AppTypography.heading.copyWith(color: AppPalette.textPrimaryDark),
        bodyLarge:
            AppTypography.body.copyWith(color: AppPalette.textPrimaryDark),
        bodyMedium:
            AppTypography.body.copyWith(color: AppPalette.textPrimaryDark),
        bodySmall:
            AppTypography.detail.copyWith(color: AppPalette.textSecondaryDark),
        headlineSmall:
            AppTypography.heading.copyWith(color: AppPalette.textSecondaryDark),
        headlineLarge:
            AppTypography.heading.copyWith(color: AppPalette.textSecondaryDark),
        headlineMedium:
            AppTypography.heading.copyWith(color: AppPalette.textSecondaryDark),
        titleMedium:
            AppTypography.body.copyWith(color: AppPalette.textSecondaryDark),
        titleSmall:
            AppTypography.detail.copyWith(color: AppPalette.textSecondaryDark),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppPalette.backgroundDark,
        foregroundColor: AppPalette.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        scrolledUnderElevation: 0,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.textSecondaryDark.withValues(alpha: 0.2),
              width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.textSecondaryDark.withValues(alpha: 0.2),
              width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: AppPalette.secondaryDark.withValues(alpha: 0.5),
              width: 0.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.secondaryDark,
          foregroundColor: AppPalette.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  static Color getBotColor(String botId) {
    switch (botId) {
      case 'balance_tracker':
        return AppPalette.income;
      case 'investment_guru':
        return AppPalette.primaryLight;
      case 'budget_planner':
        return AppPalette.secondaryLight;
      case 'fin_tips':
        return AppPalette.warning;
      default:
        return AppPalette.primaryLight;
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
