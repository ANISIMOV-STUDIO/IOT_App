/// Исключение для истёкшей сессии
///
/// Бросается interceptor'ами при неудачном refresh token.
/// Обрабатывается AuthBloc для выполнения logout.
library;

/// Исключение, указывающее что сессия пользователя истекла
/// и требуется повторная авторизация.
class SessionExpiredException implements Exception {
  const SessionExpiredException([this.message = 'Session expired']);

  final String message;

  @override
  String toString() => 'SessionExpiredException: $message';
}
