import 'package:flutter/material.dart';
import 'dart:async';
import 'package:balance_iq/core/theme/app_palette.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Simulate loading progress
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
          // Navigate to home after loading completes
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with pulse animation
              RotationTransition(
                turns: _animationController,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppPalette.trustBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.hub,
                      color: AppPalette.trustBlue,
                      size: 48,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              // Loading text
              Column(
                children: [
                  Text(
                    'Loading Dashboard...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppPalette.neutralWhite
                              : AppPalette.neutralBlack,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Automations are getting ready.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppPalette.neutralGrey
                              : AppPalette.neutralGrey,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress bar
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppPalette.trustBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
