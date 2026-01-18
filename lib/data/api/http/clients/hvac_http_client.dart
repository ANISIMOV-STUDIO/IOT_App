/// HVAC HTTP Client - реализация IHvacDataSource через HTTP
///
/// Соответствует SOLID:
/// - S: Только HTTP-транспорт для HVAC операций
/// - O: Расширяется через BaseHttpClient
/// - L: Реализует IHvacDataSource
/// - I: Интерфейс разделён на логические группы
/// - D: Зависит от абстракций (ApiClient, IHvacDataSource)
library;

import '../../../../core/config/api_config.dart';
import '../../../../domain/datasources/hvac_datasource.dart';
import '../base_http_client.dart';

/// HTTP реализация HVAC Data Source
class HvacHttpClient extends BaseHttpClient implements IHvacDataSource {
  HvacHttpClient(super.apiClient);

  /// Базовый URL для HVAC API
  String get _baseUrl => ApiConfig.hvacApiUrl;

  // ===========================================================================
  // DEVICE CRUD
  // ===========================================================================

  @override
  Future<List<Map<String, dynamic>>> listDevices() async {
    return getList(
      _baseUrl,
      (json) => json,
      listKey: 'devices',
    );
  }

  @override
  Future<Map<String, dynamic>> getDevice(String deviceId) async {
    _validateDeviceId(deviceId);
    return getRaw('$_baseUrl/$deviceId');
  }

  @override
  Future<Map<String, dynamic>> registerDevice(
    String macAddress,
    String name,
  ) async {
    return post(
      '$_baseUrl/register',
      {'macAddress': macAddress, 'name': name},
      (json) => json as Map<String, dynamic>,
    );
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    _validateDeviceId(deviceId);
    await delete('$_baseUrl/$deviceId');
  }

  @override
  Future<void> renameDevice(String deviceId, String newName) async {
    _validateDeviceId(deviceId);
    await patchVoid('$_baseUrl/$deviceId', {'name': newName});
  }

  // ===========================================================================
  // POWER & MODE
  // ===========================================================================

  @override
  Future<Map<String, dynamic>> setPower(String deviceId, bool power) async {
    _validateDeviceId(deviceId);
    return post(
      '$_baseUrl/$deviceId/power',
      {'power': power},
      (json) => json as Map<String, dynamic>,
    );
  }

  @override
  Future<Map<String, dynamic>> setMode(String deviceId, String mode) async {
    _validateDeviceId(deviceId);
    return post(
      '$_baseUrl/$deviceId/mode',
      {'mode': mode},
      (json) => json as Map<String, dynamic>,
    );
  }

  @override
  Future<void> setModeSettings(
    String deviceId, {
    required String modeName,
    required int supplyFan,
    required int exhaustFan,
    required int heatingTemperature,
    required int coolingTemperature,
  }) async {
    _validateDeviceId(deviceId);
    await postVoid(
      '$_baseUrl/$deviceId/mode-settings',
      {
        'modeName': modeName,
        'supplyFan': supplyFan,
        'exhaustFan': exhaustFan,
        'heatingTemperature': heatingTemperature,
        'coolingTemperature': coolingTemperature,
      },
    );
  }

  // ===========================================================================
  // TEMPERATURE & FANS
  // ===========================================================================

  @override
  Future<Map<String, dynamic>> updateDevice(
    String deviceId, {
    int? heatingTemperature,
    int? coolingTemperature,
    int? supplyFan,
    int? exhaustFan,
  }) async {
    _validateDeviceId(deviceId);

    final body = <String, dynamic>{};
    if (heatingTemperature != null) body['heatingTemperature'] = heatingTemperature;
    if (coolingTemperature != null) body['coolingTemperature'] = coolingTemperature;
    if (supplyFan != null) body['supplyFan'] = supplyFan;
    if (exhaustFan != null) body['exhaustFan'] = exhaustFan;

    return patch(
      '$_baseUrl/$deviceId',
      body,
      (json) => json as Map<String, dynamic>,
    );
  }

