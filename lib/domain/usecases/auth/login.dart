/// Use Case: Вход пользователя
library;

import 'package:hvac_control/domain/entities/user.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для входа
class LoginParams {

  const LoginParams({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;
}

/// Результат входа
class LoginResult {

  const LoginResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
  final User user;
  final String accessToken;
  final String refreshToken;
}

/// Абстракция репозитория авторизации для Use Case
abstract class AuthRepository {
  Future<LoginResult> login(String email, String password);
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required bool dataProcessingConsent,
  });
  Future<void> verifyEmail(String email, String code);
  Future<void> resendCode(String email);
  Future<void> logout(String refreshToken);
  Future<void> logoutAll(String accessToken);
  Future<LoginResult?> checkSession();
}

/// Выполнить вход пользователя
class Login extends UseCaseWithParams<LoginResult, LoginParams> {

  Login(this._repository);
  final AuthRepository _repository;

  @override
  Future<LoginResult> call(LoginParams params) async =>
      _repository.login(params.email, params.password);
}
