abstract class InputValidator {
  InputValidator._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s]+$');

  // XSS and injection patterns
  static final RegExp _htmlTagRegex = RegExp(r'<[^>]*>');
  static final RegExp _scriptTagRegex = RegExp(
    r'<\s*script[^>]*>.*?<\s*/\s*script\s*>',
    caseSensitive: false,
    dotAll: true,
  );
  static final RegExp _eventHandlerRegex = RegExp(
    r'\bon\w+\s*=',
    caseSensitive: false,
  );
  static final RegExp _sqlInjectionRegex = RegExp(
    r"(\b(SELECT|INSERT|UPDATE|DELETE|DROP|UNION|ALTER|CREATE|TRUNCATE)\b)|(')|(--)|(;)",
    caseSensitive: false,
  );
  static final RegExp _javascriptProtocolRegex = RegExp(
    r'javascript\s*:',
    caseSensitive: false,
  );

  /// Maximum allowed amount to prevent overflow issues
  static const double maxAmount = 999999999.99;

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

  /// Validates amount for financial transactions
  /// - Must be a valid number
  /// - Must be greater than zero
  /// - Must not exceed max amount (999,999,999.99)
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

    if (parsedAmount > maxAmount) {
      return 'Amount exceeds maximum allowed value';
    }

    return null;
  }

  /// Validates amount allowing zero (for filters, etc.)
  static String? validateAmountAllowZero(String? amount) {
    if (amount == null || amount.trim().isEmpty) {
      return 'Amount is required';
    }

    final trimmedAmount = amount.trim();
    final parsedAmount = double.tryParse(trimmedAmount);

    if (parsedAmount == null) {
      return 'Please enter a valid number';
    }

    if (parsedAmount < 0) {
      return 'Amount cannot be negative';
    }

    if (parsedAmount > maxAmount) {
      return 'Amount exceeds maximum allowed value';
    }

    return null;
  }

  /// Sanitizes input by removing potentially dangerous content
  /// - Removes HTML tags
  /// - Removes script tags and content
  /// - Removes event handlers (onclick, onload, etc.)
  /// - Removes javascript: protocols
  static String sanitizeInput(String input) {
    String sanitized = input;

    // Remove script tags and their content first
    sanitized = sanitized.replaceAll(_scriptTagRegex, '');

    // Remove all HTML tags
    sanitized = sanitized.replaceAll(_htmlTagRegex, '');

    // Remove event handlers
    sanitized = sanitized.replaceAll(_eventHandlerRegex, '');

    // Remove javascript: protocol
    sanitized = sanitized.replaceAll(_javascriptProtocolRegex, '');

    return sanitized.trim();
  }

  /// Sanitizes input for database queries (basic SQL injection prevention)
  /// Note: Always use parameterized queries as primary defense
  static String sanitizeForQuery(String input) {
    String sanitized = sanitizeInput(input);

    // Remove common SQL injection patterns
    sanitized = sanitized.replaceAll(_sqlInjectionRegex, '');

    return sanitized.trim();
  }

  /// Checks if input contains potentially malicious content
  static bool containsMaliciousContent(String input) {
    return _scriptTagRegex.hasMatch(input) ||
        _eventHandlerRegex.hasMatch(input) ||
        _javascriptProtocolRegex.hasMatch(input) ||
        _sqlInjectionRegex.hasMatch(input);
  }

  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validates that a double amount is within acceptable range
  static bool isValidAmount(double amount) {
    return amount > 0 && amount <= maxAmount;
  }
}
