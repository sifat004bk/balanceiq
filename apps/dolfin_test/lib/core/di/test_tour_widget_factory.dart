import 'package:flutter/material.dart';
import 'package:dolfin_core/tour/tour_widget_factory.dart';

/// Stub tour widget factory for test app (no tour widgets)
class TestTourWidgetFactory implements TourWidgetFactory {
  @override
  Widget createTooltip({
    required String title,
    required String description,
    String? buttonText,
    VoidCallback? onButtonPressed,
    IconData? icon,
    bool showSkip = true,
    VoidCallback? onSkip,
  }) {
    return const SizedBox.shrink();
  }

  @override
  Widget createChatInputHint({
    VoidCallback? onDismiss,
    VoidCallback? onSkip,
  }) {
    return const SizedBox.shrink();
  }
}
