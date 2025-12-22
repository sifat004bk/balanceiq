import 'package:flutter/material.dart';

/// Factory interface for creating tour-related widgets.
/// This allows the app layer to define the design of tour steps
/// while the core layer manages the logic.
abstract class TourWidgetFactory {
  /// Create a tooltip for a tour step.
  Widget createTooltip({
    required String title,
    required String description,
    String? buttonText,
    VoidCallback? onButtonPressed,
    IconData? icon,
    bool showSkip = true,
    VoidCallback? onSkip,
  });

  /// Create the special tooltip for the chat input hint.
  Widget createChatInputHint({
    VoidCallback? onDismiss,
    VoidCallback? onSkip,
  });
}
