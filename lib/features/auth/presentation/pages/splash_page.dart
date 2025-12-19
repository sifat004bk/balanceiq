import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../home/domain/usecase/get_user_dashbaord.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();

    // Start validation after a short delay for branding visibility
    Future.delayed(const Duration(milliseconds: 800), () {
      _validateSession();
    });
  }

  Future<void> _validateSession() async {
    final secureStorage = sl<SecureStorageService>();
    final authToken = await secureStorage.getToken();
    final refreshToken = await secureStorage.getRefreshToken();

    AppLogger.debug('🚀 Checking session...', name: 'SplashPage');
    AppLogger.debug('🚀 Has auth token: ${authToken != null}',
        name: 'SplashPage');
    AppLogger.debug('🚀 Has refresh token: ${refreshToken != null}',
        name: 'SplashPage');

    // If no tokens, go to onboarding
    if (authToken == null || authToken.isEmpty) {
      AppLogger.debug('🚀 No auth token, navigating to onboarding',
          name: 'SplashPage');
      _navigateToOnboarding();
      return;
    }

    // Try to validate session by calling dashboard API
    // This will trigger the AuthInterceptor if token is expired
    try {
      AppLogger.debug('🚀 Validating session by calling dashboard...',
          name: 'SplashPage');

      final getDashboardSummary = sl<GetDashboardSummary>();

      // Get current month dates
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);

      final startDate =
          "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
      final endDate =
          "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";

      final result = await getDashboardSummary(
        startDate: startDate,
        endDate: endDate,
      );

      result.fold(
        (failure) {
          AppLogger.debug('🚀 Dashboard call failed: ${failure.message}',
              name: 'SplashPage');
          // Session invalid, navigate to login
          _navigateToLogin();
        },
        (summary) {
          AppLogger.debug('🚀 Session valid, navigating to home',
              name: 'SplashPage');
          // Session valid, navigate to home
          _navigateToHome();
        },
      );
    } catch (e) {
      AppLogger.error('🚀 Exception during validation: $e', name: 'SplashPage');
      // On error, navigate to login
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _navigateToOnboarding() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/interactive-onboarding');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: colorScheme.onPrimary,
                          size: 56,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // App name
                    Text(
                      'Donfin AI',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                                letterSpacing: 1.2,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Smart Finance Management',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                    const SizedBox(height: 48),
                    // Loading indicator
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
