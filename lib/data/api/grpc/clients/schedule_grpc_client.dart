/// gRPC client for Schedule Service (Mobile/Desktop)
library;

import 'package:grpc/grpc.dart';

import '../../../../domain/entities/schedule_entry.dart' as domain;
import '../../../../generated/protos/protos.dart';
import '../grpc_interceptor.dart';

/// gRPC client for schedule operations
class ScheduleGrpcClient {
  final ClientChannel _channel;
  final Future<String?> Function() _getToken;
  late final ScheduleServiceClient _client;

  ScheduleGrpcClient(this._channel, this._getToken) {
    _client = ScheduleServiceClient(
      _channel,
      interceptors: [AuthGrpcInterceptor(_getToken)],
    );
  }

  /// Get schedule for device
  Future<List<domain.ScheduleEntry>> getSchedule(String deviceId) async {
    final response = await _client.getSchedule(
      GetScheduleRequest()..deviceId = deviceId,
    );
    return response.entries.map(_mapToDomain).toList();
  }

  /// Create schedule entry
  Future<domain.ScheduleEntry> createEntry({
    required String deviceId,
    required String time,
    required List<int> days,
    required int temp,
    required OperationMode mode,
  }) async {
    final response = await _client.createScheduleEntry(
      CreateScheduleRequest()
        ..deviceId = deviceId
        ..time = time
        ..days.addAll(days)
        ..action = (ScheduleAction()
          ..temp = temp
          ..mode = mode),
    );
    return _mapToDomain(response);
  }

  /// Update schedule entry
  Future<domain.ScheduleEntry> updateEntry({
    required String id,
    String? time,
    List<int>? days,
    int? temp,
    OperationMode? mode,
    bool? enabled,
  }) async {
    final request = UpdateScheduleRequest()..id = id;
    if (time != null) request.time = time;
    if (days != null) request.days.addAll(days);
    if (enabled != null) request.enabled = enabled;
    if (temp != null || mode != null) {
      final action = ScheduleAction();
      if (temp != null) action.temp = temp;
      if (mode != null) action.mode = mode;
      request.action = action;
    }

    final response = await _client.updateScheduleEntry(request);
    return _mapToDomain(response);
  }

  /// Delete schedule entry
  Future<void> deleteEntry(String id) async {
    await _client.deleteScheduleEntry(DeleteScheduleRequest()..id = id);
  }

  // ============================================
  // MAPPERS
  // ============================================

  /// Map proto ScheduleEntry to domain ScheduleEntry
  domain.ScheduleEntry _mapToDomain(ScheduleEntry proto) {
    // Convert days list to day name (e.g., "Monday")
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = proto.days.isNotEmpty && proto.days.first < dayNames.length
        ? dayNames[proto.days.first]
        : 'Unknown';

    // Convert mode to string
    final modeStr = _modeToString(proto.action.mode);

    return domain.ScheduleEntry(
      id: proto.id,
      deviceId: proto.deviceId,
      day: dayName,
      mode: modeStr,
      timeRange: proto.time,
      tempDay: proto.action.temp,
      tempNight: proto.action.temp, // Same temp for now
      isActive: proto.enabled,
    );
  }

  String _modeToString(OperationMode mode) {
    switch (mode) {
      case OperationMode.OPERATION_MODE_AUTO:
        return 'Auto';
      case OperationMode.OPERATION_MODE_HEAT:
        return 'Heating';
      case OperationMode.OPERATION_MODE_COOL:
        return 'Cooling';
      case OperationMode.OPERATION_MODE_FAN_ONLY:
        return 'Ventilation';
      default:
        return 'Auto';
    }
  }
}
