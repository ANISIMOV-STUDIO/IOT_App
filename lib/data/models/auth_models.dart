/// Auth Models for API requests and responses
library;

import '../../domain/entities/user.dart';

/// Запрос на регистрацию
class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final bool dataProcessingConsent;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dataProcessingConsent,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'dataProcessingConsent': dataProcessingConsent,
    };
  }
}

/// Запрос на вход
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

/// Ответ при успешной аутентификации
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      // Поддержка старого формата (token) и нового (accessToken)
      accessToken: (json['accessToken'] ?? json['token']) as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      user: User.fromJson((json['user'] as Map<String, dynamic>?) ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
}

/// Ответ при успешной регистрации
class RegisterResponse {
  final String message;
  final String email;
  final bool requiresEmailVerification;

  const RegisterResponse({
    required this.message,
    required this.email,
    required this.requiresEmailVerification,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] as String? ?? 'Регистрация выполнена',
      email: json['email'] as String? ?? '',
      requiresEmailVerification: json['requiresEmailVerification'] as bool? ?? false,
    );
  }
}

/// Запрос на подтверждение email
class VerifyEmailRequest {
  final String email;
  final String code;

  const VerifyEmailRequest({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }
}

/// Запрос на повторную отправку кода
class ResendCodeRequest {
  final String email;

  const ResendCodeRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

/// Запрос на обновление токенов через refresh token
class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}

/// Запрос на выход из системы
class LogoutRequest {
  final String refreshToken;

  const LogoutRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}
