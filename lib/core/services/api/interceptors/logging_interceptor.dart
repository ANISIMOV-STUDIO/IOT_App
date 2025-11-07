/// Logging interceptor for API requests and responses
library;

import 'package:dio/dio.dart';
import '../../../utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger.debug('''
API Request:
  Method: ${options.method}
  URL: ${options.uri}
  Headers: ${_sanitizeHeaders(options.headers)}
  Data: ${_sanitizeData(options.data)}
''');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.debug('''
API Response:
  Status: ${response.statusCode}
  URL: ${response.requestOptions.uri}
  Data: ${_truncateResponse(response.data)}
''');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.error('''
API Error:
  Type: ${err.type}
  Message: ${err.message}
  URL: ${err.requestOptions.uri}
  Response: ${err.response?.data}
''');
    handler.next(err);
  }

  /// Sanitize headers to remove sensitive information
  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);

    // Hide authorization tokens
    if (sanitized.containsKey('Authorization')) {
      sanitized['Authorization'] = '***HIDDEN***';
    }
    if (sanitized.containsKey('X-Request-Signature')) {
      sanitized['X-Request-Signature'] = '***HIDDEN***';
    }

    return sanitized;
  }

  /// Sanitize request data
  dynamic _sanitizeData(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      final sanitized = Map<String, dynamic>.from(data);

      // Hide sensitive fields
      const sensitiveFields = ['password', 'token', 'secret', 'apiKey'];
      for (final field in sensitiveFields) {
        if (sanitized.containsKey(field)) {
          sanitized[field] = '***HIDDEN***';
        }
      }

      return sanitized;
    }

    return data;
  }

  /// Truncate long responses
  String _truncateResponse(dynamic data) {
    final str = data.toString();
    const maxLength = 500;

    if (str.length > maxLength) {
      return '${str.substring(0, maxLength)}...[TRUNCATED]';
    }

    return str;
  }
}