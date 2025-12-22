import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyCubit extends Mock implements CurrencyCubit {
  @override
  CurrencyState get state => CurrencyState.initial();

  @override
  String formatAmount(double amount) => '৳${amount.toStringAsFixed(2)}';

  @override
  String formatAmountWithSign(double amount, {bool isIncome = true}) {
    final formatted = formatAmount(amount.abs());
    return isIncome ? '+$formatted' : '-$formatted';
  }

  @override
  String formatCompact(double amount) => formatAmount(amount);

  @override
  String get symbol => '৳';

  @override
  Stream<CurrencyState> get stream => Stream.value(CurrencyState.initial());
}

/// Simple test theme that doesn't depend on GetIt
ThemeData _testTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6366F1),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6366F1),
      onPrimary: Colors.white,
      secondary: Color(0xFF8B5CF6),
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF1F2937),
      error: Color(0xFFEF4444),
      onError: Colors.white,
    ),
    fontFamily: 'Manrope',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
  );
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    NavigatorObserver? navigatorObserver,
    CurrencyCubit? currencyCubit,
  }) {
    final mockCurrencyCubit = currencyCubit ?? MockCurrencyCubit();

    return pumpWidget(
      BlocProvider<CurrencyCubit>.value(
        value: mockCurrencyCubit,
        child: MaterialApp(
          theme: _testTheme(),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: widget,
          navigatorObservers:
              navigatorObserver != null ? [navigatorObserver] : [],
        ),
      ),
    );
  }
}
