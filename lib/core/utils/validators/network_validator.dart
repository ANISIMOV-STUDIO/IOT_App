/// Network Validator
///
/// Validation for network-related inputs: phone, URL, IP, SSID, WiFi
library;

import '../../constants/security_constants.dart';

class NetworkValidator {
  // Prevent instantiation
  NetworkValidator._();

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

    // URL pattern
    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.'
      r'[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)$',
    );

    if (!urlPattern.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validate IP address (IPv4 or IPv6)
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
}
