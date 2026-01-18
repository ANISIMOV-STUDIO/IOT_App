import 'package:equatable/equatable.dart';

/// Статистика энергопотребления
class EnergyStats extends Equatable {

  const EnergyStats({
    required this.totalKwh,
    required this.totalHours,
    required this.date,
    this.hourlyData = const [],
  });
  final double totalKwh;
  final int totalHours;
  final DateTime date;
  final List<HourlyUsage> hourlyData;

  @override
  List<Object?> get props => [totalKwh, totalHours, date, hourlyData];
}

/// Почасовое потребление
class HourlyUsage extends Equatable {

  const HourlyUsage({required this.hour, required this.kwh});
  final int hour;
  final double kwh;

  @override
  List<Object?> get props => [hour, kwh];
}

/// Потребление по устройствам
class DeviceEnergyUsage extends Equatable {

  const DeviceEnergyUsage({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.unitCount,
    required this.totalKwh,
  });
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final int unitCount;
  final double totalKwh;

  @override
  List<Object?> get props => [deviceId, deviceName, deviceType, unitCount, totalKwh];
}
