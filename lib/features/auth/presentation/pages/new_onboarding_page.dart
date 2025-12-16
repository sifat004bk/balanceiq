import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';

class NewOnboardingPage extends StatefulWidget {
  const NewOnboardingPage({super.key});

  @override
  State<NewOnboardingPage> createState() => _NewOnboardingPageState();
}

class _NewOnboardingPageState extends State<NewOnboardingPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToSignUp() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.hub,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.appName,
                    style: AppTypography.titleLargeBold,
                  ),
                ],
              ),
            ),
            // Page view
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  _buildSlide(
                    icon: Icons.auto_awesome,
                    title: AppStrings.onboarding.slide1Title,
                    description: AppStrings.onboarding.slide1Description,
                  ),
                  _buildSlide(
                    icon: Icons.account_tree,
                    title: AppStrings.onboarding.slide2Title,
                    description: AppStrings.onboarding.slide2Description,
                  ),
                  _buildSlide(
                    icon: Icons.smart_toy,
                    title: AppStrings.onboarding.slide3Title,
                    description: AppStrings.onboarding.slide3Description,
                  ),
                  _buildSlide(
                    icon: Icons.dashboard,
                    title: AppStrings.onboarding.slide4Title,
                    description: AppStrings.onboarding.slide4Description,
                    isLast: true,
                  ),
                ],
              ),
            ),
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 4,
                effect: WormEffect(
                  dotColor: isDark
                      ? AppPalette.indicatorActiveDark
                      : AppPalette.indicatorInactive,
                  activeDotColor: AppTheme.primaryColor,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 12,
                ),
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _navigateToSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: AppTheme.backgroundDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppStrings.onboarding.getStarted,
                        style: AppTypography.buttonLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: TextButton(
                      onPressed: _navigateToLogin,
                      child: Text(
                        AppStrings.onboarding.logInButton,
                        style: AppTypography.buttonMediumSemiBold.copyWith(
                          color: isDark
                              ? AppTheme.textDarkTheme
                              : AppTheme.textLightTheme,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide({
    required IconData icon,
    required String title,
    required String description,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isLast
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 24,
                          left: 40,
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: AppTheme.primaryColor,
                            size: 40,
                          ),
                        ),
                        Positioned(
                          top: 64,
                          right: 24,
                          child: Icon(
                            Icons.shopping_cart,
                            color: AppTheme.primaryColor,
                            size: 40,
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 56,
                          child: Icon(
                            Icons.school,
                            color: AppTheme.primaryColor,
                            size: 40,
                          ),
                        ),
                      ],
                    )
                  : Icon(
                      icon,
                      color: AppTheme.primaryColor,
                      size: 80,
                    ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: AppTypography.headlineSmallBold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.textSubtleDark
                      : AppTheme.textSubtleLight,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
