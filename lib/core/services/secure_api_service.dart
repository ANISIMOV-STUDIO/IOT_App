/// Secure API Service - Refactored version
///
/// Enhanced API service with modular architecture
library;

import 'dart:io';
import 'package:dio/dio.dart';

import '../constants/security_constants.dart';
import '../utils/logger.dart';
import 'secure_storage_service.dart' hide SecurityException;
import 'environment_config.dart';
import 'api/token_manager.dart';
import 'api/rate_limiter.dart';
import 'api/request_signer.dart';
import 'api/interceptors/security_interceptor.dart';
import 'api/interceptors/logging_interceptor.dart';
import 'api/interceptors/retry_interceptor.dart';
import 'api/exceptions.dart';

export 'api/exceptions.dart';

class SecureApiService {
  late final Dio _dio;
  late final TokenManager _tokenManager;
  late final RateLimiter _rateLimiter;
  late final RequestSigner _requestSigner;

  final SecureStorageService _secureStorage;
  final EnvironmentConfig _envConfig;

  SecureApiService({
    required SecureStorageService secureStorage,
    required EnvironmentConfig envConfig,
  })  : _secureStorage = secureStorage,
        _envConfig = envConfig {
    _initializeServices();
    _initializeDio();
    _loadStoredTokens();
  }

  /// Initialize internal services
  void _initializeServices() {
    _tokenManager = TokenManager(secureStorage: _secureStorage);
    _rateLimiter = RateLimiter();
    _requestSigner = RequestSigner(apiSecret: _envConfig.apiSecret);
  }

  /// Initialize Dio with security configurations
  void _initializeDio() {
    final baseOptions = BaseOptions(
      baseUrl: _envConfig.apiBaseUrl,
      connectTimeout:
          const Duration(seconds: SecurityConstants.apiTimeoutSeconds),
      receiveTimeout:
          const Duration(seconds: SecurityConstants.apiTimeoutSeconds),
      sendTimeout: const Duration(seconds: SecurityConstants.apiTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-App-Version': _envConfig.appVersion,
        'X-Platform': Platform.operatingSystem,
        ...SecurityConstants.securityHeaders,
      },
    );

    _dio = Dio(baseOptions);

    // Add interceptors
    _dio.interceptors.addAll([
      SecurityInterceptor(
        tokenManager: _tokenManager,
        requestSigner: _requestSigner,
        rateLimiter: _rateLimiter,
        onTokenRefresh: _refreshAuthToken,
      ),
      LoggingInterceptor(),
      RetryInterceptor(dio: _dio),
    ]);
  }

  /// Load stored tokens on initialization
  Future<void> _loadStoredTokens() async {
    await _tokenManager.loadStoredTokens();
  }

  /// Refresh authentication token
  Future<void> _refreshAuthToken() async {
    if (_tokenManager.refreshToken == null) {
      throw const SecurityException('No refresh token available');
    }

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': _tokenManager.refreshToken},
      );

      final newAuthToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      await _tokenManager.updateTokens(newAuthToken, newRefreshToken);
      Logger.security('TOKEN_REFRESH', details: {'success': true});
    } catch (e) {
      Logger.security('TOKEN_REFRESH',
          details: {'success': false, 'error': e.toString()});
      throw const SecurityException('Failed to refresh token');
    }
  }

  // ===== PUBLIC API METHODS =====

  /// Check if user is authenticated
  bool get isAuthenticated => _tokenManager.isAuthenticated;

  /// Perform GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requireAuth = true,
  }) async {
    return _performRequest<T>(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      requireAuth: requireAuth,
    );
  }

  /// Perform POST request
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? data,
    bool requireAuth = true,
  }) async {
    return _performRequest<T>(
      method: 'POST',
      path: path,
      data: data,
      requireAuth: requireAuth,
    );
  }

  /// Perform PUT request
  Future<T> put<T>(
    String path, {
    Map<String, dynamic>? data,
    bool requireAuth = true,
  }) async {
    return _performRequest<T>(
      method: 'PUT',
      path: path,
      data: data,
      requireAuth: requireAuth,
    );
  }

  /// Perform DELETE request
  Future<T> delete<T>(
    String path, {
    bool requireAuth = true,
  }) async {
    return _performRequest<T>(
      method: 'DELETE',
      path: path,
      requireAuth: requireAuth,
    );
  }

  /// Perform PATCH request
  Future<T> patch<T>(
    String path, {
    Map<String, dynamic>? data,
    bool requireAuth = true,
  }) async {
    return _performRequest<T>(
      method: 'PATCH',
      path: path,
      data: data,
      requireAuth: requireAuth,
    );
  }

  /// Core request method with security features
  Future<T> _performRequest<T>({
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    bool requireAuth = true,
  }) async {
    try {
      final response = await _dio.request<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          method: method,
          extra: {'requireAuth': requireAuth},
        ),
      );

      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout');

      case DioExceptionType.badCertificate:
        Logger.security('CERTIFICATE_VALIDATION_FAILURE', details: {
          'url': error.requestOptions.uri.toString(),
        });
        return const SecurityException('Certificate validation failed');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Unknown error';

        if (statusCode == 401) {
          Logger.security('UNAUTHORIZED_ACCESS', details: {
            'path': error.requestOptions.path,
          });
          return const AuthException('Unauthorized access');
        }

        if (statusCode == 403) {
          return const AuthException('Forbidden');
        }

        if (statusCode == 429) {
          return const RateLimitException('Too many requests');
        }

        return ApiException('$message (Status: $statusCode)');

      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');

      case DioExceptionType.connectionError:
        return const NetworkException('Connection error');

      case DioExceptionType.unknown:
        return const NetworkException('Unknown network error');
    }
  }

  // ===== AUTHENTICATION METHODS =====

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'device_info': await _getDeviceInfo(),
        },
        requireAuth: false,
      );

      final authToken = response['access_token'];
      final refreshToken = response['refresh_token'];

      await _tokenManager.updateTokens(authToken, refreshToken);

      Logger.security('LOGIN_SUCCESS', details: {'email': email});
      return response;
    } catch (e) {
      Logger.security('LOGIN_FAILURE',
          details: {'email': email, 'error': e.toString()});
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      if (_tokenManager.authToken != null) {
        await post('/auth/logout', requireAuth: true);
      }
    } finally {
      await _tokenManager.clearTokens();
      Logger.security('LOGOUT');
    }
  }

  /// Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    return await get<Map<String, dynamic>>('/auth/me');
  }

  /// Get device information for security tracking
  Future<Map<String, String>> _getDeviceInfo() async {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.version,
      'locale': Platform.localeName,
      'hostname': Platform.localHostname,
    };
  }
}
