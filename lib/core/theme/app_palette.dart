import 'package:flutter/material.dart';

/// The "Core 5" Palette + Semantic Basics for 2026 Minimalist Theme.
/// This single source of truth replaces loose Color() calls.
class AppPalette {
  const AppPalette._();

  // --- Primary Colors ---
  static const Color primaryLight = Color(0xFF2E5CFF); // Trust Blue
  static const Color primaryDark =
      Color(0xFF06B6D4); // Cyan (formerly Nebula Cyan)

  // --- Secondary/Accent Colors ---
  static const Color secondaryLight = Color(0xFFFF6F00); // Spark Orange
  static const Color secondaryDark =
      Color(0xFFD946EF); // Fuchsia (formerly Nebula Fuchsia)

  // --- Feedback Colors ---
  static const Color income = Color(0xFF00C853); // Income Green
  static const Color expense = Color(0xFFD32F2F); // Expense Red
  static const Color warning = Color(0xFFFF9800);

  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF2196F3);

  // --- Backgrounds ---
  static const Color backgroundLight = Color(0xFFFAFBFC);
  static const Color backgroundDark = Color(0xFF0B0418); // Deep Space

  // --- Surfaces ---
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1B2E); // Glass Plum
  static const Color surfaceContainerDark =
      Color(0xFF2D2A42); // Flux / Surface Highlight

  // --- Text & Neutrals ---
  static const Color textPrimaryLight = Color(0xFF1C1C1E); // Neutral Black
  static const Color textSecondaryLight = Color(0xFF8E8E93); // Neutral Grey

  static const Color textPrimaryDark = Color(0xFFE2E8F0); // Mist
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Periwinkle

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // --- Chart Colors ---
  static const List<List<Color>> chartBarColors = [
    [Color(0xFF6366F1), Color(0xFF818CF8)], // Indigo
    [Color(0xFF8B5CF6), Color(0xFFA78BFA)], // Violet
    [Color(0xFFEC4899), Color(0xFFF472B6)], // Pink
    [Color(0xFFF59E0B), Color(0xFFFBBF24)], // Amber
    [Color(0xFF10B981), Color(0xFF34D399)], // Emerald
    [Color(0xFF3B82F6), Color(0xFF60A5FA)], // Blue
    [Color(0xFFEF4444), Color(0xFFF87171)], // Red
    [Color(0xFF06B6D4), Color(0xFF22D3EE)], // Cyan
  ];

  static const List<Color> chartLineGradient = [
    Color(0xFF3B82F6), // Blue
    Color(0xFF06B6D4), // Cyan
  ];

  static Color getTooltipColor(bool isDark) {
    return isDark ? const Color(0xFF1F2937) : white;
  }

  // --- Category Colors ---
  static const List<Color> categoryColors = [
    Color(0xFF7C4DFF), // Violet
    Color(0xFFE040FB), // Pink
    Color(0xFFFF4081), // Red
    Color(0xFF7E57C2), // Deep Purple
    Color(0xFF3F51B5), // Indigo
    Color(0xFF2196F3), // Blue
    Color(0xFF00BCD4), // Cyan
    Color(0xFF009688), // Teal
    Color(0xFF4CAF50), // Green
    Color(0xFF8BC34A), // Light Green
    Color(0xFFCDDC39), // Lime
    Color(0xFFFFEB3B), // Yellow
    Color(0xFFFFC107), // Amber
    Color(0xFFFF9800), // Orange
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF03A9F4), // Light Blue
  ];

  /// Get category color by category name
  static Color getCategoryColor(String category) {
    if (category.isEmpty) return primaryLight;

    // Consistent color mapping based on hash code
    final int hash = category.trim().toLowerCase().hashCode;
    return categoryColors[hash.abs() % categoryColors.length];
  }
}
