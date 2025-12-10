import 'package:equatable/equatable.dart';

/// Статистика энергопотребления
class EnergyStats extends Equatable {
  final double totalKwh;
  final int totalHours;
  final DateTime date;
  final List<HourlyUsage> hourlyData;

  const EnergyStats({
    required this.totalKwh,
    required this.totalHours,
    required this.date,
    this.hourlyData = const [],
  });

  @override
  List<Object?> get props => [totalKwh, totalHours, date, hourlyData];
}

/// Почасовое потребление
class HourlyUsage extends Equatable {
  final int hour;
  final double kwh;

  const HourlyUsage({required this.hour, required this.kwh});

  @override
  List<Object?> get props => [hour, kwh];
}

/// Потребление по устройствам
class DeviceEnergyUsage extends Equatable {
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final int unitCount;
  final double totalKwh;

  const DeviceEnergyUsage({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.unitCount,
    required this.totalKwh,
  });

  @override
  List<Object?> get props => [deviceId, deviceName, deviceType, unitCount, totalKwh];
}
