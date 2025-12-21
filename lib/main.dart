import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/injection_container.dart' as di;
import 'core/navigation/navigator_service.dart';
import 'core/theme/app_palette.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'core/tour/tour.dart';

// Cubits
import 'features/auth/presentation/cubit/session/session_cubit.dart';
import 'features/auth/presentation/cubit/login/login_cubit.dart';
import 'features/auth/presentation/cubit/signup/signup_cubit.dart';
import 'features/auth/presentation/cubit/password/password_cubit.dart';

// Pages
import 'features/auth/presentation/pages/change_password_page.dart';
import 'features/auth/presentation/pages/email_verification_page.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';
import 'features/auth/presentation/pages/loading_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/onboarding_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/auth/presentation/pages/interactive_onboarding/interactive_onboarding_page.dart';
import 'features/auth/presentation/pages/profile_page.dart';
import 'features/auth/presentation/pages/reset_password_page.dart';
import 'features/auth/presentation/pages/verification_success_page.dart';
import 'features/home/presentation/cubit/dashboard_cubit.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/home/presentation/pages/transactions_page.dart';
import 'features/subscription/presentation/pages/manage_subscription_page.dart';
import 'features/subscription/presentation/pages/subscription_plans_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize dependency injection
  await di.init();

  // Set Global Error Widget
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: AppPalette.backgroundLight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppPalette.error,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Something went wrong!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  details.exceptionAsString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppPalette.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  };

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // SessionCubit replaces AuthCubit for global auth state
        BlocProvider(
          create: (context) => di.sl<SessionCubit>()..checkAuthStatus(),
        ),
        BlocProvider(
          create: (context) => di.sl<ThemeCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<DashboardCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<ProductTourCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final themeMode = themeState is ThemeLoaded
              ? themeState.themeMode
              : ThemeMode.system;

          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Donfin AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeMode,
            home: const SplashPage(),
            routes: {
              '/onboarding': (context) => const OnboardingPage(),
              '/interactive-onboarding': (context) =>
                  const InteractiveOnboardingPage(),
              '/login': (context) => BlocProvider(
                    create: (context) => di.sl<LoginCubit>(),
                    child: const LoginPage(),
                  ),
              '/signup': (context) => BlocProvider(
                    create: (context) => di.sl<SignupCubit>(),
                    child: const SignUpPage(),
                  ),
              '/verification-success': (context) =>
                  const VerificationSuccessPage(),
              '/loading': (context) => const LoadingPage(),
              '/home': (context) => const HomePage(),
              '/forgot-password': (context) => BlocProvider(
                    create: (context) => di.sl<PasswordCubit>(),
                    child: const ForgotPasswordPage(),
                  ),
              '/change-password': (context) => BlocProvider(
                    create: (context) => di.sl<PasswordCubit>(),
                    child: const ChangePasswordPage(),
                  ),
              '/profile': (context) => const ProfilePage(),
              '/subscription-plans': (context) => const SubscriptionPlansPage(),
              '/manage-subscription': (context) =>
                  const ManageSubscriptionPage(),
              '/transactions': (context) => const TransactionsPage(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/email-verification') {
                final email =
                    settings.arguments as String? ?? 'user@example.com';
                return MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => di.sl<SignupCubit>(),
                    child: EmailVerificationPage(email: email),
                  ),
                );
              }
              if (settings.name == '/reset-password') {
                final token = settings.arguments as String? ?? '';
                return MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => di.sl<PasswordCubit>(),
                    child: ResetPasswordPage(token: token),
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
