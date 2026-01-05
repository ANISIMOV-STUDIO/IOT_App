/// gRPC client for HVAC Service (Mobile/Desktop)
library;

import 'package:grpc/grpc.dart';

import '../../../../domain/entities/hvac_device.dart' as domain;
import '../../../../domain/entities/climate.dart';
import '../../../../generated/protos/protos.dart';
import '../grpc_interceptor.dart';

/// gRPC client for HVAC device operations
class HvacGrpcClient {
  final ClientChannel _channel;
  final Future<String?> Function() _getToken;
  late final HvacServiceClient _client;

  HvacGrpcClient(this._channel, this._getToken) {
    _client = HvacServiceClient(
      _channel,
      interceptors: [AuthGrpcInterceptor(_getToken)],
    );
  }

  /// Get all devices
  Future<List<domain.HvacDevice>> listDevices() async {
    final response = await _client.listDevices(Empty());
    return response.devices.map(_mapToDomain).toList();
  }

  /// Get device by ID
  Future<domain.HvacDevice> getDevice(String id) async {
    final response = await _client.getDevice(
      GetDeviceRequest()..id = id,
    );
    return _mapToDomain(response);
  }

  /// Create new device
  Future<domain.HvacDevice> createDevice({
    required String name,
    required String mqttTopic,
  }) async {
    final response = await _client.createDevice(
      CreateDeviceRequest()
        ..name = name
        ..mqttTopic = mqttTopic,
    );
    return _mapToDomain(response);
  }

  /// Update device
  Future<domain.HvacDevice> updateDevice({
    required String id,
    String? name,
    bool? power,
    int? temp,
    OperationMode? mode,
    FanSpeed? supplyFan,
    FanSpeed? exhaustFan,
  }) async {
    final request = UpdateDeviceRequest()..id = id;
    if (name != null) request.name = name;
    if (power != null) request.power = power;
    if (temp != null) request.temp = temp;
    if (mode != null) request.mode = mode;
    if (supplyFan != null) request.supplyFan = supplyFan;
    if (exhaustFan != null) request.exhaustFan = exhaustFan;

    final response = await _client.updateDevice(request);
    return _mapToDomain(response);
  }

  /// Delete device
  Future<void> deleteDevice(String id) async {
    await _client.deleteDevice(DeleteDeviceRequest()..id = id);
  }

  /// Set device power
  Future<domain.HvacDevice> setPower(String deviceId, bool power) async {
    final response = await _client.setPower(
      SetPowerRequest()
        ..deviceId = deviceId
        ..power = power,
    );
    return _mapToDomain(response);
  }

  /// Set temperature
  Future<domain.HvacDevice> setTemperature(String deviceId, int temp) async {
    final response = await _client.setTemperature(
      SetTemperatureRequest()
        ..deviceId = deviceId
        ..temperature = temp,
    );
    return _mapToDomain(response);
  }

  /// Set mode
  Future<domain.HvacDevice> setMode(String deviceId, ClimateMode mode) async {
    final response = await _client.setMode(
      SetModeRequest()
        ..deviceId = deviceId
        ..mode = _mapModeToProto(mode),
    );
    return _mapToDomain(response);
  }

  /// Set fan speeds
  Future<domain.HvacDevice> setFanSpeed(
    String deviceId, {
    FanSpeed? supplyFan,
    FanSpeed? exhaustFan,
  }) async {
    final request = SetFanSpeedRequest()..deviceId = deviceId;
    if (supplyFan != null) request.supplyFan = supplyFan;
    if (exhaustFan != null) request.exhaustFan = exhaustFan;

    final response = await _client.setFanSpeed(request);
    return _mapToDomain(response);
  }

  /// Apply preset
  Future<domain.HvacDevice> applyPreset(
    String deviceId,
    String presetId,
  ) async {
    final response = await _client.applyPreset(
      ApplyPresetRequest()
        ..deviceId = deviceId
        ..presetId = presetId,
    );
    return _mapToDomain(response);
  }

  /// Stream device updates (real-time)
  Stream<domain.HvacDevice> streamDeviceUpdates({String? deviceId}) {
    final request = StreamDeviceUpdatesRequest();
    if (deviceId != null) request.deviceId = deviceId;

    return _client.streamDeviceUpdates(request).map(_mapToDomain);
  }

  // ============================================
  // MAPPERS
  // ============================================

  domain.HvacDevice _mapToDomain(HvacDevice proto) {
    return domain.HvacDevice(
      id: proto.id,
      name: proto.name,
      brand: 'ZILON', // Default brand
      deviceType: domain.HvacDeviceType.ventilation,
      isOnline: proto.status == DeviceStatus.DEVICE_STATUS_ONLINE,
      isActive: proto.power,
    );
  }

  OperationMode _mapModeToProto(ClimateMode mode) {
    switch (mode) {
      case ClimateMode.auto:
        return OperationMode.OPERATION_MODE_AUTO;
      case ClimateMode.heating:
        return OperationMode.OPERATION_MODE_HEAT;
      case ClimateMode.cooling:
        return OperationMode.OPERATION_MODE_COOL;
      case ClimateMode.ventilation:
        return OperationMode.OPERATION_MODE_FAN_ONLY;
      case ClimateMode.dry:
      case ClimateMode.off:
        return OperationMode.OPERATION_MODE_UNSPECIFIED;
    }
  }
}
