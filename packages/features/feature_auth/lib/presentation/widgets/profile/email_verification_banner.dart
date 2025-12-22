import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/design_constants.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../cubit/signup/signup_cubit.dart';

class EmailVerificationBanner extends StatelessWidget {
  final dynamic user;
  final VoidCallback onVerificationClick;

  const EmailVerificationBanner({
    super.key,
    required this.user,
    required this.onVerificationClick,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final warningColor = Colors.orange;

    final backgroundColor = warningColor.withValues(alpha: 0.1);
    final borderColor = warningColor.withValues(alpha: 0.3);
    final iconBgColor = warningColor.withValues(alpha: 0.15);
    final titleColor = colorScheme.onSurface;
    final subtitleColor = colorScheme.onSurface.withValues(alpha: 0.7);

    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is VerificationEmailSent) {
          SnackbarUtils.showSuccess(
              context, '${AppStrings.auth.emailSent} ${state.email}');
        } else if (state is VerificationEmailError) {
          SnackbarUtils.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isSending = state is VerificationEmailSending;

        return Container(
          margin: EdgeInsets.only(bottom: DesignConstants.space6),
          padding: EdgeInsets.all(DesignConstants.space4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(DesignConstants.radiusLarge),
            border: Border.all(
              color: borderColor,
              width: DesignConstants.glassBorderWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(DesignConstants.space2),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius:
                          BorderRadius.circular(DesignConstants.radiusSmall),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: warningColor,
                      size: DesignConstants.iconSizeLarge,
                    ),
                  ),
                  SizedBox(width: DesignConstants.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verify your email',
                          style: TextStyle(
                            fontSize: DesignConstants.fontSizeL,
                            fontWeight: DesignConstants.fontWeightSemiBold,
                            color: titleColor,
                          ),
                        ),
                        SizedBox(height: DesignConstants.space1),
                        Text(
                          'Please verify your email to access all features',
                          style: TextStyle(
                            fontSize: DesignConstants.fontSizeS,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: DesignConstants.space4),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSending ? null : onVerificationClick,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: warningColor,
                    foregroundColor: colorScheme.onInverseSurface,
                    disabledBackgroundColor:
                        warningColor.withValues(alpha: 0.5),
                    padding:
                        EdgeInsets.symmetric(vertical: DesignConstants.space3),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DesignConstants.radiusMedium),
                    ),
                    elevation: 0,
                  ),
                  child: isSending
                      ? SizedBox(
                          height: DesignConstants.loadingIndicatorSmall,
                          width: DesignConstants.loadingIndicatorSmall,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onInverseSurface,
                          ),
                        )
                      : Text(
                          'Send Verification Email',
                          style: TextStyle(
                            fontSize: DesignConstants.fontSizeM,
                            fontWeight: DesignConstants.fontWeightSemiBold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
