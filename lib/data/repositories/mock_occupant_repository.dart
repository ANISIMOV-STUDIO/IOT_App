/// Мок-репозиторий жителей
library;

import 'dart:async';
import '../../domain/entities/occupant.dart';
import '../../domain/repositories/occupant_repository.dart';

class MockOccupantRepository implements OccupantRepository {
  final _controller = StreamController<List<Occupant>>.broadcast();

  List<Occupant> _occupants = [
    const Occupant(id: 'occ_1', name: 'Иван', isHome: true),
    const Occupant(id: 'occ_2', name: 'Мария', isHome: true),
    const Occupant(id: 'occ_3', name: 'Алексей', isHome: false),
    const Occupant(id: 'occ_4', name: 'Ольга', isHome: true),
    const Occupant(id: 'occ_5', name: 'Дмитрий', isHome: false),
  ];

  @override
  Future<List<Occupant>> getAllOccupants() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_occupants);
  }

  @override
  Future<Occupant> addOccupant(String name, {String? avatarUrl}) async {
    await Future.delayed(const Duration(milliseconds: 300));
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
    await Future.delayed(const Duration(milliseconds: 200));
    _occupants = _occupants.where((o) => o.id != id).toList();
    _controller.add(_occupants);
  }

  @override
  Future<Occupant> updatePresence(String id, bool isHome) async {
    await Future.delayed(const Duration(milliseconds: 200));
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
