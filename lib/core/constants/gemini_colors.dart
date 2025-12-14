import 'package:flutter/material.dart';

/// Gemini-style color palette for Material Design 3 (2025 Enhanced)
/// Based on Google Gemini app UI research with glassmorphism support
/// Last Updated: 2025-12-15
class GeminiColors {
  // Primary Colors (Enhanced vibrancy for 2025)
  static const Color primaryLight = Color(0xFF6750A4); // Material Design 3 Purple
  static const Color primaryDark = Color(0xFFD0BCFF); // Material Design 3 Purple (Dark)
  static const Color primaryAccentLight = Color(0xFF8A7AE0); // Lighter accent
  static const Color primaryAccentDark = Color(0xFFB8A4F0); // Muted accent
  static const Color primaryGlowLight = Color(0xFFE8DEFF); // Glow effect
  static const Color primaryGlowDark = Color(0xFF5E44BD); // Glow effect (dark)

  static const Color primaryContainerLight = Color(0xFFe8deff);
  static const Color primaryContainerDark = Color(0xFF4b21bd);

  // Glassmorphism Support Colors (NEW for 2025)
  static const Color glassBackgroundLight = Color(0xFFFEFBFF); // Semi-transparent base
  static const Color glassFrostLight = Color(0xFFF5F0FF); // Frosted glass effect
  static const Color glassBorderLight = Color(0xFFE0D7FF); // Glass border
  static const Color glassBackgroundDark = Color(0xFF1C1B1F); // Semi-transparent base
  static const Color glassFrostDark = Color(0xFF2B2930); // Frosted glass effect
  static const Color glassBorderDark = Color(0xFF3E3948); // Glass border

  // User Message Colors (Enhanced with gradient support)
  static const Color userMessageBgStart = Color(0xFF6750A4); // Gradient start
  static const Color userMessageBgEnd = Color(0xFF5E4FA2); // Gradient end
  static const Color userMessageBg = Color(0xFF6750A4); // Solid fallback
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

  // Semantic Financial Colors (NEW for 2025)
  static const Color incomeGreen = Color(0xFF00C853); // Vibrant success green
  static const Color incomeGreenLight = Color(0xFFE8F5E9); // Background tint
  static const Color expenseRed = Color(0xFFFF5252); // Coral red
  static const Color expenseRedLight = Color(0xFFFFEBEE); // Background tint
  static const Color neutralGray = Color(0xFF78909C); // Neutral transactions
  static const Color neutralGrayLight = Color(0xFFECEFF1); // Background tint

  // Warning colors for token limits
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color warningOrangeLight = Color(0xFFFFF3E0);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color errorRedLight = Color(0xFFFFEBEE);

  // Gemini Bot Avatar Colors
  static const Color botAvatarBg = Color(0xFF6750A4);
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

  // NEW: Glassmorphism helper methods
  static Color glassFrost(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? glassFrostDark : glassFrostLight;
  }

  static Color glassBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? glassBorderDark : glassBorderLight;
  }

  static Color glassBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? glassBackgroundDark : glassBackgroundLight;
  }

  // NEW: User message gradient
  static LinearGradient userMessageGradient() {
    return const LinearGradient(
      colors: [userMessageBgStart, userMessageBgEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // NEW: Primary accent color
  static Color primaryAccent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? primaryAccentDark : primaryAccentLight;
  }

  // NEW: Primary glow color
  static Color primaryGlow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? primaryGlowDark : primaryGlowLight;
  }
}
