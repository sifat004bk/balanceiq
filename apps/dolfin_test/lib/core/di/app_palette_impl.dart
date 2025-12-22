import 'package:dolfin_ui_kit/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Test App Palette Implementation with TEAL/AMBER theme (different from main app's blue theme)
class TestAppPaletteImpl implements AppPalette {
  @override
  Color get primaryLight => const Color(0xFF00897B); // Teal

  @override
  Color get primaryDark => const Color(0xFF00BFA5); // Teal accent

  @override
  Color get secondaryLight => const Color(0xFFFF6F00); // Amber

  @override
  Color get secondaryDark => const Color(0xFFFFAB00); // Amber accent

  @override
  Color get income => const Color(0xFF00C853);

  @override
  Color get expense => const Color(0xFFD32F2F);

  @override
  Color get warning => const Color(0xFFFF9800);

  @override
  Color get success => const Color(0xFF00C853);

  @override
  Color get error => const Color(0xFFD32F2F);

  @override
  Color get info => const Color(0xFF2196F3);

  @override
  Color get backgroundLight => const Color(0xFFFAFBFC);

  @override
  Color get backgroundDark => const Color(0xFF1A1A2E); // Deep navy

  @override
  Color get surfaceLight => const Color(0xFFFFFFFF);

  @override
  Color get surfaceDark => const Color(0xFF16213E); // Navy blue

  @override
  Color get surfaceContainerDark => const Color(0xFF2D2A42);

  @override
  Color get textPrimaryLight => const Color(0xFF1C1C1E);

  @override
  Color get textSecondaryLight => const Color(0xFF8E8E93);

  @override
  Color get textPrimaryDark => const Color(0xFFE2E8F0);

  @override
  Color get textSecondaryDark => const Color(0xFF94A3B8);

  @override
  Color get white => const Color(0xFFFFFFFF);

  @override
  Color get black => const Color(0xFF000000);

  @override
  Color get transparent => Colors.transparent;

  @override
  List<List<Color>> get chartBarColors => const [
        [Color(0xFF009688), Color(0xFF4DB6AC)], // Teal
        [Color(0xFFFF6F00), Color(0xFFFFAB00)], // Amber
        [Color(0xFFEC4899), Color(0xFFF472B6)], // Pink
        [Color(0xFF10B981), Color(0xFF34D399)], // Emerald
        [Color(0xFF3B82F6), Color(0xFF60A5FA)], // Blue
        [Color(0xFFEF4444), Color(0xFFF87171)], // Red
        [Color(0xFF8B5CF6), Color(0xFFA78BFA)], // Violet
        [Color(0xFF06B6D4), Color(0xFF22D3EE)], // Cyan
      ];

  @override
  List<Color> get chartLineGradient => const [
        Color(0xFF00897B), // Teal
        Color(0xFF00BFA5), // Teal accent
      ];

  @override
  Color getTooltipColor(bool isDark) {
    return isDark ? const Color(0xFF1F2937) : white;
  }

  @override
  List<Color> get categoryColors => const [
        Color(0xFF009688), // Teal
        Color(0xFFFF6F00), // Amber
        Color(0xFFE040FB), // Pink
        Color(0xFF7E57C2), // Deep Purple
        Color(0xFF3F51B5), // Indigo
        Color(0xFF2196F3), // Blue
        Color(0xFF00BCD4), // Cyan
        Color(0xFF4CAF50), // Green
        Color(0xFF8BC34A), // Light Green
        Color(0xFFCDDC39), // Lime
        Color(0xFFFFEB3B), // Yellow
        Color(0xFFFFC107), // Amber
        Color(0xFFFF9800), // Orange
        Color(0xFFFF5722), // Deep Orange
        Color(0xFF03A9F4), // Light Blue
        Color(0xFF795548), // Brown
      ];

  @override
  Color getCategoryColor(String category) {
    if (category.isEmpty) return primaryLight;
    final int hash = category.trim().toLowerCase().hashCode;
    return categoryColors[hash.abs() % categoryColors.length];
  }
}
