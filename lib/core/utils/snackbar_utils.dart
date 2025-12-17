import 'package:flutter/material.dart';
import '../constants/design_constants.dart';

/// Centralized Snackbar Utility for BalanceIQ
///
/// Provides consistent snackbar implementations across the app with:
/// - Success, Error, Info, and Warning types
/// - Consistent styling (floating, rounded corners)
/// - Customizable duration
/// - Action button support
/// - Material Design 3 compliance
///
/// Usage:
/// ```dart
/// SnackbarUtils.showSuccess(context, 'Operation completed!');
/// SnackbarUtils.showError(context, 'Failed to save');
/// SnackbarUtils.showInfo(context, 'Coming soon');
/// ```
class SnackbarUtils {
  SnackbarUtils._(); // Private constructor to prevent instantiation

  /// Default duration for snackbars (3 seconds)
  static const Duration _defaultDuration = Duration(seconds: 3);

  /// Duration for short snackbars (2 seconds)
  static const Duration _shortDuration = Duration(seconds: 2);

  /// Duration for long snackbars (5 seconds)
  static const Duration _longDuration = Duration(seconds: 5);

  /// Show a success snackbar (green background)
  ///
  /// [context]: BuildContext for ScaffoldMessenger
  /// [message]: The message to display
  /// [duration]: Optional custom duration (default: 3 seconds)
  /// [action]: Optional action button
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: Colors.green,
      duration: duration ?? _defaultDuration,
      action: action,
    );
  }

  /// Show an error snackbar (red/error color background)
  ///
  /// [context]: BuildContext for ScaffoldMessenger
  /// [message]: The error message to display
  /// [duration]: Optional custom duration (default: 3 seconds)
  /// [action]: Optional action button (e.g., "Retry")
  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: duration ?? _defaultDuration,
      action: action,
    );
  }

  /// Show an info snackbar (neutral background)
  ///
  /// [context]: BuildContext for ScaffoldMessenger
  /// [message]: The info message to display
  /// [duration]: Optional custom duration (default: 2 seconds)
  /// [action]: Optional action button
  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]
          : Colors.grey[700],
      duration: duration ?? _shortDuration,
      action: action,
    );
  }

  /// Show a warning snackbar (orange/warning color background)
  ///
  /// [context]: BuildContext for ScaffoldMessenger
  /// [message]: The warning message to display
  /// [duration]: Optional custom duration (default: 3 seconds)
  /// [action]: Optional action button
  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: Colors.orange,
      duration: duration ?? _defaultDuration,
      action: action,
    );
  }

  /// Show a custom snackbar with full control over styling
  ///
  /// Use this when you need specific styling that doesn't fit
  /// the standard success/error/info/warning types
  ///
  /// [context]: BuildContext for ScaffoldMessenger
  /// [message]: The message to display
  /// [backgroundColor]: Background color
  /// [textColor]: Text color (default: white)
  /// [duration]: Duration to show snackbar
  /// [action]: Optional action button
  /// [behavior]: SnackBarBehavior (default: floating)
  /// [borderRadius]: Border radius for rounded corners
  static void showCustom(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration? duration,
    SnackBarAction? action,
    SnackBarBehavior? behavior,
    double? borderRadius,
  }) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      duration: duration ?? _defaultDuration,
      action: action,
      behavior: behavior ?? SnackBarBehavior.floating,
      borderRadius: borderRadius ?? DesignConstants.radiusMedium,
    );
  }

  /// Internal method to show snackbar with consistent styling
  static void _showSnackbar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = _defaultDuration,
    SnackBarAction? action,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    double borderRadius = DesignConstants.radiusMedium,
  }) {
    // Clear any existing snackbars first
    ScaffoldMessenger.of(context).clearSnackBars();

    // Show new snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: textColor ?? Colors.white,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: behavior,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        action: action,
      ),
    );
  }

  /// Clear all active snackbars
  ///
  /// Useful when navigating away from a screen or before showing a new snackbar
  static void clear(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  /// Show a snackbar with a dismiss action
  ///
  /// [context]: BuildContext for ScaffoldMessenger
  /// [message]: The message to display
  /// [type]: Type of snackbar (success, error, info, warning)
  /// [dismissLabel]: Label for dismiss button (default: "Dismiss")
  static void showWithDismiss(
    BuildContext context,
    String message, {
    SnackbarType type = SnackbarType.info,
    String dismissLabel = 'Dismiss',
    Duration? duration,
  }) {
    final action = SnackBarAction(
      label: dismissLabel,
      textColor: Colors.white,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    );

    switch (type) {
      case SnackbarType.success:
        showSuccess(context, message, action: action, duration: duration);
        break;
      case SnackbarType.error:
        showError(context, message, action: action, duration: duration);
        break;
      case SnackbarType.warning:
        showWarning(context, message, action: action, duration: duration);
        break;
      case SnackbarType.info:
        showInfo(context, message, action: action, duration: duration);
        break;
    }
  }

  /// Show a "Coming Soon" info snackbar
  ///
  /// Convenience method for features not yet implemented
  ///
  /// [context]: BuildContext for ScaffoldMessenger
  /// [featureName]: Optional feature name to include in message
  static void showComingSoon(BuildContext context, [String? featureName]) {
    final message = featureName != null
        ? '$featureName - Coming Soon'
        : 'Coming Soon';
    showInfo(context, message);
  }

  /// Show a network error snackbar with retry action
  ///
  /// [context]: BuildContext for ScaffoldMessenger
  /// [message]: Error message (default: "No internet connection")
  /// [onRetry]: Callback when retry is pressed
  static void showNetworkError(
    BuildContext context, {
    String? message,
    VoidCallback? onRetry,
  }) {
    final action = onRetry != null
        ? SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: onRetry,
          )
        : null;

    showError(
      context,
      message ?? 'No internet connection',
      action: action,
      duration: _longDuration,
    );
  }
}

/// Enum for snackbar types
enum SnackbarType {
  success,
  error,
  info,
  warning,
}
