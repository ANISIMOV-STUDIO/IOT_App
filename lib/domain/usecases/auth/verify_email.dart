/// Use Case: Подтверждение email
library;

import 'package:hvac_control/domain/usecases/auth/login.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для подтверждения email
class VerifyEmailParams {

  const VerifyEmailParams({
    required this.email,
    required this.code,
  });
  final String email;
  final String code;
}

/// Подтвердить email по коду
class VerifyEmail extends UseCaseWithParams<void, VerifyEmailParams> {

  VerifyEmail(this._repository);
  final AuthRepository _repository;

  @override
  Future<void> call(VerifyEmailParams params) async {
    await _repository.verifyEmail(params.email, params.code);
  }
}
