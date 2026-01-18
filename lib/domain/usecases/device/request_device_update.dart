/// Use Case: Запросить обновление данных от устройства
library;

import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/usecases/usecase.dart';

/// Запросить принудительное обновление данных от устройства
///
/// Отправляет команду устройству опубликовать актуальные данные в MQTT.
/// Используется при загрузке страницы для получения свежих данных с пульта.
class RequestDeviceUpdate extends UseCaseWithParams<void, String> {

  RequestDeviceUpdate(this._repository);
  final ClimateRepository _repository;

  @override
  Future<void> call(String deviceId) async {
    if (deviceId.trim().isEmpty) {
      throw ArgumentError('ID устройства не может быть пустым');
    }

    await _repository.requestDeviceUpdate(deviceId: deviceId);
  }
}
