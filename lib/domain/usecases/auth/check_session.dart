/// Use Case: Проверка сохранённой сессии
library;

import '../usecase.dart';
import 'login.dart';

/// Проверить наличие сохранённой сессии при запуске приложения
class CheckSession extends UseCase<LoginResult?> {
  final AuthRepository _repository;

  CheckSession(this._repository);

  @override
  Future<LoginResult?> call() async {
    return _repository.checkSession();
  }
}
