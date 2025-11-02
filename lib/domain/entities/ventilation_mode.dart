/// Ventilation Mode Enum
///
/// Predefined operating modes for ventilation units
library;

enum VentilationMode {
  basic, // Базовый
  intensive, // Интенсивный
  economic, // Экономичный
  maximum, // Максимальный
  kitchen, // Кухня
  fireplace, // Камин
  vacation, // Отпуск
  custom, // Пользовательский
}

extension VentilationModeExtension on VentilationMode {
  String get displayName {
    switch (this) {
      case VentilationMode.basic:
        return 'Базовый';
      case VentilationMode.intensive:
        return 'Интенсивный';
      case VentilationMode.economic:
        return 'Экономичный';
      case VentilationMode.maximum:
        return 'Максимальный';
      case VentilationMode.kitchen:
        return 'Кухня';
      case VentilationMode.fireplace:
        return 'Камин';
      case VentilationMode.vacation:
        return 'Отпуск';
      case VentilationMode.custom:
        return 'Пользовательский';
    }
  }

  String get description {
    switch (this) {
      case VentilationMode.basic:
        return 'Оптимальный режим для повседневного использования';
      case VentilationMode.intensive:
        return 'Повышенная производительность для быстрого воздухообмена';
      case VentilationMode.economic:
        return 'Пониженное энергопотребление, тихая работа';
      case VentilationMode.maximum:
        return 'Максимальная производительность системы';
      case VentilationMode.kitchen:
        return 'Усиленная вытяжка для удаления запахов при готовке';
      case VentilationMode.fireplace:
        return 'Компенсация воздуха при работе камина';
      case VentilationMode.vacation:
        return 'Минимальный режим вентиляции в отсутствие жильцов';
      case VentilationMode.custom:
        return 'Настраиваемый режим работы';
    }
  }
}
