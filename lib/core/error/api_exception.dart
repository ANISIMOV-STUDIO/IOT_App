/// Unified API exceptions
library;

enum ApiErrorType {
  network,
  timeout,
  authentication,
  authorization,
  notFound,
  serverError,
  validation,
  unknown,
}

class ApiException implements Exception {
  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ApiException($type): $message';
}
