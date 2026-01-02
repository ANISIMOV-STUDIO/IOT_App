/// Use Case: Выход пользователя
library;

import '../usecase.dart';
import 'login.dart';

/// Параметры для выхода
class LogoutParams {
  final String refreshToken;
  final bool logoutAll;
  final String? accessToken;

  const LogoutParams({
    required this.refreshToken,
    this.logoutAll = false,
    this.accessToken,
  });
}

/// Выйти из системы
class Logout extends UseCaseWithParams<void, LogoutParams> {
  final AuthRepository _repository;

  Logout(this._repository);

  @override
  Future<void> call(LogoutParams params) async {
    if (params.logoutAll && params.accessToken != null) {
      await _repository.logoutAll(params.accessToken!);
    } else {
      await _repository.logout(params.refreshToken);
    }
  }
}
