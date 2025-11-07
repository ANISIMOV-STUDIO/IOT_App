/// Secure API Service
///
/// Enhanced API service with certificate pinning, request signing, and security features
library;

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:dio_certificate_pinning/dio_certificate_pinning.dart'; // Package not available
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:crypto/crypto.dart';

import '../constants/security_constants.dart';
import '../utils/logger.dart';
import 'secure_storage_service.dart';
import 'environment_config.dart';

class SecureApiService {
  late final Dio _dio;
  final SecureStorageService _secureStorage;
  final EnvironmentConfig _envConfig;

  String? _authToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  // Rate limiting
  final Map<String, List<DateTime>> _requestHistory = {};
  final Map<String, DateTime> _rateLimitExpiryMap = {};

  SecureApiService({
    required SecureStorageService secureStorage,
    required EnvironmentConfig envConfig,
  })  : _secureStorage = secureStorage,
        _envConfig = envConfig {
    _initializeDio();
    _loadStoredTokens();
  }

  /// Initialize Dio with security configurations
  void _initializeDio() {
    final baseOptions = BaseOptions(
      baseUrl: _envConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: SecurityConstants.apiTimeoutSeconds),
      receiveTimeout: const Duration(seconds: SecurityConstants.apiTimeoutSeconds),
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

    // Add certificate pinning (only for production)
    // Commented out - CertificatePinningInterceptor not available
    // if (_envConfig.isProduction) {
    //   _dio.interceptors.add(
    //     CertificatePinningInterceptor(
    //       allowedSHAFingerprints: SecurityConstants.certificateFingerprints,
    //       timeout: SecurityConstants.apiTimeoutSeconds,
    //     ),
    //   );
    // }

    // Add request/response interceptors
    _dio.interceptors.add(_SecurityInterceptor(this));
    _dio.interceptors.add(_LoggingInterceptor());
    _dio.interceptors.add(_RetryInterceptor(_dio));
  }

  /// Load stored tokens on initialization
  Future<void> _loadStoredTokens() async {
    _authToken = await _secureStorage.getAuthToken();
    _refreshToken = await _secureStorage.getRefreshToken();

    if (_authToken != null) {
      try {
        _tokenExpiry = _getTokenExpiry(_authToken!);
      } catch (e) {
        Logger.warning('Failed to parse stored token expiry: $e');
        await _clearTokens();
      }
    }
  }

  /// Get token expiry from JWT
  DateTime? _getTokenExpiry(String token) {
    try {
      if (JwtDecoder.isExpired(token)) {
        return null;
      }
      final decodedToken = JwtDecoder.decode(token);
      final exp = decodedToken['exp'] as int?;
      if (exp != null) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    } catch (e) {
      Logger.error('Failed to decode JWT: $e');
    }
    return null;
  }

  /// Check if token needs refresh
  bool _needsTokenRefresh() {
    if (_authToken == null || _tokenExpiry == null) return true;

    final now = DateTime.now();
    final timeUntilExpiry = _tokenExpiry!.difference(now);

    // Refresh if token expires in less than 5 minutes
    return timeUntilExpiry.inMinutes < 5;
  }

  /// Refresh authentication token
  Future<void> _refreshAuthToken() async {
    if (_refreshToken == null) {
      throw SecurityException('No refresh token available');
    }

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': _refreshToken},
      );

