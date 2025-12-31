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
import '../../domain/entities/climate.dart';
import '../../domain/entities/hvac_device.dart';
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
