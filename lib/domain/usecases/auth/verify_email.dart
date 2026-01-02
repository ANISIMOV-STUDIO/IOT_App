/// Use Case: Подтверждение email
library;

import '../usecase.dart';
import 'login.dart';

/// Параметры для подтверждения email
class VerifyEmailParams {
  final String email;
  final String code;

  const VerifyEmailParams({
    required this.email,
    required this.code,
  });
}

/// Подтвердить email по коду
class VerifyEmail extends UseCaseWithParams<void, VerifyEmailParams> {
  final AuthRepository _repository;

  VerifyEmail(this._repository);

  @override
  Future<void> call(VerifyEmailParams params) async {
    await _repository.verifyEmail(params.email, params.code);
  }
}
