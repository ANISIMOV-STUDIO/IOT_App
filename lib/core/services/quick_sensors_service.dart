/// Типы показателей для быстрого отображения на главном виджете
///
/// Содержит enum QuickSensorType и статические хелперы для конвертации.
/// Хранение данных происходит на сервере per-device.
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';

// =============================================================================
// QUICK SENSOR TYPE
// =============================================================================

/// Доступные типы показателей для быстрого отображения
enum QuickSensorType {
  outsideTemp('outside_temp', Icons.thermostat_outlined),
  indoorTemp('indoor_temp', Icons.home_outlined),
  humidity('humidity', Icons.water_drop_outlined),
  co2Level('co2_level', Icons.cloud_outlined),
  supplyTemp('supply_temp', Icons.air),
  recuperatorEfficiency('recuperator_eff', Icons.recycling),
  heaterPower('heater_perf', Icons.local_fire_department_outlined),
  ductPressure('duct_pressure', Icons.speed),
  filterPercent('filter_percent', Icons.filter_alt_outlined);

  const QuickSensorType(this.key, this.icon);

  /// Ключ для сохранения на сервере
  final String key;

  /// Иконка показателя
  final IconData icon;

  /// Локализованное название (краткое, как на экране аналитики)
  String getLabel(AppLocalizations l10n) => switch (this) {
      QuickSensorType.outsideTemp => l10n.outdoor,
      QuickSensorType.indoorTemp => l10n.indoor,
      QuickSensorType.humidity => l10n.humidity,
      QuickSensorType.co2Level => 'CO₂',
      QuickSensorType.supplyTemp => l10n.supply,
      QuickSensorType.recuperatorEfficiency => l10n.efficiency,
      QuickSensorType.heaterPower => l10n.heater,
      QuickSensorType.ductPressure => l10n.pressure,
      QuickSensorType.filterPercent => l10n.filter,
    };

  /// Цвет иконки (темозависимый)
  Color getColor(BreezColors colors) => switch (this) {
      QuickSensorType.outsideTemp => colors.accent,
      QuickSensorType.indoorTemp => AppColors.accentGreen,
      QuickSensorType.humidity => colors.accent,
      QuickSensorType.co2Level => AppColors.accentGreen,
      QuickSensorType.supplyTemp => AppColors.accentOrange,
      QuickSensorType.recuperatorEfficiency => colors.accent,
      QuickSensorType.heaterPower => AppColors.accentOrange,
      QuickSensorType.ductPressure => colors.textMuted,
      QuickSensorType.filterPercent => colors.accent,
    };

  /// Найти тип по ключу
  static QuickSensorType? fromKey(String? key) {
    if (key == null) {
      return null;
    }
    for (final type in QuickSensorType.values) {
      if (type.key == key) {
        return type;
      }
    }
    return null;
  }
}

// =============================================================================
// HELPER CLASS (STATELESS)
// =============================================================================

/// Статические хелперы для работы с показателями.
///
/// Данные хранятся на сервере в поле quickSensors устройства.
abstract class QuickSensorsService {
  static const int maxSensors = 3;

  /// Показатели по умолчанию
  static const List<QuickSensorType> defaultSensors = [
    QuickSensorType.outsideTemp,
    QuickSensorType.indoorTemp,
    QuickSensorType.humidity,
  ];

  /// Ключи показателей по умолчанию
  static const List<String> defaultSensorKeys = [
    'outside_temp',
    'indoor_temp',
    'humidity',
  ];

  /// Конвертировать список ключей в типы
  static List<QuickSensorType> fromKeys(List<String>? keys) {
    // null = не настроено, используем дефолтные
    if (keys == null) {
      return defaultSensors;
    }

    // Пустой список = пользователь убрал все
    if (keys.isEmpty) {
      return [];
    }

    // Конвертируем что есть (0-3 сенсора)
    return keys
        .map(QuickSensorType.fromKey)
        .whereType<QuickSensorType>()
        .toList();
  }

  /// Конвертировать типы в список ключей
  static List<String> toKeys(List<QuickSensorType> sensors) => sensors.map((s) => s.key).toList();

  /// Все доступные типы показателей
  static List<QuickSensorType> get availableSensors =>
      QuickSensorType.values.toList();
}
