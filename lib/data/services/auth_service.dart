/// Auth Service - API вызовы для аутентификации
library;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hvac_control/core/config/api_config.dart';
import 'package:hvac_control/data/models/auth_models.dart';
import 'package:hvac_control/data/models/user_model.dart';
import 'package:hvac_control/domain/entities/user.dart';

/// Исключение авторизации
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Сервис для работы с API аутентификации
class AuthService {

  AuthService(this._client) {
    _baseUrl = ApiConfig.apiBaseUrl;
  }
  final http.Client _client;
  late final String _baseUrl;

  /// Регистрация нового пользователя
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return RegisterResponse.fromJson(data);
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw AuthException(
          error['message'] as String? ?? 'Ошибка регистрации',
        );
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Ошибка подключения к серверу: $e');
    }
  }

  /// Вход пользователя
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return AuthResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        throw const AuthException('Неверный email или пароль');
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw AuthException(
          error['message'] as String? ?? 'Ошибка входа',
        );
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Ошибка подключения к серверу: $e');
    }
  }

  /// Получить информацию о текущем пользователе
  Future<User> getCurrentUser(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        // Используем UserModel для десериализации, затем преобразуем в Entity
        return UserModel.fromJson(data).toEntity();
      } else if (response.statusCode == 401) {
        throw const AuthException('Токен недействителен');
      } else {
        throw const AuthException('Ошибка получения данных пользователя');
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Ошибка подключения к серверу: $e');
    }
  }

  /// Подтверждение email по коду
  Future<void> verifyEmail(VerifyEmailRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/verify-email'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw AuthException(
          error['message'] as String? ?? 'Ошибка подтверждения email',
        );
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Ошибка подключения к серверу: $e');
    }
  }

  /// Повторная отправка кода подтверждения
  Future<void> resendCode(ResendCodeRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/resend-code'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw AuthException(
          error['message'] as String? ?? 'Ошибка отправки кода',
        );
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Ошибка подключения к серверу: $e');
    }
  }

  /// Обновление токенов через refresh token
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(RefreshTokenRequest(refreshToken: refreshToken).toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return AuthResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        throw const AuthException('Refresh token истек или недействителен');
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw AuthException(
          error['message'] as String? ?? 'Ошибка обновления токена',
        );
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Ошибка подключения к серверу: $e');
    }
  }

  /// Выход из системы (отзыв refresh token)
  Future<void> logout(String refreshToken) async {
    try {
      await _client.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(LogoutRequest(refreshToken: refreshToken).toJson()),
      );
      // Игнорируем ответ - logout всегда должен быть успешным на клиенте
    } catch (e) {
      // Логировать, но не выбрасывать - logout должен быть успешным
    }
  }

  /// Выход со всех устройств
  Future<void> logoutAll(String accessToken) async {
    try {
      await _client.post(
        Uri.parse('$_baseUrl/auth/logout-all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      // Игнорируем ответ - logout всегда должен быть успешным на клиенте
    } catch (e) {
      // Логировать, но не выбрасывать - logout должен быть успешным
    }
  }

  /// Запрос сброса пароля (отправка кода на email)
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw AuthException(
          error['message'] as String? ?? 'Ошибка отправки кода',
        );
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Ошибка подключения к серверу: $e');
    }
  }

  /// Сброс пароля по коду
  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/reset-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw AuthException(
          error['message'] as String? ?? 'Ошибка сброса пароля',
        );
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Ошибка подключения к серверу: $e');
    }
  }

  /// Смена пароля авторизованным пользователем
  Future<void> changePassword(ChangePasswordRequest request, String token) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw AuthException(
          error['message'] as String? ?? 'Ошибка смены пароля',
        );
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Ошибка подключения к серверу: $e');
    }
  }

  /// Обновление профиля пользователя
  Future<User> updateProfile(UpdateProfileRequest request, String token) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return UserModel.fromJson(data).toEntity();
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw AuthException(
          error['message'] as String? ?? 'Ошибка обновления профиля',
        );
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Ошибка подключения к серверу: $e');
    }
  }
}
