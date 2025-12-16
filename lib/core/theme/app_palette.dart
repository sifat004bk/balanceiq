import 'package:flutter/material.dart';

/// The "Core 5" Palette + Semantic Basics for 2026 Minimalist Theme.
/// This single source of truth replaces loose Color() calls.
class AppPalette {
  const AppPalette._();

  // --- The Core 5 ---

  /// Trust Blue: Primary Actions, Brand Identity.
  static final Color trustBlue = const Color(0xFF2E5CFF); // #2E5CFF

  /// Spark Orange: High-priority alerts, sparse accents.
  static final Color sparkOrange = const Color(0xFFFF6F00); // #FF6F00

  /// Income Green: Growth, Success.
  static final Color incomeGreen = const Color(0xFF00C853); // #00C853

  /// Expense Red: Errors, Debt.
  static final Color expenseRed = const Color(0xFFD32F2F); // #D32F2F

  /// Surfaces (Light/Dark)
  static final Color surfaceLight = const Color(0xFFFAFBFC); // #FAFBFC
  static final Color surfaceDark =
      const Color(0xFF000000); // #000000 (True Black)

  // --- Neutrals ---

  /// Primary Text (Light) / Secondary Text (Dark) basis
  static final Color neutralBlack = const Color(0xFF1C1C1E);

  /// Secondary Text / Icon color
  static final Color neutralGrey = const Color(0xFF8E8E93);

  /// Primary Text (Dark)
  static final Color neutralWhite = const Color(0xFFFFFFFF);

  /// Cards & Sheets (Dark Mode) - Slightly lighter than true black
  static final Color surfaceCardDark = const Color(0xFF121212);

  // --- Glassmorphism ---

  /// Cards & Sheets (Light Mode)
  static final Color surfaceCardLight = const Color(0xFFFFFFFF);

  /// To be used with .withOpacity(0.05 - 0.08)
  static final Color glassWhite = const Color(0xFFFFFFFF);
  static final Color glassBlack = const Color(0xFF000000);

  /// Text Subtle (Alias for neutralGrey)
  static final Color textSubtle = neutralGrey;

  /// Primary Gradient
  static final LinearGradient primaryGradient = LinearGradient(
    colors: [trustBlue, trustBlue.withOpacity(0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
