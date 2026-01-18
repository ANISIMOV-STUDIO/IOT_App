/// Use Case: Повторная отправка кода подтверждения
library;

import 'package:hvac_control/domain/usecases/auth/login.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для повторной отправки кода
class ResendCodeParams {

  const ResendCodeParams({required this.email});
  final String email;
}

/// Повторно отправить код подтверждения email
class ResendCode extends UseCaseWithParams<void, ResendCodeParams> {

  ResendCode(this._repository);
  final AuthRepository _repository;

  @override
  Future<void> call(ResendCodeParams params) async {
    await _repository.resendCode(params.email);
  }
}
