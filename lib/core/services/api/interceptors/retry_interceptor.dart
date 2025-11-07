/// Retry interceptor for handling transient failures
library;

import 'package:dio/dio.dart';
import '../../../utils/logger.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if request should be retried
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < maxRetries) {
        Logger.info(
          'Retrying request (${retryCount + 1}/$maxRetries): ${err.requestOptions.uri}',
        );

        // Add retry count to request options
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        // Wait with exponential backoff
        final delay = retryDelay * (retryCount + 1);
        await Future.delayed(delay);

        try {
          // Retry the request
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // If retry fails, continue with error handling
          if (e is DioException) {
            err = e;
          }
        }
      }
    }

    handler.next(err);
  }

  /// Determine if a request should be retried
  bool _shouldRetry(DioException err) {
    // Retry on network errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on specific status codes
    if (err.response != null) {
      final statusCode = err.response!.statusCode;
      // Retry on 5xx errors (server errors) and specific 4xx errors
      if (statusCode != null) {
        return statusCode >= 500 || statusCode == 408 || statusCode == 429;
      }
    }

    return false;
  }
}
