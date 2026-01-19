/// Use Case: Установить настройки режима (температуры и скорости вентиляторов)
library;

import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для установки настроек режима
class SetModeSettingsParams {
  const SetModeSettingsParams({
    required this.modeName,
    required this.settings,
    this.deviceId,
  });

  /// Идентификатор режима (basic, intensive, economy, etc.)
  final String modeName;

  /// Настройки режима
  final ModeSettings settings;

  /// ID устройства (null = текущее выбранное)
  final String? deviceId;
}

/// Установить настройки режима работы
class SetModeSettings extends UseCaseWithParams<void, SetModeSettingsParams> {
  SetModeSettings(this._repository);

  final ClimateRepository _repository;

  @override
  Future<void> call(SetModeSettingsParams params) => _repository.setModeSettings(
        modeName: params.modeName,
        settings: params.settings,
        deviceId: params.deviceId,
      );
}
