import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeCubit(this.sharedPreferences) : super(ThemeInitial()) {
    _loadTheme();
  }

  // Load saved theme from SharedPreferences
  void _loadTheme() {
    final themeModeString =
        sharedPreferences.getString(AppConstants.keyThemeMode);
    final ThemeMode themeMode;

    switch (themeModeString) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    emit(ThemeLoaded(themeMode));
  }

  // Change theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    String themeModeString;

    switch (themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }

    await sharedPreferences.setString(
        AppConstants.keyThemeMode, themeModeString);
    emit(ThemeLoaded(themeMode));
  }

  // Toggle between light and dark
  Future<void> toggleTheme() async {
    if (state is ThemeLoaded) {
      final currentMode = (state as ThemeLoaded).themeMode;
      final newMode =
          currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      await setThemeMode(newMode);
    }
  }

  // Set to light mode
  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  // Set to dark mode
  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  // Set to system mode
  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }
}
