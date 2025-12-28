/// Real implementation of OccupantRepository
library;

import 'dart:async';
import '../../domain/entities/occupant.dart';
import '../../domain/repositories/occupant_repository.dart';
import '../api/platform/api_client.dart';
import '../api/http/clients/occupant_http_client.dart';

class RealOccupantRepository implements OccupantRepository {
  final ApiClient _apiClient;
  late final OccupantHttpClient _httpClient;

  final _occupantsController = StreamController<List<Occupant>>.broadcast();

  RealOccupantRepository(this._apiClient) {
    _httpClient = OccupantHttpClient(_apiClient);
  }

  @override
  Future<List<Occupant>> getAllOccupants() async {
    final jsonOccupants = await _httpClient.getAllOccupants();

    final occupants = jsonOccupants.map((json) {
      return Occupant(
        id: json['id'] as String,
        name: json['name'] as String,
        avatarUrl: json['avatarUrl'] as String?,
        isHome: json['isHome'] as bool? ?? false,
        currentRoom: json['currentRoom'] as String?,
      );
    }).toList();

    _occupantsController.add(occupants);
    return occupants;
  }

  @override
  Future<Occupant> addOccupant(String name, {String? avatarUrl}) async {
    final jsonOccupant = await _httpClient.addOccupant({
      'name': name,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'isHome': false,
    });

    return Occupant(
      id: jsonOccupant['id'] as String,
      name: jsonOccupant['name'] as String,
      avatarUrl: jsonOccupant['avatarUrl'] as String?,
      isHome: jsonOccupant['isHome'] as bool? ?? false,
      currentRoom: jsonOccupant['currentRoom'] as String?,
    );
  }

  @override
  Future<void> removeOccupant(String occupantId) async {
    await _httpClient.removeOccupant(occupantId);
  }

  @override
  Future<Occupant> updatePresence(
    String occupantId,
    bool isHome, [
    String? currentRoom,
  ]) async {
    final jsonOccupant =
        await _httpClient.updatePresence(occupantId, isHome, currentRoom);

    return Occupant(
      id: jsonOccupant['id'] as String,
      name: jsonOccupant['name'] as String,
      avatarUrl: jsonOccupant['avatarUrl'] as String?,
      isHome: jsonOccupant['isHome'] as bool? ?? false,
      currentRoom: jsonOccupant['currentRoom'] as String?,
    );
  }

  @override
  Stream<List<Occupant>> watchOccupants() {
    getAllOccupants();
    return _occupantsController.stream;
  }

  void dispose() {
    _occupantsController.close();
  }
}
