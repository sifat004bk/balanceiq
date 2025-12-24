import 'package:flutter/material.dart';
import 'package:dolfin_ui_kit/dolfin_ui_kit.dart';

class AiMessageHeader extends StatelessWidget {
  final String botName;

  const AiMessageHeader({
    super.key,
    required this.botName,
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
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: AppLogo(
                  size: 20,
                  fit: BoxFit.contain,
                  color: Theme.of(context).colorScheme.onPrimary,
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
