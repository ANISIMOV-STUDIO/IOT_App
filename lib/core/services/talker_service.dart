/// Talker Service
///
/// Centralized logging service using Talker library
library;

import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';
import '../constants/security_constants.dart';

/// Global TalkerService instance for custom methods (security, etc.)
final talkerService = TalkerService.instance;

/// Global Talker instance for use with TalkerScreen, TalkerDioLogger, etc.
final talker = TalkerService.instance.talkerInstance;

/// Talker Service Singleton
class TalkerService {
  TalkerService._internal() {
    _talker = Talker(
      settings: TalkerSettings(
        enabled: kDebugMode,
        useConsoleLogs: kDebugMode,
        maxHistoryItems: 1000,
      ),
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(
          enableColors: true,
          lineSymbol: '│',
        ),
      ),
    );
  }

  static final TalkerService instance = TalkerService._internal();

  late final Talker _talker;

  /// Get the Talker instance
  Talker get talkerInstance => _talker;

  /// Enable or disable logging
  void setLoggingEnabled(bool enabled) {
    _talker.configure(
      settings: _talker.settings.copyWith(enabled: enabled),
    );
  }

  /// Log debug message
  void debug(String message, {String? tag}) {
    final logMessage = tag != null ? '[$tag] $message' : message;
    _talker.debug(logMessage);
  }

  /// Log info message
  void info(String message, {String? tag}) {
    final logMessage = tag != null ? '[$tag] $message' : message;
    _talker.info(logMessage);
  }

  /// Log warning message
  void warning(String message, {String? tag}) {
    final logMessage = tag != null ? '[$tag] $message' : message;
    _talker.warning(logMessage);
  }

  /// Log error message
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logMessage = tag != null ? '[$tag] $message' : message;
    _talker.error(logMessage, error, stackTrace);
  }

  /// Log security event
  void security(String event, {Map<String, dynamic>? details}) {
    if (!SecurityConstants.securityEvents.contains(event)) {
      warning('Unknown security event: $event');
    }

    _talker.logCustom(
      SecurityTalkerLog(
        event: event,
        details: details,
      ),
    );

    // In production, send to security monitoring service
    _sendToSecurityMonitoring(event, details);
  }

  /// Send security events to monitoring service
  void _sendToSecurityMonitoring(
      String event, Map<String, dynamic>? details) {
    // In production, implement actual security monitoring
    // This could send to services like Sentry, DataDog, or custom monitoring
    if (!kDebugMode) {
      // TODO: Implement production security monitoring
      // Example: SecurityMonitoringService.logEvent(event, details);
    }
  }

  /// Log network request (deprecated - use TalkerDioLogger instead)
  @Deprecated('Use TalkerDioLogger interceptor instead')
  void network({
    required String method,
    required String url,
    int? statusCode,
    Map<String, dynamic>? headers,
    dynamic body,
    dynamic response,
    Object? error,
  }) {
    final message = StringBuffer();
    message.write('$method $url');
    if (statusCode != null) {
      message.write(' - Status: $statusCode');
    }
    if (error != null) {
      _talker.error(message.toString(), error);
    } else {
      _talker.info(message.toString());
    }
  }
}

/// Custom Security Talker Log
class SecurityTalkerLog extends TalkerLog {
  SecurityTalkerLog({
    required this.event,
    this.details,
  }) : super(_formatMessage(event, details));

  final String event;
  final Map<String, dynamic>? details;

  static String _formatMessage(String event, Map<String, dynamic>? details) {
    final message = StringBuffer();
    message.write('SECURITY: $event');
    if (details != null && details.isNotEmpty) {
      message.write(' - Details: ${_sanitizeDetails(details)}');
    }
    return message.toString();
  }

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

  @override
  String get title => 'security';

  @override
  AnsiPen get pen => AnsiPen()..red();

  @override
  String generateTextMessage({TimeFormat? timeFormat}) {
    return displayMessage;
  }
}

/// Extension for easy security logging on Talker instance
extension SecurityTalker on Talker {
  void security(String event, {Map<String, dynamic>? details}) {
    talkerService.security(event, details: details);
  }
}
