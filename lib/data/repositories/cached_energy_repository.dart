/// Кеширующая обёртка для EnergyRepository
///
/// Статистика энергопотребления — только для чтения,
/// все методы кешируемые.
library;

import '../../core/error/offline_exception.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/energy_stats.dart';
import '../../domain/repositories/energy_repository.dart';

/// Кеширующий декоратор для EnergyRepository
class CachedEnergyRepository implements EnergyRepository {
  final EnergyRepository _inner;
  final CacheService _cacheService;
  final ConnectivityService _connectivity;

  CachedEnergyRepository({
    required EnergyRepository inner,
    required CacheService cacheService,
    required ConnectivityService connectivity,
  })  : _inner = inner,
        _cacheService = cacheService,
        _connectivity = connectivity;

  @override
  Future<EnergyStats> getTodayStats() async {
    if (_connectivity.isOnline) {
      try {
        final stats = await _inner.getTodayStats();
        await _cacheService.cacheEnergyStats(stats);
        return stats;
      } catch (e) {
        final cached = _cacheService.getCachedEnergyStats();
        if (cached != null) return cached;
        rethrow;
      }
    }

    final cached = _cacheService.getCachedEnergyStats();
    if (cached != null) return cached;

    throw const OfflineException(
      'Нет сохранённой статистики энергопотребления',
      operation: 'getTodayStats',
    );
  }

  @override
  Future<EnergyStats> getStats(DateTime from, DateTime to) async {
    // Статистика за произвольный период не кешируется
    if (_connectivity.isOnline) {
      return _inner.getStats(from, to);
    }

    throw const OfflineException(
      'Просмотр истории недоступен без сети',
      operation: 'getStats',
    );
  }

  @override
  Future<List<DeviceEnergyUsage>> getDevicePowerUsage() async {
    if (_connectivity.isOnline) {
      return _inner.getDevicePowerUsage();
    }

    throw const OfflineException(
      'Статистика по устройствам недоступна без сети',
      operation: 'getDevicePowerUsage',
    );
  }

  @override
  Stream<EnergyStats> watchStats() {
    return _inner.watchStats();
  }
}
