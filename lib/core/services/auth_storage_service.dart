/// Auth Storage Service for JWT token management
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Сервис для безопасного хранения токена аутентификации
class AuthStorageService {
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _tokenExpiryKey = 'auth_token_expiry';
  static const String _userIdKey = 'user_id';

  final FlutterSecureStorage _secureStorage;

  AuthStorageService(this._secureStorage);

  /// Сохранить оба токена (access и refresh)
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);

    // Декодировать JWT и сохранить время истечения access token
    try {
      final decodedToken = JwtDecoder.decode(accessToken);
      final exp = decodedToken['exp'] as int?;
      if (exp != null) {
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        await _secureStorage.write(
          key: _tokenExpiryKey,
          value: expiryDate.toIso8601String(),
        );
      }
    } catch (e) {
      // Логировать ошибку, но продолжить
    }
  }

  /// Сохранить только access token (после refresh)
  Future<void> updateAccessToken(String accessToken) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);

    // Обновить время истечения
    try {
      final decodedToken = JwtDecoder.decode(accessToken);
      final exp = decodedToken['exp'] as int?;
      if (exp != null) {
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        await _secureStorage.write(
          key: _tokenExpiryKey,
          value: expiryDate.toIso8601String(),
        );
      }
    } catch (e) {
      // Логировать ошибку, но продолжить
    }
  }

  /// Получить access token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  /// Получить refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  /// Проверить, истек ли access token
  Future<bool> isAccessTokenExpired() async {
    final expiryStr = await _secureStorage.read(key: _tokenExpiryKey);
    if (expiryStr == null) return false;

    try {
      final expiry = DateTime.parse(expiryStr);
      // Считаем токен истекшим за 1 минуту до реального истечения
      return DateTime.now().isAfter(expiry.subtract(const Duration(minutes: 1)));
    } catch (e) {
      return false;
    }
  }

  /// Сохранить ID пользователя
  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: _userIdKey, value: userId);
  }

  /// Получить ID пользователя
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _userIdKey);
  }

  /// Удалить все токены (logout)
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _tokenExpiryKey);
    await _secureStorage.delete(key: _userIdKey);
  }

  /// Проверить наличие токена
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Очистить все данные
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
