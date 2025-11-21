import 'package:balance_iq/core/constants/gemini_colors.dart';
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
    final color = widget.dotColor ?? GeminiColors.textSecondary(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bot avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: GeminiColors.botAvatarBg,
            child: const Icon(
              Icons.auto_awesome,
              color: GeminiColors.botAvatarIcon,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          // Typing indicator container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: GeminiColors.aiMessageBackground(context),
              borderRadius: const BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(_dot1Animation, color),
                const SizedBox(width: 6),
                _buildDot(_dot2Animation, color),
                const SizedBox(width: 6),
                _buildDot(_dot3Animation, color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Animation<double> animation, Color color) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
