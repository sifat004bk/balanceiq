import 'package:flutter/material.dart';
import 'package:dolfin_core/tour/tour_widget_factory.dart';
import 'widgets/tour_content_widgets.dart';

class TourWidgetFactoryImpl implements TourWidgetFactory {
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
    return TourTooltipContent(
      title: title,
      description: description,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      icon: icon,
      showSkip: showSkip,
      onSkip: onSkip,
    );
  }

  @override
  Widget createChatInputHint({
    VoidCallback? onDismiss,
    VoidCallback? onSkip,
  }) {
    return ChatInputTourTooltip(
      onDismiss: onDismiss,
      onSkip: onSkip,
    );
  }
}
