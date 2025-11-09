/// Password Validator
///
/// Password validation with strength calculation and security checks
library;

import '../../constants/security_constants.dart';

class PasswordValidator {
  // Prevent instantiation
  PasswordValidator._();

  /// Validate password with strength requirements
  static String? validate(String? value) {
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
    if (isWeakPassword(value)) {
      return 'Password is too weak. Please choose a stronger password';
    }

    return null;
  }

  /// Validate password confirmation
  static String? validateConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Calculate password strength
  static PasswordStrength calculateStrength(String password) {
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
    if (!hasRepeatingCharacters(password)) score++;
    if (!hasSequentialCharacters(password)) score++;

    if (score <= 3) return PasswordStrength.weak;
    if (score <= 5) return PasswordStrength.medium;
    if (score <= 7) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  /// Check for weak passwords
  static bool isWeakPassword(String password) {
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
  static bool hasRepeatingCharacters(String password) {
    return RegExp(r'(.)\1{2,}').hasMatch(password);
  }

  /// Check for sequential characters
  static bool hasSequentialCharacters(String password) {
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
