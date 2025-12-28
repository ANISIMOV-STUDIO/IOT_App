/// Auth States
library;

import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

/// Базовое состояние аутентификации
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние (проверка сессии)
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Загрузка
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Пользователь не авторизован
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Пользователь авторизован
class AuthAuthenticated extends AuthState {
  final User user;
  final String token;

  const AuthAuthenticated({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];
}

/// Ошибка аутентификации
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Пропущена авторизация (dev mode)
class AuthSkipped extends AuthState {
  const AuthSkipped();
}

/// Регистрация успешна, требуется подтверждение email
class AuthRegistered extends AuthState {
  final String email;
  final String password;

  const AuthRegistered({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Email подтвержден успешно
class AuthEmailVerified extends AuthState {
  const AuthEmailVerified();
}

/// Код подтверждения отправлен повторно
class AuthCodeResent extends AuthState {
  const AuthCodeResent();
}
