import 'package:feature_auth/constants/auth_strings.dart';

class AuthStringsImpl implements AuthStrings {
  const AuthStringsImpl();

  @override
  String get welcomeTitle => 'Donfin AI';
  @override
  String get welcomeSubtitle => 'Your AI-powered personal finance assistant';
  @override
  String get continueGoogle => 'Continue with Google';
  @override
  String get continueApple => 'Continue with Apple';
  @override
  String get termsPrivacy =>
      'By continuing, you agree to our Terms of Service\nand Privacy Policy';
  @override
  String get termsLink => 'View Terms of Service';
  @override
  String get privacyLink => 'View Privacy Policy';

  @override
  String get loginTitle => 'Welcome Back';
  @override
  String get loginSubtitle => 'Sign in to continue';
  @override
  String get emailLabel => 'Email';
  @override
  String get emailHint => 'Enter your email';
  @override
  String get passwordLabel => 'Password';
  @override
  String get passwordHint => 'Enter your password';
  @override
  String get forgotPassword => 'Forgot Password?';
  @override
  String get loginButton => 'Login';
  @override
  String get noAccount => "Don't have an account?";
  @override
  String get signupLink => 'Sign Up';

  @override
  String get signupTitle => 'Create Account';
  @override
  String get signupSubtitle => 'Join Donfin AI today';
  @override
  String get nameLabel => 'Full Name';
  @override
  String get nameHint => 'Enter your name';
  @override
  String get confirmPasswordLabel => 'Confirm Password';
  @override
  String get confirmPasswordHint => 'Re-enter your password';
  @override
  String get signupButton => 'Sign Up';
  @override
  String get haveAccount => 'Already have an account?';
  @override
  String get loginLink => 'Login';

  @override
  String get forgotPasswordTitle => 'Forgot Password';
  @override
  String get forgotPasswordSubtitle => 'Enter your email to reset password';
  @override
  String get resetYourPassword => 'Reset Your Password';
  @override
  String get resetInstructions =>
      'Enter your email address and we\'ll send you instructions to reset your password. The link will expire in 24 hours.';
  @override
  String get emailAddressLabel => 'Email Address';
  @override
  String get enterEmailHint => 'Enter your email';
  @override
  String get emailRequired => 'Please enter your email';
  @override
  String get emailInvalid => 'Please enter a valid email';
  @override
  String get sendResetLink => 'Send Reset Link';
  @override
  String get resetLinkSent =>
      'Password reset link sent! Check your email (and spam folder) for instructions.';
  @override
  String resetEmailSent(String email) =>
      'Password reset email sent to $email. Please check your inbox and spam folder.';
  @override
  String get backToLogin => 'Back to Login';

  @override
  String get resetPasswordTitle => 'Reset Password';
  @override
  String get resetPasswordSubtitle => 'Enter your new password';
  @override
  String get createNewPassword => 'Create New Password';
  @override
  String get enterNewPasswordHint => 'Please enter your new password.';
  @override
  String get newPasswordLabel => 'New Password';
  @override
  String get enterNewPasswordPlaceholder => 'Enter new password';
  @override
  String get passwordRequired => 'Please enter a password';
  @override
  String get passwordMinLength => 'Password must be at least 8 characters';
  @override
  String get passwordStrengthHint =>
      'Use at least 8 characters with uppercase, lowercase, and numbers';
  @override
  String get confirmPasswordRequired => 'Please confirm your password';
  @override
  String get confirmNewPasswordRequired => 'Please confirm your new password';
  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
  @override
  String get confirmNewPasswordHint => 'Confirm new password';
  @override
  String get resetPasswordButton => 'Reset Password';
  @override
  String get resetSuccess => 'Password reset successful! You can now login.';

  @override
  String get changePasswordTitle => 'Change Password';
  @override
  String get updatePasswordTitle => 'Update Your Password';
  @override
  String get updatePasswordHint =>
      'Please enter your current password and choose a new one.';
  @override
  String get currentPasswordLabel => 'Current Password';
  @override
  String get enterCurrentPasswordHint => 'Enter current password';
  @override
  String get currentPasswordRequired => 'Please enter your current password';
  @override
  String get newPasswordRequired => 'Please enter a new password';
  @override
  String get passwordMustBeDifferent =>
      'New password must be different from current password';
  @override
  String get confirmNewPasswordLabel => 'Confirm New Password';
  @override
  String get changePasswordButton => 'Change Password';
  @override
  String get passwordChangeSuccess => 'Password changed successfully!';

