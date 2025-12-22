import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dolfin_ui_kit/theme/theme_cubit.dart';
import 'package:dolfin_ui_kit/theme/theme_state.dart';
import 'package:dolfin_core/tour/product_tour_cubit.dart';
import 'package:feature_auth/presentation/pages/login_page.dart';
import 'package:feature_auth/presentation/pages/signup_page.dart';
import 'package:feature_auth/presentation/pages/forgot_password_page.dart';
import 'package:feature_auth/presentation/pages/profile_page.dart';
import 'package:feature_auth/presentation/pages/splash_page.dart';
import 'package:feature_auth/presentation/cubit/session/session_cubit.dart';
import 'package:feature_auth/presentation/cubit/login/login_cubit.dart';
import 'package:feature_auth/presentation/cubit/signup/signup_cubit.dart';
import 'package:feature_auth/presentation/cubit/password/password_cubit.dart';

import 'core/di/injection_container.dart' as di;
import 'core/navigation/navigator_service.dart';
import 'features/home/test_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (create empty .env if not exists)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // .env file not required for test app
  }

  // Initialize dependency injection
  await di.init();

  runApp(const DolfinTestApp());
}

class DolfinTestApp extends StatelessWidget {
  const DolfinTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider<SessionCubit>(
            create: (_) => di.sl<SessionCubit>()..checkAuthStatus()),
        BlocProvider<ProductTourCubit>(
            create: (_) => di.sl<ProductTourCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final themeMode = themeState is ThemeLoaded
              ? themeState.themeMode
              : ThemeMode.system;

          return MaterialApp(
            title: 'Dolfin Test',
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            themeMode: themeMode,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashPage(),
              '/login': (context) => BlocProvider<LoginCubit>(
                    create: (context) => di.sl<LoginCubit>(),
                    child: const LoginPage(),
                  ),
              '/signup': (context) => BlocProvider<SignupCubit>(
                    create: (context) => di.sl<SignupCubit>(),
                    child: const SignUpPage(),
                  ),
              '/forgot-password': (context) => BlocProvider<PasswordCubit>(
                    create: (context) => di.sl<PasswordCubit>(),
                    child: const ForgotPasswordPage(),
                  ),
              '/home': (context) => const TestHomePage(),
              '/profile': (context) => BlocProvider<SignupCubit>(
                    create: (context) => di.sl<SignupCubit>(),
                    child: const ProfilePage(),
                  ),
            },
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    // Teal/Amber theme - different from main app
    const primaryColor = Color(0xFF00897B);
    const secondaryColor = Color(0xFFFF6F00);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1A1A1A),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: const Color(0xFF1A1A1A),
        displayColor: const Color(0xFF1A1A1A),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1A),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    // Teal/Amber theme - different from main app
    const primaryColor = Color(0xFF00BFA5);
    const secondaryColor = Color(0xFFFFAB00);
    const backgroundColor = Color(0xFF1A1A2E);
    const surfaceColor = Color(0xFF16213E);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
