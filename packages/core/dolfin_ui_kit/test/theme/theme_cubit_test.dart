import 'package:dolfin_core/constants/app_constants.dart';
import 'package:dolfin_ui_kit/theme/theme_cubit.dart';
import 'package:dolfin_ui_kit/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple mock for AppConstants
class MockAppConstants extends Fake implements AppConstants {
  @override
  String get keyThemeMode => 'theme_mode';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAppConstants mockConstants;

  setUpAll(() {
    mockConstants = MockAppConstants();
    if (!GetIt.instance.isRegistered<AppConstants>()) {
      GetIt.instance.registerSingleton<AppConstants>(mockConstants);
    }
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDownAll(() async {
    await GetIt.instance.reset();
  });

  group('ThemeCubit', () {
    group('Initialization', () {
      test('initial state loads to ThemeLoaded', () async {
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(cubit.state, isA<ThemeLoaded>());
        await cubit.close();
      });

      test('should load light theme from SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(cubit.state, isA<ThemeLoaded>());
        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.light);
        await cubit.close();
      });

      test('should load dark theme from SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(cubit.state, isA<ThemeLoaded>());
        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.dark);
        await cubit.close();
      });

      test('should load system theme when no saved value', () async {
        final prefs = await SharedPreferences.getInstance();

        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(cubit.state, isA<ThemeLoaded>());
        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.system);
        await cubit.close();
      });
    });

    group('Set Theme Mode', () {
      test('should set to light mode and persist', () async {
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit.setThemeMode(ThemeMode.light);

        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.light);
        expect(prefs.getString('theme_mode'), 'light');
        await cubit.close();
      });

      test('should set to dark mode and persist', () async {
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit.setThemeMode(ThemeMode.dark);

        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.dark);
        expect(prefs.getString('theme_mode'), 'dark');
        await cubit.close();
      });

      test('should set to system mode and persist', () async {
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit.setThemeMode(ThemeMode.system);

        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.system);
        expect(prefs.getString('theme_mode'), 'system');
        await cubit.close();
      });

      test('should emit state on theme change', () async {
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        final states = <ThemeState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.setThemeMode(ThemeMode.dark);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states.length, greaterThanOrEqualTo(1));
        expect((states.last as ThemeLoaded).themeMode, ThemeMode.dark);

        await subscription.cancel();
        await cubit.close();
      });
    });

    group('Convenience Methods', () {
      test('setLightMode should set light theme', () async {
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit.setLightMode();

        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.light);
        await cubit.close();
      });

      test('setDarkMode should set dark theme', () async {
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit.setDarkMode();

        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.dark);
        await cubit.close();
      });

      test('setSystemMode should set system theme', () async {
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit.setSystemMode();

        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.system);
        await cubit.close();
      });
    });

    group('Toggle Theme', () {
      test('should toggle from light to dark', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit.toggleTheme();

        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.dark);
        await cubit.close();
      });

      test('should toggle from dark to light', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit.toggleTheme();

        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.light);
        await cubit.close();
      });

      test('should handle system mode when toggling', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'system'});
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit.toggleTheme();

        // System mode should toggle to dark (since it's not dark)
        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.dark);
        await cubit.close();
      });
    });

    group('Integration Tests', () {
      test('theme persists across cubit instances', () async {
        // First instance sets dark mode
        var prefs = await SharedPreferences.getInstance();
        var cubit1 = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));
        await cubit1.setDarkMode();
        await cubit1.close();

        // Second instance should load dark mode
        prefs = await SharedPreferences.getInstance();
        var cubit2 = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 100));

        expect((cubit2.state as ThemeLoaded).themeMode, ThemeMode.dark);
        await cubit2.close();
      });

      test('multiple theme changes handled correctly', () async {
        final prefs = await SharedPreferences.getInstance();
        final cubit = ThemeCubit(prefs);
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit.setLightMode();
        await cubit.setDarkMode();
        await cubit.setSystemMode();
        await cubit.setLightMode();

        expect((cubit.state as ThemeLoaded).themeMode, ThemeMode.light);
        expect(prefs.getString('theme_mode'), 'light');
        await cubit.close();
      });
    });
  });
}
