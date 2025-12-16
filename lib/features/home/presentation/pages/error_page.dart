import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class Error404Page extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final bool isAuthError;

  const Error404Page({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    this.isAuthError = false,
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error illustration
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: colorScheme.error.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off_outlined,
                          size: 80,
                          color: colorScheme.error,
                        ),
                        Positioned(
                          bottom: 30,
                          child: Icon(
                            Icons.warning_amber_rounded,
                            size: 40,
                            color: colorScheme.error.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Error code
              Text(
                '404',
                style: textTheme.displayLarge?.copyWith(
                  color: colorScheme.error,
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 16),

              // Error title
              Text(
                AppStrings.dashboard.errorTitle,
                style: textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Error message
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  errorMessage,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppPalette.neutralGrey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),

              // Common issues
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppPalette.trustBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppPalette.trustBlue.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppPalette.trustBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.dashboard.commonIssues,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildIssueItem(
                        context, AppStrings.dashboard.checkInternet),
                    _buildIssueItem(context, AppStrings.dashboard.serverDown),
                    _buildIssueItem(
                        context, AppStrings.dashboard.tryAgainMoments),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Retry button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: Icon(
                    isAuthError ? Icons.login : Icons.refresh,
                    size: 24,
                  ),
                  label: Text(
                    isAuthError
                        ? AppStrings.dashboard.goToLogin
                        : AppStrings.common.retry,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.neutralWhite,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.trustBlue,
                    foregroundColor: AppPalette.neutralWhite,
                    elevation: 8,
                    shadowColor: AppPalette.trustBlue.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                },
                child: Text(
                  AppStrings.dashboard.backToLoginPage,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppPalette.trustBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueItem(BuildContext context, String text) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppPalette.trustBlue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyMedium?.copyWith(
                color: AppPalette.neutralGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
