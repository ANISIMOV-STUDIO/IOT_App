import 'dart:async';
import '../../domain/entities/room.dart';
import '../../domain/entities/occupant.dart';
import '../../domain/repositories/home_repository.dart';

/// Мок-репозиторий дома (комнаты, жильцы)
class MockHomeRepository implements HomeRepository {
  final Map<String, Room> _rooms = {};
  final Map<String, Occupant> _occupants = {};
  final _roomsController = StreamController<List<Room>>.broadcast();
  final _occupantsController = StreamController<List<Occupant>>.broadcast();

  MockHomeRepository() {
    _initMockData();
  }

  void _initMockData() {
    // Комнаты
    const rooms = [
      Room(id: 'living_room', name: 'Гостиная', icon: '🛋️', deviceCount: 4, temperature: 23.5),
      Room(id: 'bedroom', name: 'Спальня', icon: '🛏️', deviceCount: 3, temperature: 21.0),
      Room(id: 'kitchen', name: 'Кухня', icon: '🍳', deviceCount: 2, temperature: 24.0),
      Room(id: 'hall', name: 'Холл', icon: '🚪', deviceCount: 2, temperature: 22.0),
      Room(id: 'bathroom', name: 'Ванная', icon: '🚿', deviceCount: 1, temperature: 25.0),
    ];
    for (final r in rooms) {
      _rooms[r.id] = r;
    }

    // Жильцы
    const occupants = [
      Occupant(id: '1', name: 'Иван', isHome: true, currentRoom: 'living_room'),
      Occupant(id: '2', name: 'Мария', isHome: true, currentRoom: 'kitchen'),
      Occupant(id: '3', name: 'Алексей', isHome: false),
      Occupant(id: '4', name: 'Ольга', isHome: true, currentRoom: 'bedroom'),
      Occupant(id: '5', name: 'Дмитрий', isHome: false),
    ];
    for (final o in occupants) {
      _occupants[o.id] = o;
    }
  }

  @override
  Future<List<Room>> getRooms() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _rooms.values.toList();
  }

  @override
  Future<Room?> getRoom(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _rooms[id];
  }

  @override
  Future<List<Occupant>> getOccupants() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _occupants.values.toList();
  }

  @override
  Future<List<Occupant>> getOccupantsAtHome() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _occupants.values.where((o) => o.isHome).toList();
  }

  @override
  Future<Occupant> addOccupant(Occupant occupant) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _occupants[occupant.id] = occupant;
    _occupantsController.add(_occupants.values.toList());
    return occupant;
  }

  @override
  Stream<List<Room>> watchRooms() {
    Future.microtask(() => _roomsController.add(_rooms.values.toList()));
    return _roomsController.stream;
  }

  @override
  Stream<List<Occupant>> watchOccupants() {
    Future.microtask(() => _occupantsController.add(_occupants.values.toList()));
    return _occupantsController.stream;
  }

  void dispose() {
    _roomsController.close();
    _occupantsController.close();
  }
}
