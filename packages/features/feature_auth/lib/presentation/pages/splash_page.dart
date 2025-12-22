import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:dolfin_core/utils/app_logger.dart';
import '../../domain/auth_config.dart';

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
    final secureStorage = GetIt.instance<SecureStorageService>();
    final authToken = await secureStorage.getToken();
    final authConfig = GetIt.instance<AuthConfig>();

    AppLogger.debug('🚀 Checking session...', name: 'SplashPage');
    AppLogger.debug('🚀 Has auth token: ${authToken != null}',
        name: 'SplashPage');

    // If no tokens, go to onboarding
    if (authToken == null || authToken.isEmpty) {
      AppLogger.debug('🚀 No auth token, navigating to onboarding',
          name: 'SplashPage');
      if (mounted) authConfig.onOnboardingRequired(context);
      return;
    }

    // Try to validate session via AuthConfig
    try {
      AppLogger.debug('🚀 Validating session...', name: 'SplashPage');

      final isValid = await authConfig.isSessionValid();

      if (isValid) {
        AppLogger.debug('🚀 Session valid, navigating to home',
            name: 'SplashPage');
        if (mounted) authConfig.onAuthenticated(context);
      } else {
        AppLogger.debug('🚀 Session invalid, navigating to login',
            name: 'SplashPage');
        if (mounted) authConfig.onUnauthenticated(context);
      }
    } catch (e) {
      AppLogger.error('🚀 Exception during validation: $e', name: 'SplashPage');
      // On error, navigate to login
      if (mounted) authConfig.onUnauthenticated(context);
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
                    Image.asset(
                      'assets/icons/app_icon.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 32),
                    // App name
                    Text(
                      'Dolfin AI',
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
