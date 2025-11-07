import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'dart:async';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  Timer? _timer;
  int _resendCooldown = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() {
      _resendCooldown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCooldown > 0) {
          _resendCooldown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _resendEmail() {
    if (_resendCooldown == 0) {
      // Mock resend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent!'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      _startCooldown();
    }
  }

  void _openEmailApp() {
    // In a real app, you would use url_launcher to open email app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening email app...')),
    );
  }

  void _mockVerifyAndContinue() {
    // Mock verification - navigate to success page
    Navigator.pushReplacementNamed(context, '/verification-success');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Verify Email'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Icon(
                          Icons.mark_email_unread,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Title
                    Text(
                      'Check your inbox',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 12),
                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: isDark
                                        ? AppTheme.textSubtleDark
                                        : AppTheme.textSubtleLight,
                                  ),
                          children: [
                            const TextSpan(
                              text: 'We\'ve sent a verification link to ',
                            ),
                            TextSpan(
                              text: widget.email,
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: '. Please check your spam folder as well.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _openEmailApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Open Email App',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Resend email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive it? ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppTheme.textSubtleDark
                                  : AppTheme.textSubtleLight,
                            ),
                      ),
                      TextButton(
                        onPressed: _resendCooldown == 0 ? _resendEmail : null,
                        child: Text(
                          _resendCooldown > 0
                              ? 'Resend in ${_resendCooldown}s'
                              : 'Resend Email',
                          style: TextStyle(
                            color: _resendCooldown > 0
                                ? (isDark
                                    ? AppTheme.textSubtleDark
                                    : AppTheme.textSubtleLight)
                                : AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Mock verify button (for testing)
                  TextButton(
                    onPressed: _mockVerifyAndContinue,
                    child: const Text(
                      'Skip Verification (Dev Only)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
