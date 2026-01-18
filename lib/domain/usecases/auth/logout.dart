/// Use Case: Выход пользователя
library;

import 'package:hvac_control/domain/usecases/auth/login.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для выхода
class LogoutParams {

  const LogoutParams({
    required this.refreshToken,
    this.logoutAll = false,
    this.accessToken,
  });
  final String refreshToken;
  final bool logoutAll;
  final String? accessToken;
}

/// Выйти из системы
class Logout extends UseCaseWithParams<void, LogoutParams> {

  Logout(this._repository);
  final AuthRepository _repository;

  @override
  Future<void> call(LogoutParams params) async {
    if (params.logoutAll && params.accessToken != null) {
      await _repository.logoutAll(params.accessToken!);
    } else {
      await _repository.logout(params.refreshToken);
    }
  }
}
