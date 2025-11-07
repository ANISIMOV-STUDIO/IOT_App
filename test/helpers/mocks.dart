import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/domain/repositories/hvac_repository.dart';
import 'package:hvac_control/domain/repositories/auth_repository.dart';
import 'package:hvac_control/domain/entities/hvac_unit.dart';
import 'package:hvac_control/domain/entities/user.dart';
import 'package:hvac_control/domain/entities/temperature_reading.dart';
import 'package:hvac_control/domain/entities/device_type.dart';
import 'package:hvac_control/domain/entities/ventilation_mode.dart';
import 'package:hvac_control/domain/entities/mode_preset.dart';
import 'package:hvac_control/domain/entities/week_schedule.dart';
import 'package:hvac_control/domain/entities/wifi_status.dart';
import 'package:hvac_control/domain/entities/alert.dart';
import 'package:hvac_control/domain/usecases/get_all_units.dart';
import 'package:hvac_control/domain/usecases/device/add_device.dart';
import 'package:hvac_control/domain/usecases/device/remove_device.dart';
import 'package:hvac_control/domain/usecases/device/connect_to_devices.dart';
import 'package:hvac_control/core/services/api_service.dart';
import 'package:hvac_control/core/services/cache_service.dart';
import 'package:hvac_control/core/services/grpc_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart' as dio;
import 'package:grpc/grpc.dart';

// Repository Mocks
class MockHvacRepository extends Mock implements HvacRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

// Service Mocks
class MockApiService extends Mock implements ApiService {}

class MockCacheService extends Mock implements CacheService {}

class MockGrpcService extends Mock implements GrpcService {}

// Network Mocks
class MockDio extends Mock implements dio.Dio {}

class MockResponse extends Mock implements dio.Response {}

class MockClientChannel extends Mock implements ClientChannel {}

// BLoC Mocks
class MockCubit<S> extends Mock implements Cubit<S> {}

class MockBloc<E, S> extends Mock implements Bloc<E, S> {}

// Entity Mocks
class MockHvacUnit extends Mock implements HvacUnit {}

class MockUser extends Mock implements User {}

// Use Case Mocks
class MockGetAllUnits extends Mock implements GetAllUnits {}

class MockAddDevice extends Mock implements AddDevice {}

class MockRemoveDevice extends Mock implements RemoveDevice {}

class MockConnectToDevices extends Mock implements ConnectToDevices {}

// Test Fake Classes for more control
class FakeHvacUnit extends Fake implements HvacUnit {
  @override
  final String id;
  @override
  final String name;
  @override
  final double currentTemp;
  @override
  final double targetTemp;
  @override
  final String mode;
  @override
  final bool power;
  @override
  final String fanSpeed;
  @override
  final DateTime timestamp;
  @override
  final String? macAddress;
  @override
  final String? location;
  @override
  final double humidity;
  @override
  final DeviceType deviceType;
  @override
  final double? supplyAirTemp;
  @override
  final double? roomTemp;
  @override
  final double? outdoorTemp;
  @override
  final double? heatingTemp;
  @override
  final double? coolingTemp;
  @override
  final int? supplyFanSpeed;
  @override
  final int? exhaustFanSpeed;
  @override
  final VentilationMode? ventMode;
  @override
  final Map<VentilationMode, ModePreset>? modePresets;
  @override
  final WeekSchedule? schedule;
  @override
  final WiFiStatus? wifiStatus;
  @override
  final List<Alert>? alerts;

  FakeHvacUnit({
    this.id = 'fake-unit-1',
    this.name = 'Fake HVAC Unit',
    this.currentTemp = 22.5,
    this.targetTemp = 23.0,
    this.mode = 'cooling',
    this.power = true,
    this.fanSpeed = 'medium',
    DateTime? timestamp,
    this.macAddress,
    this.location,
    this.humidity = 50.0,
    this.deviceType = DeviceType.hvac,
    this.supplyAirTemp,
    this.roomTemp,
    this.outdoorTemp,
    this.heatingTemp,
    this.coolingTemp,
    this.supplyFanSpeed,
    this.exhaustFanSpeed,
    this.ventMode,
    this.modePresets,
    this.schedule,
    this.wifiStatus,
    this.alerts,
  }) : timestamp = timestamp ?? DateTime.now();
}

