/// Централизованное хранилище мок-данных
/// Все моки в одном месте для удобства редактирования
library;

/// JSON-подобная структура всех мок-данных приложения
abstract class MockData {
  /// HVAC устройства для быстрого переключения на дашборде
  static const List<Map<String, dynamic>> devices = [
    {
      'id': 'pv_1',
      'name': 'ПВ-1',
      'type': 'ventilation',
      'isOn': true,
      'roomId': 'living_room',
      'powerConsumption': 0.8,
      'activeHours': 12,
    },
    {
      'id': 'pv_2',
      'name': 'ПВ-2',
      'type': 'ventilation',
      'isOn': false,
      'roomId': 'bedroom',
      'powerConsumption': 0.6,
      'activeHours': 8,
    },
    {
      'id': 'pv_3',
      'name': 'ПВ-3',
      'type': 'ventilation',
      'isOn': true,
      'roomId': 'office',
      'powerConsumption': 0.7,
      'activeHours': 6,
    },
  ];

  /// HVAC устройства с полным состоянием климата
  static const List<Map<String, dynamic>> hvacDevices = [
    {
      'id': 'zilon-1',
      'brand': 'ZILON',
      'type': 'Приточная установка',
      'icon': 'air',
      'isOnline': true,
      'climate': {
        'roomId': 'main',
        'deviceName': 'ZILON ZPE-6000',
        'currentTemperature': 21.5,
        'targetTemperature': 22.0,
        'humidity': 58.0,
        'targetHumidity': 50.0,
        'supplyAirflow': 65.0,
        'exhaustAirflow': 50.0,
        'mode': 'auto',
        'preset': 'auto',
        'airQuality': 'good',
        'co2Ppm': 720,
        'pollutantsAqi': 45,
        'isOn': true,
      },
    },
    {
      'id': 'lg-1',
      'brand': 'LG',
      'type': 'Сплит-система',
      'icon': 'ac_unit',
      'isOnline': true,
      'climate': {
        'roomId': 'bedroom',
        'deviceName': 'LG Dual Inverter',
        'currentTemperature': 24.0,
        'targetTemperature': 23.0,
        'humidity': 45.0,
        'targetHumidity': 45.0,
        'supplyAirflow': 40.0,
        'exhaustAirflow': 0.0,
        'mode': 'cooling',
        'preset': 'auto',
        'airQuality': 'excellent',
        'co2Ppm': 520,
        'pollutantsAqi': 25,
        'isOn': false,
      },
    },
    {
      'id': 'xiaomi-1',
      'brand': 'Xiaomi',
      'type': 'Увлажнитель',
      'icon': 'water_drop',
      'isOnline': false,
      'climate': {
        'roomId': 'living',
        'deviceName': 'Xiaomi Mi Humidifier',
        'currentTemperature': 22.0,
        'targetTemperature': 22.0,
        'humidity': 52.0,
        'targetHumidity': 55.0,
        'supplyAirflow': 30.0,
        'exhaustAirflow': 0.0,
        'mode': 'ventilation',
        'preset': 'auto',
        'airQuality': 'good',
        'co2Ppm': 650,
        'pollutantsAqi': 38,
        'isOn': false,
      },
    },
  ];

  /// Потребление энергии по устройствам
  static const List<Map<String, dynamic>> energyUsage = [
    {
      'deviceId': 'pv_1',
      'deviceName': 'ПВ-1',
      'deviceType': 'ventilation',
      'unitCount': 1,
      'totalKwh': 18.0,
    },
    {
      'deviceId': 'pv_2',
      'deviceName': 'ПВ-2',
      'deviceType': 'ventilation',
      'unitCount': 1,
      'totalKwh': 14.0,
    },
    {
      'deviceId': 'pv_3',
      'deviceName': 'ПВ-3',
      'deviceType': 'ventilation',
      'unitCount': 1,
      'totalKwh': 16.0,
    },
  ];

  /// Жители/пользователи системы
  static const List<Map<String, dynamic>> occupants = [
    {'id': 'occ_1', 'name': 'Иван', 'isHome': true, 'avatarUrl': null},
    {'id': 'occ_2', 'name': 'Мария', 'isHome': true, 'avatarUrl': null},
    {'id': 'occ_3', 'name': 'Алексей', 'isHome': false, 'avatarUrl': null},
    {'id': 'occ_4', 'name': 'Ольга', 'isHome': true, 'avatarUrl': null},
    {'id': 'occ_5', 'name': 'Дмитрий', 'isHome': false, 'avatarUrl': null},
  ];

  /// Комнаты
  static const List<Map<String, dynamic>> rooms = [
    {'id': 'living_room', 'name': 'Гостиная', 'deviceCount': 3},
    {'id': 'bedroom', 'name': 'Спальня', 'deviceCount': 2},
    {'id': 'kitchen', 'name': 'Кухня', 'deviceCount': 1},
    {'id': 'office', 'name': 'Офис', 'deviceCount': 2},
  ];

  /// Пресеты климата
  static const Map<String, Map<String, dynamic>> climatePresets = {
    'auto': {
      'mode': 'auto',
    },
    'night': {
      'targetTemperature': 19.0,
      'supplyAirflow': 30.0,
      'exhaustAirflow': 25.0,
    },
    'turbo': {
      'supplyAirflow': 100.0,
      'exhaustAirflow': 90.0,
    },
    'eco': {
      'targetTemperature': 20.0,
      'supplyAirflow': 40.0,
      'exhaustAirflow': 35.0,
    },
    'away': {
      'targetTemperature': 16.0,
      'supplyAirflow': 20.0,
      'exhaustAirflow': 15.0,
    },
  };

  /// Задержки для имитации сети (мс)
  static const Map<String, int> networkDelays = {
    'fast': 100,
    'normal': 200,
    'slow': 300,
    'load': 400,
  };
}
