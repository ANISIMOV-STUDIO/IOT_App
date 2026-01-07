/// Кеширующая обёртка для ClimateRepository
///
/// Использует паттерн Decorator:
/// - При наличии сети: получает данные из API и кеширует
/// - При отсутствии сети: возвращает данные из кеша
/// - Операции управления требуют сети (выбрасывают OfflineException)
library;

import '../../core/error/offline_exception.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/alarm_info.dart';
import '../../domain/entities/climate.dart';
import '../../domain/entities/hvac_device.dart';
import '../../domain/entities/device_full_state.dart';
import '../../domain/repositories/climate_repository.dart';

/// Кеширующий декоратор для ClimateRepository
class CachedClimateRepository implements ClimateRepository {
  final ClimateRepository _inner;
  final CacheService _cacheService;
  final ConnectivityService _connectivity;

  CachedClimateRepository({
    required ClimateRepository inner,
    required CacheService cacheService,
    required ConnectivityService connectivity,
  })  : _inner = inner,
        _cacheService = cacheService,
        _connectivity = connectivity;

  // ============================================
  // HVAC DEVICES (read-only, кешируемые)
  // ============================================

  @override
  Future<List<HvacDevice>> getAllHvacDevices() async {
    if (_connectivity.isOnline) {
      try {
        final devices = await _inner.getAllHvacDevices();
        await _cacheService.cacheHvacDevices(devices);
        return devices;
      } catch (e) {
        // При ошибке сети — пробуем кеш
        final cached = _cacheService.getCachedHvacDevices();
        if (cached != null) return cached;
        rethrow;
      }
    }

    // Offline — возвращаем из кеша
    final cached = _cacheService.getCachedHvacDevices();
    if (cached != null) return cached;

    throw const OfflineException(
      'Нет сохранённых устройств',
      operation: 'getAllHvacDevices',
    );
  }

  @override
  Stream<List<HvacDevice>> watchHvacDevices() {
    // Стрим передаём напрямую — он сам обработает подключение
    return _inner.watchHvacDevices();
  }

  @override
  void setSelectedDevice(String deviceId) {
    _inner.setSelectedDevice(deviceId);
  }

  // ============================================
  // CLIMATE STATE (read-only, кешируемые)
  // ============================================

  @override
  Future<ClimateState> getDeviceState(String deviceId) async {
    if (_connectivity.isOnline) {
      try {
        final state = await _inner.getDeviceState(deviceId);
        await _cacheService.cacheClimateState(state, deviceId: deviceId);
        return state;
      } catch (e) {
        final cached = _cacheService.getCachedClimateState(deviceId: deviceId);
        if (cached != null) return cached;
        rethrow;
      }
    }

    final cached = _cacheService.getCachedClimateState(deviceId: deviceId);
    if (cached != null) return cached;

    throw OfflineException(
      'Нет сохранённого состояния для $deviceId',
      operation: 'getDeviceState',
    );
  }

  @override
  Stream<ClimateState> watchDeviceClimate(String deviceId) {
    return _inner.watchDeviceClimate(deviceId);
  }

  @override
  Future<ClimateState> getCurrentState() async {
    if (_connectivity.isOnline) {
      try {
        final state = await _inner.getCurrentState();
        await _cacheService.cacheClimateState(state);
        return state;
      } catch (e) {
        final cached = _cacheService.getCachedClimateState();
        if (cached != null) return cached;
        rethrow;
      }
    }

    final cached = _cacheService.getCachedClimateState();
    if (cached != null) return cached;

    throw const OfflineException(
      'Нет сохранённого состояния климата',
      operation: 'getCurrentState',
    );
  }

  @override
  Stream<ClimateState> watchClimate() {
    return _inner.watchClimate();
  }

  // ============================================
  // CONTROL OPERATIONS (требуют сети)
  // ============================================

  @override
  Future<ClimateState> setPower(bool isOn, {String? deviceId}) async {
    _ensureOnline('setPower');
    final result = await _inner.setPower(isOn, deviceId: deviceId);
    await _cacheService.cacheClimateState(result, deviceId: deviceId);
    return result;
  }

  @override
  Future<ClimateState> setTargetTemperature(double temperature, {String? deviceId}) async {
    _ensureOnline('setTargetTemperature');
    final result = await _inner.setTargetTemperature(temperature, deviceId: deviceId);
    await _cacheService.cacheClimateState(result, deviceId: deviceId);
    return result;
  }

