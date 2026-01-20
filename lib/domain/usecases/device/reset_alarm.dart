/// Use Case: Сбросить активные аварии устройства
library;

import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Сбросить активные аварии устройства
class ResetAlarm extends UseCaseWithParams<void, String> {

  ResetAlarm(this._repository);
  final ClimateRepository _repository;

  @override
  Future<void> call(String deviceId) async => _repository.resetAlarm(deviceId);
}
