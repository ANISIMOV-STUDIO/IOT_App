/// Security interceptor for Dio
library;

import 'package:dio/dio.dart';
import '../token_manager.dart';
import '../request_signer.dart';
import '../rate_limiter.dart';

class SecurityInterceptor extends Interceptor {
  final TokenManager tokenManager;
  final RequestSigner requestSigner;
  final RateLimiter rateLimiter;
  final Future<void> Function()? onTokenRefresh;

  SecurityInterceptor({
    required this.tokenManager,
    required this.requestSigner,
    required this.rateLimiter,
    this.onTokenRefresh,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check rate limit
    try {
      rateLimiter.checkRateLimit(options.path);
    } catch (e) {
      handler.reject(DioException(
        requestOptions: options,
        error: e,
        type: DioExceptionType.cancel,
      ));
      return;
    }

    // Add auth token if available
    if (tokenManager.authToken != null) {
      // Check if token needs refresh
      if (tokenManager.needsTokenRefresh() && onTokenRefresh != null) {
        try {
          await onTokenRefresh!();
        } catch (e) {
          // Continue without token if refresh fails
        }
      }

      if (tokenManager.authToken != null) {
        options.headers['Authorization'] = 'Bearer ${tokenManager.authToken}';
      }
    }

    // Sign request
    final signature = requestSigner.signRequest(
      options.method,
      options.path,
      options.data as Map<String, dynamic>?,
    );
    options.headers['X-Request-Signature'] = signature;
    options.headers['X-Request-Timestamp'] =
        DateTime.now().millisecondsSinceEpoch.toString();
    options.headers['X-Request-Nonce'] = requestSigner.generateNonce();

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Validate response signature if present
    final signature = response.headers.value('X-Response-Signature');
    if (signature != null) {
      final isValid = requestSigner.validateResponseSignature(
        signature,
        response.data.toString(),
        '', // API secret should be passed here
      );

      if (!isValid) {
        handler.reject(DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Invalid response signature',
          type: DioExceptionType.badResponse,
        ));
        return;
      }
    }

    handler.next(response);
  }
}