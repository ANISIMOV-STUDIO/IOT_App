/// Auth Events
library;

import 'package:equatable/equatable.dart';

/// Базовое событие аутентификации
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Проверка сохраненной сессии при старте
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Вход пользователя
class AuthLoginRequested extends AuthEvent {

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Регистрация пользователя
class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
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

  // password исключён из props для безопасного логирования
  @override
  List<Object?> get props => [
        email,
        firstName,
        lastName,
        dataProcessingConsent,
      ];
}

/// Выход пользователя
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Выход со всех устройств
class AuthLogoutAllRequested extends AuthEvent {
  const AuthLogoutAllRequested();
}

/// Подтверждение email по коду
class AuthVerifyEmailRequested extends AuthEvent {

  const AuthVerifyEmailRequested({
    required this.email,
    required this.code,
  });
  final String email;
  final String code;

  @override
  List<Object?> get props => [email, code];
}

/// Повторная отправка кода подтверждения
class AuthResendCodeRequested extends AuthEvent {

  const AuthResendCodeRequested({
    required this.email,
  });
  final String email;

  @override
  List<Object?> get props => [email];
}

/// Запрос сброса пароля (forgot password)
class AuthForgotPasswordRequested extends AuthEvent {

  const AuthForgotPasswordRequested({
    required this.email,
  });
  final String email;

  @override
  List<Object?> get props => [email];
}

/// Сброс пароля по коду (reset password)
class AuthResetPasswordRequested extends AuthEvent {

  const AuthResetPasswordRequested({
    required this.email,
    required this.code,
    required this.newPassword,
  });
  final String email;
  final String code;
  final String newPassword;

  @override
  List<Object?> get props => [email, code, newPassword];
}

/// Смена пароля (авторизованный пользователь)
class AuthChangePasswordRequested extends AuthEvent {

  const AuthChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });
  final String currentPassword;
  final String newPassword;

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Обновление профиля
class AuthUpdateProfileRequested extends AuthEvent {

  const AuthUpdateProfileRequested({
    required this.firstName,
    required this.lastName,
  });
  final String firstName;
  final String lastName;

  @override
  List<Object?> get props => [firstName, lastName];
}

/// Сессия истекла (от TokenRefreshService или interceptor)
class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}

/// Обновление настроек пользователя
class AuthUpdatePreferencesRequested extends AuthEvent {
  const AuthUpdatePreferencesRequested({
    this.pushNotificationsEnabled,
    this.emailNotificationsEnabled,
    this.theme,
    this.language,
  });

  final bool? pushNotificationsEnabled;
  final bool? emailNotificationsEnabled;
  final String? theme;
  final String? language;

  @override
  List<Object?> get props => [
        pushNotificationsEnabled,
        emailNotificationsEnabled,
        theme,
        language,
      ];
}