class FakeUser extends Fake implements User {
  @override
  final String id;
  @override
  final String email;
  @override
  final String name;
  final String? role;
  @override
  final DateTime createdAt;
  final String? token;

  FakeUser({
    this.id = 'fake-user-1',
    this.email = 'fake@example.com',
    this.name = 'Fake User',
    this.role = 'admin',
    DateTime? createdAt,
    this.token,
  }) : createdAt = createdAt ?? DateTime.now();
}

// Custom Stub Classes for complex scenarios
class StubHvacRepository implements HvacRepository {
  final List<HvacUnit> _units = [];
  final bool shouldThrowError;
  final Duration? delay;
  bool _isConnected = false;

  StubHvacRepository({
    List<HvacUnit>? initialUnits,
    this.shouldThrowError = false,
    this.delay,
  }) {
    if (initialUnits != null) {
      _units.addAll(initialUnits);
    }
  }

  @override
  Stream<List<HvacUnit>> getAllUnits() {
    if (shouldThrowError) {
      return Stream.error(Exception('Failed to fetch units'));
    }
    return Stream.value(_units);
  }

  @override
  Stream<HvacUnit> getUnitById(String id) {
    if (shouldThrowError) {
      return Stream.error(Exception('Failed to fetch unit'));
    }
    return Stream.value(_units.firstWhere((unit) => unit.id == id));
  }

  @override
  Future<List<TemperatureReading>> getTemperatureHistory(String unitId,
      {int hours = 24}) async {
    if (shouldThrowError) {
      throw Exception('Failed to fetch temperature history');
    }
    return [];
  }

  @override
  Future<void> updateUnit({
    required String unitId,
    bool? power,
    double? targetTemp,
    String? mode,
    String? fanSpeed,
  }) async {
    if (shouldThrowError) {
      throw Exception('Failed to update unit');
    }
  }

  @override
  Future<void> updateUnitEntity(HvacUnit unit) async {
    if (shouldThrowError) {
      throw Exception('Failed to update unit');
    }
    final index = _units.indexWhere((u) => u.id == unit.id);
    if (index != -1) {
      _units[index] = unit;
    }
  }

  @override
  Future<void> connect() async {
    if (shouldThrowError) {
      throw Exception('Failed to connect');
    }
    _isConnected = true;
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
  }

  @override
  bool isConnected() => _isConnected;
}

// Test Data Factory
class TestDataFactory {
  static List<HvacUnit> createHvacUnits({int count = 5}) {
    return List.generate(
      count,
      (index) => FakeHvacUnit(
        id: 'unit-$index',
        name: 'HVAC Unit ${index + 1}',
        currentTemp: 20.0 + index,
        targetTemp: 22.0 + index,
        mode: index % 2 == 0 ? 'cooling' : 'heating',
        power: index % 3 != 0,
        fanSpeed: 'medium',
      ),
    );
  }

  static User createUser({
    String? id,
    String? email,
    String? name,
    String? role,
  }) {
    return FakeUser(
      id: id ?? 'test-user',
      email: email ?? 'test@example.com',
      name: name ?? 'Test User',
      role: role ?? 'user',
    );
  }
}

// Setup functions for common mock scenarios
void setupCommonMocks() {
  registerFallbackValue(FakeHvacUnit());
  registerFallbackValue(FakeUser());
  registerFallbackValue(Uri.parse('http://example.com'));
  registerFallbackValue(dio.RequestOptions(path: ''));
}

// Mock response builders
class MockResponseBuilder {
  static dio.Response<T> success<T>(T data, {int statusCode = 200}) {
    return dio.Response<T>(
      data: data,
      statusCode: statusCode,
      statusMessage: 'OK',
      requestOptions: dio.RequestOptions(path: ''),
    );
  }

  static dio.Response<T> error<T>({
    int statusCode = 500,
    String? message,
  }) {
    return dio.Response<T>(
      data: null,
      statusCode: statusCode,
      statusMessage: message ?? 'Server Error',
      requestOptions: dio.RequestOptions(path: ''),
    );
  }
}

// Add mock navigator observer
class MockNavigatorObserver extends Mock implements NavigatorObserver {}
