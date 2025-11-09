/// Input Validators - Barrel File
///
/// Comprehensive input validation utilities with security focus
///
/// This file provides backward compatibility while the implementation
/// has been modularized into separate files for better maintainability.
library;

import 'validators/email_validator.dart';
import 'validators/password_validator.dart';
import 'validators/text_validator.dart';
import 'validators/network_validator.dart';
import 'validators/device_validator.dart';
import '../constants/security_constants.dart';

// Export all validator modules for external use
export 'validators/email_validator.dart' show EmailValidator;
export 'validators/password_validator.dart' show PasswordValidator;
export 'validators/text_validator.dart' show TextValidator;
export 'validators/network_validator.dart' show NetworkValidator;
export 'validators/device_validator.dart' show DeviceValidator;
export 'validators/security_helpers.dart';

// Re-export PasswordStrength from security_constants for backward compatibility
export '../constants/security_constants.dart' show PasswordStrength;

/// Main Validators class for backward compatibility
///
/// All methods delegate to specialized validator classes
class Validators {
  // Prevent instantiation
  Validators._();

  // ============================================================================
  // EMAIL VALIDATION
  // ============================================================================

  /// Validate email address
  static String? validateEmail(String? value) =>
      EmailValidator.validate(value);

  // ============================================================================
  // PASSWORD VALIDATION
  // ============================================================================

  /// Validate password with strength requirements
  static String? validatePassword(String? value) =>
      PasswordValidator.validate(value);

  /// Validate password confirmation
  static String? validatePasswordConfirmation(String? value, String? password) =>
      PasswordValidator.validateConfirmation(value, password);

  /// Calculate password strength
  static PasswordStrength calculatePasswordStrength(String password) =>
      PasswordValidator.calculateStrength(password);

  // ============================================================================
  // TEXT VALIDATION
  // ============================================================================

  /// Validate name (first or last)
  static String? validateName(String? value, {String fieldName = 'Name'}) =>
      TextValidator.validateName(value, fieldName: fieldName);

  /// Validate alphanumeric input
  static String? validateAlphanumeric(
    String? value, {
    String fieldName = 'Value',
    int? minLength,
    int? maxLength,
  }) =>
      TextValidator.validateAlphanumeric(
        value,
        fieldName: fieldName,
        minLength: minLength,
        maxLength: maxLength,
      );

  /// Sanitize input to prevent injection attacks
  static String sanitizeInput(String input) => TextValidator.sanitize(input);

  // ============================================================================
  // NETWORK VALIDATION
  // ============================================================================

  /// Validate phone number
  static String? validatePhone(String? value) =>
      NetworkValidator.validatePhone(value);

  /// Validate URL
  static String? validateUrl(String? value) =>
      NetworkValidator.validateUrl(value);

  /// Validate IP address (IPv4 or IPv6)
  static String? validateIpAddress(String? value) =>
      NetworkValidator.validateIpAddress(value);

  /// Validate WiFi SSID
  static String? validateSSID(String? value) =>
      NetworkValidator.validateSSID(value);

  /// Validate WiFi password
  static String? validateWiFiPassword(String? value, String securityType) =>
      NetworkValidator.validateWiFiPassword(value, securityType);

  // ============================================================================
  // DEVICE VALIDATION
  // ============================================================================

  /// Validate device ID
  static String? validateDeviceId(String? value) =>
      DeviceValidator.validateDeviceId(value);

  /// Validate temperature input
  static String? validateTemperature(
    String? value, {
    double min = -50,
    double max = 100,
    String unit = '°C',
  }) =>
      DeviceValidator.validateTemperature(
        value,
        min: min,
        max: max,
        unit: unit,
      );

  /// Validate numeric input
  static String? validateNumber(
    String? value, {
    String fieldName = 'Value',
    double? min,
    double? max,
    bool allowDecimal = true,
  }) =>
      DeviceValidator.validateNumber(
        value,
        fieldName: fieldName,
        min: min,
        max: max,
        allowDecimal: allowDecimal,
      );

}
