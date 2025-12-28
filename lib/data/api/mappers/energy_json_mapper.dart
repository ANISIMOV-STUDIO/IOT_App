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
          hourlyData.add(HourlyUsage(
            hour: item['hour'] as int,
            kwh: (item['kwh'] as num).toDouble(),
          ));
        }
      }
    }

    return EnergyStats(
      totalKwh: (json['totalKwh'] as num?)?.toDouble() ?? 0.0,
      totalHours: json['totalHours'] as int? ?? 24,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      hourlyData: hourlyData,
    );
  }

  /// JSON → List<DeviceEnergyUsage>
  static List<DeviceEnergyUsage> deviceEnergyListFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) {
      final data = json as Map<String, dynamic>;
      return DeviceEnergyUsage(
        deviceId: data['deviceId'] as String,
        deviceName: data['deviceName'] as String? ?? 'Unknown',
        deviceType: data['deviceType'] as String? ?? 'Unknown',
        unitCount: data['unitCount'] as int? ?? 1,
        totalKwh: (data['totalKwh'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();
  }
}
