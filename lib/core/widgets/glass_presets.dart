import 'dart:ui';
import 'package:flutter/material.dart';

/// Preset configurations for glassmorphism effects
enum GlassPreset {
  /// Subtle glass - minimal blur, high opacity
  subtle,

  /// Medium glass - balanced blur and opacity
  medium,

  /// Strong glass - heavy blur, low opacity
  strong,

  /// Card glass - optimized for card containers
  card,

  /// Modal glass - for bottom sheets and dialogs
  modal;

  double blur(bool isDark) {
    switch (this) {
      case GlassPreset.subtle:
        return isDark ? 8.0 : 5.0;
      case GlassPreset.medium:
        return isDark ? 20.0 : 10.0;
      case GlassPreset.strong:
        return isDark ? 30.0 : 15.0;
      case GlassPreset.card:
        return isDark ? 15.0 : 8.0;
      case GlassPreset.modal:
        return isDark ? 25.0 : 12.0;
    }
  }

  double opacity(bool isDark) {
    switch (this) {
      case GlassPreset.subtle:
        return isDark ? 0.8 : 0.9;
      case GlassPreset.medium:
        return isDark ? 0.65 : 0.85;
      case GlassPreset.strong:
        return isDark ? 0.5 : 0.7;
      case GlassPreset.card:
        return isDark ? 0.7 : 0.85;
      case GlassPreset.modal:
        return isDark ? 0.6 : 0.8;
    }
  }
}

/// Helper class to create theme-aware glass containers
class ThemedGlass {
  const ThemedGlass._();

  /// Create a theme-aware glass container
  static Widget container({
    required BuildContext context,
    required Widget child,
    GlassPreset preset = GlassPreset.medium,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 20.0,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: preset.blur(isDark),
            sigmaY: preset.blur(isDark),
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.white)
                  .withOpacity(preset.opacity(isDark)),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.grey)
                      .withOpacity(isDark ? 0.3 : 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
