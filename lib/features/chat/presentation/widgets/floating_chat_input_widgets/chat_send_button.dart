import 'package:flutter/material.dart';

class ChatSendButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isDark;

  const ChatSendButton({
    super.key,
    required this.onTap,
    this.isEnabled = true,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return AnimatedScale(
      scale: isEnabled ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: isEnabled
                ? LinearGradient(
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isEnabled
                ? null
                : (isDark
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).dividerColor),
            shape: BoxShape.circle,
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.arrow_upward_rounded,
            color: isEnabled
                ? Theme.of(context).colorScheme.onPrimary
                : Colors.grey,
            size: 24,
          ),
        ),
      ),
    );
  }
}
