import 'package:balance_iq/core/utils/input_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InputValidator', () {
    group('validateEmail', () {
      test('should return null for valid email', () {
        expect(InputValidator.validateEmail('test@example.com'), null);
        expect(InputValidator.validateEmail('user.name@domain.co.uk'), null);
      });

      test('should return error message for null or empty email', () {
        expect(InputValidator.validateEmail(null), 'Email is required');
        expect(InputValidator.validateEmail(''), 'Email is required');
        expect(InputValidator.validateEmail('  '), 'Email is required');
      });

      test('should return error message for invalid email format', () {
        expect(InputValidator.validateEmail('test'),
            'Please enter a valid email address');
        expect(InputValidator.validateEmail('test@'),
            'Please enter a valid email address');
        expect(InputValidator.validateEmail('@example.com'),
            'Please enter a valid email address');
        expect(InputValidator.validateEmail('test@example'),
            'Please enter a valid email address');
      });
    });

    group('validatePassword', () {
      test('should return null for valid password', () {
        expect(InputValidator.validatePassword('Password123!'), null);
      });

      test('should return error message for null or empty password', () {
        expect(InputValidator.validatePassword(null), 'Password is required');
        expect(InputValidator.validatePassword(''), 'Password is required');
      });

      test('should return error message for short password', () {
        expect(InputValidator.validatePassword('Pass12!'),
            'Password must be at least 8 characters');
      });

      test('should return error message for weak password', () {
        expect(InputValidator.validatePassword('password123'),
            'Password must contain uppercase, lowercase, number, and special character');
        expect(InputValidator.validatePassword('PASSWORD123'),
            'Password must contain uppercase, lowercase, number, and special character');
        expect(InputValidator.validatePassword('Password!'),
            'Password must contain uppercase, lowercase, number, and special character');
      });
    });

    group('validateName', () {
      test('should return null for valid name', () {
        expect(InputValidator.validateName('John Doe'), null);
      });

      test('should return error message for null or empty name', () {
        expect(InputValidator.validateName(null), 'Name is required');
        expect(InputValidator.validateName(''), 'Name is required');
        expect(InputValidator.validateName('  '), 'Name is required');
      });

      test('should return error message for short name', () {
        expect(InputValidator.validateName('J'),
            'Name must be at least 2 characters');
      });

      test('should return error message for long name', () {
        final longName = 'a' * 51;
        expect(InputValidator.validateName(longName),
            'Name must not exceed 50 characters');
      });

      test('should return error message for invalid characters', () {
        expect(InputValidator.validateName('John123'),
            'Name can only contain letters and spaces');
        expect(InputValidator.validateName('John@Doe'),
            'Name can only contain letters and spaces');
      });
    });

    group('validateAmount', () {
      test('should return null for valid amount', () {
        expect(InputValidator.validateAmount('100'), null);
        expect(InputValidator.validateAmount('100.50'), null);
      });

      test('should return error message for null or empty amount', () {
        expect(InputValidator.validateAmount(null), 'Amount is required');
        expect(InputValidator.validateAmount(''), 'Amount is required');
        expect(InputValidator.validateAmount('  '), 'Amount is required');
      });

      test('should return error message for non-numeric input', () {
        expect(InputValidator.validateAmount('abc'),
            'Please enter a valid number');
        expect(InputValidator.validateAmount('12.3.4'),
            'Please enter a valid number');
      });

      test('should return error message for zero or negative amount', () {
        expect(InputValidator.validateAmount('0'),
            'Amount must be greater than zero');
        expect(InputValidator.validateAmount('-100'),
            'Amount must be greater than zero');
      });
    });

    group('sanitizeInput', () {
      test('should remove HTML tags', () {
        expect(InputValidator.sanitizeInput('<script>alert("xss")</script>'),
            'alert("xss")');
        expect(InputValidator.sanitizeInput('<b>Bold</b>'), 'Bold');
        expect(InputValidator.sanitizeInput('Normal text'), 'Normal text');
      });
    });

    group('isValidEmail', () {
      test('should return true for valid email', () {
        expect(InputValidator.isValidEmail('test@example.com'), true);
      });

      test('should return false for invalid email', () {
        expect(InputValidator.isValidEmail('test'), false);
      });
    });
  });
}
