import 'package:flutter/material.dart';

class ChatSendButton extends StatelessWidget {
  final bool hasContent;
  final bool isDisabled;
  final Color primaryColor;
  final VoidCallback? onTap;

  const ChatSendButton({
    super.key,
    required this.hasContent,
    required this.isDisabled,
    required this.primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = hasContent && !isDisabled;

    return AnimatedScale(
      scale: isActive ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTap: isActive ? onTap : null,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      primaryColor,
                      primaryColor.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isActive
                ? null
                : (isDark
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).dividerColor),
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.arrow_upward_rounded,
            color: isActive
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).hintColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}
