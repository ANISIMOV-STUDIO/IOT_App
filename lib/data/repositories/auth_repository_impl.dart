/// Auth Repository Implementation
///
/// Concrete implementation of authentication repository
/// Handles actual API calls and data persistence
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/api_service.dart';
import '../../core/utils/logger.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository using REST API
class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'cached_user';

  AuthRepositoryImpl({
    required ApiService apiService,
    required SharedPreferences prefs,
  })  : _apiService = apiService,
        _prefs = prefs;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      // Extract user from response
      final userJson = response['user'] ?? response;
      final userModel = UserModel.fromJson(userJson);

      // Cache user data
      await _cacheUser(userModel);

      // Convert to domain entity
      return userModel.toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _apiService.register(
        email: email,
        password: password,
        name: name,
      );

      // Extract user from response
      final userJson = response['user'] ?? response;
      final userModel = UserModel.fromJson(userJson);

      // Cache user data
      await _cacheUser(userModel);

      // Convert to domain entity
      return userModel.toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Notify server about logout
      await _apiService.logout();
    } catch (e) {
      // Log error but continue with local logout
      Logger.debug('Server logout failed: $e');
    } finally {
      // Always clear local data
      await clearAuthToken();
      await _clearCachedUser();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // Try to get from API first
      final userData = await _apiService.getCurrentUser();
      final userModel = UserModel.fromJson(userData['user'] ?? userData);

      // Update cache
      await _cacheUser(userModel);

      return userModel.toEntity();
    } catch (e) {
      // Fall back to cached user
      final cachedUser = _getCachedUser();
      return cachedUser;
    }
  }

  @override
  bool get isAuthenticated => _apiService.isAuthenticated;

  @override
  String? get authToken => _apiService.authToken;

  @override
  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_tokenKey, token);
    // Update API service with new token
    await _apiService.saveAuthToken(token);
  }

  @override
  Future<void> clearAuthToken() async {
    await _prefs.remove(_tokenKey);
    await _apiService.clearAuthToken();
  }

  @override
  Future<String> refreshToken() async {
    try {
      final response = await _apiService.post('/auth/refresh');
      // Parse response body since post() returns http.Response
      if (response.statusCode != 200) {
        throw Exception('Token refresh failed');
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final newToken = responseData['token'] as String;

      await saveAuthToken(newToken);
      return newToken;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<bool> isTokenValid() async {
    if (!isAuthenticated) return false;

    try {
      // Try to get current user to validate token
      await _apiService.getCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Cache user data locally
  Future<void> _cacheUser(UserModel user) async {
    await _prefs.setString(_userKey, user.toJson());
  }

  /// Get cached user data
  User? _getCachedUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;

    try {
      final userModel = UserModel.fromJsonString(userJson);
      return userModel.toEntity();
    } catch (e) {
      return null;
    }
  }

  /// Clear cached user data
  Future<void> _clearCachedUser() async {
    await _prefs.remove(_userKey);
  }

  /// Handle and transform errors
  Exception _handleError(dynamic error) {
    final errorStr = error.toString();

    if (errorStr.contains('401')) {
      return Exception('Invalid credentials');
    } else if (errorStr.contains('409')) {
      return Exception('User already exists');
    } else if (errorStr.contains('network')) {
      return Exception('Network error');
    } else if (errorStr.contains('timeout')) {
      return Exception('Request timeout');
    } else {
      return Exception(errorStr.replaceAll('Exception: ', ''));
    }
  }
}