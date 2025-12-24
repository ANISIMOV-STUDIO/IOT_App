/// Мок-репозиторий жителей
library;

import 'dart:async';
import '../../domain/entities/occupant.dart';
import '../../domain/repositories/occupant_repository.dart';
import '../mock/mock_data.dart';

class MockOccupantRepository implements OccupantRepository {
  final _controller = StreamController<List<Occupant>>.broadcast();
  late List<Occupant> _occupants;

  MockOccupantRepository() {
    _occupants = _parseOccupants(MockData.occupants);
  }

  List<Occupant> _parseOccupants(List<Map<String, dynamic>> json) {
    return json.map((o) => Occupant(
      id: o['id'] as String,
      name: o['name'] as String,
      avatarUrl: o['avatarUrl'] as String?,
      isHome: o['isHome'] as bool,
    )).toList();
  }

  @override
  Future<List<Occupant>> getAllOccupants() async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal']!));
    return List.unmodifiable(_occupants);
  }

  @override
  Future<Occupant> addOccupant(String name, {String? avatarUrl}) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['slow']!));
    final newOccupant = Occupant(
      id: 'occ_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      avatarUrl: avatarUrl,
      isHome: false,
    );
    _occupants = [..._occupants, newOccupant];
    _controller.add(_occupants);
    return newOccupant;
  }

  @override
  Future<void> removeOccupant(String id) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal']!));
    _occupants = _occupants.where((o) => o.id != id).toList();
    _controller.add(_occupants);
  }

  @override
  Future<Occupant> updatePresence(String id, bool isHome) async {
    await Future.delayed(Duration(milliseconds: MockData.networkDelays['normal']!));
    final index = _occupants.indexWhere((o) => o.id == id);
    if (index == -1) throw Exception('Житель не найден: $id');
    final updated = _occupants[index].copyWith(isHome: isHome);
    _occupants = List.from(_occupants)..[index] = updated;
    _controller.add(_occupants);
    return updated;
  }

  @override
  Stream<List<Occupant>> watchOccupants() {
    Future.microtask(() => _controller.add(_occupants));
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
