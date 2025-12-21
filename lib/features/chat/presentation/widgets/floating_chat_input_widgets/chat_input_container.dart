import 'package:flutter/material.dart';

class ChatInputContainer extends StatelessWidget {
  final Widget child;
  final bool hasFocus;
  final bool hasContent;
  final bool isDark;

  const ChatInputContainer({
    super.key,
    required this.child,
    required this.hasFocus,
    required this.hasContent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()..scale(hasFocus ? 1.02 : 1.0),
      transformAlignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        // Glassmorphic background
        color: isDark
            ? Theme.of(context).cardColor.withOpacity(hasFocus ? 1.0 : 0.95)
            : Theme.of(context).cardColor.withOpacity(hasFocus ? 1.0 : 0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: hasFocus
              ? primaryColor.withOpacity(0.8) // Stronger glow on focus
              : (hasContent
                  ? primaryColor.withOpacity(0.6)
                  : (isDark
                      ? primaryColor.withOpacity(0.2)
                      : primaryColor.withOpacity(0.15))),
          width: hasFocus ? 2.5 : (hasContent ? 2.0 : 1.5),
        ),
        boxShadow: [
          // Spotlight Glow
          if (hasFocus)
            BoxShadow(
              color: primaryColor.withOpacity(0.5),
              blurRadius: 16,
              spreadRadius: 4,
              offset: const Offset(0, 4),
            ),
          // Primary shadow
          BoxShadow(
            color: hasContent
                ? primaryColor.withOpacity(0.35)
                : primaryColor.withOpacity(0.15),
            blurRadius: hasContent ? 10 : 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
