import 'package:dolfin_core/constants/core_strings.dart';
import 'package:dolfin_core/utils/snackbar_utils.dart';
import 'package:feature_auth/constants/auth_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

import "package:feature_auth/presentation/cubit/signup/signup_cubit.dart";

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
      context.read<SignupCubit>().resendEmailVerification(email: widget.email);
    }
  }

  void _openEmailApp() {
    // In a real app, you would use url_launcher to open email app
    SnackbarUtils.showInfo(
        context, '${GetIt.I<CoreStrings>().common.loading}...');
  }

  void _mockVerifyAndContinue() {
    // Mock verification - navigate to success page
    Navigator.pushReplacementNamed(context, '/verification-success');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is VerificationEmailSent) {
          SnackbarUtils.showSuccess(
            context,
            '${GetIt.I<AuthStrings>().emailSent} ${state.email}',
          );
          _startCooldown();
        } else if (state is VerificationEmailError) {
          SnackbarUtils.showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(GetIt.I<AuthStrings>().verifyEmailTitle),
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
                              color: colorScheme.primary.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Icon(
                            Icons.mark_email_unread,
                            size: 48,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Title
                      Text(
                        GetIt.I<AuthStrings>().checkInbox,
                        style: textTheme.headlineMedium?.copyWith(
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
                            style: textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    GetIt.I<AuthStrings>().verificationLinkSent,
                              ),
                              TextSpan(
                                text: widget.email,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              TextSpan(
                                text: GetIt.I<AuthStrings>().checkSpamFolder,
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
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          GetIt.I<AuthStrings>().openEmailApp,
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
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
                          GetIt.I<AuthStrings>().didntReceive,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        BlocBuilder<SignupCubit, SignupState>(
                          builder: (context, state) {
                            final isSending = state is VerificationEmailSending;

                            if (isSending) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              );
                            }

                            return TextButton(
                              onPressed:
                                  _resendCooldown == 0 ? _resendEmail : null,
                              child: Text(
                                _resendCooldown > 0
                                    ? GetIt.I<AuthStrings>()
                                        .resendIn(_resendCooldown)
                                    : GetIt.I<AuthStrings>()
                                        .sendVerificationEmail,
                                style: TextStyle(
                                  color: _resendCooldown > 0
                                      ? Theme.of(context).hintColor
                                      : colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Mock verify button (for testing)
                    TextButton(
                      onPressed: _mockVerifyAndContinue,
                      child: Text(
                        GetIt.I<AuthStrings>().skipVerificationDevOnly,
                        style: textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
