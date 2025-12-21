import 'package:flutter/material.dart';

class ChatAttachmentButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isEnabled;

  const ChatAttachmentButton({
    super.key,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add_rounded,
          color: isEnabled ? primaryColor : Colors.grey,
          size: 22,
        ),
      ),
    );
  }
}
