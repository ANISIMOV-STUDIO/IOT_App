/// Device Repository Implementation
///
/// Concrete implementation of device repository
/// Handles device management operations
library;

import 'dart:convert';
import '../../core/services/api_service.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/hvac_repository.dart';
import '../models/hvac_unit_model.dart';

/// Implementation of DeviceRepository
class DeviceRepositoryImpl implements DeviceRepository {
  final ApiService _apiService;
  final HvacRepository _hvacRepository;

  DeviceRepositoryImpl({
    required ApiService apiService,
    required HvacRepository hvacRepository,
  })  : _apiService = apiService,
        _hvacRepository = hvacRepository;

  @override
  Future<HvacUnit> addDevice(DeviceInfo deviceInfo) async {
    try {
      final response = await _apiService.post('/devices', body: {
        'mac_address': deviceInfo.macAddress,
        'name': deviceInfo.name,
        if (deviceInfo.location != null) 'location': deviceInfo.location,
        if (deviceInfo.model != null) 'model': deviceInfo.model,
        if (deviceInfo.firmware != null) 'firmware': deviceInfo.firmware,
      });

      // Parse response body since post() returns http.Response
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add device');
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      // Convert response to HVAC unit
      final unitModel =
          HvacUnitModel.fromJson(responseData['device'] ?? responseData);
      return unitModel.toEntity();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<bool> removeDevice(String deviceId) async {
    try {
      await _apiService.delete('/devices/$deviceId');
      return true;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> connect() async {
    // Delegate to HVAC repository for connection management
    await _hvacRepository.connect();
  }

  @override
  Future<void> disconnect() async {
    // Delegate to HVAC repository for connection management
    await _hvacRepository.disconnect();
  }

  @override
  bool isConnected() {
    // Delegate to HVAC repository for connection status
    return _hvacRepository.isConnected();
  }

  @override
  Future<List<DeviceInfo>> scanForDevices() async {
    try {
      final response = await _apiService.get('/devices/scan');

      // Parse response body since get() returns http.Response
      if (response.statusCode != 200) {
        throw Exception('Failed to scan for devices');
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      final devices = (responseData['devices'] as List<dynamic>)
          .map((json) => DeviceInfo(
                macAddress: json['mac_address'] as String,
                name: json['name'] as String? ?? 'Unknown Device',
                location: json['location'] as String?,
                model: json['model'] as String?,
                firmware: json['firmware'] as String?,
              ))
          .toList();

      return devices;
    } catch (e) {
      // For demo/mock mode, return sample devices
      if (e.toString().contains('404') || e.toString().contains('mock')) {
        return _getMockDevices();
      }
      throw _handleError(e);
    }
  }

  @override
  Future<bool> pairDevice(String macAddress, String pairingCode) async {
    try {
      final response = await _apiService.post('/devices/pair', body: {
        'mac_address': macAddress,
        'pairing_code': pairingCode,
      });

      // Parse response body since post() returns http.Response
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to pair device');
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      return responseData['success'] == true;
    } catch (e) {
      // Mock success for demo
      if (e.toString().contains('mock')) {
        await Future.delayed(const Duration(seconds: 2));
        return true;
      }
      throw _handleError(e);
    }
  }

  @override
  Future<bool> factoryReset(String deviceId) async {
    try {
      final response = await _apiService.post('/devices/$deviceId/reset');

      // Parse response body since post() returns http.Response
      if (response.statusCode != 200) {
        throw Exception('Failed to reset device');
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      return responseData['success'] == true;
    } catch (e) {
      // Mock success for demo
      if (e.toString().contains('mock')) {
        await Future.delayed(const Duration(seconds: 1));
        return true;
      }
      throw _handleError(e);
    }
  }

  @override
  Future<bool> updateFirmware(String deviceId, String firmwareVersion) async {
    try {
      final response =
          await _apiService.post('/devices/$deviceId/firmware', body: {
        'version': firmwareVersion,
      });

      // Parse response body since post() returns http.Response
      if (response.statusCode != 200) {
        throw Exception('Failed to update firmware');
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      return responseData['success'] == true;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getDeviceDiagnostics(String deviceId) async {
    try {
      final response = await _apiService.get('/devices/$deviceId/diagnostics');

      // Parse response body since get() returns http.Response
      if (response.statusCode != 200) {
        throw Exception('Failed to get device diagnostics');
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      return responseData;
    } catch (e) {
      // Return mock diagnostics for demo
      if (e.toString().contains('mock')) {
        return _getMockDiagnostics(deviceId);
      }
      throw _handleError(e);
    }
  }

  /// Get mock devices for demo/testing
  List<DeviceInfo> _getMockDevices() {
    return [
      const DeviceInfo(
        macAddress: 'AA:BB:CC:DD:EE:01',
        name: 'Living Room AC',
        location: 'Living Room',
        model: 'SmartAC Pro 2000',
        firmware: 'v2.1.0',
      ),
      const DeviceInfo(
        macAddress: 'AA:BB:CC:DD:EE:02',
        name: 'Bedroom AC',
        location: 'Master Bedroom',
        model: 'SmartAC Lite',
        firmware: 'v1.8.5',
      ),
      const DeviceInfo(
        macAddress: 'AA:BB:CC:DD:EE:03',
        name: 'Office Heater',
        location: 'Home Office',
        model: 'HeatMax Secure',
        firmware: 'v3.0.1',
      ),
    ];
  }

  /// Get mock diagnostics for demo/testing
  Map<String, dynamic> _getMockDiagnostics(String deviceId) {
    return {
      'device_id': deviceId,
      'status': 'healthy',
      'uptime_hours': 1234,
      'last_maintenance':
          DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'wifi_strength': -65,
      'cpu_usage': 45,
      'memory_usage': 62,
      'error_count': 0,
      'firmware_version': 'v2.1.0',
      'hardware_version': 'hw1.2',
    };
  }

  /// Handle and transform errors
  Exception _handleError(dynamic error) {
    final errorStr = error.toString();

    if (errorStr.contains('401')) {
      return Exception('Unauthorized: Please login again');
    } else if (errorStr.contains('403')) {
      return Exception('Permission denied');
    } else if (errorStr.contains('404')) {
      return Exception('Device not found');
    } else if (errorStr.contains('409')) {
      return Exception('Device already exists');
    } else if (errorStr.contains('network')) {
      return Exception('Network error');
    } else if (errorStr.contains('timeout')) {
      return Exception('Request timeout');
    } else {
      return Exception(errorStr.replaceAll('Exception: ', ''));
    }
  }
}
