/// Text Validator
///
/// Validation for names, alphanumeric text, and general text inputs
library;

import '../../constants/security_constants.dart';
import 'security_helpers.dart';

class TextValidator {
  // Prevent instantiation
  TextValidator._();

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
    if (containsSQLInjection(value)) {
      return 'Invalid $fieldName format';
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

  /// Sanitize input to prevent injection attacks
  static String sanitize(String input) {
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
}
