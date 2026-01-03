/// Use Case: Установить пресет
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Параметры для установки пресета
class SetPresetParams {
  final String preset;
  final String? deviceId;

  const SetPresetParams({
    required this.preset,
    this.deviceId,
  });
}

/// Установить пресет (auto, night, turbo, eco, away)
class SetPreset extends UseCaseWithParams<ClimateState, SetPresetParams> {
  final ClimateRepository _repository;

  SetPreset(this._repository);

  @override
  Future<ClimateState> call(SetPresetParams params) async {
    return _repository.setPreset(params.preset, deviceId: params.deviceId);
  }
}
