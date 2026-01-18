/// gRPC client for Analytics Service (Mobile/Desktop)
/// Provides graph data, energy stats, and climate history
library;

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:hvac_control/data/api/grpc/grpc_interceptor.dart';
import 'package:hvac_control/generated/protos/google/protobuf/timestamp.pb.dart' as ts;
import 'package:hvac_control/generated/protos/protos.dart';

/// gRPC client for analytics operations
class AnalyticsGrpcClient {

  AnalyticsGrpcClient(this._channel, this._getToken) {
    _client = AnalyticsServiceClient(
      _channel,
      interceptors: [AuthGrpcInterceptor(_getToken)],
    );
  }
  final ClientChannel _channel;
  final Future<String?> Function() _getToken;
  late final AnalyticsServiceClient _client;

  /// Get graph data for a device
  Future<GraphDataResponse> getGraphData({
    required String deviceId,
    required GraphMetric metric,
    required DateTime from,
    required DateTime to,
    int? resolution,
  }) async {
    final request = GraphDataRequest()
      ..deviceId = deviceId
      ..metric = metric
      ..from = _toTimestamp(from)
      ..to = _toTimestamp(to);

    if (resolution != null) {
      request.resolution = resolution;
    }

    return await _client.getGraphData(request);
  }

  /// Get energy statistics for a device
  Future<EnergyStats> getEnergyStats(String deviceId) async {
    final request = GetEnergyStatsRequest()..deviceId = deviceId;
    return await _client.getEnergyStats(request);
  }

  /// Get energy consumption history
  Future<EnergyHistoryResponse> getEnergyHistory({
    required String deviceId,
    required DateTime from,
    required DateTime to,
    EnergyPeriod period = EnergyPeriod.ENERGY_PERIOD_DAILY,
  }) async {
    final request = EnergyHistoryRequest()
      ..deviceId = deviceId
      ..from = _toTimestamp(from)
      ..to = _toTimestamp(to)
      ..period = period;

    return await _client.getEnergyHistory(request);
  }

  /// Get current climate state
  Future<ClimateState> getClimateState(String deviceId) async {
    final request = GetClimateStateRequest()..deviceId = deviceId;
    return await _client.getClimateState(request);
  }

  /// Get climate history
  Future<ClimateHistoryResponse> getClimateHistory({
    required String deviceId,
    required DateTime from,
    required DateTime to,
  }) async {
    final request = ClimateHistoryRequest()
      ..deviceId = deviceId
      ..from = _toTimestamp(from)
      ..to = _toTimestamp(to);

    return await _client.getClimateHistory(request);
  }

  // ============================================
  // HELPERS
  // ============================================

  ts.Timestamp _toTimestamp(DateTime dt) => ts.Timestamp()
    ..seconds = Int64(dt.millisecondsSinceEpoch ~/ 1000)
    ..nanos = (dt.millisecondsSinceEpoch % 1000) * 1000000;
}
