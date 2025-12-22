import 'package:flutter/material.dart';

/// The "Core 5" Palette + Semantic Basics for 2026 Minimalist Theme.
/// This single source of truth replaces loose Color() calls.
abstract class AppPalette {
  // --- Primary Colors ---
  Color get primaryLight;
  Color get primaryDark;

  // --- Secondary/Accent Colors ---
  Color get secondaryLight;
  Color get secondaryDark;

  // --- Feedback Colors ---
  Color get income;
  Color get expense;
  Color get warning;

  Color get success;
  Color get error;
  Color get info;

  // --- Backgrounds ---
  Color get backgroundLight;
  Color get backgroundDark;

  // --- Surfaces ---
  Color get surfaceLight;
  Color get surfaceDark;
  Color get surfaceContainerDark;

  // --- Text & Neutrals ---
  Color get textPrimaryLight;
  Color get textSecondaryLight;

  Color get textPrimaryDark;
  Color get textSecondaryDark;

  Color get white;
  Color get black;
  Color get transparent;

  // --- Chart Colors ---
  List<List<Color>> get chartBarColors;

  List<Color> get chartLineGradient;

  Color getTooltipColor(bool isDark);

  // --- Category Colors ---
  List<Color> get categoryColors;

  /// Get category color by category name
  Color getCategoryColor(String category);
}