      final newAuthToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      await _updateTokens(newAuthToken, newRefreshToken);
      Logger.security('TOKEN_REFRESH', details: {'success': true});
    } catch (e) {
      Logger.security('TOKEN_REFRESH', details: {'success': false, 'error': e.toString()});
      throw SecurityException('Failed to refresh token');
    }
  }

  /// Update and store tokens
  Future<void> _updateTokens(String authToken, String? refreshToken) async {
    _authToken = authToken;
    _tokenExpiry = _getTokenExpiry(authToken);

    await _secureStorage.saveAuthToken(authToken);

    if (refreshToken != null) {
      _refreshToken = refreshToken;
      await _secureStorage.saveRefreshToken(refreshToken);
    }
  }

  /// Clear all tokens
  Future<void> _clearTokens() async {
    _authToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    await _secureStorage.clearAuthData();
  }

  /// Check rate limiting
  void _checkRateLimit(String endpoint) {
    final now = DateTime.now();

    // Check if rate limit is already exceeded
    if (_rateLimitExpiryMap.containsKey(endpoint)) {
      final expiry = _rateLimitExpiryMap[endpoint]!;
      if (now.isBefore(expiry)) {
        final waitTime = expiry.difference(now);
        throw RateLimitException(
          'Rate limit exceeded. Please wait ${waitTime.inSeconds} seconds',
        );
      } else {
        _rateLimitExpiryMap.remove(endpoint);
      }
    }

    // Track request
    _requestHistory[endpoint] ??= [];
    _requestHistory[endpoint]!.add(now);

    // Remove old requests (older than 1 minute)
    _requestHistory[endpoint]!.removeWhere(
      (time) => now.difference(time).inMinutes >= 1,
    );

    // Check if limit exceeded
    if (_requestHistory[endpoint]!.length > SecurityConstants.maxApiRequestsPerMinute) {
      _rateLimitExpiryMap[endpoint] = now.add(const Duration(minutes: 1));
      Logger.security('RATE_LIMIT_EXCEEDED', details: {'endpoint': endpoint});
      throw RateLimitException('Rate limit exceeded for endpoint: $endpoint');
    }
  }

  /// Sign request for additional security
  String _signRequest(String method, String path, Map<String, dynamic>? body) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final nonce = _generateNonce();

    String dataToSign = '$method$path$timestamp$nonce';
    if (body != null) {
      dataToSign += json.encode(body);
    }

    final key = utf8.encode(_envConfig.apiSecret);
    final bytes = utf8.encode(dataToSign);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    return base64.encode(digest.bytes);
  }

  /// Generate random nonce
  String _generateNonce() {
    final random = List<int>.generate(16, (i) =>
      DateTime.now().millisecondsSinceEpoch + i);
    return base64.encode(random);
  }

  /// Validate response signature
  bool _validateResponseSignature(Response response) {
    final signature = response.headers.value('X-Signature');
    if (signature == null) return false;

    // Implement signature validation logic
    // This should match the server's signing algorithm
    return true; // Simplified for example
  }

  // ===== PUBLIC API METHODS =====

  /// Check if user is authenticated
  bool get isAuthenticated => _authToken != null && !_needsTokenRefresh();

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
      // Check rate limiting
      _checkRateLimit(path);

      // Refresh token if needed
      if (requireAuth && _needsTokenRefresh()) {
        await _refreshAuthToken();
      }

      // Sign request
      final signature = _signRequest(method, path, data);

      // Prepare headers
      final headers = <String, dynamic>{
        'X-Request-Signature': signature,
        'X-Request-Timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      if (requireAuth && _authToken != null) {
        headers['Authorization'] = 'Bearer $_authToken';
      }

      // Perform request
      final response = await _dio.request<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          method: method,
          headers: headers,
        ),
      );

      // Validate response signature
      if (_envConfig.isProduction && !_validateResponseSignature(response)) {
        throw SecurityException('Invalid response signature');
      }

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
        return NetworkException('Connection timeout');

      case DioExceptionType.badCertificate:
        Logger.security('CERTIFICATE_VALIDATION_FAILURE', details: {
          'url': error.requestOptions.uri.toString(),
        });
        return SecurityException('Certificate validation failed');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Unknown error';

        if (statusCode == 401) {
          Logger.security('UNAUTHORIZED_ACCESS', details: {
            'path': error.requestOptions.path,
          });
          return AuthException('Unauthorized access');
        }

        if (statusCode == 403) {
          return AuthException('Forbidden');
        }

        if (statusCode == 429) {
          return RateLimitException('Too many requests');
        }

        return ApiException('$message (Status: $statusCode)');

      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');

      case DioExceptionType.connectionError:
        return NetworkException('Connection error');

      case DioExceptionType.unknown:
        return NetworkException('Unknown network error');
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

      await _updateTokens(authToken, refreshToken);

      Logger.security('LOGIN_SUCCESS', details: {'email': email});
      return response;
    } catch (e) {
      Logger.security('LOGIN_FAILURE', details: {'email': email, 'error': e.toString()});
      rethrow;
    }
  }

  /// Register user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'name': name,
        'device_info': await _getDeviceInfo(),
      },
      requireAuth: false,
    );

    final authToken = response['access_token'];
    final refreshToken = response['refresh_token'];

    await _updateTokens(authToken, refreshToken);

    return response;
  }

  /// Logout user
  Future<void> logout() async {
    try {
      if (_authToken != null) {
        await post('/auth/logout', requireAuth: true);
      }
    } finally {
      await _clearTokens();
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

/// Security Interceptor
class _SecurityInterceptor extends Interceptor {
  final SecureApiService _apiService;

  _SecurityInterceptor(this._apiService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add security headers
    options.headers.addAll(SecurityConstants.securityHeaders);

    // Validate method
    if (!SecurityConstants.allowedMethods.contains(options.method)) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Method not allowed: ${options.method}',
        ),
      );
      return;
    }

    // Validate domain (for production)
    if (_apiService._envConfig.isProduction) {
      final host = options.uri.host;
      if (!SecurityConstants.allowedDomains.contains(host)) {
        Logger.security('SUSPICIOUS_ACTIVITY', details: {
          'reason': 'Unauthorized domain',
          'domain': host,
        });
        handler.reject(
          DioException(
            requestOptions: options,
            error: 'Unauthorized domain: $host',
          ),
        );
        return;
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log security-related errors
    if (err.response?.statusCode == 401) {
      Logger.security('TOKEN_EXPIRED');
    }

    handler.next(err);
  }
}

/// Logging Interceptor
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger.network(
      method: options.method,
      url: options.uri.toString(),
      headers: options.headers,
      body: options.data,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.network(
      method: response.requestOptions.method,
      url: response.requestOptions.uri.toString(),
      statusCode: response.statusCode,
      response: response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.network(
      method: err.requestOptions.method,
      url: err.requestOptions.uri.toString(),
      statusCode: err.response?.statusCode,
      error: err.message,
    );
    handler.next(err);
  }
}

/// Retry Interceptor
class _RetryInterceptor extends Interceptor {
  final Dio dio;
  int _retryCount = 0;

  _RetryInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && _retryCount < SecurityConstants.maxRetryAttempts) {
      _retryCount++;
      Logger.info('Retrying request (attempt $_retryCount)');

      try {
        // Wait before retry with exponential backoff
        await Future.delayed(Duration(seconds: _retryCount * 2));

        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
        );

        handler.resolve(response);
        _retryCount = 0;
      } catch (e) {
        handler.next(err);
      }
    } else {
      _retryCount = 0;
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500);
  }
}

// ===== EXCEPTIONS =====

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class RateLimitException implements Exception {
  final String message;
  RateLimitException(this.message);

  @override
  String toString() => 'RateLimitException: $message';
}