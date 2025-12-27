import 'package:dolfin_ui_kit/dolfin_ui_kit.dart';
import 'package:flutter/material.dart';

/// Gemini-style typing indicator with three animated dots
class TypingIndicator extends StatefulWidget {
  final Color? dotColor;

  const TypingIndicator({
    super.key,
    this.dotColor,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _dot1Animation;
  late Animation<double> _dot2Animation;
  late Animation<double> _dot3Animation;

  @override
  void initState() {
    super.initState();

    // Gemini typing indicator cycle: 1200ms
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Each dot animates with a delay, creating a wave effect
    // Dot 1: 0-400ms fade up, 400-800ms fade down
    _dot1Animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33.3,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33.3,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.2),
        weight: 33.4,
      ),
    ]).animate(_animationController);

    // Dot 2: Delayed by 1/3 of the cycle
    _dot2Animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(0.2),
        weight: 33.3,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33.3,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33.4,
      ),
    ]).animate(_animationController);

    // Dot 3: Delayed by 2/3 of the cycle
    _dot3Animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(0.2),
        weight: 66.6,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 16.7,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 16.7,
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.dotColor ?? Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated Dolfin logo with rotating beam while AI is responding
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              // Beam color: opposite of theme (white in dark, primary in light)
              final beamColor =
                  isDark ? Colors.white : Theme.of(context).colorScheme.primary;

              return SizedBox(
                width: 36,
                height: 36,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rotating beam arc around the logo
                    RepaintBoundary(
                      child: Transform.rotate(
                        angle: _animationController.value * 2 * 3.14159,
                        child: CustomPaint(
                          size: const Size(36, 36),
                          painter: _BeamPainter(
                            color: beamColor,
                            strokeWidth: 2.5,
                          ),
                        ),
                      ),
                    ),
                    // Logo in the center - always blue on white background
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: AppLogo(
                              size: 24,
                              color: Theme.of(context).colorScheme.onPrimary,
                            )),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          // Glassmorphic typing indicator container (2025 redesign)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.8),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(_dot1Animation, color),
                const SizedBox(width: 7),
                _buildDot(_dot2Animation, color),
                const SizedBox(width: 7),
                _buildDot(_dot3Animation, color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Enhanced dot with scale animation (2025 redesign)
  Widget _buildDot(Animation<double> animation, Color color) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.7 + (animation.value * 0.3), // Pulsate effect
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color.withValues(alpha: animation.value),
              shape: BoxShape.circle,
              boxShadow: animation.value > 0.7
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
          ),
        );
      },
    );
  }
}

/// Custom painter for the rotating beam arc around the logo
class _BeamPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _BeamPainter({
    required this.color,
    this.strokeWidth = 2.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.1),
          color,
          color.withValues(alpha: 0.1),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      0,
      3.14159 * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BeamPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
