/// Умное устройство (ТВ, розетка, колонка и т.д.)
library;

import 'package:equatable/equatable.dart';

enum SmartDeviceType {
  tv,
  speaker,
  router,
  wifi,
  heater,
  socket,
  lamp,
  airCondition,
  camera,
  doorLock,
}

class SmartDevice extends Equatable {
  final String id;
  final String name;
  final SmartDeviceType type;
  final bool isOn;
  final String? roomId;
  final double powerConsumption; // кВт
  final Duration activeTime;
  final DateTime lastUpdated;
  final Map<String, dynamic>? metadata;

  const SmartDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.isOn,
    this.roomId,
    this.powerConsumption = 0,
    this.activeTime = Duration.zero,
    required this.lastUpdated,
    this.metadata,
  });

  SmartDevice copyWith({
    String? id,
    String? name,
    SmartDeviceType? type,
    bool? isOn,
    String? roomId,
    double? powerConsumption,
    Duration? activeTime,
    DateTime? lastUpdated,
    Map<String, dynamic>? metadata,
  }) {
    return SmartDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isOn: isOn ?? this.isOn,
      roomId: roomId ?? this.roomId,
      powerConsumption: powerConsumption ?? this.powerConsumption,
      activeTime: activeTime ?? this.activeTime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [id, name, type, isOn, roomId, powerConsumption, activeTime, lastUpdated];
}
