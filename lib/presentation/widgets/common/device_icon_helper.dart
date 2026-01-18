/// Хелпер для получения иконки устройства
///
/// Иконки определяются в Presentation Layer, а не в Domain.
library;

import 'package:flutter/material.dart';

import 'package:hvac_control/domain/entities/hvac_device.dart';

/// Получить иконку для типа HVAC устройства
IconData getDeviceIcon(HvacDeviceType deviceType) {
  switch (deviceType) {
    case HvacDeviceType.ventilation:
      return Icons.air;
    case HvacDeviceType.airConditioner:
      return Icons.ac_unit;
    case HvacDeviceType.heatPump:
      return Icons.heat_pump;
    case HvacDeviceType.generic:
      return Icons.device_hub;
  }
}

/// Расширение для удобного получения иконки
extension HvacDeviceIconExtension on HvacDevice {
  /// Получить иконку для этого устройства
  IconData get icon => getDeviceIcon(deviceType);
}
