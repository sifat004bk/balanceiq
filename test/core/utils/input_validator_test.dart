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

      test('should return error message for amount exceeding maximum', () {
        expect(InputValidator.validateAmount('9999999999'),
            'Amount exceeds maximum allowed value');
      });
    });

    group('validateAmountAllowZero', () {
      test('should return null for zero amount', () {
        expect(InputValidator.validateAmountAllowZero('0'), null);
      });

      test('should return error for negative amount', () {
        expect(InputValidator.validateAmountAllowZero('-1'),
            'Amount cannot be negative');
      });

      test('should return error for amount exceeding maximum', () {
        expect(InputValidator.validateAmountAllowZero('9999999999'),
            'Amount exceeds maximum allowed value');
      });
    });

    group('sanitizeInput', () {
      test('should remove HTML tags', () {
        expect(InputValidator.sanitizeInput('<b>Bold</b>'), 'Bold');
        expect(InputValidator.sanitizeInput('Normal text'), 'Normal text');
      });

      test('should remove script tags and content', () {
        expect(
            InputValidator.sanitizeInput('<script>alert("xss")</script>'), '');
        expect(
            InputValidator.sanitizeInput('Hello<script>evil()</script>World'),
            'HelloWorld');
      });

      test('should remove event handlers', () {
        expect(InputValidator.sanitizeInput('onclick=alert("xss")'),
            'alert("xss")');
        expect(
            InputValidator.sanitizeInput('onload=malicious()'), 'malicious()');
      });

      test('should remove javascript: protocol', () {
        expect(InputValidator.sanitizeInput('javascript:alert(1)'), 'alert(1)');
      });
    });

    group('sanitizeForQuery', () {
      test('should remove SQL injection patterns', () {
        // Removes quotes, semicolons, and double-dash comments
        expect(InputValidator.sanitizeForQuery("'; DROP TABLE users; --"),
            'TABLE users');
        // Removes SQL keywords
        expect(InputValidator.sanitizeForQuery('SELECT * FROM users'),
            '* FROM users');
      });
    });

    group('containsMaliciousContent', () {
      test('should detect script tags', () {
        expect(
            InputValidator.containsMaliciousContent(
                '<script>alert(1)</script>'),
            true);
      });

      test('should detect event handlers', () {
        expect(InputValidator.containsMaliciousContent('onclick=evil()'), true);
      });

      test('should detect javascript protocol', () {
        expect(InputValidator.containsMaliciousContent('javascript:alert(1)'),
            true);
      });

      test('should detect SQL injection', () {
        expect(InputValidator.containsMaliciousContent("'; DROP TABLE users;"),
            true);
      });

      test('should return false for safe content', () {
        expect(InputValidator.containsMaliciousContent('Hello World'), false);
        expect(
            InputValidator.containsMaliciousContent('Normal text 123'), false);
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

    group('isValidAmount', () {
      test('should return true for valid amount', () {
        expect(InputValidator.isValidAmount(100.0), true);
        expect(InputValidator.isValidAmount(999999999.99), true);
      });

      test('should return false for invalid amount', () {
        expect(InputValidator.isValidAmount(0), false);
        expect(InputValidator.isValidAmount(-10), false);
        expect(InputValidator.isValidAmount(9999999999), false);
      });
    });
  });
}
