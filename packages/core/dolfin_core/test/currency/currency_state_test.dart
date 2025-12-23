import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyState', () {
    test('should create CurrencyState with required parameters', () {
      // Arrange & Act
      const state = CurrencyState(
        currencyCode: 'USD',
        currencySymbol: '\$',
        currencyName: 'US Dollar',
      );

      // Assert
      expect(state.currencyCode, 'USD');
      expect(state.currencySymbol, '\$');
      expect(state.currencyName, 'US Dollar');
    });

    test('initial factory should create BDT state', () {
      // Act
      final state = CurrencyState.initial();

      // Assert
      expect(state.currencyCode, 'BDT');
      expect(state.currencySymbol, '৳');
      expect(state.currencyName, 'Bangladeshi Taka');
    });

    group('copyWith', () {
      test('should copy with new currencyCode', () {
        // Arrange
        const original = CurrencyState(
          currencyCode: 'BDT',
          currencySymbol: '৳',
          currencyName: 'Bangladeshi Taka',
        );

        // Act
        final copy = original.copyWith(currencyCode: 'USD');

        // Assert
        expect(copy.currencyCode, 'USD');
        expect(copy.currencySymbol, '৳');
        expect(copy.currencyName, 'Bangladeshi Taka');
      });

      test('should copy with new currencySymbol', () {
        // Arrange
        const original = CurrencyState(
          currencyCode: 'BDT',
          currencySymbol: '৳',
          currencyName: 'Bangladeshi Taka',
        );

        // Act
        final copy = original.copyWith(currencySymbol: '\$');

        // Assert
        expect(copy.currencyCode, 'BDT');
        expect(copy.currencySymbol, '\$');
        expect(copy.currencyName, 'Bangladeshi Taka');
      });

      test('should copy with new currencyName', () {
        // Arrange
        const original = CurrencyState(
          currencyCode: 'BDT',
          currencySymbol: '৳',
          currencyName: 'Bangladeshi Taka',
        );

        // Act
        final copy = original.copyWith(currencyName: 'US Dollar');

        // Assert
        expect(copy.currencyCode, 'BDT');
        expect(copy.currencySymbol, '৳');
        expect(copy.currencyName, 'US Dollar');
      });

      test('should copy with all new values', () {
        // Arrange
        const original = CurrencyState(
          currencyCode: 'BDT',
          currencySymbol: '৳',
          currencyName: 'Bangladeshi Taka',
        );

        // Act
        final copy = original.copyWith(
          currencyCode: 'EUR',
          currencySymbol: '€',
          currencyName: 'Euro',
        );

        // Assert
        expect(copy.currencyCode, 'EUR');
        expect(copy.currencySymbol, '€');
        expect(copy.currencyName, 'Euro');
      });

      test('should keep original values when no parameters provided', () {
        // Arrange
        const original = CurrencyState(
          currencyCode: 'GBP',
          currencySymbol: '£',
          currencyName: 'British Pound',
        );

        // Act
        final copy = original.copyWith();

        // Assert
        expect(copy.currencyCode, 'GBP');
        expect(copy.currencySymbol, '£');
        expect(copy.currencyName, 'British Pound');
      });
    });
  });
}
