import 'package:flutter/material.dart';

class ChatAttachmentButton extends StatelessWidget {
  final Color primaryColor;
  final bool isDisabled;
  final VoidCallback? onTap;

  const ChatAttachmentButton({
    super.key,
    required this.primaryColor,
    required this.isDisabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add_rounded,
          color: isDisabled ? Colors.grey : primaryColor,
          size: 22,
        ),
      ),
    );
  }
}
