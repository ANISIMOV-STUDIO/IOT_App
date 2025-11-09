/// Email Validator
///
/// Email address validation with security checks
library;

import '../../constants/security_constants.dart';
import 'security_helpers.dart';

class EmailValidator {
  // Prevent instantiation
  EmailValidator._();

  /// Validate email address
  static String? validate(String? value) {
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
    if (containsSuspiciousPatterns(value)) {
      return 'Invalid email format';
    }

    return null;
  }
}
