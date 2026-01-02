/// Use Case: Повторная отправка кода подтверждения
library;

import '../usecase.dart';
import 'login.dart';

/// Параметры для повторной отправки кода
class ResendCodeParams {
  final String email;

  const ResendCodeParams({required this.email});
}

/// Повторно отправить код подтверждения email
class ResendCode extends UseCaseWithParams<void, ResendCodeParams> {
  final AuthRepository _repository;

  ResendCode(this._repository);

  @override
  Future<void> call(ResendCodeParams params) async {
    await _repository.resendCode(params.email);
  }
}
