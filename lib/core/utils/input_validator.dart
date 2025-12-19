abstract class InputValidator {
  InputValidator._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s]+$');

  static final RegExp _htmlTagRegex = RegExp(r'<[^>]*>');

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmedEmail = email.trim();

    if (!_emailRegex.hasMatch(trimmedEmail)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static final RegExp _passwordComplexityRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$',
  );

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!_passwordComplexityRegex.hasMatch(password)) {
      return 'Password must contain uppercase, lowercase, number, and special character';
    }

    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }

    final trimmedName = name.trim();

    if (trimmedName.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (trimmedName.length > 50) {
      return 'Name must not exceed 50 characters';
    }

    if (!_nameRegex.hasMatch(trimmedName)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  static String? validateAmount(String? amount) {
    if (amount == null || amount.trim().isEmpty) {
      return 'Amount is required';
    }

    final trimmedAmount = amount.trim();
    final parsedAmount = double.tryParse(trimmedAmount);

    if (parsedAmount == null) {
      return 'Please enter a valid number';
    }

    if (parsedAmount <= 0) {
      return 'Amount must be greater than zero';
    }

    return null;
  }

  static String sanitizeInput(String input) {
    return input.replaceAll(_htmlTagRegex, '').trim();
  }

  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }
}
