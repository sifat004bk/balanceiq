import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final String userName;
  final VoidCallback onGetStarted;

  const WelcomePage({
    super.key,
    required this.userName,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                Text(
                  'Hello $userName',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  color: colorScheme.onSurface,
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Welcome text
                    Text(
                      'Welcome to BalanceIQ',
                      style: textTheme.displayMedium?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Start tracking your finances and\ntake control of your money',
                      style: textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? AppTheme.textSubtleDark
                            : AppTheme.textSubtleLight,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Features
                    _buildFeatureItem(
                      context,
                      icon: Icons.attach_money,
                      title: 'Track Expenses',
                      description: 'Monitor your spending in real-time',
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureItem(
                      context,
                      icon: Icons.trending_up,
                      title: 'Smart Insights',
                      description: 'Get AI-powered financial advice',
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureItem(
                      context,
                      icon: Icons.savings_outlined,
                      title: 'Reach Goals',
                      description: 'Save smarter with personalized plans',
                    ),
                    const SizedBox(height: 64),

                    // Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: onGetStarted,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: isDark
                              ? AppTheme.textDark
                              : AppTheme.backgroundDark,
                          elevation: 8,
                          shadowColor: AppTheme.primaryColor.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppTheme.textDark
                                : AppTheme.backgroundDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppTheme.textSubtleDark
                      : AppTheme.textSubtleLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
