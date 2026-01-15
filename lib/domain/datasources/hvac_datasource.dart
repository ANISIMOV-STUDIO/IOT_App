/// HVAC Data Source Interface (DIP - Dependency Inversion)
///
/// Абстракция для работы с HVAC устройствами.
/// Позволяет подменять реализацию (HTTP, Mock, gRPC).
library;

/// Интерфейс для операций с HVAC устройствами
///
/// Разделён на логические группы методов (ISP):
/// - Device CRUD
/// - Power & Mode
/// - Temperature & Fans
/// - Timer & Schedule
/// - Alarms
/// - Sensors
abstract class IHvacDataSource {
  // ===========================================================================
  // DEVICE CRUD
  // ===========================================================================

  /// Получить список всех устройств
  Future<List<Map<String, dynamic>>> listDevices();

  /// Получить устройство по ID
  Future<Map<String, dynamic>> getDevice(String deviceId);

  /// Зарегистрировать новое устройство
  Future<Map<String, dynamic>> registerDevice(String macAddress, String name);

  /// Удалить устройство
  Future<void> deleteDevice(String deviceId);

  /// Переименовать устройство
  Future<void> renameDevice(String deviceId, String newName);

  // ===========================================================================
  // POWER & MODE
  // ===========================================================================

  /// Включить/выключить устройство
  Future<Map<String, dynamic>> setPower(String deviceId, bool power);

  /// Установить режим работы
  Future<Map<String, dynamic>> setMode(String deviceId, String mode);

  /// Установить настройки режима
  Future<void> setModeSettings(
    String deviceId, {
    required String modeName,
    required int supplyFan,
    required int exhaustFan,
    required int heatingTemperature,
    required int coolingTemperature,
  });

  // ===========================================================================
  // TEMPERATURE & FANS
  // ===========================================================================

  /// Обновить настройки устройства
  Future<Map<String, dynamic>> updateDevice(
    String deviceId, {
    int? heatingTemperature,
    int? coolingTemperature,
    int? supplyFan,
    int? exhaustFan,
  });

  /// Установить температуру нагрева
  Future<void> setHeatingTemperature(
    String deviceId,
    int temperature, {
    required String modeName,
  });

  /// Установить температуру охлаждения
  Future<void> setCoolingTemperature(
    String deviceId,
    int temperature, {
    required String modeName,
  });

  /// Установить скорость приточного вентилятора
  Future<void> setSupplyFan(
    String deviceId,
    int fanSpeed, {
    required String modeName,
  });

  /// Установить скорость вытяжного вентилятора
  Future<void> setExhaustFan(
    String deviceId,
    int fanSpeed, {
    required String modeName,
  });

  // ===========================================================================
  // TIMER & SCHEDULE
  // ===========================================================================

  /// Установить настройки таймера для дня недели
  Future<void> setTimerSettings(
    String deviceId, {
    required String day,
    required int onHour,
    required int onMinute,
    required int offHour,
    required int offMinute,
    required bool enabled,
  });

  /// Получить время устройства
  Future<Map<String, dynamic>> getDeviceTime(String deviceId);

  // ===========================================================================
  // ALARMS
  // ===========================================================================

  /// Получить историю аварий
  Future<List<Map<String, dynamic>>> getAlarmHistory(
    String deviceId, {
    int limit = 100,
  });

  /// Сбросить аварию
  Future<void> resetAlarm(String deviceId);

  // ===========================================================================
  // SENSORS
  // ===========================================================================

  /// Установить быстрые показатели для главного экрана
  Future<void> setQuickSensors(String deviceId, List<String> sensors);
}
