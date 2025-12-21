import 'package:flutter/material.dart';

class GlassHeaderBackground extends StatelessWidget {
  const GlassHeaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).padding.top + 10,
      child: ClipRect(
        child: Container(
          color:
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
