import 'package:equatable/equatable.dart';

/// Тип умного устройства
enum DeviceType {
  tv,
  speaker,
  router,
  wifi,
  heater,
  socket,
  airConditioner,
  lamp,
  camera,
  lock,
}

/// Умное устройство
class Device extends Equatable {
  final String id;
  final String name;
  final DeviceType type;
  final bool isOn;
  final String roomId;
  final double powerConsumption; // кВт
  final Duration activeTime;
  final Map<String, dynamic>? settings;

  const Device({
    required this.id,
    required this.name,
    required this.type,
    required this.isOn,
    required this.roomId,
    this.powerConsumption = 0,
    this.activeTime = Duration.zero,
    this.settings,
  });

  Device copyWith({
    String? id,
    String? name,
    DeviceType? type,
    bool? isOn,
    String? roomId,
    double? powerConsumption,
    Duration? activeTime,
    Map<String, dynamic>? settings,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isOn: isOn ?? this.isOn,
      roomId: roomId ?? this.roomId,
      powerConsumption: powerConsumption ?? this.powerConsumption,
      activeTime: activeTime ?? this.activeTime,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [id, name, type, isOn, roomId, powerConsumption, activeTime, settings];
}
