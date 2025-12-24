/// Централизованное хранилище мок-данных
/// Все моки в одном месте для удобства редактирования
library;

/// JSON-подобная структура всех мок-данных приложения
abstract class MockData {
  /// Вентиляционные установки (ПВ)
  static const List<Map<String, dynamic>> units = [
    {
      'id': 'pv_1',
      'name': 'ПВ-1',
      'power': true,
      'temp': 22,
      'supplyFan': 60,
      'exhaustFan': 45,
      'mode': 'auto',
      'humidity': 45,
      'outsideTemp': 18,
      'filterPercent': 88,
      'airflowRate': 420,
    },
    {
      'id': 'pv_2',
      'name': 'ПВ-2',
      'power': false,
      'temp': 20,
      'supplyFan': 30,
      'exhaustFan': 20,
      'mode': 'eco',
      'humidity': 50,
      'outsideTemp': 18,
      'filterPercent': 72,
      'airflowRate': 280,
    },
    {
      'id': 'pv_3',
      'name': 'ПВ-3',
      'power': true,
      'temp': 24,
      'supplyFan': 80,
      'exhaustFan': 70,
      'mode': 'boost',
      'humidity': 40,
      'outsideTemp': 18,
      'filterPercent': 95,
      'airflowRate': 580,
    },
    {
      'id': 'pv_4',
      'name': 'ПВ-4',
      'power': true,
      'temp': 21,
      'supplyFan': 50,
      'exhaustFan': 40,
      'mode': 'night',
      'humidity': 55,
      'outsideTemp': 18,
      'filterPercent': 65,
      'airflowRate': 350,
    },
  ];

