/// HTTP реализация AnalyticsDataSource
///
/// Используется на Web платформе, где gRPC не поддерживается.
/// Делегирует вызовы к AnalyticsHttpClient.
library;

import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/data/api/http/clients/analytics_http_client.dart';
import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/datasources/analytics/analytics_data_source.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';
import 'package:hvac_control/domain/entities/sensor_history.dart';

class AnalyticsHttpDataSource implements AnalyticsDataSource {

  AnalyticsHttpDataSource(ApiClient apiClient)
      : _httpClient = AnalyticsHttpClient(apiClient);
  final AnalyticsHttpClient _httpClient;

  @override
  Future<List<GraphDataPoint>> getGraphData({
    required String deviceId,
    required String metric,
    required DateTime from,
    required DateTime to,
  }) async {
    final jsonData = await _httpClient.getGraphData(deviceId, metric, from, to);

    final dataPoints = <GraphDataPoint>[];
    if (jsonData.containsKey('dataPoints') && jsonData['dataPoints'] is List) {
      for (final point in jsonData['dataPoints'] as List) {
        if (point is Map<String, dynamic>) {
          final rawLabel = point['label'] as String? ?? '';
          final label = _formatLabel(rawLabel);
          dataPoints.add(GraphDataPoint(
            label: label,
            value: (point['value'] as num?)?.toDouble() ?? 0.0,
          ));
        }
      }
    }

    return dataPoints;
  }

  @override
  Future<EnergyStatsDto> getEnergyStats(String deviceId) async {
    final json = await _httpClient.getEnergyStats(deviceId);

    return EnergyStatsDto(
      todayKwh: (json['todayKwh'] as num?)?.toDouble() ?? 0.0,
      weekKwh: (json['weekKwh'] as num?)?.toDouble() ?? 0.0,
      monthKwh: (json['monthKwh'] as num?)?.toDouble() ?? 0.0,
      currentPowerW: (json['currentPowerW'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  Future<List<EnergyHistoryEntryDto>> getEnergyHistory({
    required String deviceId,
    required DateTime from,
    required DateTime to,
    required String period,
  }) async {
    final json = await _httpClient.getEnergyHistory(deviceId, from, to, period);

    final entries = <EnergyHistoryEntryDto>[];
    if (json.containsKey('entries') && json['entries'] is List) {
      for (final entry in json['entries'] as List) {
        if (entry is Map<String, dynamic>) {
          // Безопасный парсинг timestamp
          final timestampStr = entry['timestamp'];
          if (timestampStr is! String) {
            continue;
          }
          final timestamp = DateTime.tryParse(timestampStr);
          if (timestamp == null) {
            continue;
          }

          entries.add(EnergyHistoryEntryDto(
            timestamp: timestamp,
            kwh: (entry['kwh'] as num?)?.toDouble() ?? 0.0,
          ));
        }
      }
    }

    return entries;
  }

  @override
  Future<List<SensorHistory>> getSensorHistory({
    required String deviceId,
    DateTime? from,
    DateTime? to,
    int limit = 1000,
  }) async => _httpClient.getSensorHistory(
      deviceId,
      from: from,
      to: to,
      limit: limit,
    );

  String _formatLabel(String rawLabel) {
    if (rawLabel.isEmpty) {
      return '';
    }
    try {
      final dateTime = DateTime.parse(rawLabel);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      // Неизвестный формат даты — используем как есть
      ApiLogger.debug('[AnalyticsHttpDataSource] Не удалось распарсить дату: $rawLabel', e);
      return rawLabel;
    }
  }
}
