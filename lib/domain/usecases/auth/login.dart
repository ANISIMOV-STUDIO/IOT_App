/// Use Case: Вход пользователя
library;

import '../../entities/user.dart';
import '../usecase.dart';

/// Параметры для входа
class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

/// Результат входа
class LoginResult {
  final User user;
  final String accessToken;
  final String refreshToken;

  const LoginResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
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
  final AuthRepository _repository;

  Login(this._repository);

  @override
  Future<LoginResult> call(LoginParams params) async {
    return _repository.login(params.email, params.password);
  }
}
