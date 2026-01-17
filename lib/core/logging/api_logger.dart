/// API-specific logging utilities
library;

import 'package:talker_flutter/talker_flutter.dart';
import 'talker_config.dart';

class ApiLogger {
  static final Talker _talker = TalkerConfig.talker;

  // gRPC logging
  static void logGrpcRequest(String service, String method, dynamic request) {
    if (!TalkerConfig.canLog(AppLogLevel.info)) return;
    _talker.info(
      '🔵 [gRPC Request] $service.$method\n'
      'Request: ${_truncate(request.toString())}',
    );
  }

  static void logGrpcResponse(
      String service, String method, dynamic response) {
    if (!TalkerConfig.canLog(AppLogLevel.info)) return;
    _talker.info(
      '✅ [gRPC Response] $service.$method\n'
      'Response: ${_truncate(response.toString())}',
    );
  }

  static void logGrpcError(String service, String method, dynamic error) {
    if (!TalkerConfig.canLog(AppLogLevel.error)) return;
    _talker.error(
      '❌ [gRPC Error] $service.$method\n'
      'Error: $error',
    );
  }

  // HTTP logging
  static void logHttpRequest(String method, String url, dynamic body) {
    if (!TalkerConfig.canLog(AppLogLevel.info)) return;
    final bodyStr = body?.toString() ?? 'null';
    _talker.info(
      '🌐 [HTTP Request] $method $url\n'
      'Body: ${_maskSensitiveData(_truncate(bodyStr))}',
    );
  }

  static void logHttpResponse(
      String method, String url, int statusCode, dynamic body) {
    if (!TalkerConfig.canLog(AppLogLevel.info)) return;
    final bodyStr = body?.toString() ?? 'null';
    _talker.info(
      '✅ [HTTP Response] $method $url\n'
      'Status: $statusCode\n'
      'Body: ${_maskSensitiveData(_truncate(bodyStr))}',
    );
  }

  static void logHttpError(String method, String url, dynamic error) {
    if (!TalkerConfig.canLog(AppLogLevel.error)) return;
    _talker.error(
      '❌ [HTTP Error] $method $url\n'
      'Error: $error',
    );
  }

  // WebSocket logging
  static void logWebSocketConnect(String url) {
    if (!TalkerConfig.canLog(AppLogLevel.info)) return;
    _talker.info('🔌 [WebSocket] Connecting to $url');
  }

  static void logWebSocketMessage(String event, dynamic data) {
    if (!TalkerConfig.canLog(AppLogLevel.verbose)) return;
    _talker.debug(
      '📨 [WebSocket] Event: $event\n'
      'Data: ${_truncate(data?.toString() ?? 'null')}',
    );
  }

  static void logWebSocketError(dynamic error) {
    if (!TalkerConfig.canLog(AppLogLevel.error)) return;
    _talker.error('❌ [WebSocket Error] $error');
  }

  // Stream logging
  static void logStreamStart(String name) {
    if (!TalkerConfig.canLog(AppLogLevel.info)) return;
    _talker.info('📡 [Stream] Started: $name');
  }

  static void logStreamData(String name, dynamic data) {
    if (!TalkerConfig.canLog(AppLogLevel.verbose)) return;
    _talker.debug('📊 [Stream] $name: ${_truncate(data.toString())}');
  }

  static void logStreamError(String name, dynamic error) {
    if (!TalkerConfig.canLog(AppLogLevel.error)) return;
    _talker.error('❌ [Stream Error] $name: $error');
  }

  static void logStreamClose(String name) {
    if (!TalkerConfig.canLog(AppLogLevel.warning)) return;
    _talker.warning('🔴 [Stream] Closed: $name');
  }

  // General purpose logging
  static void debug(String message, [Object? error]) {
    if (!TalkerConfig.canLog(AppLogLevel.verbose)) return;
    _talker.debug(message);
    if (error != null) {
      _talker.debug('Details: $error');
    }
  }

  static void info(String message) {
    if (!TalkerConfig.canLog(AppLogLevel.info)) return;
    _talker.info(message);
  }

  static void warning(String message, [Object? error]) {
    if (!TalkerConfig.canLog(AppLogLevel.warning)) return;
    _talker.warning(message);
    if (error != null) {
      _talker.warning('Details: $error');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (!TalkerConfig.canLog(AppLogLevel.error)) return;
    _talker.error(message, error, stackTrace);
  }

  // Utility
  static String _truncate(String text, [int maxLength = 500]) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}... (truncated)';
  }

  /// Маскирует чувствительные данные (токены, пароли, email)
  static String _maskSensitiveData(String text) {
    var masked = text;

    // Маскировка JWT токенов (Bearer eyJhbGc...)
    masked = masked.replaceAllMapped(
      RegExp(r'(Bearer\s+|token["\s:]+)([A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+)'),
      (match) => '${match.group(1)}***MASKED_JWT***',
    );

    // Маскировка паролей в JSON
    masked = masked.replaceAllMapped(
      RegExp(r'"password"\s*:\s*"([^"]+)"', caseSensitive: false),
      (match) => '"password": "***MASKED***"',
    );

    // Маскировка refresh tokens
    masked = masked.replaceAllMapped(
      RegExp(r'"refreshToken"\s*:\s*"([^"]+)"', caseSensitive: false),
      (match) => '"refreshToken": "***MASKED***"',
    );

    // Частичная маскировка email (оставить первые 3 символа)
    masked = masked.replaceAllMapped(
      RegExp(r'"email"\s*:\s*"([a-zA-Z0-9._%+-]{3})[a-zA-Z0-9._%+-]*@([^"]+)"'),
      (match) => '"email": "${match.group(1)}***@${match.group(2)}"',
    );

    return masked;
  }
}
