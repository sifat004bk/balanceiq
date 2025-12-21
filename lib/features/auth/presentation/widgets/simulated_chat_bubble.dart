import 'package:flutter/material.dart';

/// A chat bubble widget for the simulated onboarding chat demo.
/// Supports user messages, bot messages, and typing indicator.
class SimulatedChatBubble extends StatefulWidget {
  final String content;
  final bool isUser;
  final bool isTyping;
  final bool animate;

  const SimulatedChatBubble({
    super.key,
    required this.content,
    required this.isUser,
    this.isTyping = false,
    this.animate = true,
  });

  @override
  State<SimulatedChatBubble> createState() => _SimulatedChatBubbleState();
}

class _SimulatedChatBubbleState extends State<SimulatedChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: widget.animate ? 20.0 : 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: widget.animate ? 0.0 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment:
              widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!widget.isUser) ...[
              _buildAvatar(colorScheme),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: widget.isUser
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(widget.isUser ? 20 : 4),
                    bottomRight: Radius.circular(widget.isUser ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: widget.isTyping
                    ? _buildTypingIndicator(colorScheme)
                    : Text(
                        widget.content,
                        style: TextStyle(
                          color: widget.isUser
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
              ),
            ),
            if (widget.isUser) ...[
              const SizedBox(width: 8),
              _buildUserAvatar(colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.auto_awesome,
        size: 18,
        color: colorScheme.primary,
      ),
    );
  }

  Widget _buildUserAvatar(ColorScheme colorScheme) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 18,
        color: colorScheme.onSecondaryContainer,
      ),
    );
  }

  Widget _buildTypingIndicator(ColorScheme colorScheme) {
    return SizedBox(
      width: 50,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return _TypingDot(
            delay: index * 150,
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final int delay;
  final Color color;

  const _TypingDot({
    required this.delay,
    required this.color,
  });

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Transform.translate(
            offset: Offset(0, -4 * _animation.value),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: widget.color
                    .withValues(alpha: 0.4 + 0.6 * _animation.value),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Narrator text widget for story context
class NarratorText extends StatefulWidget {
  final String text;
  final bool animate;

  const NarratorText({
    super.key,
    required this.text,
    this.animate = true,
  });

  @override
  State<NarratorText> createState() => _NarratorTextState();
}

class _NarratorTextState extends State<NarratorText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: widget.animate ? 0.0 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 16,
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
