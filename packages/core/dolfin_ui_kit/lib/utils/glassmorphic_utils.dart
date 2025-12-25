import 'dart:ui';
import 'package:flutter/material.dart';

/// Utility class for creating glassmorphic UI elements
class GlassmorphicUtils {
  GlassmorphicUtils._(); // Private constructor

  /// Creates a glassmorphic dialog theme
  static DialogTheme getDialogTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DialogTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }

  /// Wraps content in a glassmorphic container
  static Widget wrapWithGlass({
    required Widget child,
    required BuildContext context,
    double borderRadius = 24,
    double blur = 10,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  /// Creates a glassmorphic AlertDialog
  static Widget createGlassmorphicDialog({
    required BuildContext context,
    Widget? title,
    Widget? content,
    List<Widget>? actions,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: wrapWithGlass(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleLarge!,
                  child: title,
                ),
                const SizedBox(height: 16),
              ],
              if (content != null) ...[
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!,
                  child: content,
                ),
                const SizedBox(height: 24),
              ],
              if (actions != null && actions.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions
                      .map((action) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: action,
                          ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a glassmorphic bottom sheet decoration
  static BoxDecoration getBottomSheetDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BoxDecoration(
      color: isDark
          ? Colors.white.withOpacity(0.1)
          : Colors.white.withOpacity(0.7),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.3),
        width: 1.5,
      ),
    );
  }

  /// Wraps a bottom sheet with glassmorphic effect
  static Widget wrapBottomSheet({
    required Widget child,
    required BuildContext context,
  }) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: getBottomSheetDecoration(context),
          child: child,
        ),
      ),
    );
  }

  /// Creates a glassmorphic SnackBar
  static SnackBar createGlassmorphicSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(isDark ? 0.3 : 0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: backgroundColor.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
