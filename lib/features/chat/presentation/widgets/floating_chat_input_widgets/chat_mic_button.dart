import 'package:flutter/material.dart';

class ChatMicButton extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onTap;
  final bool isEnabled;

  const ChatMicButton({
    super.key,
    required this.isRecording,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  State<ChatMicButton> createState() => _ChatMicButtonState();
}

class _ChatMicButtonState extends State<ChatMicButton> {
  // Use a key to force rebuild of TweenAnimationBuilder if needed,
  // or just rely on state changes.
  // Actually, for continuous looping, we need to trigger rebuilds.

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return AnimatedScale(
      scale: widget.isRecording ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: widget.isEnabled ? widget.onTap : null,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: widget.isRecording
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.error,
                      Theme.of(context).colorScheme.error
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isRecording
                ? null
                : (isDark
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).dividerColor),
            shape: BoxShape.circle,
            boxShadow: widget.isRecording
                ? [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.error.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.error.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: widget.isRecording
              ? _buildRecordingAnimation()
              : Icon(
                  Icons.mic_none,
                  color: widget.isEnabled ? primaryColor : Colors.grey,
                  size: 22,
                ),
        ),
      ),
    );
  }

  Widget _buildRecordingAnimation() {
    return TweenAnimationBuilder<double>(
      key: ValueKey(
          DateTime.now().millisecondsSinceEpoch), // Force restart on loop
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing outer ring
            Container(
              width: 30 + (value * 4),
              height: 30 + (value * 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6 * (1 - value)),
                  width: 2,
                ),
              ),
            ),
            // Stop icon
            Icon(
              Icons.stop_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ],
        );
      },
      onEnd: () {
        if (widget.isRecording && mounted) {
          setState(() {}); // Trigger rebuild to restart animation
        }
      },
    );
  }
}
