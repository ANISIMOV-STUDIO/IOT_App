/// Use Case: Установить режим работы установки
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для установки режима работы
class SetOperatingModeParams {
  final String mode;
  final String? deviceId;

  const SetOperatingModeParams({
    required this.mode,
    this.deviceId,
  });
}

/// Установить режим работы установки (basic, intensive, economy, etc.)
class SetOperatingMode extends UseCaseWithParams<ClimateState, SetOperatingModeParams> {
  final ClimateRepository _repository;

  SetOperatingMode(this._repository);

  @override
  Future<ClimateState> call(SetOperatingModeParams params) async {
    return _repository.setOperatingMode(params.mode, deviceId: params.deviceId);
  }
}
