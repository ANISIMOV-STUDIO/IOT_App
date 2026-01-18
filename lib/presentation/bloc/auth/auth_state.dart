/// Auth States
library;

import 'package:equatable/equatable.dart';
import 'package:hvac_control/domain/entities/user.dart';

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

  const AuthAuthenticated({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
  final User user;
  final String accessToken;
  final String refreshToken;

  /// Для обратной совместимости
  String get token => accessToken;

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}

/// Ошибка аутентификации
class AuthError extends AuthState {

  const AuthError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Регистрация успешна, требуется подтверждение email
class AuthRegistered extends AuthState {

  const AuthRegistered({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

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

  const AuthPasswordResetCodeSent({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}

/// Пароль успешно изменён (через forgot password)
class AuthPasswordReset extends AuthState {
  const AuthPasswordReset();
}

/// Пароль успешно изменён (авторизованным пользователем)
class AuthPasswordChanged extends AuthState {
  const AuthPasswordChanged();
}

/// Профиль успешно обновлён
class AuthProfileUpdated extends AuthState {

  const AuthProfileUpdated({required this.user});
  final User user;

  @override
  List<Object?> get props => [user];
}

/// Сессия истекла - перед logout с показом предупреждения
class AuthSessionExpiredState extends AuthState {
  const AuthSessionExpiredState();
}
