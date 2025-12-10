/// Dashboard BLoC — состояние главного экрана
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/smart_device.dart';
import '../../../domain/entities/climate.dart';
import '../../../domain/entities/energy_stats.dart';
import '../../../domain/entities/occupant.dart';
import '../../../domain/repositories/smart_device_repository.dart';
import '../../../domain/repositories/climate_repository.dart';
import '../../../domain/repositories/energy_repository.dart';
import '../../../domain/repositories/occupant_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final SmartDeviceRepository _deviceRepository;
  final ClimateRepository _climateRepository;
  final EnergyRepository _energyRepository;
  final OccupantRepository _occupantRepository;

  StreamSubscription<List<SmartDevice>>? _devicesSubscription;
  StreamSubscription<ClimateState>? _climateSubscription;
  StreamSubscription<EnergyStats>? _energySubscription;
  StreamSubscription<List<Occupant>>? _occupantsSubscription;

  DashboardBloc({
    required SmartDeviceRepository deviceRepository,
    required ClimateRepository climateRepository,
    required EnergyRepository energyRepository,
    required OccupantRepository occupantRepository,
  })  : _deviceRepository = deviceRepository,
        _climateRepository = climateRepository,
        _energyRepository = energyRepository,
        _occupantRepository = occupantRepository,
        super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardRefreshed>(_onRefreshed);
    on<DeviceToggled>(_onDeviceToggled);
    on<TemperatureChanged>(_onTemperatureChanged);
    on<HumidityChanged>(_onHumidityChanged);
    on<ClimateModeChanged>(_onClimateModeChanged);
    on<DevicesUpdated>(_onDevicesUpdated);
    on<ClimateUpdated>(_onClimateUpdated);
    on<EnergyUpdated>(_onEnergyUpdated);
    on<OccupantsUpdated>(_onOccupantsUpdated);
  }

  Future<void> _onStarted(DashboardStarted event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    try {
      final results = await Future.wait([
        _deviceRepository.getAllDevices(),
        _climateRepository.getCurrentState(),
        _energyRepository.getTodayStats(),
        _energyRepository.getDevicePowerUsage(),
        _occupantRepository.getAllOccupants(),
      ]);

      emit(state.copyWith(
        status: DashboardStatus.success,
        devices: results[0] as List<SmartDevice>,
        climate: results[1] as ClimateState,
        energyStats: results[2] as EnergyStats,
        powerUsage: results[3] as List<DeviceEnergyUsage>,
        occupants: results[4] as List<Occupant>,
      ));

      _subscribeToUpdates();
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _subscribeToUpdates() {
    _devicesSubscription = _deviceRepository.watchDevices().listen(
      (devices) => add(DevicesUpdated(devices)),
    );
    _climateSubscription = _climateRepository.watchClimate().listen(
      (climate) => add(ClimateUpdated(climate)),
    );
    _energySubscription = _energyRepository.watchStats().listen(
      (stats) => add(EnergyUpdated(stats)),
    );
    _occupantsSubscription = _occupantRepository.watchOccupants().listen(
      (occupants) => add(OccupantsUpdated(occupants)),
    );
  }

  Future<void> _onRefreshed(DashboardRefreshed event, Emitter<DashboardState> emit) async {
    add(const DashboardStarted());
  }

  Future<void> _onDeviceToggled(DeviceToggled event, Emitter<DashboardState> emit) async {
    try {
      await _deviceRepository.toggleDevice(event.deviceId, event.isOn);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка переключения: $e'));
    }
  }

  Future<void> _onTemperatureChanged(TemperatureChanged event, Emitter<DashboardState> emit) async {
    try {
      await _climateRepository.setTargetTemperature(event.temperature);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка установки температуры: $e'));
    }
  }

  Future<void> _onHumidityChanged(HumidityChanged event, Emitter<DashboardState> emit) async {
    try {
      await _climateRepository.setHumidity(event.humidity);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка установки влажности: $e'));
    }
  }

  Future<void> _onClimateModeChanged(ClimateModeChanged event, Emitter<DashboardState> emit) async {
    try {
      await _climateRepository.setMode(event.mode);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка смены режима: $e'));
    }
  }

  void _onDevicesUpdated(DevicesUpdated event, Emitter<DashboardState> emit) {
    emit(state.copyWith(devices: event.devices));
  }

  void _onClimateUpdated(ClimateUpdated event, Emitter<DashboardState> emit) {
    emit(state.copyWith(climate: event.climate));
  }

  void _onEnergyUpdated(EnergyUpdated event, Emitter<DashboardState> emit) {
    emit(state.copyWith(energyStats: event.stats));
  }

  void _onOccupantsUpdated(OccupantsUpdated event, Emitter<DashboardState> emit) {
    emit(state.copyWith(occupants: event.occupants));
  }

  @override
  Future<void> close() {
    _devicesSubscription?.cancel();
    _climateSubscription?.cancel();
    _energySubscription?.cancel();
    _occupantsSubscription?.cancel();
    return super.close();
  }
}
