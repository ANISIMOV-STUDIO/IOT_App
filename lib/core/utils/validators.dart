/// Simplified validators for form fields
///
/// Uses form_builder_validators library for standard validations
/// while maintaining backward compatibility with existing API

import 'package:form_builder_validators/form_builder_validators.dart';

class Validators {
  Validators._();

  /// Validate email format
  static String? validateEmail(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Email is required'),
      FormBuilderValidators.email(errorText: 'Please enter a valid email'),
    ])(value);
  }

  /// Validate password
  static String? validatePassword(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Password is required'),
      FormBuilderValidators.minLength(
        8,
        errorText: 'Password must be at least 8 characters',
      ),
    ])(value);
  }

  /// Validate name
  static String? validateName(String? value, {String fieldName = 'Name'}) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: '$fieldName is required'),
      (val) {
        if (val == null) return null;
        final str = val.toString();
        if (str.trim().isEmpty) {
          return '$fieldName is required';
        }
        if (str.trim().length < 2) {
          return '$fieldName must be at least 2 characters';
        }
        return null;
      },
    ])(value);
  }

  /// Validate password confirmation
  /// Custom validator - compares password with confirmation
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Calculate password strength (alias for checkPasswordStrength)
  static PasswordStrength calculatePasswordStrength(String password) {
    return checkPasswordStrength(password);
  }

  /// Check password strength
  /// Custom logic for password strength calculation
  static PasswordStrength checkPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }
}

/// Password strength levels
enum PasswordStrength { weak, medium, strong, veryStrong }
