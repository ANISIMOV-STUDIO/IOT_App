/// Кеширующая обёртка для ScheduleRepository
///
/// Расписание: чтение кешируется, изменения требуют сети.
library;

import 'package:hvac_control/core/error/offline_exception.dart';
import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/core/services/cache_service.dart';
import 'package:hvac_control/core/services/connectivity_service.dart';
import 'package:hvac_control/domain/entities/schedule_entry.dart';
import 'package:hvac_control/domain/repositories/schedule_repository.dart';

/// Кеширующий декоратор для ScheduleRepository
class CachedScheduleRepository implements ScheduleRepository {

  CachedScheduleRepository({
    required ScheduleRepository inner,
    required CacheService cacheService,
    required ConnectivityService connectivity,
  })  : _inner = inner,
        _cacheService = cacheService,
        _connectivity = connectivity;
  final ScheduleRepository _inner;
  final CacheService _cacheService;
  final ConnectivityService _connectivity;

  // ============================================
  // READ OPERATIONS (кешируемые)
  // ============================================

  @override
  Future<List<ScheduleEntry>> getSchedule(String deviceId) async {
    if (_connectivity.isOnline) {
      try {
        final schedule = await _inner.getSchedule(deviceId);
        await _cacheService.cacheSchedule(deviceId, schedule);
        return schedule;
      } catch (e) {
        final cached = _cacheService.getCachedSchedule(deviceId);
        if (cached != null) {
          return cached;
        }
        rethrow;
      }
    }

    final cached = _cacheService.getCachedSchedule(deviceId);
    if (cached != null) {
      return cached;
    }

    throw OfflineException(
      'Нет сохранённого расписания для $deviceId',
      operation: 'getSchedule',
    );
  }

  @override
  Stream<List<ScheduleEntry>> watchSchedule(String deviceId) =>
    _inner.watchSchedule(deviceId);

  // ============================================
  // WRITE OPERATIONS (требуют сети)
  // ============================================

  @override
  Future<ScheduleEntry> addEntry(ScheduleEntry entry) async {
    _ensureOnline('addEntry');
    final result = await _inner.addEntry(entry);
    // Инвалидируем кеш — перезагрузим при следующем запросе
    await _refreshCache(entry.deviceId);
    return result;
  }

  @override
  Future<ScheduleEntry> updateEntry(ScheduleEntry entry) async {
    _ensureOnline('updateEntry');
    final result = await _inner.updateEntry(entry);
    await _refreshCache(entry.deviceId);
    return result;
  }

  @override
  Future<void> deleteEntry(String entryId) async {
    _ensureOnline('deleteEntry');
    await _inner.deleteEntry(entryId);
    // Кеш нельзя обновить без deviceId, будет обновлён при следующем getSchedule
  }

  @override
  Future<ScheduleEntry> toggleEntry(String entryId, {required bool isActive}) async {
    _ensureOnline('toggleEntry');
    final result = await _inner.toggleEntry(entryId, isActive: isActive);
    await _refreshCache(result.deviceId);
    return result;
  }

  // ============================================
  // HELPERS
  // ============================================

  void _ensureOnline(String operation) {
    if (!_connectivity.isOnline) {
      throw OfflineException(
        'Изменение расписания недоступно без сети',
        operation: operation,
      );
    }
  }

  /// Обновить кеш расписания
  Future<void> _refreshCache(String deviceId) async {
    try {
      final schedule = await _inner.getSchedule(deviceId);
      await _cacheService.cacheSchedule(deviceId, schedule);
    } catch (e) {
      // Ошибки фонового обновления кеша не критичны
      ApiLogger.debug('[ScheduleCache] Ошибка обновления кеша', e);
    }
  }

  @override
  Future<void> setScheduleEnabled(String deviceId, {required bool enabled}) async {
    _ensureOnline('setScheduleEnabled');
    await _inner.setScheduleEnabled(deviceId, enabled: enabled);
  }
}