  @override
  Future<void> setHeatingTemperature(
    String deviceId,
    int temperature, {
    required String modeName,
  }) async {
    _validateDeviceId(deviceId);
    await patchVoid(
      '$_baseUrl/$deviceId/mode-settings',
      {'modeName': modeName, 'heatingTemperature': temperature},
    );
  }

  @override
  Future<void> setCoolingTemperature(
    String deviceId,
    int temperature, {
    required String modeName,
  }) async {
    _validateDeviceId(deviceId);
    await patchVoid(
      '$_baseUrl/$deviceId/mode-settings',
      {'modeName': modeName, 'coolingTemperature': temperature},
    );
  }

  @override
  Future<void> setSupplyFan(
    String deviceId,
    int fanSpeed, {
    required String modeName,
  }) async {
    _validateDeviceId(deviceId);
    await patchVoid(
      '$_baseUrl/$deviceId/mode-settings',
      {'modeName': modeName, 'supplyFan': fanSpeed},
    );
  }

  @override
  Future<void> setExhaustFan(
    String deviceId,
    int fanSpeed, {
    required String modeName,
  }) async {
    _validateDeviceId(deviceId);
    await patchVoid(
      '$_baseUrl/$deviceId/mode-settings',
      {'modeName': modeName, 'exhaustFan': fanSpeed},
    );
  }

  // ===========================================================================
  // TIMER & SCHEDULE
  // ===========================================================================

  @override
  Future<void> setTimerSettings(
    String deviceId, {
    required String day,
    required int onHour,
    required int onMinute,
    required int offHour,
    required int offMinute,
    required bool enabled,
  }) async {
    _validateDeviceId(deviceId);
    await patchVoid(
      '$_baseUrl/$deviceId/timer-settings',
      {
        'day': day,
        'onHour': onHour,
        'onMinute': onMinute,
        'offHour': offHour,
        'offMinute': offMinute,
        'enabled': enabled,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> getDeviceTime(String deviceId) async {
    _validateDeviceId(deviceId);
    return getRaw('$_baseUrl/$deviceId/time');
  }

  // ===========================================================================
  // ALARMS
  // ===========================================================================

  @override
  Future<List<Map<String, dynamic>>> getAlarmHistory(
    String deviceId, {
    int limit = 100,
  }) async {
    _validateDeviceId(deviceId);
    return getList(
      '$_baseUrl/$deviceId/alarms?limit=$limit',
      (json) => json,
    );
  }

  @override
  Future<void> resetAlarm(String deviceId) async {
    _validateDeviceId(deviceId);
    await postVoid('$_baseUrl/$deviceId/alarm-reset');
  }

  // ===========================================================================
  // SENSORS
  // ===========================================================================

  @override
  Future<void> setQuickSensors(String deviceId, List<String> sensors) async {
    _validateDeviceId(deviceId);
    await patchVoid(
      '$_baseUrl/$deviceId/quick-sensors',
      {'quickSensors': sensors},
    );
  }

  // ===========================================================================
  // LOGS
  // ===========================================================================

  @override
  Future<Map<String, dynamic>> getDeviceLogs(
    String deviceId, {
    int limit = 100,
    int offset = 0,
  }) async {
    _validateDeviceId(deviceId);
    return getRaw('$_baseUrl/$deviceId/logs?limit=$limit&offset=$offset');
  }

  // ===========================================================================
  // TIME SETTING
  // ===========================================================================

  /// Установить время на устройстве
  Future<void> setDeviceTime(String deviceId, DateTime time) async {
    _validateDeviceId(deviceId);
    await postVoid(
      '$_baseUrl/$deviceId/time-setting',
      {'time': time.toIso8601String()},
    );
  }

  // ===========================================================================
  // PRIVATE HELPERS
  // ===========================================================================

  /// Валидация deviceId
  void _validateDeviceId(String deviceId) {
    if (deviceId.isEmpty) {
      throw ArgumentError('deviceId cannot be empty');
    }
  }
}
