import '../entities/room.dart';
import '../entities/occupant.dart';

/// Репозиторий дома — комнаты и жильцы
abstract class HomeRepository {
  /// Получить все комнаты
  Future<List<Room>> getRooms();

  /// Получить комнату по ID
  Future<Room?> getRoom(String id);

  /// Получить всех жильцов
  Future<List<Occupant>> getOccupants();

  /// Получить жильцов, которые дома
  Future<List<Occupant>> getOccupantsAtHome();

  /// Добавить жильца
  Future<Occupant> addOccupant(Occupant occupant);

  /// Стрим комнат
  Stream<List<Room>> watchRooms();

  /// Стрим жильцов
  Stream<List<Occupant>> watchOccupants();
}
