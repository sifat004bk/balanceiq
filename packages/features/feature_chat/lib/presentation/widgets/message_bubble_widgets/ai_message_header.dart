import 'package:flutter/material.dart';

class AiMessageHeader extends StatelessWidget {
  final String botName;
  final Color botColor;

  const AiMessageHeader({
    super.key,
    required this.botName,
    required this.botColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  botColor,
                  botColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: botColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  'assets/icons/app_icon.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            botName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).hintColor,
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }
}
