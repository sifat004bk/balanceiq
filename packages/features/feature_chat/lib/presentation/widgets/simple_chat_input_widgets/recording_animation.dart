import 'package:flutter/material.dart';

class RecordingAnimation extends StatelessWidget {
  const RecordingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 30 + (value * 4),
              height: 30 + (value * 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6 * (1 - value)),
                  width: 2,
                ),
              ),
            ),
            Icon(
              Icons.stop_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ],
        );
      },
    );
  }
}