  @override
  String get verifyEmailTitle => 'Verify Your Email';
  @override
  String get verifyEmailSubtitle =>
      'Click the button to send a verification email. This unlocks all features!';
  @override
  String get sendVerificationEmail => 'Send Verification Email';
  @override
  String get emailSent => 'Verification email sent to';
  @override
  String get checkInbox => 'Check your inbox';
  @override
  String get checkSpamFolder => '. Please check your spam folder as well.';
  @override
  String get verificationLinkSent => "We've sent a verification link to ";
  @override
  String get verificationSuccess => 'Email Verified!';
  @override
  String get verificationSuccessMessage =>
      'Your email has been successfully verified';
  @override
  String get verificationSuccessTitle => 'Verification Successful!';
  @override
  String get verificationWelcomeMessage =>
      'Welcome! Your account is now active and ready to go.';
  @override
  String get skipVerificationDevOnly => 'Skip Verification (Dev Only)';
  @override
  String get accountCreated => 'Account created successfully!';
  @override
  String get pleaseLogin => 'Please login to continue';
  @override
  String get openEmailApp => 'Open Email App';
  @override
  String get didntReceive => "Didn't receive it? ";
  @override
  @override
  String resendIn(int seconds) => 'Resend in ${seconds}s';

  @override
  OnboardingStrings get onboarding => const OnboardingStringsImpl();
  @override
  String get continueToDashboard => 'Continue to Dashboard';

  @override
  String get sessionExpired => 'Session Expired';
  @override
  String get sessionExpiredMessage =>
      'For your security, please login again to continue.';
  @override
  String get emailAlreadyInUse =>
      'This email is already registered. Try logging in instead.';

  @override
  String get signingIn => 'Signing in';
  @override
  String get signingUp => 'Creating account';
  @override
  String get sendingEmail => 'Sending email';
  @override
  String get networkError => 'Network Error';
  @override
  String get networkErrorMessage => 'Please check your internet connection';
  @override
  String get authError =>
      'Unable to sign in. Please check your email and password.';
  @override
  String get tryAgain => 'Try Again';

  @override
  String get dataSecurityNotice =>
      'Your financial data is encrypted and secure';
  @override
  String get biometricOptional => 'Add fingerprint or face unlock (optional)';

  @override
  ProfileStrings get profile => const ProfileStringsImpl();
}

class ProfileStringsImpl implements ProfileStrings {
  const ProfileStringsImpl();

  @override
  String get profile => 'Profile';
  @override
  String get myProfile => 'My Profile';
  @override
  String get editProfile => 'Edit Profile';

  @override
  String get accountDetails => 'Account Details';
  @override
  String get security => 'Security';
  @override
  String get notifications => 'Notifications';
  @override
  String get appearance => 'Appearance';
  @override
  String get language => 'Language';
  @override
  String get currency => 'Currency';
  @override
  String get helpCenter => 'Help Center';
  @override
  String get aboutApp => 'About';
  @override
  String get termsOfService => 'Terms of Service';
  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get logOut => 'Logout';
  @override
  String get logOutConfirm => 'Are you sure you want to logout?';
  @override
  String get deleteAccount => 'Delete Account';
  @override
  String get deleteAccountTitle => 'Delete Account Permanently?';
  @override
  String get deleteAccountWarning =>
      'All your financial data, transactions, and account history will be permanently deleted. This action cannot be undone.';
  @override
  String get deleteAccountButton => 'Delete My Account';
  @override
  String get deleteAccountSuccess =>
      'Account deleted. We\'re sorry to see you go.';

  @override
  String get name => 'Name';
  @override
  String get email => 'Email';
  @override
  String get phone => 'Phone';
  @override
  String get joinedDate => 'Member Since';
  @override
  String get accountStatus => 'Account Status';
  @override
  String get verified => 'Verified';
  @override
  String get notVerified => 'Not Verified';

  @override
  String get theme => 'Theme';
  @override
  String get lightMode => 'Light Mode';
  @override
  String get darkMode => 'Dark Mode';
  @override
  String get systemDefault => 'System Default';
  @override
  String get themeChanged => 'Theme changed successfully';

  @override
  String get pushNotifications => 'Push Notifications';
  @override
  String get emailNotifications => 'Email Notifications';
  @override
  String get transactionAlerts => 'Transaction Alerts';
  @override
  String get budgetAlerts => 'Budget Alerts';
  @override
  String get weeklyReports => 'Weekly Reports';
  @override
  String get notificationSettingsSaved => 'Notification preferences saved';

  @override
  String get profileUpdated => 'Profile updated successfully!';
  @override
  String get emailVerified => 'Email verified successfully!';
  @override
  String get languageChanged => 'Language changed successfully';
}

class OnboardingStringsImpl implements OnboardingStrings {
  const OnboardingStringsImpl();

  @override
  String get slide1Title => 'Welcome to Dolfin AI';
  @override
  String get slide1Description =>
      'Your AI-powered personal finance assistant for smart money management';
  @override
  String get slide2Title => 'Track Every Taka';
  @override
  String get slide2Description =>
      'Easily track expenses, income, and manage your cash, bank, and mobile money';
  @override
  String get slide3Title => 'Chat with Your AI Assistant';
  @override
  String get slide3Description =>
      'Get answers, track expenses, and receive personalized financial advice through conversation';
  @override
  String get slide4Title => 'Reach Your Financial Goals';
  @override
  String get slide4Description =>
      'Set budgets, track progress, and achieve your savings goals faster';
  @override
  String get getStarted => 'Get Started';
  @override
  String get loginButton => 'Login';
}
