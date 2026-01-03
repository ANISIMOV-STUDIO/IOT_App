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
  final String accessToken;
  final String refreshToken;

  const AuthAuthenticated({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  /// Для обратной совместимости
  String get token => accessToken;

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}

/// Ошибка аутентификации
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
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

/// Код сброса пароля отправлен на email
class AuthPasswordResetCodeSent extends AuthState {
  final String email;

  const AuthPasswordResetCodeSent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Пароль успешно изменён
class AuthPasswordReset extends AuthState {
  const AuthPasswordReset();
}
