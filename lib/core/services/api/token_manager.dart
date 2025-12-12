/// Token management service for API authentication
library;

import 'package:jwt_decoder/jwt_decoder.dart';
import '../talker_service.dart';
import '../secure_storage_service.dart';

class TokenManager {
  final SecureStorageService _secureStorage;

  String? _authToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  TokenManager({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage;

  String? get authToken => _authToken;
  String? get refreshToken => _refreshToken;
  DateTime? get tokenExpiry => _tokenExpiry;

  /// Load stored tokens on initialization
  Future<void> loadStoredTokens() async {
    _authToken = await _secureStorage.getAuthToken();
    _refreshToken = await _secureStorage.getRefreshToken();

    if (_authToken != null) {
      try {
        _tokenExpiry = getTokenExpiry(_authToken!);
      } catch (e) {
        talker.warning('Failed to parse stored token expiry: $e');
        await clearTokens();
      }
    }
  }

  /// Get token expiry from JWT
  DateTime? getTokenExpiry(String token) {
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
      talker.error('Failed to decode token expiry: $e');
    }
    return null;
  }

  /// Check if token needs refreshing
  bool needsTokenRefresh() {
    if (_authToken == null || _tokenExpiry == null) {
      return true;
    }

    final now = DateTime.now();
    const expiryBuffer =
        Duration(minutes: 5); // Refresh 5 minutes before expiry
    return now.isAfter(_tokenExpiry!.subtract(expiryBuffer));
  }

  /// Update tokens
  Future<void> updateTokens(String authToken, String? refreshToken) async {
    _authToken = authToken;
    await _secureStorage.saveAuthToken(authToken);

    _tokenExpiry = getTokenExpiry(authToken);

    if (refreshToken != null) {
      _refreshToken = refreshToken;
      await _secureStorage.saveRefreshToken(refreshToken);
    }
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    _authToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    await _secureStorage.clearTokens();
  }

  /// Check if authenticated
  bool get isAuthenticated => _authToken != null && !needsTokenRefresh();
}
