/// Use Case: Установить скорость воздушного потока
library;

import '../../entities/climate.dart';
import '../../repositories/climate_repository.dart';
import '../usecase.dart';

/// Тип воздушного потока
enum AirflowType { supply, exhaust }

/// Параметры для установки скорости потока
class SetAirflowParams {
  final AirflowType type;
  final double value;
  final String? deviceId;

  const SetAirflowParams({
    required this.type,
    required this.value,
    this.deviceId,
  });
}

/// Установить скорость притока или вытяжки
class SetAirflow extends UseCaseWithParams<ClimateState, SetAirflowParams> {
  final ClimateRepository _repository;

  SetAirflow(this._repository);

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
