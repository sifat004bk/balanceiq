import 'package:flutter/material.dart';
import 'app_logo.dart';

/// Animated Dolfin AI logo widget that can be used throughout the app.
/// Supports different sizes and optional animation effects.
class AnimatedDolfinLogo extends StatefulWidget {
  /// Size of the logo (width and height)
  final double size;

  /// Whether to animate the logo with a pulse effect
  final bool animate;

  /// Optional color override. If null, uses theme primary color.
  final Color? color;

  /// Duration of one animation cycle
  final Duration animationDuration;

  /// Whether to show a glow effect
  final bool showGlow;

  const AnimatedDolfinLogo({
    super.key,
    this.size = 80,
    this.animate = true,
    this.color,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.showGlow = true,
  });

  @override
  State<AnimatedDolfinLogo> createState() => _AnimatedDolfinLogoState();
}

class _AnimatedDolfinLogoState extends State<AnimatedDolfinLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.color ?? Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.animate ? _scaleAnimation.value : 1.0,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size * 0.27),
              boxShadow: widget.showGlow
                  ? [
                      BoxShadow(
                        color: primaryColor.withValues(
                          alpha: widget.animate ? _glowAnimation.value : 0.3,
                        ),
                        blurRadius: widget.size * 0.3,
                        spreadRadius: widget.size * 0.05,
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.size * 0.27),
              child: AppLogo(
                size: widget.size,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Static Dolfin logo icon for use in smaller contexts like chat headers.
/// Uses the logo image with theme-aware styling.
class DolfinLogoIcon extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final bool showShadow;

  const DolfinLogoIcon({
    super.key,
    this.size = 28,
    this.backgroundColor,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(size * 0.15),
          child: AppLogo(
            size: size * 0.7,
            fit: BoxFit.contain,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
