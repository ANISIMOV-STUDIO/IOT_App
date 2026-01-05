/// Сервис кеширования данных в Hive
///
/// Обеспечивает:
/// - Единое хранилище для всех типов данных
/// - Автоматическое управление TTL (time-to-live)
/// - Методы для работы с климатом, устройствами, расписанием и др.
library;

import 'package:hive_flutter/hive_flutter.dart';

import '../config/app_constants.dart';
import '../../domain/entities/climate.dart';
import '../../domain/entities/hvac_device.dart';
import '../../domain/entities/smart_device.dart';
import '../../domain/entities/energy_stats.dart';
import '../../domain/entities/schedule_entry.dart';
import '../../domain/entities/unit_notification.dart';
import '../../domain/entities/graph_data.dart';

/// Ключи для Hive боксов
class CacheKeys {
  static const String climateBox = 'climate_cache';
  static const String devicesBox = 'devices_cache';
  static const String hvacDevicesBox = 'hvac_devices_cache';
  static const String energyBox = 'energy_cache';
  static const String scheduleBox = 'schedule_cache';
  static const String notificationsBox = 'notifications_cache';
  static const String graphDataBox = 'graph_data_cache';
  static const String metadataBox = 'cache_metadata';

  // Ключи внутри боксов
  static const String currentClimate = 'current_climate';
  static const String allDevices = 'all_devices';
  static const String allHvacDevices = 'all_hvac_devices';
  static const String todayEnergy = 'today_energy';
}

/// Метаданные кеша (время сохранения)
class CacheMetadata {
  final DateTime timestamp;
  final Duration ttl;

  CacheMetadata({
    required this.timestamp,
    this.ttl = CacheConstants.defaultTtl,
  });

  /// Кеш истёк?
  bool get isExpired => DateTime.now().difference(timestamp) > ttl;

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'ttlMinutes': ttl.inMinutes,
      };

  factory CacheMetadata.fromJson(Map<String, dynamic> json) => CacheMetadata(
        timestamp: DateTime.parse(json['timestamp'] as String),
        ttl: Duration(minutes: json['ttlMinutes'] as int? ?? 30),
      );
}

/// Сервис для управления кешем приложения
class CacheService {
  late Box<dynamic> _climateBox;
  late Box<dynamic> _devicesBox;
  late Box<dynamic> _hvacDevicesBox;
  late Box<dynamic> _energyBox;
  late Box<dynamic> _scheduleBox;
  late Box<dynamic> _notificationsBox;
  late Box<dynamic> _graphDataBox;
  late Box<dynamic> _metadataBox;

  bool _initialized = false;

  /// Инициализация Hive и открытие боксов
  Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();

    _climateBox = await Hive.openBox(CacheKeys.climateBox);
    _devicesBox = await Hive.openBox(CacheKeys.devicesBox);
    _hvacDevicesBox = await Hive.openBox(CacheKeys.hvacDevicesBox);
    _energyBox = await Hive.openBox(CacheKeys.energyBox);
    _scheduleBox = await Hive.openBox(CacheKeys.scheduleBox);
    _notificationsBox = await Hive.openBox(CacheKeys.notificationsBox);
    _graphDataBox = await Hive.openBox(CacheKeys.graphDataBox);
    _metadataBox = await Hive.openBox(CacheKeys.metadataBox);

