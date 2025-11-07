/// Input Validators
///
/// Comprehensive input validation utilities with security focus
library;

import '../constants/security_constants.dart';

class Validators {
  // Prevent instantiation
  Validators._();

  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Trim and lowercase
    value = value.trim().toLowerCase();

    // Check length
    if (value.length > 254) {
      return 'Email is too long';
    }

    // Check format
    if (!SecurityConstants.emailPattern.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    // Check for suspicious patterns
    if (_containsSuspiciousPatterns(value)) {
      return 'Invalid email format';
    }

    return null;
  }

  /// Validate password with strength requirements
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Check minimum length
    if (value.length < SecurityConstants.minPasswordLength) {
      return 'Password must be at least ${SecurityConstants.minPasswordLength} characters';
    }

    // Check maximum length
    if (value.length > SecurityConstants.maxPasswordLength) {
      return 'Password is too long';
    }

    final List<String> errors = [];

    // Check uppercase requirement
    if (SecurityConstants.requireUppercase &&
        !value.contains(RegExp(r'[A-Z]'))) {
      errors.add('one uppercase letter');
    }

    // Check lowercase requirement
    if (SecurityConstants.requireLowercase &&
        !value.contains(RegExp(r'[a-z]'))) {
      errors.add('one lowercase letter');
    }

    // Check number requirement
    if (SecurityConstants.requireNumber && !value.contains(RegExp(r'[0-9]'))) {
      errors.add('one number');
    }

    // Check special character requirement
    if (SecurityConstants.requireSpecialChar &&
        !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.add('one special character');
    }

    if (errors.isNotEmpty) {
      return 'Password must contain ${errors.join(', ')}';
    }

    // Check for common weak passwords
    if (_isWeakPassword(value)) {
      return 'Password is too weak. Please choose a stronger password';
    }

