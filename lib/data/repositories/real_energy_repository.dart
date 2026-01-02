/// Real implementation of EnergyRepository
library;

import 'dart:async';
import '../../domain/entities/energy_stats.dart';
import '../../domain/repositories/energy_repository.dart';
import '../api/platform/api_client.dart';
import '../api/http/clients/analytics_http_client.dart';
import '../api/mappers/energy_json_mapper.dart';

class RealEnergyRepository implements EnergyRepository {
  final ApiClient _apiClient;
  String? _selectedDeviceId;

  late final AnalyticsHttpClient _httpClient;

  final _statsController = StreamController<EnergyStats>.broadcast();
  Timer? _pollTimer; // Для отслеживания и отмены polling

  RealEnergyRepository(this._apiClient, {String? deviceId})
      : _selectedDeviceId = deviceId {
    _httpClient = AnalyticsHttpClient(_apiClient);
  }

  /// Установить ID выбранного устройства
  void setSelectedDeviceId(String? deviceId) {
    _selectedDeviceId = deviceId;
  }

  /// Возвращает пустую статистику когда устройство не выбрано
  EnergyStats get _emptyStats => EnergyStats(
        totalKwh: 0,
        totalHours: 0,
        date: DateTime.now(),
        hourlyData: const [],
      );

  @override
  Future<EnergyStats> getTodayStats() async {
    if (_selectedDeviceId == null || _selectedDeviceId!.isEmpty) {
      return _emptyStats;
    }
    final jsonStats = await _httpClient.getEnergyStats(_selectedDeviceId!);
    final stats = EnergyJsonMapper.energyStatsFromJson(jsonStats);
    _statsController.add(stats);
    return stats;
  }

  @override
  Future<EnergyStats> getStats(DateTime from, DateTime to) async {
    if (_selectedDeviceId == null || _selectedDeviceId!.isEmpty) {
      return _emptyStats;
    }
    final jsonHistory =
        await _httpClient.getEnergyHistory(_selectedDeviceId!, from, to, 'hourly');

    final stats = EnergyJsonMapper.energyStatsFromJson(jsonHistory);
    return stats;
  }

  @override
  Future<List<DeviceEnergyUsage>> getDevicePowerUsage() async {
    // TODO: Implement when backend API is available
    return [];
  }

  @override
  Stream<EnergyStats> watchStats() {
    // Отменить предыдущий таймер, если существует
    _pollTimer?.cancel();

    // Создать новый таймер для polling каждую минуту
    _pollTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      getTodayStats();
    });

    // Начальная загрузка данных
    getTodayStats();

    return _statsController.stream;
  }

  void dispose() {
    _pollTimer?.cancel(); // Отменить таймер для предотвращения утечки памяти
    _statsController.close();
  }
}
