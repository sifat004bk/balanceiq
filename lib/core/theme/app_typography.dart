import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_palette.dart';

/// Fluid Typography System for 2026.
/// Simplified hierarchy: Hero, Heading, Body, Detail.
class AppTypography {
  const AppTypography._();

  // We use Google Sans (Open Sans / Product Sans logic) if available,
  // otherwise we can fallback to Manrope or Inter.
  // 'GoogleFonts.outfit' is a great modern geometric sans match for 2026 fintech.
  // Using Manrope as it was legacy default, but modernizing the weights.
  static TextTheme textTheme = GoogleFonts.manropeTextTheme();

  /// Hero: Huge, thin/light. For Balances.
  static TextStyle get hero => textTheme.displayLarge!.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        height: 1.1,
      );

  /// Heading: Section titles.
  static TextStyle get heading => textTheme.titleLarge!.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600, // SemiBold
        letterSpacing: -0.5,
        height: 1.3,
      );

  /// Body: Default readable text.
  static TextStyle get body => textTheme.bodyLarge!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400, // Regular
        letterSpacing: 0.2,
        height: 1.6, // Airy line height
      );

  /// Detail: Captions, timestamps.
  static TextStyle get detail => textTheme.bodySmall!.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500, // Medium for readability at small sizes
        color: AppPalette.textSecondaryLight,
        letterSpacing: 0.1,
        height: 1.4,
      );

  /// Link: For clickable text
  static TextStyle get link => body.copyWith(
        color: AppPalette.primaryLight,
        fontWeight: FontWeight.w600,
      );

  // --- Display Styles ---

  /// Display Large: For hero numbers (40px, bold)
  static TextStyle get displayLarge => textTheme.displayLarge!.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        height: 1.1,
      );

  /// Display Medium: For large headings (28px, bold)
  static TextStyle get displayMedium => textTheme.displayMedium!.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
        height: 1.2,
      );

  // --- Headline Styles ---

  /// Headline Medium Bold: For section headings
  static TextStyle get headlineMediumBold => textTheme.headlineMedium!.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
      );

  /// Headline Small Bold: For smaller headings
  static TextStyle get headlineSmallBold => textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.bold,
      );

  // --- Title Styles ---

  /// Title XLarge Bold: For prominent titles (22px, w800)
  static TextStyle get titleXLargeBold => textTheme.titleLarge!.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        height: 1.3,
      );

  /// Title XLarge SemiBold: For titles (20px, w600)
  static TextStyle get titleXLargeSemiBold => textTheme.titleLarge!.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
      );

  /// Title Large Bold: For bold titles
  static TextStyle get titleLargeBold => textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
      );

  /// Title Medium Bold: For medium-sized bold titles
  static TextStyle get titleMediumBold => textTheme.titleMedium!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        height: 1.4,
      );

  // --- Body Styles ---

  /// Body Large: For standard text (16px)
  static TextStyle get bodyLarge => textTheme.bodyLarge!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.6,
      );

  /// Body Medium: For smaller text (14px)
  static TextStyle get bodyMedium => textTheme.bodyMedium!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.5,
      );

  /// Body Medium SemiBold: For emphasized text (14px, w500)
  static TextStyle get bodyMediumSemiBold => textTheme.bodyMedium!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.5,
      );

  /// Body Medium Bold: For bold body text
  static TextStyle get bodyMediumBold => textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.bold,
      );

  /// Body Large Bold: For bold large text
  static TextStyle get bodyLargeBold => textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.bold,
      );

  // --- Button Styles ---

  /// Button Large: For primary buttons (16px, bold)
  static TextStyle get buttonLarge => textTheme.labelLarge!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      );

  /// Button Medium: For standard buttons (16px, w600)
  static TextStyle get buttonMedium => textTheme.labelLarge!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  /// Button Medium SemiBold: For secondary buttons (w600)
  static TextStyle get buttonMediumSemiBold => textTheme.labelMedium!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  // --- Caption Styles ---

  /// Caption SemiBold: For emphasized captions (12px, w600)
  static TextStyle get captionSemiBold => textTheme.bodySmall!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.4,
      );

  /// Caption Bold: For bold captions (13px, w800)
  static TextStyle get captionBold => textTheme.bodySmall!.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
        height: 1.3,
      );

  /// Caption XSmall Bold: For tiny bold text (11px, w800)
  static TextStyle get captionXSmallBold => textTheme.bodySmall!.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
        height: 1.3,
      );

  /// Caption Subtle: For secondary captions (12px)
  static TextStyle get captionSubtle => textTheme.bodySmall!.copyWith(
        fontSize: 12,
        color: AppPalette.textSecondaryLight,
        letterSpacing: 0.1,
        height: 1.4,
      );

  /// Caption Medium: For standard captions (12px, w500)
  static TextStyle get captionMedium => textTheme.bodySmall!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
      );

  /// Caption Error: For error messages (13px, bold, red)
  static TextStyle get captionError => textTheme.bodySmall!.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppPalette.expense,
        letterSpacing: 0.1,
      );

  /// Caption Warning: For warning messages (12px, orange)
  static TextStyle get captionWarning => textTheme.bodySmall!.copyWith(
        fontSize: 12,
        color: AppPalette.secondaryLight,
        letterSpacing: 0.1,
      );

  // --- Input Styles ---

  /// Input Large: For large input fields (18px)
  static TextStyle get inputLarge => textTheme.bodyLarge!.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
      );
}
