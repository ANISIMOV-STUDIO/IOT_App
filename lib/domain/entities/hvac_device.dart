/// HVAC Device Entity
///
/// Чистая доменная сущность без зависимостей от Flutter.
/// Иконки определяются в Presentation Layer на основе типа устройства.
library;

import 'package:equatable/equatable.dart';

/// Тип HVAC устройства
enum HvacDeviceType {
  /// Вентиляционная установка
  ventilation,

  /// Кондиционер
  airConditioner,

  /// Тепловой насос
  heatPump,

  /// Универсальное устройство
  generic,
}

/// HVAC устройство для отображения в переключателе
class HvacDevice extends Equatable {
  final String id;
  final String name;
  final String brand;
  final HvacDeviceType deviceType;
  final bool isOnline;
  final bool isActive;

  const HvacDevice({
    required this.id,
    required this.name,
    required this.brand,
    this.deviceType = HvacDeviceType.ventilation,
    this.isOnline = true,
    this.isActive = false,
  });

  HvacDevice copyWith({
    String? id,
    String? name,
    String? brand,
    HvacDeviceType? deviceType,
    bool? isOnline,
    bool? isActive,
  }) {
    return HvacDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      deviceType: deviceType ?? this.deviceType,
      isOnline: isOnline ?? this.isOnline,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, brand, deviceType, isOnline, isActive];
}
