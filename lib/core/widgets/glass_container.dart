import 'dart:ui';
import 'package:flutter/material.dart';

/// Reusable Liquid Glass (Glassmorphism) Container Widget
///
/// Creates a frosted glass effect with:
/// - Background blur (BackdropFilter)
/// - Semi-transparent background
/// - Subtle border
/// - Soft shadow
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final double opacity;
  final Color backgroundColor;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.blurSigma = 10,
    this.opacity = 0.15,
    this.backgroundColor = Colors.white,
    this.borderRadius = 20,
    this.borderColor = Colors.white70,
    this.borderWidth = 1.5,
    this.boxShadow,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor, width: borderWidth),
              boxShadow: boxShadow ??
                  [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Animated Glass Container with fade and scale animation
class AnimatedGlassContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double blurSigma;
  final double opacity;
  final Color backgroundColor;
  final double borderRadius;

  const AnimatedGlassContainer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.blurSigma = 10,
    this.opacity = 0.15,
    this.backgroundColor = Colors.white,
    this.borderRadius = 20,
  });

  @override
  State<AnimatedGlassContainer> createState() => _AnimatedGlassContainerState();
}

class _AnimatedGlassContainerState extends State<AnimatedGlassContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        ),
        child: GlassContainer(
          blurSigma: widget.blurSigma,
          opacity: widget.opacity,
          backgroundColor: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// Glass Container with gradient background
class GradientGlassContainer extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double blurSigma;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;

  const GradientGlassContainer({
    super.key,
    required this.child,
    this.gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0084FF),
        Color(0xFF0055CC),
      ],
    ),
    this.blurSigma = 10,
    this.borderRadius = 20,
    this.borderColor = Colors.white24,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient.scale(0.5), // Reduce gradient intensity
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: child,
        ),
      ),
    );
  }
}
