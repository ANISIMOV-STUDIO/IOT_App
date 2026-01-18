/// Use Case: Регистрация пользователя
library;

import 'package:hvac_control/domain/usecases/auth/login.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для регистрации
class RegisterParams {

  const RegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dataProcessingConsent,
  });
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final bool dataProcessingConsent;
}

/// Зарегистрировать нового пользователя
class Register extends UseCaseWithParams<void, RegisterParams> {

  Register(this._repository);
  final AuthRepository _repository;

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
