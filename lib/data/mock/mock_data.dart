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
  // SCHEDULE DATA (расписание по устройствам)
  // ============================================

  /// Расписание для всех устройств
  static const Map<String, List<Map<String, dynamic>>> schedules = {
    'pv_1': [
      {
        'id': 'sch_1_1',
        'day': 'Понедельник',
        'mode': 'Охлаждение',
        'timeRange': '08:00 - 22:00',
        'tempDay': 22,
        'tempNight': 19,
        'isActive': true,
      },
      {
        'id': 'sch_1_2',
        'day': 'Вторник',
        'mode': 'Авто',
        'timeRange': '08:00 - 22:00',
        'tempDay': 22,
        'tempNight': 19,
        'isActive': false,
      },
      {
        'id': 'sch_1_3',
        'day': 'Среда',
        'mode': 'Охлаждение',
        'timeRange': '08:00 - 22:00',
        'tempDay': 21,
        'tempNight': 18,
        'isActive': false,
      },
      {
        'id': 'sch_1_4',
        'day': 'Четверг',
        'mode': 'Эко',
        'timeRange': '09:00 - 21:00',
        'tempDay': 23,
        'tempNight': 20,
        'isActive': false,
      },
      {
        'id': 'sch_1_5',
        'day': 'Пятница',
        'mode': 'Авто',
        'timeRange': '08:00 - 23:00',
        'tempDay': 22,
        'tempNight': 19,
        'isActive': false,
      },
    ],
    'pv_2': [
      {
        'id': 'sch_2_1',
        'day': 'Понедельник',
        'mode': 'Эко',
        'timeRange': '09:00 - 18:00',
        'tempDay': 20,
        'tempNight': 18,
        'isActive': true,
      },
    ],
    'pv_3': [
      {
        'id': 'sch_3_1',
        'day': 'Понедельник',
        'mode': 'Турбо',
        'timeRange': '06:00 - 22:00',
        'tempDay': 24,
        'tempNight': 20,
        'isActive': true,
      },
    ],
    'pv_4': [
      {
        'id': 'sch_4_1',
        'day': 'Понедельник',
        'mode': 'Ночь',
        'timeRange': '22:00 - 08:00',
        'tempDay': 21,
        'tempNight': 19,
        'isActive': true,
      },
    ],
  };

  // ============================================
  // UNIT NOTIFICATIONS (уведомления с привязкой к устройству)
  // ============================================

  /// Уведомления для устройств (с deviceId и временными метками)
  static const List<Map<String, dynamic>> unitNotifications = [
    {
      'id': 'notif_1',
      'deviceId': 'pv_1',
      'title': 'Замена фильтра',
      'message': 'Рекомендуется заменить фильтр в течение 7 дней',
      'type': 'warning',
      'hoursAgo': 2,
      'isRead': false,
    },
    {
      'id': 'notif_2',
      'deviceId': 'pv_1',
      'title': 'Температура достигнута',
      'message': 'Целевая температура 22°C достигнута',
      'type': 'success',
      'hoursAgo': 5,
      'isRead': true,
    },
    {
      'id': 'notif_3',
      'deviceId': null,
      'title': 'Обновление системы',
      'message': 'Доступна новая версия прошивки v2.1.4',
      'type': 'info',
      'hoursAgo': 24,
      'isRead': false,
    },
    {
      'id': 'notif_4',
      'deviceId': 'pv_2',
      'title': 'Устройство выключено',
      'message': 'ПВ-2 выключено по расписанию',
      'type': 'info',
      'hoursAgo': 1,
      'isRead': true,
    },
    {
      'id': 'notif_5',
      'deviceId': 'pv_3',
      'title': 'Высокая нагрузка',
      'message': 'Вентилятор работает на максимальной мощности',
      'type': 'warning',
      'hoursAgo': 3,
      'isRead': false,
    },
  ];

  // ============================================
  // GRAPH DATA TEMPLATES (шаблоны данных графиков)
  // ============================================

  /// Базовые данные для графиков (по дням недели)
  static const List<Map<String, dynamic>> graphDataTemplate = [
    {'label': 'Пн', 'baseTemp': 21, 'baseHumidity': 45, 'baseAirflow': 400},
    {'label': 'Вт', 'baseTemp': 22, 'baseHumidity': 48, 'baseAirflow': 420},
    {'label': 'Ср', 'baseTemp': 20, 'baseHumidity': 42, 'baseAirflow': 380},
    {'label': 'Чт', 'baseTemp': 23, 'baseHumidity': 50, 'baseAirflow': 450},
    {'label': 'Пт', 'baseTemp': 22, 'baseHumidity': 47, 'baseAirflow': 410},
    {'label': 'Сб', 'baseTemp': 19, 'baseHumidity': 44, 'baseAirflow': 360},
    {'label': 'Вс', 'baseTemp': 21, 'baseHumidity': 46, 'baseAirflow': 400},
  ];

  // ============================================
  // HVAC MODES (режимы работы)
  // ============================================

  /// Режимы работы HVAC
  static const List<Map<String, dynamic>> hvacModes = [
    {'id': 'auto', 'label': 'АВТО', 'icon': 'bolt'},
    {'id': 'eco', 'label': 'ЭКО', 'icon': 'wb_sunny_outlined'},
    {'id': 'night', 'label': 'НОЧЬ', 'icon': 'nightlight_outlined'},
    {'id': 'boost', 'label': 'ТУРБО', 'icon': 'air'},
  ];

  // ============================================
  // USER PRESETS (пользовательские пресеты)
  // ============================================

  /// Пресеты пользователя
  static const List<Map<String, dynamic>> userPresets = [
    {
      'id': 'comfort',
      'name': 'Комфорт',
      'description': 'Оптимальный режим',
      'icon': 'spa_outlined',
      'temperature': 22,
      'airflow': 60,
      'color': 0xFF2D7DFF,
    },
    {
      'id': 'eco',
      'name': 'Эко',
      'description': 'Энергосбережение',
      'icon': 'eco_outlined',
      'temperature': 20,
      'airflow': 40,
      'color': 0xFF22C55E,
    },
    {
      'id': 'night',
      'name': 'Ночь',
      'description': 'Тихий режим',
      'icon': 'nightlight_outlined',
      'temperature': 19,
      'airflow': 30,
      'color': 0xFF8B5CF6,
    },
    {
      'id': 'turbo',
      'name': 'Турбо',
      'description': 'Максимальная мощность',
      'icon': 'bolt_outlined',
      'temperature': 18,
      'airflow': 100,
      'color': 0xFFF97316,
    },
    {
      'id': 'away',
      'name': 'Нет дома',
      'description': 'Минимальный режим',
      'icon': 'home_outlined',
      'temperature': 16,
      'airflow': 20,
      'color': 0xFF64748B,
    },
    {
      'id': 'sleep',
      'name': 'Сон',
      'description': 'Комфортный сон',
      'icon': 'bedtime_outlined',
      'temperature': 20,
      'airflow': 25,
      'color': 0xFF6366F1,
    },
  ];

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
