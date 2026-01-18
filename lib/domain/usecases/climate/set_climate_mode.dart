/// Use Case: Установить режим климата
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для установки режима
class SetClimateModeParams {

  const SetClimateModeParams({
    required this.mode,
    this.deviceId,
  });
  final ClimateMode mode;
  final String? deviceId;
}

/// Установить режим работы климатической системы
class SetClimateMode extends UseCaseWithParams<ClimateState, SetClimateModeParams> {

  SetClimateMode(this._repository);
  final ClimateRepository _repository;

  @override
  Future<ClimateState> call(SetClimateModeParams params) async =>
      _repository.setMode(params.mode, deviceId: params.deviceId);
}
