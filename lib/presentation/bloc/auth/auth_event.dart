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
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Регистрация пользователя
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final bool dataProcessingConsent;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dataProcessingConsent,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        firstName,
        lastName,
        dataProcessingConsent,
      ];
}

/// Выход пользователя
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Пропуск авторизации (только для разработки)
class AuthSkipRequested extends AuthEvent {
  const AuthSkipRequested();
}

/// Подтверждение email по коду
class AuthVerifyEmailRequested extends AuthEvent {
  final String email;
  final String code;

  const AuthVerifyEmailRequested({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
}

/// Повторная отправка кода подтверждения
class AuthResendCodeRequested extends AuthEvent {
  final String email;

  const AuthResendCodeRequested({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}