  @override
  Future<ClimateState> setHeatingTemperature(int temperature, {String? deviceId}) async {
    _ensureOnline('setHeatingTemperature');
    final result = await _inner.setHeatingTemperature(temperature, deviceId: deviceId);
    await _cacheService.cacheClimateState(result, deviceId: deviceId);
    return result;
  }

  @override
  Future<ClimateState> setCoolingTemperature(int temperature, {String? deviceId}) async {
    _ensureOnline('setCoolingTemperature');
    final result = await _inner.setCoolingTemperature(temperature, deviceId: deviceId);
    await _cacheService.cacheClimateState(result, deviceId: deviceId);
    return result;
  }

  @override
  Future<ClimateState> setHumidity(double humidity, {String? deviceId}) async {
    _ensureOnline('setHumidity');
    final result = await _inner.setHumidity(humidity, deviceId: deviceId);
    await _cacheService.cacheClimateState(result, deviceId: deviceId);
    return result;
  }

  @override
  Future<ClimateState> setMode(ClimateMode mode, {String? deviceId}) async {
    _ensureOnline('setMode');
    final result = await _inner.setMode(mode, deviceId: deviceId);
    await _cacheService.cacheClimateState(result, deviceId: deviceId);
    return result;
  }

  @override
  Future<ClimateState> setSupplyAirflow(double value, {String? deviceId}) async {
    _ensureOnline('setSupplyAirflow');
    final result = await _inner.setSupplyAirflow(value, deviceId: deviceId);
    await _cacheService.cacheClimateState(result, deviceId: deviceId);
    return result;
  }

  @override
  Future<ClimateState> setExhaustAirflow(double value, {String? deviceId}) async {
    _ensureOnline('setExhaustAirflow');
    final result = await _inner.setExhaustAirflow(value, deviceId: deviceId);
    await _cacheService.cacheClimateState(result, deviceId: deviceId);
    return result;
  }

  @override
  Future<ClimateState> setPreset(String preset, {String? deviceId}) async {
    _ensureOnline('setPreset');
    final result = await _inner.setPreset(preset, deviceId: deviceId);
    await _cacheService.cacheClimateState(result, deviceId: deviceId);
    return result;
  }

  @override
  Future<ClimateState> setOperatingMode(String mode, {String? deviceId}) async {
    _ensureOnline('setOperatingMode');
    final result = await _inner.setOperatingMode(mode, deviceId: deviceId);
    await _cacheService.cacheClimateState(result, deviceId: deviceId);
    return result;
  }

  @override
  Future<HvacDevice> registerDevice(String macAddress, String name) async {
    _ensureOnline('registerDevice');
    final result = await _inner.registerDevice(macAddress, name);
    // Обновляем кеш устройств после регистрации
    final devices = await _inner.getAllHvacDevices();
    await _cacheService.cacheHvacDevices(devices);
    return result;
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    _ensureOnline('deleteDevice');
    await _inner.deleteDevice(deviceId);
    // Обновляем кеш устройств после удаления
    final devices = await _inner.getAllHvacDevices();
    await _cacheService.cacheHvacDevices(devices);
  }

  @override
  Future<void> renameDevice(String deviceId, String newName) async {
    _ensureOnline('renameDevice');
    await _inner.renameDevice(deviceId, newName);
    // Обновляем кеш устройств после переименования
    final devices = await _inner.getAllHvacDevices();
    await _cacheService.cacheHvacDevices(devices);
  }

  // ============================================
  // FULL STATE
  // ============================================

  @override
  Future<DeviceFullState> getDeviceFullState(String deviceId) async {
    // Полное состояние пока не кешируем — делегируем во inner
    // TODO: Добавить кеширование при необходимости
    return await _inner.getDeviceFullState(deviceId);
  }

  // ============================================
  // ALARM HISTORY
  // ============================================

  @override
  Future<List<AlarmHistory>> getAlarmHistory(
    String deviceId, {
    int limit = 100,
  }) async {
    // История аварий — делегируем во inner (требует сети)
    return await _inner.getAlarmHistory(deviceId, limit: limit);
  }

  // ============================================
  // HELPERS
  // ============================================

  /// Проверить наличие сети, выбросить OfflineException если offline
  void _ensureOnline(String operation) {
    if (!_connectivity.isOnline) {
      throw OfflineException(
        'Управление устройством недоступно без сети',
        operation: operation,
      );
    }
  }
}
