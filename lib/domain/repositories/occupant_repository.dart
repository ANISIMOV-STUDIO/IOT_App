/// Репозиторий жителей
library;

import '../entities/occupant.dart';

abstract class OccupantRepository {
  /// Получить всех жителей
  Future<List<Occupant>> getAllOccupants();

  /// Добавить жителя
  Future<Occupant> addOccupant(String name, {String? avatarUrl});

  /// Удалить жителя
  Future<void> removeOccupant(String id);

  /// Обновить статус присутствия
  Future<Occupant> updatePresence(String id, bool isHome);

  /// Стрим обновлений
  Stream<List<Occupant>> watchOccupants();
}
