import 'package:flutter/material.dart';

/// Gemini-style color palette for Material Design 3
/// Based on Google Gemini app UI research
class GeminiColors {
  // Primary Colors
  static const Color primary = Color(0xFF6442d6); // Gemini purple
  static const Color primaryContainer = Color(0xFFe8deff);

  // User Message Colors
  static const Color userMessageBg = Color(0xFF6442d6); // Purple
  static const Color userMessageText = Color(0xFFffffff); // White

  // AI Message Colors (Light Mode)
  static const Color aiMessageBgLight = Color(0xFFf2ecee); // Light beige
  static const Color aiMessageTextLight = Color(0xFF1a0a2e); // Dark purple

  // AI Message Colors (Dark Mode)
  static const Color aiMessageBgDark = Color(0xFF2a2a2e); // Dark grey
  static const Color aiMessageTextDark = Color(0xFFe5e1e6); // Light grey

  // Background Colors
  static const Color backgroundLight = Color(0xFFfefbff); // Off-white
  static const Color backgroundDark = Color(0xFF1a0a2e); // Deep purple-black

  // Surface Colors
  static const Color surfaceLight = Color(0xFFffffff); // Pure white
  static const Color surfaceDark = Color(0xFF2a2a2e); // Dark grey

  // Input Field Colors
  static const Color inputBgLight = Color(0xFFf5f5f5); // Light grey
  static const Color inputBgDark = Color(0xFF2a2a2e); // Dark grey
  static const Color inputBorderLight = Color(0xFFe0e0e0); // Light border
  static const Color inputBorderDark = Color(0xFF3a3a3e); // Dark border

  // Icon Colors
  static const Color iconLight = Color(0xFF5f6368); // Grey
  static const Color iconDark = Color(0xFF9aa0a6); // Light grey

  // Suggested Prompt Chip Colors
  static const Color chipBgLight = Color(0xFFf8f9fa);
  static const Color chipBgDark = Color(0xFF2a2a2e);
  static const Color chipBorderLight = Color(0xFFdadce0);
  static const Color chipBorderDark = Color(0xFF3a3a3e);

  // Divider/Border Colors
  static const Color dividerLight = Color(0xFFe8eaed);
  static const Color dividerDark = Color(0xFF3a3a3e);

  // Text Colors (Secondary)
  static const Color textSecondaryLight = Color(0xFF5f6368);
  static const Color textSecondaryDark = Color(0xFF9aa0a6);

  // Gemini Bot Avatar Colors
  static const Color botAvatarBg = Color(0xFF6442d6);
  static const Color botAvatarIcon = Color(0xFFffffff);

  // Helper methods to get theme-aware colors
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
