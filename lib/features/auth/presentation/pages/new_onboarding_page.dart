import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_theme.dart';

class NewOnboardingPage extends StatefulWidget {
  const NewOnboardingPage({super.key});

  @override
  State<NewOnboardingPage> createState() => _NewOnboardingPageState();
}

class _NewOnboardingPageState extends State<NewOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
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
                    'BalanceIQ',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            // Page view
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildSlide(
                    icon: Icons.auto_awesome,
                    title: 'Welcome to Your All-in-One BalanceIQ',
                    description:
                        'Centralize your digital life and automate tasks with ease.',
                  ),
                  _buildSlide(
                    icon: Icons.account_tree,
                    title: 'Powered by n8n Automation',
                    description:
                        'Connect your favorite apps and create powerful workflows without any code.',
                  ),
                  _buildSlide(
                    icon: Icons.smart_toy,
                    title: 'Chat with Your AI Assistant',
                    description:
                        'Get answers, generate content, and control your automations with a simple chat.',
                  ),
                  _buildSlide(
                    icon: Icons.dashboard,
                    title: 'Manage Your Work & Life',
                    description:
                        'Handle your finances, e-commerce, and social media all in one place.',
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
                      ? const Color(0xFF32674d)
                      : const Color(0xFFd1d5db),
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
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                        'Log In',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
