import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A celebration animation widget that shows confetti-like particles
class CelebrationAnimation extends StatefulWidget {
  final bool show;
  final Widget child;

  const CelebrationAnimation({
    super.key,
    required this.show,
    required this.child,
  });

  @override
  State<CelebrationAnimation> createState() => _CelebrationAnimationState();
}

class _CelebrationAnimationState extends State<CelebrationAnimation>
    with TickerProviderStateMixin {
  late List<_Particle> _particles;
  late AnimationController _controller;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _particles = [];
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _particles = [];
        });
      }
    });
  }

  @override
  void didUpdateWidget(CelebrationAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _startCelebration();
    }
  }

  void _startCelebration() {
    _particles = List.generate(50, (index) => _createParticle());
    _controller.reset();
    _controller.forward();
  }

  _Particle _createParticle() {
    final colors = [
      Colors.purple,
      Colors.pink,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.yellow,
      Colors.red,
      Colors.teal,
    ];

    return _Particle(
      color: colors[_random.nextInt(colors.length)],
      x: _random.nextDouble(),
      initialY: 0.8 + _random.nextDouble() * 0.2,
      velocityX: (_random.nextDouble() - 0.5) * 2,
      velocityY: -1.5 - _random.nextDouble() * 2,
      size: 6 + _random.nextDouble() * 8,
      rotation: _random.nextDouble() * math.pi * 2,
      rotationSpeed: (_random.nextDouble() - 0.5) * 10,
      shape: _random.nextBool() ? _ParticleShape.circle : _ParticleShape.square,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_particles.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ParticlePainter(
                      particles: _particles,
                      progress: _controller.value,
                    ),
                    size: Size.infinite,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

enum _ParticleShape { circle, square }

class _Particle {
  final Color color;
  final double x;
  final double initialY;
  final double velocityX;
  final double velocityY;
  final double size;
  final double rotation;
  final double rotationSpeed;
  final _ParticleShape shape;

  _Particle({
    required this.color,
    required this.x,
    required this.initialY,
    required this.velocityX,
    required this.velocityY,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const gravity = 3.0;

    for (final particle in particles) {
      // Calculate position with physics
      final time = progress * 2.5;
      final x = size.width * particle.x +
          particle.velocityX * time * size.width * 0.3;
      final y = size.height * particle.initialY +
          particle.velocityY * time * size.height * 0.3 +
          gravity * time * time * size.height * 0.1;

      // Fade out towards the end
      final opacity = (1 - progress).clamp(0.0, 1.0);
      if (opacity <= 0) continue;

      final paint = Paint()
        ..color = particle.color.withOpacity(opacity * 0.8)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + particle.rotationSpeed * progress);

      final scaledSize = particle.size * (1.0 - progress * 0.3);

      if (particle.shape == _ParticleShape.circle) {
        canvas.drawCircle(Offset.zero, scaledSize / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: scaledSize,
            height: scaledSize,
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Simple progress indicator for onboarding screens
class OnboardingProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const OnboardingProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isPast = index < currentStep;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive || isPast
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
