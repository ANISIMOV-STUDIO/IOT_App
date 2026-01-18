/// Use Case: Проверка сохранённой сессии
library;

import 'package:hvac_control/domain/usecases/auth/login.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Проверить наличие сохранённой сессии при запуске приложения
class CheckSession extends UseCase<LoginResult?> {

  CheckSession(this._repository);
  final AuthRepository _repository;

  @override
  Future<LoginResult?> call() async => _repository.checkSession();
}
