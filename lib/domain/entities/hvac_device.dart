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

  const HvacDevice({
    required this.id,
    required this.name,
    this.macAddress = '',
    this.deviceType = HvacDeviceType.ventilation,
    this.isOnline = true,
    this.isActive = false,
    this.operatingMode = 'basic',
    this.isScheduleEnabled = false,
  });
  final String id;
  final String name;
  /// MAC-адрес устройства
  final String macAddress;
  final HvacDeviceType deviceType;
  final bool isOnline;
  final bool isActive;
  /// Текущий режим работы (basic, intensive, economy, etc.)
  final String operatingMode;
  /// Включено ли расписание
  final bool isScheduleEnabled;

  HvacDevice copyWith({
    String? id,
    String? name,
    String? macAddress,
    HvacDeviceType? deviceType,
    bool? isOnline,
    bool? isActive,
    String? operatingMode,
    bool? isScheduleEnabled,
  }) => HvacDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      macAddress: macAddress ?? this.macAddress,
      deviceType: deviceType ?? this.deviceType,
      isOnline: isOnline ?? this.isOnline,
      isActive: isActive ?? this.isActive,
      operatingMode: operatingMode ?? this.operatingMode,
      isScheduleEnabled: isScheduleEnabled ?? this.isScheduleEnabled,
    );

  @override
  List<Object?> get props => [id, name, macAddress, deviceType, isOnline, isActive, operatingMode, isScheduleEnabled];
}