    _initialized = true;
  }

  // ============================================
  // CLIMATE CACHE
  // ============================================

  /// Сохранить состояние климата
  Future<void> cacheClimateState(ClimateState climate, {String? deviceId}) async {
    final key = deviceId ?? CacheKeys.currentClimate;
    await _climateBox.put(key, _climateStateToMap(climate));
    await _saveMetadata('climate_$key');
  }

  /// Получить состояние климата из кеша
  ClimateState? getCachedClimateState({String? deviceId}) {
    final key = deviceId ?? CacheKeys.currentClimate;
    if (!_isValidCache('climate_$key')) return null;

    final data = _climateBox.get(key);
    if (data == null) return null;

    return _climateStateFromMap(Map<String, dynamic>.from(data));
  }

  // ============================================
  // HVAC DEVICES CACHE
  // ============================================

  /// Сохранить список HVAC устройств
  Future<void> cacheHvacDevices(List<HvacDevice> devices) async {
    final data = devices.map((d) => _hvacDeviceToMap(d)).toList();
    await _hvacDevicesBox.put(CacheKeys.allHvacDevices, data);
    await _saveMetadata('hvac_devices');
  }

  /// Получить HVAC устройства из кеша
  List<HvacDevice>? getCachedHvacDevices() {
    if (!_isValidCache('hvac_devices')) return null;

    final data = _hvacDevicesBox.get(CacheKeys.allHvacDevices);
    if (data == null) return null;

    return (data as List).map((item) {
      return _hvacDeviceFromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  // ============================================
  // SMART DEVICES CACHE
  // ============================================

  /// Сохранить список smart устройств
  Future<void> cacheSmartDevices(List<SmartDevice> devices) async {
    final data = devices.map((d) => _smartDeviceToMap(d)).toList();
    await _devicesBox.put(CacheKeys.allDevices, data);
    await _saveMetadata('smart_devices');
  }

  /// Получить smart устройства из кеша
  List<SmartDevice>? getCachedSmartDevices() {
    if (!_isValidCache('smart_devices')) return null;

    final data = _devicesBox.get(CacheKeys.allDevices);
    if (data == null) return null;

    return (data as List).map((item) {
      return _smartDeviceFromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  // ============================================
  // ENERGY CACHE
  // ============================================

  /// Сохранить статистику энергопотребления
  Future<void> cacheEnergyStats(EnergyStats stats) async {
    await _energyBox.put(CacheKeys.todayEnergy, _energyStatsToMap(stats));
    await _saveMetadata('energy');
  }

  /// Получить статистику из кеша
  EnergyStats? getCachedEnergyStats() {
    if (!_isValidCache('energy')) return null;

    final data = _energyBox.get(CacheKeys.todayEnergy);
    if (data == null) return null;

    return _energyStatsFromMap(Map<String, dynamic>.from(data));
  }

  // ============================================
  // SCHEDULE CACHE
  // ============================================

  /// Сохранить расписание устройства
  Future<void> cacheSchedule(String deviceId, List<ScheduleEntry> entries) async {
    final data = entries.map((e) => _scheduleEntryToMap(e)).toList();
    await _scheduleBox.put(deviceId, data);
    await _saveMetadata('schedule_$deviceId');
  }

  /// Получить расписание из кеша
  List<ScheduleEntry>? getCachedSchedule(String deviceId) {
    if (!_isValidCache('schedule_$deviceId')) return null;

    final data = _scheduleBox.get(deviceId);
    if (data == null) return null;

    return (data as List).map((item) {
      return _scheduleEntryFromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  // ============================================
  // NOTIFICATIONS CACHE
  // ============================================

  /// Сохранить уведомления
  Future<void> cacheNotifications(List<UnitNotification> notifications, {String? deviceId}) async {
    final key = deviceId ?? 'all';
    final data = notifications.map((n) => _notificationToMap(n)).toList();
    await _notificationsBox.put(key, data);
    await _saveMetadata('notifications_$key');
  }

  /// Получить уведомления из кеша
  List<UnitNotification>? getCachedNotifications({String? deviceId}) {
    final key = deviceId ?? 'all';
    if (!_isValidCache('notifications_$key')) return null;

    final data = _notificationsBox.get(key);
    if (data == null) return null;

    return (data as List).map((item) {
      return _notificationFromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  // ============================================
  // GRAPH DATA CACHE
  // ============================================

  /// Сохранить данные графика
  Future<void> cacheGraphData(
    String deviceId,
    GraphMetric metric,
    List<GraphDataPoint> data,
  ) async {
    final key = '${deviceId}_${metric.name}';
    final mapData = data.map((d) => _graphDataPointToMap(d)).toList();
    await _graphDataBox.put(key, mapData);
    await _saveMetadata('graph_$key');
  }

  /// Получить данные графика из кеша
  List<GraphDataPoint>? getCachedGraphData(String deviceId, GraphMetric metric) {
    final key = '${deviceId}_${metric.name}';
    if (!_isValidCache('graph_$key')) return null;

    final data = _graphDataBox.get(key);
    if (data == null) return null;

    return (data as List).map((item) {
      return _graphDataPointFromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  // ============================================
  // UTILITY METHODS
  // ============================================

  /// Очистить весь кеш
  Future<void> clearAll() async {
    await _climateBox.clear();
    await _devicesBox.clear();
    await _hvacDevicesBox.clear();
    await _energyBox.clear();
    await _scheduleBox.clear();
    await _notificationsBox.clear();
    await _graphDataBox.clear();
    await _metadataBox.clear();
  }

  /// Сохранить метаданные (timestamp)
  Future<void> _saveMetadata(String key) async {
    final metadata = CacheMetadata(timestamp: DateTime.now());
    await _metadataBox.put(key, metadata.toJson());
  }

  /// Проверить валидность кеша (не истёк ли TTL)
  bool _isValidCache(String key) {
    final metaJson = _metadataBox.get(key);
    if (metaJson == null) return false;

    final metadata = CacheMetadata.fromJson(Map<String, dynamic>.from(metaJson));
    return !metadata.isExpired;
  }

  // ============================================
  // SERIALIZATION HELPERS
  // ============================================

  Map<String, dynamic> _climateStateToMap(ClimateState c) => {
        'roomId': c.roomId,
        'deviceName': c.deviceName,
        'currentTemperature': c.currentTemperature,
        'targetTemperature': c.targetTemperature,
        'humidity': c.humidity,
        'targetHumidity': c.targetHumidity,
        'supplyAirflow': c.supplyAirflow,
        'exhaustAirflow': c.exhaustAirflow,
        'mode': c.mode.index,
        'preset': c.preset,
        'airQuality': c.airQuality.index,
        'co2Ppm': c.co2Ppm,
        'pollutantsAqi': c.pollutantsAqi,
        'isOn': c.isOn,
      };

  ClimateState _climateStateFromMap(Map<String, dynamic> m) => ClimateState(
        roomId: m['roomId'] as String,
        deviceName: m['deviceName'] as String? ?? 'HVAC Unit',
        currentTemperature: (m['currentTemperature'] as num).toDouble(),
        targetTemperature: (m['targetTemperature'] as num).toDouble(),
        humidity: (m['humidity'] as num).toDouble(),
        targetHumidity: (m['targetHumidity'] as num?)?.toDouble() ?? 50,
        supplyAirflow: (m['supplyAirflow'] as num?)?.toDouble() ?? 50,
        exhaustAirflow: (m['exhaustAirflow'] as num?)?.toDouble() ?? 40,
        mode: ClimateMode.values[m['mode'] as int],
        preset: m['preset'] as String? ?? 'auto',
        airQuality: AirQualityLevel.values[m['airQuality'] as int],
        co2Ppm: m['co2Ppm'] as int? ?? 400,
        pollutantsAqi: m['pollutantsAqi'] as int? ?? 50,
        isOn: m['isOn'] as bool? ?? true,
      );

  Map<String, dynamic> _hvacDeviceToMap(HvacDevice d) => {
        'id': d.id,
        'name': d.name,
        'brand': d.brand,
        'deviceType': d.deviceType.index,
        'isOnline': d.isOnline,
        'isActive': d.isActive,
      };

  HvacDevice _hvacDeviceFromMap(Map<String, dynamic> m) => HvacDevice(
        id: m['id'] as String,
        name: m['name'] as String,
        brand: m['brand'] as String,
        deviceType: HvacDeviceType.values[m['deviceType'] as int? ?? 0],
        isOnline: m['isOnline'] as bool? ?? true,
        isActive: m['isActive'] as bool? ?? false,
      );

  Map<String, dynamic> _smartDeviceToMap(SmartDevice d) => {
        'id': d.id,
        'name': d.name,
        'type': d.type.index,
        'isOn': d.isOn,
        'roomId': d.roomId,
        'powerConsumption': d.powerConsumption,
        'activeTimeMinutes': d.activeTime.inMinutes,
        'lastUpdated': d.lastUpdated.toIso8601String(),
      };

  SmartDevice _smartDeviceFromMap(Map<String, dynamic> m) => SmartDevice(
        id: m['id'] as String,
        name: m['name'] as String,
        type: SmartDeviceType.values[m['type'] as int],
        isOn: m['isOn'] as bool,
        roomId: m['roomId'] as String?,
        powerConsumption: (m['powerConsumption'] as num?)?.toDouble() ?? 0,
        activeTime: Duration(minutes: m['activeTimeMinutes'] as int? ?? 0),
        lastUpdated: DateTime.parse(m['lastUpdated'] as String),
      );

  Map<String, dynamic> _energyStatsToMap(EnergyStats e) => {
        'totalKwh': e.totalKwh,
        'totalHours': e.totalHours,
        'date': e.date.toIso8601String(),
        'hourlyData': e.hourlyData.map((h) => {'hour': h.hour, 'kwh': h.kwh}).toList(),
      };

  EnergyStats _energyStatsFromMap(Map<String, dynamic> m) => EnergyStats(
        totalKwh: (m['totalKwh'] as num).toDouble(),
        totalHours: m['totalHours'] as int,
        date: DateTime.parse(m['date'] as String),
        hourlyData: (m['hourlyData'] as List?)
                ?.map((h) => HourlyUsage(
                      hour: h['hour'] as int,
                      kwh: (h['kwh'] as num).toDouble(),
                    ))
                .toList() ??
            [],
      );

  Map<String, dynamic> _scheduleEntryToMap(ScheduleEntry e) => {
        'id': e.id,
        'deviceId': e.deviceId,
        'day': e.day,
        'mode': e.mode,
        'timeRange': e.timeRange,
        'tempDay': e.tempDay,
        'tempNight': e.tempNight,
        'isActive': e.isActive,
      };

  ScheduleEntry _scheduleEntryFromMap(Map<String, dynamic> m) => ScheduleEntry(
        id: m['id'] as String,
        deviceId: m['deviceId'] as String,
        day: m['day'] as String,
        mode: m['mode'] as String,
        timeRange: m['timeRange'] as String,
        tempDay: m['tempDay'] as int,
        tempNight: m['tempNight'] as int,
        isActive: m['isActive'] as bool? ?? false,
      );

  Map<String, dynamic> _notificationToMap(UnitNotification n) => {
        'id': n.id,
        'deviceId': n.deviceId,
        'title': n.title,
        'message': n.message,
        'type': n.type.index,
        'timestamp': n.timestamp.toIso8601String(),
        'isRead': n.isRead,
      };

  UnitNotification _notificationFromMap(Map<String, dynamic> m) => UnitNotification(
        id: m['id'] as String,
        deviceId: m['deviceId'] as String?,
        title: m['title'] as String,
        message: m['message'] as String,
        type: NotificationType.values[m['type'] as int],
        timestamp: DateTime.parse(m['timestamp'] as String),
        isRead: m['isRead'] as bool? ?? false,
      );

  Map<String, dynamic> _graphDataPointToMap(GraphDataPoint p) => {
        'label': p.label,
        'value': p.value,
      };

  GraphDataPoint _graphDataPointFromMap(Map<String, dynamic> m) => GraphDataPoint(
        label: m['label'] as String,
        value: (m['value'] as num).toDouble(),
      );
}
