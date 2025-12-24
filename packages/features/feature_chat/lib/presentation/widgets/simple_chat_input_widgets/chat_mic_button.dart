import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'recording_animation.dart';

class ChatMicButton extends StatelessWidget {
  final bool isRecording;
  final bool isDisabled;
  final Color primaryColor;
  final VoidCallback? onTap;

  const ChatMicButton({
    super.key,
    required this.isRecording,
    required this.isDisabled,
    required this.primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScale(
      scale: isRecording ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: isRecording
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.error,
                      Theme.of(context).colorScheme.error,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isRecording
                ? null
                : (isDark
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).dividerColor),
            shape: BoxShape.circle,
            boxShadow: isRecording
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .error
                          .withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .error
                          .withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: isRecording
              ? const RecordingAnimation()
              : Icon(
                  LucideIcons.mic,
                  color: isDisabled ? Colors.grey : primaryColor,
                  size: 22,
                ),
        ),
      ),
    );
  }
}
