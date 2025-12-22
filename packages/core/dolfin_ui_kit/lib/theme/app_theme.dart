import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'app_palette.dart';
import 'app_typography.dart';

class AppTheme {
  // --- Light Theme ---
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Core Palette
      primaryColor: GetIt.instance<AppPalette>().primaryLight,
      scaffoldBackgroundColor: GetIt.instance<AppPalette>().backgroundLight,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: GetIt.instance<AppPalette>().primaryLight,
        onPrimary: GetIt.instance<AppPalette>().white,
        primaryContainer:
            GetIt.instance<AppPalette>().primaryLight.withValues(alpha: 0.1),
        onPrimaryContainer: GetIt.instance<AppPalette>().primaryLight,
        secondary: GetIt.instance<AppPalette>().secondaryLight,
        onSecondary: GetIt.instance<AppPalette>().white,
        secondaryContainer:
            GetIt.instance<AppPalette>().secondaryLight.withValues(alpha: 0.1),
        onSecondaryContainer: GetIt.instance<AppPalette>().secondaryLight,
        surface: GetIt.instance<AppPalette>().surfaceLight,
        onSurface: GetIt.instance<AppPalette>().textPrimaryLight,
        surfaceContainerHighest: GetIt.instance<AppPalette>()
            .textSecondaryLight
            .withValues(alpha: 0.05),
        error: GetIt.instance<AppPalette>().expense,
        onError: GetIt.instance<AppPalette>().white,
        outline: GetIt.instance<AppPalette>()
            .textSecondaryLight
            .withValues(alpha: 0.2),
        outlineVariant: GetIt.instance<AppPalette>()
            .textSecondaryLight
            .withValues(alpha: 0.1),
      ),

      // Typography
      fontFamily: 'Manrope',
      textTheme: AppTypography.textTheme.copyWith(
        displayLarge: AppTypography.hero
            .copyWith(color: GetIt.instance<AppPalette>().textPrimaryLight),
        titleLarge: AppTypography.heading
            .copyWith(color: GetIt.instance<AppPalette>().textPrimaryLight),
        bodyLarge: AppTypography.body
            .copyWith(color: GetIt.instance<AppPalette>().textPrimaryLight),
        bodyMedium: AppTypography.body
            .copyWith(color: GetIt.instance<AppPalette>().textPrimaryLight),
        bodySmall: AppTypography.detail,
        headlineSmall: AppTypography.detail,
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: GetIt.instance<AppPalette>().surfaceLight,
        foregroundColor: GetIt.instance<AppPalette>().textPrimaryLight,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        scrolledUnderElevation: 0,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GetIt.instance<AppPalette>()
            .textSecondaryLight
            .withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: GetIt.instance<AppPalette>()
                  .textSecondaryLight
                  .withValues(alpha: 0.2),
              width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: GetIt.instance<AppPalette>()
                  .textSecondaryLight
                  .withValues(alpha: 0.2),
              width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: GetIt.instance<AppPalette>()
                  .primaryLight
                  .withValues(alpha: 0.5),
              width: 0.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GetIt.instance<AppPalette>().primaryLight,
          foregroundColor: GetIt.instance<AppPalette>().white,
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
      primaryColor: GetIt.instance<AppPalette>().primaryDark,
      scaffoldBackgroundColor: GetIt.instance<AppPalette>().backgroundDark,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: GetIt.instance<AppPalette>().primaryDark,
        onPrimary: GetIt.instance<AppPalette>().white,
        primaryContainer:
            GetIt.instance<AppPalette>().primaryDark.withValues(alpha: 0.1),
        onPrimaryContainer: GetIt.instance<AppPalette>().primaryDark,
        secondary: GetIt.instance<AppPalette>().secondaryDark,
        onSecondary: GetIt.instance<AppPalette>().white,
        secondaryContainer:
            GetIt.instance<AppPalette>().secondaryDark.withValues(alpha: 0.1),
        onSecondaryContainer: GetIt.instance<AppPalette>().secondaryDark,
        surface: GetIt.instance<AppPalette>().surfaceDark,
        onSurface: GetIt.instance<AppPalette>().textPrimaryDark,
        surfaceContainer: GetIt.instance<AppPalette>().surfaceContainerDark,
        error: GetIt.instance<AppPalette>().expense,
        onError: GetIt.instance<AppPalette>().white,
        outline: GetIt.instance<AppPalette>()
            .textSecondaryDark
            .withValues(alpha: 0.2),
        outlineVariant: GetIt.instance<AppPalette>()
            .textSecondaryDark
            .withValues(alpha: 0.1),
      ),

      // Typography
      fontFamily: 'Manrope',
      textTheme: AppTypography.textTheme.copyWith(
        displayLarge: AppTypography.hero
            .copyWith(color: GetIt.instance<AppPalette>().textPrimaryDark),
        titleLarge: AppTypography.heading
            .copyWith(color: GetIt.instance<AppPalette>().textPrimaryDark),
        bodyLarge: AppTypography.body
            .copyWith(color: GetIt.instance<AppPalette>().textPrimaryDark),
        bodyMedium: AppTypography.body
            .copyWith(color: GetIt.instance<AppPalette>().textPrimaryDark),
        bodySmall: AppTypography.detail
            .copyWith(color: GetIt.instance<AppPalette>().textSecondaryDark),
        headlineSmall: AppTypography.heading
            .copyWith(color: GetIt.instance<AppPalette>().textSecondaryDark),
        headlineLarge: AppTypography.heading
            .copyWith(color: GetIt.instance<AppPalette>().textSecondaryDark),
        headlineMedium: AppTypography.heading
            .copyWith(color: GetIt.instance<AppPalette>().textSecondaryDark),
        titleMedium: AppTypography.body
            .copyWith(color: GetIt.instance<AppPalette>().textSecondaryDark),
        titleSmall: AppTypography.detail
            .copyWith(color: GetIt.instance<AppPalette>().textSecondaryDark),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: GetIt.instance<AppPalette>().backgroundDark,
        foregroundColor: GetIt.instance<AppPalette>().textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        scrolledUnderElevation: 0,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GetIt.instance<AppPalette>().surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: GetIt.instance<AppPalette>()
                  .textSecondaryDark
                  .withValues(alpha: 0.2),
              width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: GetIt.instance<AppPalette>()
                  .textSecondaryDark
                  .withValues(alpha: 0.2),
              width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
              color: GetIt.instance<AppPalette>()
                  .secondaryDark
                  .withValues(alpha: 0.5),
              width: 0.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GetIt.instance<AppPalette>().secondaryDark,
          foregroundColor: GetIt.instance<AppPalette>().white,
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
        return GetIt.instance<AppPalette>().income;
      case 'investment_guru':
        return GetIt.instance<AppPalette>().primaryLight;
      case 'budget_planner':
        return GetIt.instance<AppPalette>().secondaryLight;
      case 'fin_tips':
        return GetIt.instance<AppPalette>().warning;
      default:
        return GetIt.instance<AppPalette>().primaryLight;
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
