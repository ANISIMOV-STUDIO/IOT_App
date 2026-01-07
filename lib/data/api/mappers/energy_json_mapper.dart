/// JSON Mapper: Energy data
library;

import '../../../domain/entities/energy_stats.dart';

class EnergyJsonMapper {
  /// JSON → Domain EnergyStats
  static EnergyStats energyStatsFromJson(Map<String, dynamic> json) {
    final hourlyData = <HourlyUsage>[];

    if (json.containsKey('hourlyData') && json['hourlyData'] is List) {
      for (final item in json['hourlyData'] as List) {
        if (item is Map<String, dynamic>) {
          // Безопасный парсинг с проверкой типов
          final hour = item['hour'];
          final kwh = item['kwh'];
          if (hour is int && kwh is num) {
            hourlyData.add(HourlyUsage(
              hour: hour,
              kwh: kwh.toDouble(),
            ));
          }
        }
      }
    }

    // Безопасный парсинг даты с fallback
    DateTime parsedDate = DateTime.now();
    final dateStr = json['date'];
    if (dateStr is String) {
      parsedDate = DateTime.tryParse(dateStr) ?? DateTime.now();
    }

    return EnergyStats(
      totalKwh: (json['totalKwh'] as num?)?.toDouble() ?? 0.0,
      totalHours: json['totalHours'] as int? ?? 24,
      date: parsedDate,
      hourlyData: hourlyData,
    );
  }

  /// JSON → List<DeviceEnergyUsage>
  static List<DeviceEnergyUsage> deviceEnergyListFromJson(List<dynamic> jsonList) {
    final result = <DeviceEnergyUsage>[];

    for (final json in jsonList) {
      // Пропускаем элементы неправильного типа
      if (json is! Map<String, dynamic>) continue;

      final deviceId = json['deviceId'];
      // deviceId обязателен
      if (deviceId is! String) continue;

      result.add(DeviceEnergyUsage(
        deviceId: deviceId,
        deviceName: json['deviceName'] as String? ?? 'Unknown',
        deviceType: json['deviceType'] as String? ?? 'Unknown',
        unitCount: json['unitCount'] as int? ?? 1,
        totalKwh: (json['totalKwh'] as num?)?.toDouble() ?? 0.0,
      ));
    }

    return result;
  }
}
