abstract class AuthStrings {
  // Onboarding
  String get welcomeTitle;
  String get welcomeSubtitle;
  String get continueGoogle;
  String get continueApple;
  String get termsPrivacy;
  String get termsLink;
  String get privacyLink;

  // Login
  String get loginTitle;
  String get loginSubtitle;
  String get emailLabel;
  String get emailHint;
  String get passwordLabel;
  String get passwordHint;
  String get forgotPassword;
  String get loginButton;
  String get noAccount;
  String get signupLink;

  // Signup
  String get signupTitle;
  String get signupSubtitle;
  String get nameLabel;
  String get nameHint;
  String get confirmPasswordLabel;
  String get confirmPasswordHint;
  String get signupButton;
  String get haveAccount;
  String get loginLink;

  // Password Management
  String get forgotPasswordTitle;
  String get forgotPasswordSubtitle;
  String get resetYourPassword;
  String get resetInstructions;
  String get emailAddressLabel;
  String get enterEmailHint;
  String get emailRequired;
  String get emailInvalid;
  String get sendResetLink;
  String get resetLinkSent;
  String resetEmailSent(String email);
  String get backToLogin;
  String get resetPasswordTitle;
  String get resetPasswordSubtitle;
  String get createNewPassword;
  String get enterNewPasswordHint;
  String get newPasswordLabel;
  String get enterNewPasswordPlaceholder;
  String get passwordRequired;
  String get passwordMinLength;
  String get passwordStrengthHint;
  String get confirmPasswordRequired;
  String get confirmNewPasswordRequired;
  String get passwordsDoNotMatch;
  String get confirmNewPasswordHint;
  String get resetPasswordButton;
  String get resetSuccess;
  String get changePasswordTitle;
  String get updatePasswordTitle;
  String get updatePasswordHint;
  String get currentPasswordLabel;
  String get enterCurrentPasswordHint;
  String get currentPasswordRequired;
  String get newPasswordRequired;
  String get passwordMustBeDifferent;
  String get confirmNewPasswordLabel;
  String get changePasswordButton;
  String get passwordChangeSuccess;

  // Email Verification
  String get verifyEmailTitle;
  String get verifyEmailSubtitle;
  String get sendVerificationEmail;
  String get emailSent;
  String get checkInbox;
  String get checkSpamFolder;
  String get verificationLinkSent;
  String get verificationSuccess;
  String get verificationSuccessMessage;
  String get verificationSuccessTitle;
  String get verificationWelcomeMessage;
  String get skipVerificationDevOnly;
  String get accountCreated;
  String get pleaseLogin;
  String get openEmailApp;
  String get didntReceive;
  String resendIn(int seconds);
  String get continueToDashboard;

  // Session Management
  String get sessionExpired;
  String get sessionExpiredMessage;
  String get emailAlreadyInUse;

  // Loading & Errors
  String get signingIn;
  String get signingUp;
  String get sendingEmail;
  String get networkError;
  String get networkErrorMessage;
  String get authError;
  String get tryAgain;

  // Security
  String get dataSecurityNotice;
  String get biometricOptional;

  ProfileStrings get profile;
  OnboardingStrings get onboarding;
}

abstract class OnboardingStrings {
  String get slide1Title;
  String get slide1Description;
  String get slide2Title;
  String get slide2Description;
  String get slide3Title;
  String get slide3Description;
  String get slide4Title;
  String get slide4Description;
  String get getStarted;
  String get loginButton;
}

abstract class ProfileStrings {
  String get profile;
  String get myProfile;
  String get editProfile;
  String get accountDetails;
  String get security;
  String get notifications;
  String get appearance;
  String get language;
  String get currency;
  String get helpCenter;
  String get aboutApp;
  String get termsOfService;
  String get privacyPolicy;
  String get logOut;
  String get logOutConfirm;
  String get deleteAccount;
  String get deleteAccountTitle;
  String get deleteAccountWarning;
  String get deleteAccountButton;
  String get deleteAccountSuccess;
  String get name;
  String get email;
  String get phone;
  String get joinedDate;
  String get accountStatus;
  String get verified;
  String get notVerified;
  String get theme;
  String get lightMode;
  String get darkMode;
  String get systemDefault;
  String get themeChanged;
  String get pushNotifications;
  String get emailNotifications;
  String get transactionAlerts;
  String get budgetAlerts;
  String get weeklyReports;
  String get notificationSettingsSaved;
  String get profileUpdated;
  String get emailVerified;
  String get languageChanged;
  String get updateAccountDetails;
  String get fullName;
  String get saveChanges;
  String get changeTheme;
  String get changePassword;
}
