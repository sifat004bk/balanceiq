import 'package:flutter/material.dart';

class GlassFooterBackground extends StatelessWidget {
  const GlassFooterBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: MediaQuery.of(context).padding.bottom + 16,
      child: ClipRect(
        child: Container(
          color:
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
