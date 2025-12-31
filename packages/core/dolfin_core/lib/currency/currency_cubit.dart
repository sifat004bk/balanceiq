import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../analytics/analytics_service.dart';

/// Currency state
class CurrencyState {
  final String? currencyCode;
  final String? currencySymbol;
  final String? currencyName;

  bool get isCurrencySet => currencyCode != null;

  const CurrencyState({
    this.currencyCode,
    this.currencySymbol,
    this.currencyName,
  });

  /// Default currency (Unset)
  factory CurrencyState.initial() => const CurrencyState(
        currencyCode: null,
        currencySymbol: null,
        currencyName: null,
      );

  CurrencyState copyWith({
    String? currencyCode,
    String? currencySymbol,
    String? currencyName,
  }) {
    return CurrencyState(
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencyName: currencyName ?? this.currencyName,
    );
  }
}

/// Currency Cubit - manages selected currency and formatting
class CurrencyCubit extends Cubit<CurrencyState> {
  static const String _currencyCodeKey = 'selected_currency_code';
  static const String _currencySymbolKey = 'selected_currency_symbol';
  static const String _currencyNameKey = 'selected_currency_name';

  final AnalyticsService _analyticsService;

  CurrencyCubit({
    required AnalyticsService analyticsService,
  })  : _analyticsService = analyticsService,
        super(CurrencyState.initial()) {
    _loadSavedCurrency();
  }

  /// Load saved currency from SharedPreferences
  Future<void> _loadSavedCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_currencyCodeKey);
    final symbol = prefs.getString(_currencySymbolKey);
    final name = prefs.getString(_currencyNameKey);

    if (code != null && symbol != null && name != null) {
      emit(CurrencyState(
        currencyCode: code,
        currencySymbol: symbol,
        currencyName: name,
      ));
    }
  }

  /// Set currency from currency_picker's Currency object
  Future<void> setCurrency(Currency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyCodeKey, currency.code);
    await prefs.setString(_currencySymbolKey, currency.symbol);
    await prefs.setString(_currencyNameKey, currency.name);

    emit(CurrencyState(
      currencyCode: currency.code,
      currencySymbol: currency.symbol,
      currencyName: currency.name,
    ));

    // Log select_currency
    await _analyticsService.logEvent(
      name: 'select_currency',
      parameters: {'currency_code': currency.code},
    );
  }

  /// Set currency by code string (e.g., 'USD', 'BDT')
  Future<void> setCurrencyByCode(String code) async {
    final currency = CurrencyService().findByCode(code);
    if (currency != null) {
      await setCurrency(currency);
    }
  }

  /// Format amount with current currency symbol
  /// Example: 1234.56 -> "৳1,234.56" or "$1,234.56"
  String formatAmount(double amount) {
    // Fallback to strict formatting if needed, or empty symbol
    final symbol = state.currencySymbol ?? '';
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format amount with sign (+ for income, - for expense)
  String formatAmountWithSign(double amount, {bool isIncome = true}) {
    final formatted = formatAmount(amount.abs());
    return isIncome ? '+$formatted' : '-$formatted';
  }

  /// Format compact amount (e.g., 1.2K, 3.5M)
  /// Returns just the number if currency is not set
  String formatCompact(double amount) {
    final sym = state.currencySymbol ?? '';
    if (amount >= 1000000) {
      return '$sym${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$sym${(amount / 1000).toStringAsFixed(1)}K';
    }
    return formatAmount(amount);
  }

  /// Get just the symbol
  String get symbol => state.currencySymbol ?? '';

  /// Check if currency has been set by user
  Future<bool> hasCurrencyBeenSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_currencyCodeKey);
  }

  /// Reset currency state (call on logout)
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currencyCodeKey);
    await prefs.remove(_currencySymbolKey);
    await prefs.remove(_currencyNameKey);
    emit(CurrencyState.initial());
  }
}
