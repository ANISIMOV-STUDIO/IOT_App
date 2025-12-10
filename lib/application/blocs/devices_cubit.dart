import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

// ============================================
// STATE
// ============================================

enum DevicesStatus { initial, loading, success, failure }

class DevicesState extends Equatable {
  final DevicesStatus status;
  final List<Device> devices;
  final String? errorMessage;

  const DevicesState({
    this.status = DevicesStatus.initial,
    this.devices = const [],
    this.errorMessage,
  });

  DevicesState copyWith({
    DevicesStatus? status,
    List<Device>? devices,
    String? errorMessage,
  }) {
    return DevicesState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Получить устройство по ID
  Device? getDevice(String id) {
    try {
      return devices.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Устройства по типу
  List<Device> byType(DeviceType type) => 
      devices.where((d) => d.type == type).toList();

  /// Устройства по комнате
  List<Device> byRoom(String roomId) => 
      devices.where((d) => d.roomId == roomId).toList();

  /// Только включенные
  List<Device> get activeDevices => devices.where((d) => d.isOn).toList();

  @override
  List<Object?> get props => [status, devices, errorMessage];
}

// ============================================
// CUBIT
// ============================================

class DevicesCubit extends Cubit<DevicesState> {
  final DeviceRepository _repository;

  DevicesCubit(this._repository) : super(const DevicesState());

  /// Загрузить все устройства
  Future<void> loadDevices() async {
    emit(state.copyWith(status: DevicesStatus.loading));
    
    try {
      final devices = await _repository.getDevices();
      emit(state.copyWith(
        status: DevicesStatus.success,
        devices: devices,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DevicesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Переключить устройство
  Future<void> toggleDevice(String deviceId) async {
    try {
      final updated = await _repository.toggleDevice(deviceId);
      
      final devices = state.devices.map((d) {
        return d.id == deviceId ? updated : d;
      }).toList();
      
      emit(state.copyWith(devices: devices));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Обновить настройки устройства
  Future<void> updateDevice(String deviceId, Map<String, dynamic> settings) async {
    try {
      final updated = await _repository.updateDevice(deviceId, settings);
      
      final devices = state.devices.map((d) {
        return d.id == deviceId ? updated : d;
      }).toList();
      
      emit(state.copyWith(devices: devices));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Подписаться на обновления
  void watchDevices() {
    _repository.watchDevices().listen((devices) {
      emit(state.copyWith(
        status: DevicesStatus.success,
        devices: devices,
      ));
    });
  }
}
