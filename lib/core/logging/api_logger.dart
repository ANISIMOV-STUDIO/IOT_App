/// API-specific logging utilities
library;

import 'package:talker_flutter/talker_flutter.dart';
import 'talker_config.dart';

class ApiLogger {
  static final Talker _talker = TalkerConfig.talker;

  // gRPC logging
  static void logGrpcRequest(String service, String method, dynamic request) {
    _talker.info(
      '🔵 [gRPC Request] $service.$method\n'
      'Request: ${_truncate(request.toString())}',
    );
  }

  static void logGrpcResponse(
      String service, String method, dynamic response) {
    _talker.info(
      '✅ [gRPC Response] $service.$method\n'
      'Response: ${_truncate(response.toString())}',
    );
  }

  static void logGrpcError(String service, String method, dynamic error) {
    _talker.error(
      '❌ [gRPC Error] $service.$method\n'
      'Error: $error',
    );
  }

  // HTTP logging
  static void logHttpRequest(String method, String url, dynamic body) {
    _talker.info(
      '🌐 [HTTP Request] $method $url\n'
      'Body: ${_truncate(body?.toString() ?? 'null')}',
    );
  }

  static void logHttpResponse(
      String method, String url, int statusCode, dynamic body) {
    _talker.info(
      '✅ [HTTP Response] $method $url\n'
      'Status: $statusCode\n'
      'Body: ${_truncate(body?.toString() ?? 'null')}',
    );
  }

  static void logHttpError(String method, String url, dynamic error) {
    _talker.error(
      '❌ [HTTP Error] $method $url\n'
      'Error: $error',
    );
  }

  // WebSocket logging
  static void logWebSocketConnect(String url) {
    _talker.info('🔌 [WebSocket] Connecting to $url');
  }

  static void logWebSocketMessage(String event, dynamic data) {
    _talker.debug(
      '📨 [WebSocket] Event: $event\n'
      'Data: ${_truncate(data?.toString() ?? 'null')}',
    );
  }

  static void logWebSocketError(dynamic error) {
    _talker.error('❌ [WebSocket Error] $error');
  }

  // Stream logging
  static void logStreamStart(String name) {
    _talker.info('📡 [Stream] Started: $name');
  }

  static void logStreamData(String name, dynamic data) {
    _talker.debug('📊 [Stream] $name: ${_truncate(data.toString())}');
  }

  static void logStreamError(String name, dynamic error) {
    _talker.error('❌ [Stream Error] $name: $error');
  }

  static void logStreamClose(String name) {
    _talker.warning('🔴 [Stream] Closed: $name');
  }

  // Utility
  static String _truncate(String text, [int maxLength = 500]) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}... (truncated)';
  }
}
