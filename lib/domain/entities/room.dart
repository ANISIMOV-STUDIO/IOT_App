import 'package:equatable/equatable.dart';

/// Комната в доме
class Room extends Equatable {
  final String id;
  final String name;
  final String icon;
  final int deviceCount;
  final double temperature;
  final bool isOccupied;

  const Room({
    required this.id,
    required this.name,
    required this.icon,
    this.deviceCount = 0,
    this.temperature = 22,
    this.isOccupied = false,
  });

  Room copyWith({
    String? id,
    String? name,
    String? icon,
    int? deviceCount,
    double? temperature,
    bool? isOccupied,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      deviceCount: deviceCount ?? this.deviceCount,
      temperature: temperature ?? this.temperature,
      isOccupied: isOccupied ?? this.isOccupied,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, deviceCount, temperature, isOccupied];
}
