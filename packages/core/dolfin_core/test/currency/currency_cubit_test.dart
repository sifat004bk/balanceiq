import 'package:currency_picker/currency_picker.dart';
import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper to create a currency object
  Currency createCurrency(String code, String symbol, String name) {
    return Currency(
      code: code,
      name: name,
      symbol: symbol,
      flag: 'flag',
      number: 0,
      decimalDigits: 2,
      namePlural: name,
      thousandsSeparator: ',',
      decimalSeparator: '.',
      spaceBetweenAmountAndSymbol: false,
      symbolOnLeft: true,
    );
  }

  group('CurrencyCubit', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    group('Initial State', () {
      test('should have BDT as initial currency', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(currencyCubit.state.currencyCode, equals('BDT'));
        expect(currencyCubit.state.currencySymbol, equals('৳'));
        expect(currencyCubit.state.currencyName, equals('Bangladeshi Taka'));

        await currencyCubit.close();
      });
    });

    group('Load Saved Currency', () {
      test('should load saved currency from SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({
          'selected_currency_code': 'USD',
          'selected_currency_symbol': '\$',
          'selected_currency_name': 'United States Dollar',
        });

        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        expect(currencyCubit.state.currencyCode, equals('USD'));
        expect(currencyCubit.state.currencySymbol, equals('\$'));
        expect(
            currencyCubit.state.currencyName, equals('United States Dollar'));

        await currencyCubit.close();
      });

      test('should use default BDT when no currency is saved', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(currencyCubit.state.currencyCode, equals('BDT'));
        expect(currencyCubit.state.currencySymbol, equals('৳'));

        await currencyCubit.close();
      });
    });

    group('Set Currency', () {
      test('should emit new state when currency is set', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        final states = <CurrencyState>[];
        final subscription = currencyCubit.stream.listen(states.add);

        await currencyCubit.setCurrency(createCurrency('EUR', '€', 'Euro'));
        await Future.delayed(const Duration(milliseconds: 50));

        expect(states.length, equals(1));
        expect(states.first.currencyCode, equals('EUR'));
        expect(states.first.currencySymbol, equals('€'));

        await subscription.cancel();
        await currencyCubit.close();
      });

      test('should save currency to SharedPreferences', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        await currencyCubit
            .setCurrency(createCurrency('GBP', '£', 'British Pound'));

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('selected_currency_code'), equals('GBP'));
        expect(prefs.getString('selected_currency_symbol'), equals('£'));

        await currencyCubit.close();
      });
    });

    group('Format Amount', () {
      test('should format amount with currency symbol', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        final formatted = currencyCubit.formatAmount(1234.56);
        expect(formatted, contains('৳'));
        expect(formatted, contains('1,234.56'));

        await currencyCubit.close();
      });

      test('should handle zero amount', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        final formatted = currencyCubit.formatAmount(0);
        expect(formatted, contains('0.00'));

        await currencyCubit.close();
      });

      test('should handle large amounts with commas', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        final formatted = currencyCubit.formatAmount(1000000.50);
        expect(formatted, contains('1,000,000.50'));

        await currencyCubit.close();
      });

      test('should handle negative amounts', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        final formatted = currencyCubit.formatAmount(-500.25);
        expect(formatted, contains('500.25'));

        await currencyCubit.close();
      });
    });

    group('Format Amount With Sign', () {
      test('should format income with + sign', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        final formatted =
            currencyCubit.formatAmountWithSign(500.0, isIncome: true);
        expect(formatted, startsWith('+'));
        expect(formatted, contains('500.00'));

        await currencyCubit.close();
      });

      test('should format expense with - sign', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        final formatted =
            currencyCubit.formatAmountWithSign(250.75, isIncome: false);
        expect(formatted, startsWith('-'));
        expect(formatted, contains('250.75'));

        await currencyCubit.close();
      });
    });

    group('Format Compact', () {
      test('should format millions with M suffix', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        final formatted = currencyCubit.formatCompact(1500000);
        expect(formatted, equals('৳1.5M'));

        await currencyCubit.close();
      });

      test('should format thousands with K suffix', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        final formatted = currencyCubit.formatCompact(2300);
        expect(formatted, equals('৳2.3K'));

        await currencyCubit.close();
      });

      test('should format small amounts normally', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        final formatted = currencyCubit.formatCompact(999);
        expect(formatted, contains('999'));
        expect(formatted, isNot(contains('K')));
        expect(formatted, isNot(contains('M')));

        await currencyCubit.close();
      });
    });

    group('Symbol Getter', () {
      test('should return current currency symbol', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(currencyCubit.symbol, equals('৳'));

        await currencyCubit.close();
      });

      test('should return updated symbol after currency change', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        await currencyCubit
            .setCurrency(createCurrency('USD', '\$', 'US Dollar'));
        expect(currencyCubit.symbol, equals('\$'));

        await currencyCubit.close();
      });
    });

    group('Has Currency Been Set', () {
      test('should return false when no currency has been saved', () async {
        final currencyCubit = CurrencyCubit();
        final hasBeenSet = await currencyCubit.hasCurrencyBeenSet();

        expect(hasBeenSet, isFalse);
        await currencyCubit.close();
      });

      test('should return true when currency has been saved', () async {
        SharedPreferences.setMockInitialValues(
            {'selected_currency_code': 'EUR'});

        final currencyCubit = CurrencyCubit();
        final hasBeenSet = await currencyCubit.hasCurrencyBeenSet();

        expect(hasBeenSet, isTrue);
        await currencyCubit.close();
      });
    });

    group('Integration Tests', () {
      test('should persist and reload currency across cubit instances',
          () async {
        var cubit1 = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        await cubit1.setCurrency(createCurrency('JPY', '¥', 'Japanese Yen'));
        await cubit1.close();

        var cubit2 = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit2.state.currencyCode, equals('JPY'));
        expect(cubit2.state.currencySymbol, equals('¥'));

        await cubit2.close();
      });

      test('should handle formatting with different currencies', () async {
        final currencyCubit = CurrencyCubit();
        await Future.delayed(const Duration(milliseconds: 50));

        // Test with BDT
        var formatted = currencyCubit.formatAmount(1000);
        expect(formatted, contains('৳'));

        // Change to USD
        await currencyCubit
            .setCurrency(createCurrency('USD', '\$', 'US Dollar'));
        formatted = currencyCubit.formatAmount(1000);
        expect(formatted, contains('\$'));

        // Change to EUR
        await currencyCubit.setCurrency(createCurrency('EUR', '€', 'Euro'));
        formatted = currencyCubit.formatAmount(1000);
        expect(formatted, contains('€'));

        await currencyCubit.close();
      });
    });
  });
}
