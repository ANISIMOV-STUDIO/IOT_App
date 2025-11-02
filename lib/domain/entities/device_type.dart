/// Device Type Enum
///
/// Defines the type of IoT device
library;

enum DeviceType {
  ventilation, // Вентиляционная установка (приточно-вытяжная)
  hvac, // Полноценный HVAC (отопление, вентиляция, кондиционирование)
  ac, // Кондиционер
  heater, // Обогреватель
}

extension DeviceTypeExtension on DeviceType {
  String get displayName {
    switch (this) {
      case DeviceType.ventilation:
        return 'Вентиляционная установка';
      case DeviceType.hvac:
        return 'HVAC система';
      case DeviceType.ac:
        return 'Кондиционер';
      case DeviceType.heater:
        return 'Обогреватель';
    }
  }

  String get shortName {
    switch (this) {
      case DeviceType.ventilation:
        return 'Вентиляция';
      case DeviceType.hvac:
        return 'HVAC';
      case DeviceType.ac:
        return 'Кондиционер';
      case DeviceType.heater:
        return 'Обогреватель';
    }
  }
}
