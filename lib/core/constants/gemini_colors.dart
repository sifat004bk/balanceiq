import 'package:flutter/material.dart';

/// Gemini-style color palette for Material Design 3
/// Based on Google Gemini app UI research
/// Gemini-style color palette for Material Design 3
/// Based on Google Gemini app UI research
/// Gemini-style color palette for Material Design 3
/// Based on Google Gemini app UI research
class GeminiColors {
  // Primary Colors
  static const Color primaryLight = Color(0xFF6442d6); // Gemini purple (Light)
  static const Color primaryDark = Color(0xFFcbbeff); // Gemini purple (Dark)
  
  static const Color primaryContainerLight = Color(0xFFe8deff);
  static const Color primaryContainerDark = Color(0xFF4b21bd);

  // User Message Colors
  static const Color userMessageBg = Color(0xFF303030); // Dark Grey from screenshot
  static const Color userMessageText = Color(0xFFffffff); // White

  // AI Message Colors (Light Mode)
  static const Color aiMessageBgLight = Color(0xFFf2ecee); // Surface 2 (Light)
  static const Color aiMessageTextLight = Color(0xFF1c1b1d); // On Surface (Light)

  // AI Message Colors (Dark Mode)
  static const Color aiMessageBgDark = Color(0xFF131314); // Darker background
  static const Color aiMessageTextDark = Color(0xFFece7ea); // On Surface (Dark)

  // Background Colors
  static const Color backgroundLight = Color(0xFFfefbff); // Off-white
  static const Color backgroundDark = Color(0xFF131314); // Darker background from screenshot

  // Surface Colors
  static const Color surfaceLight = Color(0xFFffffff); // Pure white
  static const Color surfaceDark = Color(0xFF1e1f20); // Dark grey (Surface 1)

  // Input Field Colors
  static const Color inputBgLight = Color(0xFFf2ecee); // Surface 2 (Light)
  static const Color inputBgDark = Color(0xFF1e1f20); // Surface 2 (Dark)
  static const Color inputBorderLight = Color(0xFFe8e0e8); // Surface Variant (Light)
  static const Color inputBorderDark = Color(0xFF49454e); // Surface Variant (Dark)

  // Icon Colors
  static const Color iconLight = Color(0xFF1c1b1d); // On Surface
  static const Color iconDark = Color(0xFFc4c7c5); // Light grey icon

  // Suggested Prompt Chip Colors
  static const Color chipBgLight = Color(0xFFe8deff); // Primary Container
  static const Color chipBgDark = Color(0xFF4b21bd); // Primary Container
  static const Color chipBorderLight = Color(0xFF6442d6); // Primary
  static const Color chipBorderDark = Color(0xFFcbbeff); // Primary

  // Divider/Border Colors
  static const Color dividerLight = Color(0xFFece7e9); // Surface 3
  static const Color dividerDark = Color(0xFF3a3a3f); // Surface 3

  // Text Colors (Secondary)
  static const Color textSecondaryLight = Color(0xFF787579); // Outline
  static const Color textSecondaryDark = Color(0xFFc4c7c5); // Outline

  // Gemini Bot Avatar Colors
  static const Color botAvatarBg = Color(0xFF6442d6);
  static const Color botAvatarIcon = Color(0xFFffffff);

  // Helper methods to get theme-aware colors
  static Color get primary => primaryLight; // Default to light for static access if needed, but prefer context methods

  static Color primaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? primaryDark : primaryLight;
  }

  static Color userMessageBackground(BuildContext context) => userMessageBg;

  static Color aiMessageBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? aiMessageBgDark : aiMessageBgLight;
  }

  static Color aiMessageText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? aiMessageTextDark : aiMessageTextLight;
  }

  static Color background(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? backgroundDark : backgroundLight;
  }

  static Color surface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? surfaceDark : surfaceLight;
  }

  static Color inputBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? inputBgDark : inputBgLight;
  }

  static Color inputBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? inputBorderDark : inputBorderLight;
  }

  static Color icon(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? iconDark : iconLight;
  }

  static Color chipBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? chipBgDark : chipBgLight;
  }

  static Color chipBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? chipBorderDark : chipBorderLight;
  }

  static Color divider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dividerDark : dividerLight;
  }

  static Color textSecondary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? textSecondaryDark : textSecondaryLight;
  }
}