  /// Уведомления
  static const List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'type': 'critical',
      'title': 'АВАРИЯ: ПОЖАРНЫЙ КЛАПАН',
      'message': 'Сработал датчик задымления в канале ПВ-1. Система экстренно остановлена.',
      'time': '10:45',
      'unit': 'ПВ-1',
    },
    {
      'id': '2',
      'type': 'warning',
      'title': 'Засорение фильтра',
      'message': 'Ресурс фильтра ПВ-3 менее 10%. Требуется замена.',
      'time': '09:12',
      'unit': 'ПВ-3',
    },
    {
      'id': '3',
      'type': 'critical',
      'title': 'ПЕРЕГРЕВ ДВИГАТЕЛЯ',
      'message': 'Превышена критическая температура обмоток приточного вентилятора.',
      'time': 'Вчера',
      'unit': 'ПВ-2',
    },
    {
      'id': '4',
      'type': 'info',
      'title': 'Обновление ПО',
      'message': 'Система успешно обновлена до версии v2.4.0-stable.',
      'time': '08:00',
      'unit': null,
    },
    {
      'id': '5',
      'type': 'warning',
      'title': 'Низкое давление',
      'message': 'Зафиксировано падение давления в водяном контуре нагревателя.',
      'time': '07:20',
      'unit': 'ПВ-4',
    },
  ];

  /// Жители/пользователи системы
  static const List<Map<String, dynamic>> occupants = [
    {'id': 'occ_1', 'name': 'Алексей Б.', 'role': 'Админ', 'isHome': true},
  ];

  /// Пресеты режимов
  static const Map<String, Map<String, dynamic>> modePresets = {
    'auto': {
      'label': 'АВТО',
      'icon': 'bolt',
    },
    'eco': {
      'label': 'ЭКО',
      'icon': 'sun',
      'supplyFan': 40,
      'exhaustFan': 35,
    },
    'night': {
      'label': 'НОЧЬ',
      'icon': 'moon',
      'supplyFan': 30,
      'exhaustFan': 25,
    },
    'boost': {
      'label': 'ТУРБО',
      'icon': 'air',
      'supplyFan': 100,
      'exhaustFan': 90,
    },
  };

  /// Системная информация
  static const Map<String, dynamic> systemInfo = {
    'version': 'v2.4.0',
    'isOnline': true,
    'outsideTemp': 18,
  };

  /// Задержки для имитации сети (мс)
  static const Map<String, int> networkDelays = {
    'fast': 100,
    'normal': 200,
    'slow': 300,
    'load': 400,
  };

  // ============================================
  // LEGACY DATA (для обратной совместимости с репозиториями)
  // ============================================

  /// HVAC устройства (legacy format для MockClimateRepository)
  static const List<Map<String, dynamic>> hvacDevices = [
    {
      'id': 'pv_1',
      'brand': 'BREEZ',
      'type': 'ventilation',
      'icon': 'air',
      'isOnline': true,
      'climate': {
        'roomId': 'room_1',
        'deviceName': 'ПВ-1',
        'currentTemperature': 22.0,
        'targetTemperature': 22.0,
        'humidity': 45.0,
        'targetHumidity': 50.0,
        'supplyAirflow': 60.0,
        'exhaustAirflow': 45.0,
        'mode': 'auto',
        'preset': 'auto',
        'airQuality': 'good',
        'co2Ppm': 450,
        'pollutantsAqi': 25,
        'isOn': true,
      },
    },
    {
      'id': 'pv_2',
      'brand': 'BREEZ',
      'type': 'ventilation',
      'icon': 'air',
      'isOnline': true,
      'climate': {
        'roomId': 'room_2',
        'deviceName': 'ПВ-2',
        'currentTemperature': 20.0,
        'targetTemperature': 20.0,
        'humidity': 50.0,
        'targetHumidity': 50.0,
        'supplyAirflow': 30.0,
        'exhaustAirflow': 20.0,
        'mode': 'eco',
        'preset': 'eco',
        'airQuality': 'good',
        'co2Ppm': 400,
        'pollutantsAqi': 20,
        'isOn': false,
      },
    },
  ];

  /// Пресеты климата (legacy format для MockClimateRepository)
  static const Map<String, Map<String, dynamic>> climatePresets = {
    'auto': {
      'mode': 'auto',
    },
    'eco': {
      'mode': 'eco',
      'supplyAirflow': 40.0,
      'exhaustAirflow': 35.0,
    },
    'night': {
      'mode': 'night',
      'supplyAirflow': 30.0,
      'exhaustAirflow': 25.0,
      'targetTemperature': 20.0,
    },
    'boost': {
      'mode': 'boost',
      'supplyAirflow': 100.0,
      'exhaustAirflow': 90.0,
    },
  };

  /// Энергопотребление (legacy format для MockEnergyRepository)
  static const List<Map<String, dynamic>> energyUsage = [
    {
      'deviceId': 'pv_1',
      'deviceName': 'ПВ-1',
      'deviceType': 'ventilation',
      'unitCount': 1,
      'totalKwh': 12.5,
    },
    {
      'deviceId': 'pv_2',
      'deviceName': 'ПВ-2',
      'deviceType': 'ventilation',
      'unitCount': 1,
      'totalKwh': 8.2,
    },
    {
      'deviceId': 'pv_3',
      'deviceName': 'ПВ-3',
      'deviceType': 'ventilation',
      'unitCount': 1,
      'totalKwh': 15.8,
    },
    {
      'deviceId': 'pv_4',
      'deviceName': 'ПВ-4',
      'deviceType': 'ventilation',
      'unitCount': 1,
      'totalKwh': 10.3,
    },
  ];

  /// Устройства (legacy format для MockSmartDeviceRepository)
  static const List<Map<String, dynamic>> devices = [
    {
      'id': 'pv_1',
      'name': 'ПВ-1',
      'type': 'ventilation',
      'isOn': true,
      'roomId': 'room_1',
      'powerConsumption': 250.0,
      'activeHours': 8,
    },
    {
      'id': 'pv_2',
      'name': 'ПВ-2',
      'type': 'ventilation',
      'isOn': false,
      'roomId': 'room_2',
      'powerConsumption': 200.0,
      'activeHours': 4,
    },
    {
      'id': 'pv_3',
      'name': 'ПВ-3',
      'type': 'ventilation',
      'isOn': true,
      'roomId': 'room_3',
      'powerConsumption': 300.0,
      'activeHours': 12,
    },
    {
      'id': 'pv_4',
      'name': 'ПВ-4',
      'type': 'ventilation',
      'isOn': true,
      'roomId': 'room_4',
      'powerConsumption': 220.0,
      'activeHours': 6,
    },
  ];
}
