/// Auth Storage Service for JWT token management
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Сервис для безопасного хранения токена аутентификации
class AuthStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _skippedKey = 'auth_skipped';

  final FlutterSecureStorage _secureStorage;

  AuthStorageService(this._secureStorage);

  /// Сохранить токен
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Получить токен
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Сохранить ID пользователя
  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: _userIdKey, value: userId);
  }

  /// Получить ID пользователя
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _userIdKey);
  }

  /// Удалить токен (logout)
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _userIdKey);
    await _secureStorage.delete(key: _skippedKey);
  }

  /// Проверить наличие токена
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Сохранить флаг "пропущено" (dev mode)
  Future<void> saveSkipped() async {
    await _secureStorage.write(key: _skippedKey, value: 'true');
  }

  /// Проверить, пропущена ли авторизация (dev mode)
  Future<bool> hasSkipped() async {
    final skipped = await _secureStorage.read(key: _skippedKey);
    return skipped == 'true';
  }

  /// Очистить все данные
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
