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
        color: AppPalette.neutralGrey,
        letterSpacing: 0.1,
        height: 1.4,
      );

  /// Link: For clickable text
  static TextStyle get link => body.copyWith(
        color: AppPalette.trustBlue,
        fontWeight: FontWeight.w600,
      );
}
