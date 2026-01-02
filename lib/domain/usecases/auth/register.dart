/// Use Case: Регистрация пользователя
library;

import '../usecase.dart';
import 'login.dart';

/// Параметры для регистрации
class RegisterParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final bool dataProcessingConsent;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dataProcessingConsent,
  });
}

/// Зарегистрировать нового пользователя
class Register extends UseCaseWithParams<void, RegisterParams> {
  final AuthRepository _repository;

  Register(this._repository);

  @override
  Future<void> call(RegisterParams params) async {
    await _repository.register(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
      dataProcessingConsent: params.dataProcessingConsent,
    );
  }
}
