import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/injection_container.dart' as di;
import 'core/navigation/navigator_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'core/tour/tour.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/pages/change_password_page.dart';
import 'features/auth/presentation/pages/email_verification_page.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';
import 'features/auth/presentation/pages/loading_page.dart';
import 'features/auth/presentation/pages/new_login_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/new_onboarding_page.dart';
import 'features/auth/presentation/pages/new_signup_page.dart';
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
        BlocProvider(
          create: (context) => di.sl<AuthCubit>(),
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
            title: 'BalanceIQ',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeMode,
            home: const SplashPage(),
            routes: {
              '/onboarding': (context) => const NewOnboardingPage(),
              '/login': (context) => const NewLoginPage(),
              '/signup': (context) => const NewSignUpPage(),
              '/verification-success': (context) =>
                  const VerificationSuccessPage(),
              '/loading': (context) => const LoadingPage(),
              '/home': (context) => const HomePage(),
              '/forgot-password': (context) => const ForgotPasswordPage(),
              '/change-password': (context) => const ChangePasswordPage(),
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
                  builder: (context) => EmailVerificationPage(email: email),
                );
              }
              if (settings.name == '/reset-password') {
                final token = settings.arguments as String? ?? '';
                return MaterialPageRoute(
                  builder: (context) => ResetPasswordPage(token: token),
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

// Wrapper widget to handle auth state and navigate accordingly
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthAuthenticated) {
          return const HomePage();
        } else {
          return const NewOnboardingPage();
        }
      },
    );
  }
}
