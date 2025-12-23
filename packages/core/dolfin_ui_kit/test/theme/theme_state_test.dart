import 'package:dolfin_ui_kit/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeState', () {
    group('ThemeInitial', () {
      test('should create ThemeInitial state', () {
        final state = ThemeInitial();
        expect(state, isA<ThemeState>());
        expect(state, isA<ThemeInitial>());
      });

      test('should have empty props', () {
        final state = ThemeInitial();
        expect(state.props, isEmpty);
      });

      test('should be equal to another ThemeInitial', () {
        final state1 = ThemeInitial();
        final state2 = ThemeInitial();
        expect(state1, equals(state2));
      });
    });

    group('ThemeLoaded', () {
      test('should create ThemeLoaded with light mode', () {
        const state = ThemeLoaded(ThemeMode.light);

        expect(state, isA<ThemeState>());
        expect(state, isA<ThemeLoaded>());
        expect(state.themeMode, equals(ThemeMode.light));
      });

      test('should create ThemeLoaded with dark mode', () {
        const state = ThemeLoaded(ThemeMode.dark);
        expect(state.themeMode, equals(ThemeMode.dark));
      });

      test('should create ThemeLoaded with system mode', () {
        const state = ThemeLoaded(ThemeMode.system);
        expect(state.themeMode, equals(ThemeMode.system));
      });

      test('should have themeMode in props', () {
        const state = ThemeLoaded(ThemeMode.light);
        expect(state.props, equals([ThemeMode.light]));
      });

      test('should be equal when theme modes are same', () {
        const state1 = ThemeLoaded(ThemeMode.dark);
        const state2 = ThemeLoaded(ThemeMode.dark);
        expect(state1, equals(state2));
      });

      test('should not be equal when theme modes differ', () {
        const state1 = ThemeLoaded(ThemeMode.light);
        const state2 = ThemeLoaded(ThemeMode.dark);
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal to ThemeInitial', () {
        const loaded = ThemeLoaded(ThemeMode.light);
        final initial = ThemeInitial();
        expect(loaded, isNot(equals(initial)));
      });
    });
  });
}
