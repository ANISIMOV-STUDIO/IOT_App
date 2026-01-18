/// Unified API exceptions
library;

enum ApiErrorType {
  network,
  timeout,
  authentication,
  authorization,
  notFound,
  conflict,
  serverError,
  validation,
  unknown,
}

class ApiException implements Exception {

  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
    this.originalError,
  });
  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final dynamic originalError;

  @override
  String toString() => 'ApiException($type): $message';
}
