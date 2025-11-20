import 'package:flutter/material.dart';

class AppTheme {
  // New Design System Colors (Updated to match design)
  static const Color primaryColor = Color(0xFF2bee4b); // Primary green (brighter)
  static const Color accentColor = Color(0xFF2bee4b);
  static const Color backgroundLight =
      Color(0xFFF6F8F6); // Light theme background
  static const Color backgroundDark =
      Color(0xFF102213); // Dark theme background (darker green-tint)

  // Text Colors
  static const Color textLightTheme = Color(0xFF111827);
  static const Color textDarkTheme = Color(0xFFE5E7EB);
  static const Color textSubtleLight = Color(0xFF6B7280);
  static const Color textSubtleDark = Color(0xFF9CA3AF);

  // Bot Colors
  static const Color balanceTrackerColor = Color(0xFF4CAF50); // Green
  static const Color investmentGuruColor = Color(0xFF9C27B0); // Purple
  static const Color budgetPlannerColor = Color(0xFF2196F3); // Blue
  static const Color finTipsColor = Color(0xFFFFC107); // Yellow

  // Text Colors
  static const Color textDark = Color(0xFF000000);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF757575);

  // Message Bubble Colors
  static const Color userMessageColor = primaryColor;
  static const Color botMessageLightColor = Color(0xFFE0E0E0);
  static const Color botMessageDarkColor = Color(0xFF283339);

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLight,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
        error: Colors.red,
        onPrimary: investmentGuruColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
      ),
      fontFamily: 'Manrope',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textDark,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textGrey,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundDark,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.black.withOpacity(0.2), // Match design card backgrounds
        error: Colors.red,
        onPrimary: budgetPlannerColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: true,
      ),
      fontFamily: 'Manrope',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textLight,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textLight,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textLight,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Color(0xFFB0B0B0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  static Color getBotColor(String botId) {
    switch (botId) {
      case 'balance_tracker':
        return balanceTrackerColor;
      case 'investment_guru':
        return investmentGuruColor;
      case 'budget_planner':
        return budgetPlannerColor;
      case 'fin_tips':
        return finTipsColor;
      default:
        return primaryColor;
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
