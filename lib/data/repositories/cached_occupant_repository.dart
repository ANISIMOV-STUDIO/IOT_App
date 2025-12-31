/// Кеширующая обёртка для OccupantRepository
///
/// Использует паттерн Decorator:
/// - При наличии сети: получает данные из API и кеширует
/// - При отсутствии сети: возвращает данные из кеша
/// - Операции управления требуют сети (выбрасывают OfflineException)
library;

import '../../core/error/offline_exception.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../domain/entities/occupant.dart';
import '../../domain/repositories/occupant_repository.dart';

/// Кеширующий декоратор для OccupantRepository
class CachedOccupantRepository implements OccupantRepository {
  final OccupantRepository _inner;
  final CacheService _cacheService;
  final ConnectivityService _connectivity;

  CachedOccupantRepository({
    required OccupantRepository inner,
    required CacheService cacheService,
    required ConnectivityService connectivity,
  })  : _inner = inner,
        _cacheService = cacheService,
        _connectivity = connectivity;

  // ============================================
  // READ OPERATIONS (кешируемые)
  // ============================================

  @override
  Future<List<Occupant>> getAllOccupants() async {
    if (_connectivity.isOnline) {
      try {
        final occupants = await _inner.getAllOccupants();
        await _cacheService.cacheOccupants(occupants);
        return occupants;
      } catch (e) {
        // При ошибке сети — пробуем кеш
        final cached = _cacheService.getCachedOccupants();
        if (cached != null) return cached;
        rethrow;
      }
    }

    // Offline — возвращаем из кеша
    final cached = _cacheService.getCachedOccupants();
    if (cached != null) return cached;

    throw const OfflineException('Нет подключения к сети и нет кешированных данных');
  }

  @override
  Stream<List<Occupant>> watchOccupants() {
    // Стрим работает только онлайн
    return _inner.watchOccupants();
  }

  // ============================================
  // WRITE OPERATIONS (требуют сети)
  // ============================================

  @override
  Future<Occupant> addOccupant(String name, {String? avatarUrl}) async {
    if (!_connectivity.isOnline) {
      throw const OfflineException('Добавление жителя требует подключения к сети');
    }
    final occupant = await _inner.addOccupant(name, avatarUrl: avatarUrl);
    // Инвалидируем кеш после изменения
    await _cacheService.clearOccupantsCache();
    return occupant;
  }

  @override
  Future<void> removeOccupant(String id) async {
    if (!_connectivity.isOnline) {
      throw const OfflineException('Удаление жителя требует подключения к сети');
    }
    await _inner.removeOccupant(id);
    await _cacheService.clearOccupantsCache();
  }

  @override
  Future<Occupant> updatePresence(String id, bool isHome) async {
    if (!_connectivity.isOnline) {
      throw const OfflineException('Обновление статуса требует подключения к сети');
    }
    final occupant = await _inner.updatePresence(id, isHome);
    await _cacheService.clearOccupantsCache();
    return occupant;
  }
}
