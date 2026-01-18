/// Use Case: Установить скорость воздушного потока
library;

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Тип воздушного потока
enum AirflowType { supply, exhaust }

/// Параметры для установки скорости потока
class SetAirflowParams {

  const SetAirflowParams({
    required this.type,
    required this.value,
    this.deviceId,
  });
  final AirflowType type;
  final double value;
  final String? deviceId;
}

/// Установить скорость притока или вытяжки
class SetAirflow extends UseCaseWithParams<ClimateState, SetAirflowParams> {

  SetAirflow(this._repository);
  final ClimateRepository _repository;

  @override
  Future<ClimateState> call(SetAirflowParams params) async {
    switch (params.type) {
      case AirflowType.supply:
        return _repository.setSupplyAirflow(params.value, deviceId: params.deviceId);
      case AirflowType.exhaust:
        return _repository.setExhaustAirflow(params.value, deviceId: params.deviceId);
    }
  }
}
