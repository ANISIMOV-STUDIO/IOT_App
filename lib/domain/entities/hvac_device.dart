import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'climate.dart';

/// HVAC устройство для отображения в переключателе
class HvacDevice extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String type;
  final bool isOnline;
  final bool isActive;
  final IconData icon;

  const HvacDevice({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    this.isOnline = true,
    this.isActive = false,
    this.icon = Icons.device_hub,
  });

  /// Создать HvacDevice из ClimateState
  factory HvacDevice.fromClimateState({
    required String id,
    required ClimateState climate,
    required String brand,
    required String type,
    required IconData icon,
    bool isOnline = true,
  }) {
    return HvacDevice(
      id: id,
      name: climate.deviceName,
      brand: brand,
      type: type,
      isOnline: isOnline,
      isActive: climate.isOn,
      icon: icon,
    );
  }

  HvacDevice copyWith({
    String? id,
    String? name,
    String? brand,
    String? type,
    bool? isOnline,
    bool? isActive,
    IconData? icon,
  }) {
    return HvacDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      type: type ?? this.type,
      isOnline: isOnline ?? this.isOnline,
      isActive: isActive ?? this.isActive,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [id, name, brand, type, isOnline, isActive, icon];
}
