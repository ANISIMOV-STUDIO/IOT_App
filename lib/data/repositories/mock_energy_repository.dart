/// Мок-репозиторий энергопотребления
library;

import 'dart:async';
import 'dart:math';
import '../../domain/entities/energy_stats.dart';
import '../../domain/repositories/energy_repository.dart';

class MockEnergyRepository implements EnergyRepository {
  final _controller = StreamController<EnergyStats>.broadcast();
  final _random = Random();

  @override
  Future<EnergyStats> getTodayStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _generateStats(DateTime.now());
  }

  @override
  Future<EnergyStats> getStats(DateTime from, DateTime to) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _generateStats(from);
  }

  @override
  Future<List<DeviceEnergyUsage>> getDevicePowerUsage() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      DeviceEnergyUsage(
        deviceId: 'ac_1',
        deviceName: 'Кондиционер',
        deviceType: 'airCondition',
        unitCount: 2,
        totalKwh: 52,
      ),
      DeviceEnergyUsage(
        deviceId: 'lamp_group',
        deviceName: 'Умные лампы',
        deviceType: 'lamp',
        unitCount: 8,
        totalKwh: 12,
      ),
      DeviceEnergyUsage(
        deviceId: 'tv_group',
        deviceName: 'Телевизоры',
        deviceType: 'tv',
        unitCount: 5,
        totalKwh: 21,
      ),
      DeviceEnergyUsage(
        deviceId: 'speaker_group',
        deviceName: 'Колонки',
        deviceType: 'speaker',
        unitCount: 1,
        totalKwh: 42,
      ),
    ];
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
