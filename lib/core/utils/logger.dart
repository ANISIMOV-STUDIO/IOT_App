/// Logger Utility
///
/// Centralized logging with security event tracking
library;

import 'package:flutter/foundation.dart';
import '../constants/security_constants.dart';

class Logger {
  // Prevent instantiation
  Logger._();

  static const String _tag = 'HVAC_Control';
  static bool _enableLogging = kDebugMode;

  /// Enable or disable logging
  static void setLoggingEnabled(bool enabled) {
    _enableLogging = enabled;
  }

  /// Log debug message
  static void debug(String message, {String? tag}) {
    if (_enableLogging) {
      debugPrint('${_timestamp()} [DEBUG] ${tag ?? _tag}: $message');
    }
  }

  /// Log info message
  static void info(String message, {String? tag}) {
    if (_enableLogging) {
      debugPrint('${_timestamp()} [INFO] ${tag ?? _tag}: $message');
    }
  }

  /// Log warning message
  static void warning(String message, {String? tag}) {
    if (_enableLogging) {
      debugPrint('${_timestamp()} [WARNING] ${tag ?? _tag}: $message');
    }
  }

  /// Log error message
  static void error(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    if (_enableLogging) {
      debugPrint('${_timestamp()} [ERROR] ${tag ?? _tag}: $message');
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }

  /// Log security event
  static void security(String event, {Map<String, dynamic>? details}) {
    if (!SecurityConstants.securityEvents.contains(event)) {
      warning('Unknown security event: $event');
    }

    final logMessage = StringBuffer();
    logMessage.write('${_timestamp()} [SECURITY] $event');

    if (details != null && details.isNotEmpty) {
      logMessage.write(' - Details: ${_sanitizeDetails(details)}');
    }

    if (_enableLogging) {
      debugPrint(logMessage.toString());
    }

    // In production, send to security monitoring service
    _sendToSecurityMonitoring(event, details);
  }

  /// Log network request
  static void network({
    required String method,
    required String url,
    int? statusCode,
    Map<String, dynamic>? headers,
    dynamic body,
    dynamic response,
    Object? error,
  }) {
    if (!_enableLogging) return;

    final logMessage = StringBuffer();
    logMessage.writeln('${_timestamp()} [NETWORK] $method $url');

    if (statusCode != null) {
      logMessage.writeln('  Status: $statusCode');
    }

    if (headers != null && kDebugMode) {
      // Only log headers in debug mode, exclude sensitive headers
      final safeHeaders = Map<String, dynamic>.from(headers);
      safeHeaders.remove('Authorization');
      safeHeaders.remove('Cookie');
      safeHeaders.remove('X-API-Key');
      logMessage.writeln('  Headers: $safeHeaders');
    }

    if (body != null && kDebugMode) {
      // Sanitize body to remove sensitive data
      logMessage.writeln('  Body: ${_sanitizeData(body)}');
    }

    if (response != null && kDebugMode) {
      logMessage.writeln('  Response: ${_sanitizeData(response)}');
    }

    if (error != null) {
      logMessage.writeln('  Error: $error');
    }

    debugPrint(logMessage.toString());
  }

  /// Get formatted timestamp
  static String _timestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';
  }

  /// Sanitize sensitive data from logs
  static dynamic _sanitizeData(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      return _sanitizeDetails(data);
    }

    if (data is String) {
      // Check if it looks like sensitive data
      if (data.length > 20 && _looksLikeSensitiveData(data)) {
        return '[REDACTED]';
      }
      return data.length > 500 ? '${data.substring(0, 500)}...' : data;
    }

    return data.toString();
  }

  /// Sanitize details map
  static Map<String, dynamic> _sanitizeDetails(Map<dynamic, dynamic> details) {
    final sanitized = <String, dynamic>{};

    for (final entry in details.entries) {
      final key = entry.key.toString();
      var value = entry.value;

      // Redact sensitive fields
      if (_isSensitiveField(key)) {
        value = '[REDACTED]';
      } else if (value is Map) {
        value = _sanitizeDetails(value);
      } else if (value is String && _looksLikeSensitiveData(value)) {
        value = '[REDACTED]';
      }

      sanitized[key] = value;
    }

    return sanitized;
  }

  /// Check if field name indicates sensitive data
  static bool _isSensitiveField(String fieldName) {
    final sensitiveFields = [
      'password',
      'passwd',
      'pwd',
      'secret',
      'token',
      'api_key',
      'apikey',
      'auth',
      'authorization',
      'credit_card',
      'creditcard',
      'cc_number',
      'cvv',
      'ssn',
      'social_security',
      'pin',
      'private_key',
      'refresh_token',
      'access_token',
      'bearer',
    ];

    final lowerField = fieldName.toLowerCase();
    return sensitiveFields.any((field) => lowerField.contains(field));
  }

  /// Check if string looks like sensitive data
  static bool _looksLikeSensitiveData(String value) {
    // Check for JWT tokens
    if (value.startsWith('eyJ') && value.contains('.')) {
      return true;
    }

    // Check for API keys (usually long alphanumeric strings)
    if (value.length > 30 && RegExp(r'^[a-zA-Z0-9\-_]+$').hasMatch(value)) {
      return true;
    }

    // Check for credit card patterns
    if (RegExp(r'^\d{13,19}$').hasMatch(value.replaceAll(' ', ''))) {
      return true;
    }

    return false;
  }

  /// Send security events to monitoring service
  static void _sendToSecurityMonitoring(
      String event, Map<String, dynamic>? details) {
    // In production, implement actual security monitoring
    // This could send to services like Sentry, DataDog, or custom monitoring
    if (!kDebugMode) {
      // TODO: Implement production security monitoring
      // Example: SecurityMonitoringService.logEvent(event, details);
    }
  }
}
