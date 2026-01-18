/// Auth Models (DTO) для API запросов и ответов
///
/// Все модели отвечают только за сериализацию/десериализацию.
/// Преобразование в Domain Entities выполняется через методы toEntity().
library;

import 'package:hvac_control/data/models/user_model.dart';
import 'package:hvac_control/domain/entities/user.dart';

/// Запрос на регистрацию
class RegisterRequest {

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dataProcessingConsent,
  });
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final bool dataProcessingConsent;

  Map<String, dynamic> toJson() => {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'dataProcessingConsent': dataProcessingConsent,
    };
}

/// Запрос на вход
class LoginRequest {

  const LoginRequest({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
      'email': email,
      'password': password,
    };
}

/// Ответ при успешной аутентификации
class AuthResponse {

  const AuthResponse._({
    required this.accessToken,
    required this.refreshToken,
    required UserModel userModel,
  }) : _userModel = userModel;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse._(
      // Поддержка старого формата (token) и нового (accessToken)
      accessToken: (json['accessToken'] ?? json['token']) as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      userModel: UserModel.fromJson((json['user'] as Map<String, dynamic>?) ?? {}),
    );
  final String accessToken;
  final String refreshToken;
  final UserModel _userModel;

  /// Получить Domain Entity пользователя
  User get user => _userModel.toEntity();

  Map<String, dynamic> toJson() => {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': _userModel.toJson(),
    };
}

/// Ответ при успешной регистрации
class RegisterResponse {

  const RegisterResponse({
    required this.message,
    required this.email,
    required this.requiresEmailVerification,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
      message: json['message'] as String? ?? 'Регистрация выполнена',
      email: json['email'] as String? ?? '',
      requiresEmailVerification: json['requiresEmailVerification'] as bool? ?? false,
    );
  final String message;
  final String email;
  final bool requiresEmailVerification;
}

/// Запрос на подтверждение email
class VerifyEmailRequest {

  const VerifyEmailRequest({
    required this.email,
    required this.code,
  });
  final String email;
  final String code;

  Map<String, dynamic> toJson() => {
      'email': email,
      'code': code,
    };
}

/// Запрос на повторную отправку кода
class ResendCodeRequest {

  const ResendCodeRequest({
    required this.email,
  });
  final String email;

  Map<String, dynamic> toJson() => {
      'email': email,
    };
}

/// Запрос на обновление токенов через refresh token
class RefreshTokenRequest {

  const RefreshTokenRequest({
    required this.refreshToken,
  });
  final String refreshToken;

  Map<String, dynamic> toJson() => {
      'refreshToken': refreshToken,
    };
}

/// Запрос на выход из системы
class LogoutRequest {

  const LogoutRequest({
    required this.refreshToken,
  });
  final String refreshToken;

  Map<String, dynamic> toJson() => {
      'refreshToken': refreshToken,
    };
}

/// Запрос на восстановление пароля (forgot password)
class ForgotPasswordRequest {

  const ForgotPasswordRequest({
    required this.email,
  });
  final String email;

  Map<String, dynamic> toJson() => {
      'email': email,
    };
}

/// Запрос на сброс пароля (reset password)
class ResetPasswordRequest {

  const ResetPasswordRequest({
    required this.email,
    required this.code,
    required this.newPassword,
  });
  final String email;
  final String code;
  final String newPassword;

  Map<String, dynamic> toJson() => {
      'email': email,
      'code': code,
      'newPassword': newPassword,
    };
}

/// Запрос на смену пароля (авторизованный пользователь)
class ChangePasswordRequest {

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });
  final String currentPassword;
  final String newPassword;

  Map<String, dynamic> toJson() => {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
}

/// Запрос на обновление профиля
class UpdateProfileRequest {

  const UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
  });
  final String firstName;
  final String lastName;

  Map<String, dynamic> toJson() => {
      'firstName': firstName,
      'lastName': lastName,
    };
}
