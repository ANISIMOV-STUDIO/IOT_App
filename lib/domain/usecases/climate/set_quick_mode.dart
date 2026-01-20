/// Use Case: Установить быстрый режим (все настройки одним запросом)
library;

import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Параметры для установки быстрого режима
class SetQuickModeParams {
  const SetQuickModeParams({
    required this.heatingTemperature,
    required this.coolingTemperature,
    required this.supplyFan,
    required this.exhaustFan,
    this.deviceId,
  });

  final int heatingTemperature;
  final int coolingTemperature;
  final int supplyFan;
  final int exhaustFan;
  final String? deviceId;
}

/// Установить быстрый режим для устройства
///
/// Отправляет все настройки одним запросом при изменении
/// любого параметра в главном виджете управления.
class SetQuickMode extends UseCaseWithParams<void, SetQuickModeParams> {
  SetQuickMode(this._repository);

  final ClimateRepository _repository;

  @override
  Future<void> call(SetQuickModeParams params) => _repository.setQuickMode(
        heatingTemperature: params.heatingTemperature,
        coolingTemperature: params.coolingTemperature,
        supplyFan: params.supplyFan,
        exhaustFan: params.exhaustFan,
        deviceId: params.deviceId,
      );
}
