/// Use Case: Установить режим работы установки
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для установки режима работы
class SetOperatingModeParams {

  const SetOperatingModeParams({
    required this.mode,
    this.deviceId,
  });
  final String mode;
  final String? deviceId;
}

/// Установить режим работы установки (basic, intensive, economy, etc.)
class SetOperatingMode extends UseCaseWithParams<ClimateState, SetOperatingModeParams> {

  SetOperatingMode(this._repository);
  final ClimateRepository _repository;

  @override
  Future<ClimateState> call(SetOperatingModeParams params) async => _repository.setOperatingMode(params.mode, deviceId: params.deviceId);
}
