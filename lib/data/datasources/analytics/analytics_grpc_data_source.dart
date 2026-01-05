/// gRPC реализация AnalyticsDataSource
///
/// Используется на Mobile/Desktop платформах для лучшей производительности.
/// Применяет бинарную protobuf сериализацию и HTTP/2 мультиплексирование.
library;

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';

import '../../../domain/entities/graph_data.dart' as domain;
import '../../../domain/entities/sensor_history.dart';
import '../../../generated/protos/protos.dart' as proto;
import '../../../generated/protos/climate.pb.dart' as proto_climate;
import '../../../generated/protos/google/protobuf/timestamp.pb.dart' as ts;
import '../../api/grpc/grpc_interceptor.dart';
import 'analytics_data_source.dart';

class AnalyticsGrpcDataSource implements AnalyticsDataSource {
  final ClientChannel _channel;
  final Future<String?> Function() _getToken;
  late final proto.AnalyticsServiceClient _client;

  AnalyticsGrpcDataSource(this._channel, this._getToken) {
    _client = proto.AnalyticsServiceClient(
      _channel,
      interceptors: [AuthGrpcInterceptor(_getToken)],
    );
  }

  @override
  Future<List<domain.GraphDataPoint>> getGraphData({
    required String deviceId,
    required String metric,
    required DateTime from,
    required DateTime to,
  }) async {
    final request = proto.GraphDataRequest()
      ..deviceId = deviceId
      ..metric = _stringToGraphMetric(metric)
      ..from = _toTimestamp(from)
      ..to = _toTimestamp(to);

    final response = await _client.getGraphData(request);

    return response.dataPoints.map((point) {
      final dt = _fromTimestamp(point.timestamp);
      return domain.GraphDataPoint(
        label: '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
        value: point.value,
      );
    }).toList();
  }

  @override
  Future<EnergyStatsDto> getEnergyStats(String deviceId) async {
    final request = proto.GetEnergyStatsRequest()..deviceId = deviceId;
    final response = await _client.getEnergyStats(request);

    return EnergyStatsDto(
      todayKwh: response.dailyConsumption,
      weekKwh: response.weeklyConsumption,
      monthKwh: response.monthlyConsumption,
      currentPowerW: response.currentConsumption,
    );
  }

  @override
  Future<List<EnergyHistoryEntryDto>> getEnergyHistory({
    required String deviceId,
    required DateTime from,
    required DateTime to,
    required String period,
  }) async {
    final request = proto.EnergyHistoryRequest()
      ..deviceId = deviceId
      ..from = _toTimestamp(from)
      ..to = _toTimestamp(to)
      ..period = _stringToEnergyPeriod(period);

    final response = await _client.getEnergyHistory(request);

    return response.dataPoints.map((point) {
      return EnergyHistoryEntryDto(
        timestamp: _fromTimestamp(point.timestamp),
        kwh: point.consumption,
      );
    }).toList();
  }

  @override
  Future<List<SensorHistory>> getSensorHistory({
    required String deviceId,
    DateTime? from,
    DateTime? to,
    int limit = 1000,
  }) async {
    final request = proto_climate.ClimateHistoryRequest()..deviceId = deviceId;
    if (from != null) request.from = _toTimestamp(from);
    if (to != null) request.to = _toTimestamp(to);

    final response = await _client.getClimateHistory(request);

    return response.history.asMap().entries.map((entry) {
      final state = entry.value;
      return SensorHistory(
        id: '${deviceId}_${entry.key}',
        timestamp: _fromTimestamp(state.timestamp),
        roomTemperature: state.indoorTemp.toDouble(),
        outdoorTemperature: state.outdoorTemp.toDouble(),
        humidity: state.humidity,
      );
    }).toList();
  }

  // ============================================
  // ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ
  // ============================================

  ts.Timestamp _toTimestamp(DateTime dt) {
    return ts.Timestamp()
      ..seconds = Int64(dt.millisecondsSinceEpoch ~/ 1000)
      ..nanos = (dt.millisecondsSinceEpoch % 1000) * 1000000;
  }

  DateTime _fromTimestamp(ts.Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds.toInt() * 1000 + timestamp.nanos ~/ 1000000,
    );
  }

  proto.GraphMetric _stringToGraphMetric(String metric) {
    switch (metric.toLowerCase()) {
      case 'temperature':
        return proto.GraphMetric.GRAPH_METRIC_TEMPERATURE;
      case 'humidity':
        return proto.GraphMetric.GRAPH_METRIC_HUMIDITY;
      case 'airflow':
        return proto.GraphMetric.GRAPH_METRIC_AIRFLOW;
      default:
        return proto.GraphMetric.GRAPH_METRIC_TEMPERATURE;
    }
  }

  proto.EnergyPeriod _stringToEnergyPeriod(String period) {
    switch (period.toLowerCase()) {
      case 'hourly':
        return proto.EnergyPeriod.ENERGY_PERIOD_HOURLY;
      case 'daily':
        return proto.EnergyPeriod.ENERGY_PERIOD_DAILY;
      case 'weekly':
        return proto.EnergyPeriod.ENERGY_PERIOD_WEEKLY;
      case 'monthly':
        return proto.EnergyPeriod.ENERGY_PERIOD_MONTHLY;
      default:
        return proto.EnergyPeriod.ENERGY_PERIOD_DAILY;
    }
  }
}
