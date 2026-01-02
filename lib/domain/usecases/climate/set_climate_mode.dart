/// Use Case: Установить режим климата
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для установки режима
class SetClimateModeParams {
  final ClimateMode mode;
  final String? deviceId;

  const SetClimateModeParams({
    required this.mode,
    this.deviceId,
  });
}

/// Установить режим работы климатической системы
class SetClimateMode extends UseCaseWithParams<ClimateState, SetClimateModeParams> {
  final ClimateRepository _repository;

  SetClimateMode(this._repository);

  @override
  Future<ClimateState> call(SetClimateModeParams params) async {
    return _repository.setMode(params.mode, deviceId: params.deviceId);
  }
}
