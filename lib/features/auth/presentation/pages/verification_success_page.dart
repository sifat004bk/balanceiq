import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../domain/entities/user.dart';

class VerificationSuccessPage extends StatefulWidget {
  const VerificationSuccessPage({super.key});

  @override
  State<VerificationSuccessPage> createState() =>
      _VerificationSuccessPageState();
}

class _VerificationSuccessPageState extends State<VerificationSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _continueToDashboard() {
    // Mock authentication - create a mock user for development/testing
    final mockUser = User(
      id: const Uuid().v4(),
      email: 'user@example.com',
      name: 'User',
      photoUrl: null,
      authProvider: 'email',
      createdAt: DateTime.now(),
    );
    context.read<AuthCubit>().emit(AuthAuthenticated(mockUser));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated checkmark
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulsing background
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Container(
                                width: 160 * _pulseAnimation.value,
                                height: 160 * _pulseAnimation.value,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                          ),
                          // Middle circle
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Checkmark icon
                          Icon(
                            Icons.task_alt,
                            size: 80,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Title
                    Text(
                      AppStrings.auth.verificationSuccessTitle,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        AppStrings.auth.verificationWelcomeMessage,
                        style: textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _continueToDashboard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    AppStrings.auth.continueToDashboard,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
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
