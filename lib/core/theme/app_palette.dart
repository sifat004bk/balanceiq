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
  static final Color incomeGreen = cyan; // #00C853

  /// Expense Red: Errors, Debt.
  static final Color expenseRed = fuchsia; // #D32F2F

  /// Surfaces (Light/Dark)
  static final Color surfaceLight = const Color(0xFFFAFBFC); // #FAFBFC
  static final Color surfaceDark =
      const Color(0xFF000000); // #000000 (True Black)

  // --- Option 1: Midnight Slate ---
  static final Color slate950 = const Color(0xFF020617); // Background
  static final Color slate900 = const Color(0xFF0F172A); // Surface
  static final Color indigo500 = const Color(0xFF6366F1); // Primary
  static final Color sky400 = const Color(0xFF38BDF8); // Secondary
  static final Color slate100 = const Color(0xFFF1F5F9); // Text

  // --- Option 4: Nebula Glass ---
  static final Color deepSpace = const Color(0xFF0B0418); // Background
  static final Color glassPlum = const Color(0xFF1E1B2E); // Surface
  static final Color flux = const Color(0xFF2D2A42); // Surface Highlight
  static final Color fuchsia = const Color(0xFFD946EF); // Primary
  static final Color cyan = const Color(0xFF06B6D4); // Secondary
  static final Color mist = const Color(0xFFE2E8F0); // Text Primary
  static final Color periwinkle = const Color(0xFF94A3B8); // Text Secondary

  // --- Neutrals ---

  /// Primary Text (Light) / Secondary Text (Dark) basis
  static final Color neutralBlack = const Color(0xFF1C1C1E);

  /// Secondary Text / Icon color
  static final Color neutralGrey = const Color(0xFF8E8E93);

  /// Primary Text (Dark)
  static final Color neutralWhite = const Color(0xFFFFFFFF);

  /// Cards & Sheets (Dark Mode) - Slightly lighter than true black
  static final Color surfaceCardDark = const Color(0xFF121212);

  /// Avatar gradient start color
  static final Color avatarGradientStart = const Color(0xFFFFC2A1);

  /// Avatar gradient end color
  static final Color avatarGradientEnd = const Color(0xFFFFD8B8);

  // --- Additional Surface Colors ---

  /// Modal surfaces in dark mode
  static final Color surfaceModalDark = const Color(0xFF1e1f20);

  /// Card variant for dark mode (slightly elevated)
  static final Color surfaceCardVariantDark = const Color(0xFF2a2a2e);

  /// Toggle and switch backgrounds
  static final Color surfaceToggleDark = const Color(0xFF1A1C23);

  /// Container with darker background
  static final Color surfaceContainerDark = const Color(0xFF2D3142);

  // --- Input Field Colors ---

  /// Input background (dark theme)
  static final Color inputBackgroundDark = const Color(0xFF1F2937);

  /// Input background (light theme)
  static final Color inputBackgroundLight = const Color(0xFFF3F4F6);

  /// Input border (dark theme)
  static final Color inputBorderDark = const Color(0xFF374151);

  /// Input border (light theme)
  static final Color inputBorderLight = const Color(0xFFD1D5DB);

  /// Divider color (light theme)
  static final Color dividerLight = const Color(0xFFE5E7EB);

  /// Divider color (dark theme)
  static final Color dividerDark = const Color(0xFF374151);

  // --- Text Colors ---

  /// Subtle text color for secondary information
  static final Color textSubtleLight = const Color(0xFFc4c7c5);

  /// Accent text color for links/chips
  static final Color textAccent = const Color(0xFFa8c7fa);

  /// Chip background color
  static final Color chipBackground = const Color(0xFF2e406c);

  // --- Status Colors ---

  /// Success/Confirmation color
  static final Color successGreen = const Color(0xFF00C853);

  /// Warning color
  static final Color warningOrange = const Color(0xFFFF9800);

  /// Error color (alias for expenseRed)
  static final Color errorRed = expenseRed;

  // --- Category Colors (12 distinct colors for categories) ---

  static final Color categoryOrange = const Color(0xFFFF9800);
  static final Color categoryBlue = const Color(0xFF2196F3);
  static final Color categoryPink = const Color(0xFFE91E63);
  static final Color categoryCyan = const Color(0xFF00BCD4);
  static final Color categoryIndigo = const Color(0xFF3F51B5);
  static final Color categoryRed = const Color(0xFFF44336);
  static final Color categoryPurple = const Color(0xFF9C27B0);
  static final Color categoryTeal = const Color(0xFF009688);
  static final Color categoryLime = const Color(0xFFCDDC39);
  static final Color categoryAmber = const Color(0xFFFFC107);
  static final Color categoryDeepOrange = const Color(0xFFFF5722);
  static final Color categoryLightBlue = const Color(0xFF03A9F4);

  // --- Glassmorphism ---

  /// Cards & Sheets (Light Mode)
  static final Color surfaceCardLight = const Color(0xFFFFFFFF);

  /// To be used with .withOpacity(0.05 - 0.08)
  static final Color glassWhite = const Color(0xFFFFFFFF);
  static final Color glassBlack = const Color(0xFF000000);

  /// Text Subtle (Alias for neutralGrey)
  static final Color textSubtle = neutralGrey;

  // --- Indicator Colors ---

  /// Page indicator active (dark)
  static final Color indicatorActiveDark = const Color(0xFF32674d);

  /// Page indicator inactive (light/dark)
  static final Color indicatorInactive = const Color(0xFFd1d5db);

  /// Primary Gradient
  static final LinearGradient primaryGradient = LinearGradient(
    colors: [trustBlue, trustBlue.withOpacity(0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Get category color by category name
  static Color getCategoryColor(String category) {
    final categoryLower = category.toLowerCase();
    if (categoryLower.contains('food') || categoryLower.contains('dining')) {
      return categoryOrange;
    } else if (categoryLower.contains('transport')) {
      return categoryBlue;
    } else if (categoryLower.contains('shopping')) {
      return categoryPink;
    } else if (categoryLower.contains('entertainment')) {
      return categoryCyan;
    } else if (categoryLower.contains('bills') ||
        categoryLower.contains('utilities')) {
      return categoryIndigo;
    } else if (categoryLower.contains('health')) {
      return categoryRed;
    } else if (categoryLower.contains('education')) {
      return categoryPurple;
    } else if (categoryLower.contains('salary') ||
        categoryLower.contains('income')) {
      return categoryTeal;
    } else if (categoryLower.contains('investment')) {
      return categoryLime;
    } else if (categoryLower.contains('gift')) {
      return categoryAmber;
    } else if (categoryLower.contains('other')) {
      return categoryDeepOrange;
    } else {
      return categoryLightBlue;
    }
  }
}
