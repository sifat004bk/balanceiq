import 'package:flutter/material.dart';
import '../../../../core/utils/snackbar_utils.dart';

class NetworkErrorPage extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onSettings;

  const NetworkErrorPage({
    super.key,
    this.onRetry,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                Icons.wifi_off,
                size: 120,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'No Internet Connection',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Please check your Wi-Fi or mobile data connection. You can also try turning Airplane Mode off and on.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              // Retry button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onRetry ??
                      () {
                        // Default retry action - pop back
                        Navigator.pop(context);
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Settings link
              TextButton(
                onPressed: onSettings ??
                    () {
                      // Default action - you could open app settings
                      SnackbarUtils.showInfo(context, 'Opening settings...');
                    },
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16,
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
}