    return null;
  }

  /// Validate password confirmation
  static String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate name (first or last)
  static String? validateName(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    // Trim whitespace
    value = value.trim();

    // Check length
    if (value.length < 2) {
      return '$fieldName must be at least 2 characters';
    }

    if (value.length > 50) {
      return '$fieldName is too long';
    }

    // Check for valid characters
    if (!SecurityConstants.namePattern.hasMatch(value)) {
      return '$fieldName contains invalid characters';
    }

    // Check for SQL injection patterns
    if (_containsSQLInjection(value)) {
      return 'Invalid $fieldName format';
    }

    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove common formatting characters
    value = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check format
    if (!SecurityConstants.phonePattern.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    // Check format
    if (!SecurityConstants.urlPattern.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    // Check for suspicious patterns
    if (_containsSuspiciousPatterns(value)) {
      return 'Invalid URL format';
    }

    return null;
  }

  /// Validate temperature input
  static String? validateTemperature(
    String? value, {
    double min = -50,
    double max = 100,
    String unit = '°C',
  }) {
    if (value == null || value.isEmpty) {
      return 'Temperature is required';
    }

    final temp = double.tryParse(value);
    if (temp == null) {
      return 'Please enter a valid number';
    }

    if (temp < min || temp > max) {
      return 'Temperature must be between $min$unit and $max$unit';
    }

    return null;
  }

  /// Validate numeric input
  static String? validateNumber(
    String? value, {
    String fieldName = 'Value',
    double? min,
    double? max,
    bool allowDecimal = true,
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (!allowDecimal && number % 1 != 0) {
      return '$fieldName must be a whole number';
    }

    if (min != null && number < min) {
      return '$fieldName must be at least $min';
    }

    if (max != null && number > max) {
      return '$fieldName must be at most $max';
    }

    return null;
  }

  /// Validate alphanumeric input
  static String? validateAlphanumeric(
    String? value, {
    String fieldName = 'Value',
    int? minLength,
    int? maxLength,
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (!SecurityConstants.alphanumericPattern.hasMatch(value)) {
      return '$fieldName must contain only letters and numbers';
    }

    if (minLength != null && value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (maxLength != null && value.length > maxLength) {
      return '$fieldName must be at most $maxLength characters';
    }

    return null;
  }

  /// Validate device ID
  static String? validateDeviceId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Device ID is required';
    }

    // Device ID format: alphanumeric with hyphens, 8-36 characters
    final deviceIdPattern = RegExp(r'^[a-zA-Z0-9\-]{8,36}$');
    if (!deviceIdPattern.hasMatch(value)) {
      return 'Invalid device ID format';
    }

    return null;
  }

  /// Validate IP address
  static String? validateIpAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'IP address is required';
    }

    // IPv4 pattern
    final ipv4Pattern = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}'
      r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );

    // IPv6 pattern (simplified)
    final ipv6Pattern = RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|'
      r'([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|'
      r'::([0-9a-fA-F]{1,4}:){0,5}[0-9a-fA-F]{1,4})$',
    );

    if (!ipv4Pattern.hasMatch(value) && !ipv6Pattern.hasMatch(value)) {
      return 'Please enter a valid IP address';
    }

    return null;
  }

  /// Validate WiFi SSID
  static String? validateSSID(String? value) {
    if (value == null || value.isEmpty) {
      return 'Network name is required';
    }

    if (value.length > 32) {
      return 'Network name is too long (max 32 characters)';
    }

    // Check for invalid characters
    if (value.contains('\n') || value.contains('\r') || value.contains('\t')) {
      return 'Network name contains invalid characters';
    }

    return null;
  }

  /// Validate WiFi password
  static String? validateWiFiPassword(String? value, String securityType) {
    if (securityType.toLowerCase() == 'open') {
      return null; // No password needed for open networks
    }

    if (value == null || value.isEmpty) {
      return 'Password is required for secure networks';
    }

    // WPA/WPA2 requirements
    if (securityType.contains('WPA')) {
      if (value.length < 8) {
        return 'WiFi password must be at least 8 characters';
      }
      if (value.length > 63) {
        return 'WiFi password is too long (max 63 characters)';
      }
    }

    // WEP requirements (deprecated but still supported)
    if (securityType.contains('WEP')) {
      if (value.length != 5 &&
          value.length != 13 &&
          value.length != 10 &&
          value.length != 26) {
        return 'WEP key must be 5, 13 characters (ASCII) or 10, 26 characters (HEX)';
      }
    }

    return null;
  }

  /// Sanitize input to prevent injection attacks
  static String sanitizeInput(String input) {
    // Remove or escape potentially dangerous characters
    String sanitized = input;

    // Remove HTML/script tags
    sanitized = sanitized.replaceAll(RegExp(r'<[^>]*>'), '');

    // Escape special characters
    for (final char in SecurityConstants.bannedCharacters) {
      sanitized = sanitized.replaceAll(char, '');
    }

    // Remove multiple spaces
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');

    // Trim whitespace
    return sanitized.trim();
  }

  /// Calculate password strength
  static PasswordStrength calculatePasswordStrength(String password) {
    int score = 0;

    // Length score
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.length >= 16) score++;

    // Complexity score
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    // Pattern score
    if (!_hasRepeatingCharacters(password)) score++;
    if (!_hasSequentialCharacters(password)) score++;

    if (score <= 3) return PasswordStrength.weak;
    if (score <= 5) return PasswordStrength.medium;
    if (score <= 7) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  /// Check for suspicious patterns (XSS, injection attempts)
  static bool _containsSuspiciousPatterns(String value) {
    final suspiciousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false), // Event handlers
      RegExp(r'data:text/html', caseSensitive: false),
      RegExp(r'vbscript:', caseSensitive: false),
      RegExp(r'<iframe', caseSensitive: false),
      RegExp(r'<embed', caseSensitive: false),
      RegExp(r'<object', caseSensitive: false),
    ];

    for (final pattern in suspiciousPatterns) {
      if (pattern.hasMatch(value)) {
        return true;
      }
    }

    return false;
  }

  /// Check for SQL injection patterns
  static bool _containsSQLInjection(String value) {
    final sqlPatterns = [
      RegExp(
          r"('|(')|(--)|(/\*)|(\*/)|(\bor\b)|(\band\b)|(\bunion\b)|(\bselect\b)|(\binsert\b)|(\bupdate\b)|(\bdelete\b)|(\bdrop\b))",
          caseSensitive: false),
    ];

    for (final pattern in sqlPatterns) {
      if (pattern.hasMatch(value)) {
        return true;
      }
    }

    return false;
  }

  /// Check for weak passwords
  static bool _isWeakPassword(String password) {
    final weakPasswords = [
      'password',
      '12345678',
      'qwerty',
      'abc123',
      'password123',
      'admin',
      'letmein',
      'welcome',
      'monkey',
      '1234567890',
      'password1',
      'qwerty123',
      'admin123',
      'root',
      'toor',
      'pass',
      'test',
      'guest',
      'master',
      'dragon',
      'baseball',
      'football',
      'letmein123',
      'welcome123',
      'admin1234',
    ];

    final lowerPassword = password.toLowerCase();
    return weakPasswords.contains(lowerPassword);
  }

  /// Check for repeating characters
  static bool _hasRepeatingCharacters(String password) {
    return RegExp(r'(.)\1{2,}').hasMatch(password);
  }

  /// Check for sequential characters
  static bool _hasSequentialCharacters(String password) {
    final sequences = [
      'abcd',
      'bcde',
      'cdef',
      'defg',
      'efgh',
      '1234',
      '2345',
      '3456',
      '4567',
      '5678',
      'qwer',
      'wert',
      'erty',
      'rtyu',
      'tyui'
    ];

    final lowerPassword = password.toLowerCase();
    for (final seq in sequences) {
      if (lowerPassword.contains(seq)) {
        return true;
      }
    }

    return false;
  }
}
