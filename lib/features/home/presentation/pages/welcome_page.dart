import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/theme/app_palette.dart';
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
                      color: AppPalette.trustBlue,
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
                        color: AppPalette.trustBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppPalette.trustBlue.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 80,
                            color: AppPalette.trustBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Welcome text
                    Text(
                      AppStrings.dashboard.welcomeToApp,
                      style: textTheme.displayMedium?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.dashboard.welcomeSubtitle,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppPalette.neutralGrey,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Features
                    _buildFeatureItem(
                      context,
                      icon: Icons.attach_money,
                      title: AppStrings.dashboard.trackExpenses,
                      description: AppStrings.dashboard.trackExpensesDesc,
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureItem(
                      context,
                      icon: Icons.trending_up,
                      title: AppStrings.dashboard.smartInsights,
                      description: AppStrings.dashboard.smartInsightsDesc,
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureItem(
                      context,
                      icon: Icons.savings_outlined,
                      title: AppStrings.dashboard.reachGoals,
                      description: AppStrings.dashboard.reachGoalsDesc,
                    ),
                    const SizedBox(height: 64),

                    // Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: onGetStarted,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.trustBlue,
                          foregroundColor: AppPalette.neutralWhite,
                          elevation: 8,
                          shadowColor: AppPalette.trustBlue.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          AppStrings.common.getStarted,
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.neutralWhite,
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

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppPalette.trustBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: AppPalette.trustBlue,
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
                  color: AppPalette.neutralGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
