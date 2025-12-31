/// Кеширующая обёртка для SmartDeviceRepository
///
/// Паттерн Decorator для offline поддержки:
/// - Чтение: онлайн → кеш, оффлайн → кеш
/// - Управление: только онлайн
library;

import '../../core/error/offline_exception.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/smart_device.dart';
import '../../domain/repositories/smart_device_repository.dart';

/// Кеширующий декоратор для SmartDeviceRepository
class CachedSmartDeviceRepository implements SmartDeviceRepository {
  final SmartDeviceRepository _inner;
  final CacheService _cacheService;
  final ConnectivityService _connectivity;

  CachedSmartDeviceRepository({
    required SmartDeviceRepository inner,
    required CacheService cacheService,
    required ConnectivityService connectivity,
  })  : _inner = inner,
        _cacheService = cacheService,
        _connectivity = connectivity;

  // ============================================
  // READ OPERATIONS (кешируемые)
  // ============================================

  @override
  Future<List<SmartDevice>> getAllDevices() async {
    if (_connectivity.isOnline) {
      try {
        final devices = await _inner.getAllDevices();
        await _cacheService.cacheSmartDevices(devices);
        return devices;
      } catch (e) {
        final cached = _cacheService.getCachedSmartDevices();
        if (cached != null) return cached;
        rethrow;
      }
    }

    final cached = _cacheService.getCachedSmartDevices();
    if (cached != null) return cached;

    throw const OfflineException(
      'Нет сохранённых устройств',
      operation: 'getAllDevices',
    );
  }

  @override
  Future<List<SmartDevice>> getDevicesByRoom(String roomId) async {
    // Фильтруем из общего списка
    final allDevices = await getAllDevices();
    return allDevices.where((d) => d.roomId == roomId).toList();
  }

  @override
  Future<SmartDevice?> getDeviceById(String id) async {
    final allDevices = await getAllDevices();
    try {
      return allDevices.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<List<SmartDevice>> watchDevices() {
    return _inner.watchDevices();
  }

  // ============================================
  // WRITE OPERATIONS (требуют сети)
  // ============================================

  @override
  Future<SmartDevice> toggleDevice(String id, bool isOn) async {
    _ensureOnline('toggleDevice');
    final result = await _inner.toggleDevice(id, isOn);
    // Обновляем кеш
    await _updateDeviceInCache(result);
    return result;
  }

  @override
  Future<SmartDevice> updateDevice(SmartDevice device) async {
    _ensureOnline('updateDevice');
    final result = await _inner.updateDevice(device);
    await _updateDeviceInCache(result);
    return result;
  }

  // ============================================
  // HELPERS
  // ============================================

  void _ensureOnline(String operation) {
    if (!_connectivity.isOnline) {
      throw OfflineException(
        'Управление устройством недоступно без сети',
        operation: operation,
      );
    }
  }

  /// Обновить одно устройство в кеше
  Future<void> _updateDeviceInCache(SmartDevice updated) async {
    final cached = _cacheService.getCachedSmartDevices();
    if (cached == null) return;

    final updatedList = cached.map((d) {
      return d.id == updated.id ? updated : d;
    }).toList();

    await _cacheService.cacheSmartDevices(updatedList);
  }
}
