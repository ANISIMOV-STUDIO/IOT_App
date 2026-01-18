/// Use Case: Установить пресет
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для установки пресета
class SetPresetParams {

  const SetPresetParams({
    required this.preset,
    this.deviceId,
  });
  final String preset;
  final String? deviceId;
}

/// Установить пресет (auto, night, turbo, eco, away)
class SetPreset extends UseCaseWithParams<ClimateState, SetPresetParams> {

  SetPreset(this._repository);
  final ClimateRepository _repository;

  @override
  Future<ClimateState> call(SetPresetParams params) async => _repository.setPreset(params.preset, deviceId: params.deviceId);
}
