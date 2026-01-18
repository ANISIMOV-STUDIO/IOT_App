/// Мок-репозиторий энергопотребления
library;

import 'dart:async';
import 'dart:math';
import '../../domain/entities/energy_stats.dart';
import '../../domain/repositories/energy_repository.dart';
import '../mock/mock_data.dart';

class MockEnergyRepository implements EnergyRepository {
  final _controller = StreamController<EnergyStats>.broadcast();
  final _random = Random();

  @override
  Future<EnergyStats> getTodayStats() async {
    await Future.delayed(MockData.slowDelay);
    return _generateStats(DateTime.now());
  }

  @override
  Future<EnergyStats> getStats(DateTime from, DateTime to) async {
    await Future.delayed(MockData.loadDelay);
    return _generateStats(from);
  }

  @override
  Future<List<DeviceEnergyUsage>> getDevicePowerUsage() async {
    await Future.delayed(MockData.slowDelay);
    return MockData.energyUsage.map((d) => DeviceEnergyUsage(
      deviceId: d['deviceId'] as String,
      deviceName: d['deviceName'] as String,
      deviceType: d['deviceType'] as String,
      unitCount: d['unitCount'] as int,
      totalKwh: (d['totalKwh'] as num).toDouble(),
    )).toList();
  }

  @override
  Stream<EnergyStats> watchStats() {
    Future.microtask(() async {
      _controller.add(await getTodayStats());
    });
    return _controller.stream;
  }

  EnergyStats _generateStats(DateTime date) {
    final hourlyData = <HourlyUsage>[];
    final currentHour = DateTime.now().hour;

    for (var h = 0; h <= currentHour; h++) {
      hourlyData.add(HourlyUsage(
        hour: h,
        kwh: 1.0 + _random.nextDouble() * 3.0,
      ));
    }

    final totalKwh = hourlyData.fold<double>(0, (sum, h) => sum + h.kwh);

    return EnergyStats(
      totalKwh: double.parse(totalKwh.toStringAsFixed(2)),
      totalHours: currentHour + 1,
      hourlyData: hourlyData,
      date: date,
    );
  }

  void dispose() {
    _controller.close();
  }
}
