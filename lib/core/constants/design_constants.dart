import 'package:flutter/material.dart';

/// Design Constants for Donfin AI (2025 Design System)
/// Spacing, Typography, Elevation, and Animation constants
/// Last Updated: 2025-12-15

class DesignConstants {
  // ==================== SPACING SYSTEM (8pt Grid) ====================

  /// Base spacing unit (8dp)
  static const double spaceUnit = 8.0;

  /// Spacing scale based on 8pt grid
  static const double space0 = 0.0;      // 0dp - No space
  static const double space1 = 4.0;      // 4dp - Micro spacing
  static const double space2 = 8.0;      // 8dp - Base unit
  static const double space3 = 12.0;     // 12dp - Small spacing
  static const double space4 = 16.0;     // 16dp - Standard spacing
  static const double space5 = 20.0;     // 20dp - Medium spacing
  static const double space6 = 24.0;     // 24dp - Large spacing
  static const double space8 = 32.0;     // 32dp - XL spacing
  static const double space10 = 40.0;    // 40dp - XXL spacing
  static const double space12 = 48.0;    // 48dp - XXXL spacing
  static const double space16 = 64.0;    // 64dp - Huge spacing

  // Chat-specific spacing
  static const double messageBubblePadding = 12.0;
  static const double messageBubbleHorizontal = 16.0;
  static const double messageSpacing = 8.0;
  static const double inputPadding = 16.0;
  static const double inputFieldHeight = 56.0;

  // ==================== BORDER RADIUS ====================

  static const double radiusSmall = 8.0;      // Small components
  static const double radiusMedium = 12.0;    // Cards, containers
  static const double radiusLarge = 16.0;     // Large cards
  static const double radiusXL = 20.0;        // Modals, sheets
  static const double radiusXXL = 24.0;       // Hero elements
  static const double radiusPill = 999.0;     // Pill-shaped (fully rounded)

  // Message bubble specific
  static const double messageBubbleRadius = 20.0;
  static const double inputFieldRadius = 28.0;

  // ==================== ELEVATION & SHADOWS ====================

  /// Elevation levels for Material Design 3
  static BoxShadow elevation0() => const BoxShadow(
        color: Colors.transparent,
        blurRadius: 0,
        offset: Offset(0, 0),
      );

  static BoxShadow elevation1(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxShadow(
      color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.08),
      blurRadius: 4,
      offset: const Offset(0, 1),
    );
  }

  static BoxShadow elevation2(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxShadow(
      color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.12),
      blurRadius: 8,
      offset: const Offset(0, 2),
    );
  }

  static BoxShadow elevation3(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxShadow(
      color: isDark ? Colors.black.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.16),
      blurRadius: 16,
      offset: const Offset(0, 4),
    );
  }

  static BoxShadow elevation4(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxShadow(
      color: isDark ? Colors.black.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.20),
      blurRadius: 24,
      offset: const Offset(0, 8),
    );
  }

  // Glow effect for primary elements
  static BoxShadow primaryGlow(BuildContext context, Color color) {
    return BoxShadow(
      color: color.withValues(alpha: 0.3),
      blurRadius: 16,
      offset: const Offset(0, 4),
    );
  }

  // ==================== ANIMATION DURATIONS ====================

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Message-specific animations
  static const Duration messageEntryDuration = Duration(milliseconds: 400);
  static const Duration typingIndicatorDuration = Duration(milliseconds: 600);
  static const Duration buttonPressDuration = Duration(milliseconds: 100);
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  // Animation curves
  static const Curve animationCurve = Curves.easeOutCubic;
  static const Curve animationCurveIn = Curves.easeIn;
  static const Curve animationCurveOut = Curves.easeOut;
  static const Curve bounceCurve = Curves.elasticOut;

  // ==================== TYPOGRAPHY SCALE ====================

  /// Font sizes following Material Design 3
  static const double fontSizeXS = 10.0;    // Micro text
  static const double fontSizeS = 12.0;     // Captions, timestamps
  static const double fontSizeM = 14.0;     // Body text, messages
  static const double fontSizeL = 16.0;     // Large body, buttons
  static const double fontSizeXL = 18.0;    // Subtitles
  static const double fontSize2XL = 20.0;   // Titles
  static const double fontSize3XL = 24.0;   // Headlines
  static const double fontSize4XL = 28.0;   // Display
  static const double fontSize5XL = 32.0;   // Large display

  // Line heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;

  // Font weights
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  // ==================== TOUCH TARGETS (Accessibility) ====================

  /// Minimum touch target size for WCAG 2.2 AA compliance
  static const double minTouchTarget = 48.0;
  static const double recommendedTouchTarget = 48.0;

  /// Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXL = 32.0;

  // Button sizes
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  // ==================== RESPONSIVE BREAKPOINTS ====================

  static const double breakpointMobile = 600;      // 0-599dp
  static const double breakpointTablet = 840;      // 600-839dp
  static const double breakpointDesktop = 1240;    // 840+dp

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointMobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointMobile && width < breakpointTablet;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointTablet;
  }

  // ==================== GLASSMORPHISM EFFECTS ====================

  /// Blur amount for glassmorphism effect
  static const double glassBlurAmount = 10.0;

  /// Opacity for glass containers
  static const double glassOpacity = 0.85;

  /// Border width for glass containers
  static const double glassBorderWidth = 1.0;

  // ==================== Z-INDEX / LAYER HIERARCHY ====================

  static const int layerBackground = 0;
  static const int layerContent = 1;
  static const int layerFloating = 2;
  static const int layerModal = 3;
  static const int layerPopup = 4;
  static const int layerToast = 5;

  // ==================== CHAT SPECIFIC CONSTANTS ====================

  /// Maximum width for message bubbles (prevents overly wide messages)
  static const double maxMessageWidth = 320.0;

  /// Avatar sizes
  static const double avatarSizeSmall = 24.0;
  static const double avatarSizeMedium = 32.0;
  static const double avatarSizeLarge = 40.0;

  /// Input field constraints
  static const double inputMinLines = 1;
  static const double inputMaxLines = 6;

  /// Suggested prompt chip sizes
  static const double chipHeight = 40.0;
  static const double chipPadding = 16.0;

  /// Loading indicator sizes
  static const double loadingIndicatorSmall = 16.0;
  static const double loadingIndicatorMedium = 24.0;
  static const double loadingIndicatorLarge = 32.0;
}
