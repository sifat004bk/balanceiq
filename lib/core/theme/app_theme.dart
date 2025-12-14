import 'package:flutter/material.dart';

class AppTheme {
  // Material 3 Expressive - Primary Palette
  static const Color primaryLight = Color(0xFF6750A4); // Deep Purple
  static const Color primaryDark = Color(0xFFD0BCFF);
  static const Color primaryContainerLight = Color(0xFFEADDFF);
  static const Color primaryContainerDark = Color(0xFF4F378B);
  
  // Secondary & Tertiary
  static const Color secondaryLight = Color(0xFF625B71);
  static const Color secondaryDark = Color(0xFFCCC2DC);
  static const Color tertiaryLight = Color(0xFF7D5260); // Warm Rose
  static const Color tertiaryDark = Color(0xFFEFB8C8);
  
  // Semantic Colors - Income/Expense
  static const Color incomeLight = Color(0xFF00C853); // Vibrant Green
  static const Color incomeDark = Color(0xFF69F0AE);
  static const Color expenseLight = Color(0xFFFF5252); // Coral Red
  static const Color expenseDark = Color(0xFFFF8A80);
  static const Color neutralLight = Color(0xFF625B71);
  static const Color neutralDark = Color(0xFF938F99);
  
  // Surface & Background
  static const Color backgroundLight = Color(0xFFFEF7FF); // Warm Off-white
  static const Color backgroundDark = Color(0xFF1C1B1F); // Deep charcoal
  static const Color surfaceLight = Color(0xFFFFFBFE);
  static const Color surfaceDark = Color(0xFF2B2930);
  static const Color surfaceVariantLight = Color(0xFFE7E0EC);
  static const Color surfaceVariantDark = Color(0xFF49454F);

  // Text Colors
  static const Color textLightTheme = Color(0xFF1C1B1F);
  static const Color textDarkTheme = Color(0xFFE6E1E5);
  static const Color textSubtleLight = Color(0xFF49454F);
  static const Color textSubtleDark = Color(0xFFCAC4D0);

  // Bot Colors (kept for chat functionality)
  static const Color balanceTrackerColor = Color(0xFF4CAF50);
  static const Color investmentGuruColor = Color(0xFF9C27B0);
  static const Color budgetPlannerColor = Color(0xFF2196F3);
  static const Color finTipsColor = Color(0xFFFFC107);

  // Legacy compatibility
  static const Color textDark = Color(0xFF1C1B1F);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF757575);

  // Message Bubble Colors
  static Color userMessageColor = primaryLight;
  static const Color botMessageLightColor = Color(0xFFE7E0EC);
  static const Color botMessageDarkColor = Color(0xFF2B2930);
  
  // Gradient Definitions
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [Color(0xFF6750A4), Color(0xFF5E4FA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFFD0BCFF), Color(0xFFBBA4E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradientLight = LinearGradient(
    colors: [Color(0xFF6750A4), Color(0xFF5E8FD9)], // Purple to Blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradientDark = LinearGradient(
    colors: [Color(0xFFD0BCFF), Color(0xFFEFB8C8)], // Purple to Pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Compatibility property for files still using primaryColor
  static const Color primaryColor = primaryLight;
  static const Color accentColor = primaryLight;

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: backgroundLight,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        onPrimary: Colors.white,
        primaryContainer: primaryContainerLight,
        onPrimaryContainer: Color(0xFF21005D),
        secondary: secondaryLight,
        onSecondary: Colors.white,
        tertiary: tertiaryLight,
        onTertiary: Colors.white,
        surface: surfaceLight,
        onSurface: textLightTheme,
        surfaceContainerHighest: surfaceVariantLight,
        error: expenseLight,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundLight,
        foregroundColor: textLightTheme,
        elevation: 0,
        centerTitle: true,
      ),
      fontFamily: 'Manrope',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textLightTheme,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textLightTheme,
          letterSpacing: -0.3,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textLightTheme,
          letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textLightTheme,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textLightTheme,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSubtleLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariantLight,
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
      primaryColor: primaryDark,
      scaffoldBackgroundColor: backgroundDark,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        onPrimary: Color(0xFF381E72),
        primaryContainer: primaryContainerDark,
        onPrimaryContainer: Color(0xFFEADDFF),
        secondary: secondaryDark,
        onSecondary: Color(0xFF332D41),
        tertiary: tertiaryDark,
        onTertiary: Color(0xFF492532),
        surface: surfaceDark,
        onSurface: textDarkTheme,
        surfaceContainerHighest: surfaceVariantDark,
        error: expenseDark,
        onError: Color(0xFF690005),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: textDarkTheme,
        elevation: 0,
        centerTitle: true,
      ),
      fontFamily: 'Manrope',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textDarkTheme,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textDarkTheme,
          letterSpacing: -0.3,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textDarkTheme,
          letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textDarkTheme,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textDarkTheme,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSubtleDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Color(0xFF381E72),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
          shadowColor: primaryDark.withOpacity(0.3),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariantDark,
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
