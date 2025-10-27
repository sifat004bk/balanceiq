import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/pages/onboarding_page.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          create: (context) => di.sl<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider(
          create: (context) => di.sl<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final themeMode = themeState is ThemeLoaded
              ? themeState.themeMode
              : ThemeMode.system;

          return MaterialApp(
            title: 'BalanceIQ',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeMode,
            home: const AuthWrapper(),
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
          return const OnboardingPage();
        }
      },
    );
  }
}
