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
  final String token;
  final User user;

  const AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
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
