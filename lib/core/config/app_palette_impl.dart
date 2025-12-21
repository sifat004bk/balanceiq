import 'package:dolfin_ui_kit/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AppPaletteImpl implements AppPalette {
  @override
  Color get primaryLight => const Color(0xFF2E5CFF); // Trust Blue

  @override
  Color get primaryDark =>
      const Color(0xFF06B6D4); // Cyan (formerly Nebula Cyan)

  @override
  Color get secondaryLight => const Color(0xFFFF6F00); // Spark Orange

  @override
  Color get secondaryDark =>
      const Color(0xFFD946EF); // Fuchsia (formerly Nebula Fuchsia)

  @override
  Color get income => const Color(0xFF00C853); // Income Green

  @override
  Color get expense => const Color(0xFFD32F2F); // Expense Red

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
  Color get backgroundDark => const Color(0xFF0B0418); // Deep Space

  @override
  Color get surfaceLight => const Color(0xFFFFFFFF);

  @override
  Color get surfaceDark => const Color(0xFF1E1B2E); // Glass Plum

  @override
  Color get surfaceContainerDark =>
      const Color(0xFF2D2A42); // Flux / Surface Highlight

  @override
  Color get textPrimaryLight => const Color(0xFF1C1C1E); // Neutral Black

  @override
  Color get textSecondaryLight => const Color(0xFF8E8E93); // Neutral Grey

  @override
  Color get textPrimaryDark => const Color(0xFFE2E8F0); // Mist

  @override
  Color get textSecondaryDark => const Color(0xFF94A3B8); // Periwinkle

  @override
  Color get white => const Color(0xFFFFFFFF);

  @override
  Color get black => const Color(0xFF000000);

  @override
  Color get transparent => Colors.transparent;

  @override
  List<List<Color>> get chartBarColors => const [
        [Color(0xFF6366F1), Color(0xFF818CF8)], // Indigo
        [Color(0xFF8B5CF6), Color(0xFFA78BFA)], // Violet
        [Color(0xFFEC4899), Color(0xFFF472B6)], // Pink
        [Color(0xFFF59E0B), Color(0xFFFBBF24)], // Amber
        [Color(0xFF10B981), Color(0xFF34D399)], // Emerald
        [Color(0xFF3B82F6), Color(0xFF60A5FA)], // Blue
        [Color(0xFFEF4444), Color(0xFFF87171)], // Red
        [Color(0xFF06B6D4), Color(0xFF22D3EE)], // Cyan
      ];

  @override
  List<Color> get chartLineGradient => const [
        Color(0xFF3B82F6), // Blue
        Color(0xFF06B6D4), // Cyan
      ];

  @override
  Color getTooltipColor(bool isDark) {
    return isDark ? const Color(0xFF1F2937) : white;
  }

  @override
  List<Color> get categoryColors => const [
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

  @override
  Color getCategoryColor(String category) {
    if (category.isEmpty) return primaryLight;

    // Consistent color mapping based on hash code
    final int hash = category.trim().toLowerCase().hashCode;
    return categoryColors[hash.abs() % categoryColors.length];
  }
}
