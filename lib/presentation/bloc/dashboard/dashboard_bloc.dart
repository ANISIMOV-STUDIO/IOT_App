/// Dashboard BLoC — состояние главного экрана
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/smart_device.dart';
import '../../../domain/entities/climate.dart';
import '../../../domain/entities/hvac_device.dart';
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
  StreamSubscription<List<HvacDevice>>? _hvacDevicesSubscription;

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
    on<DevicePowerToggled>(_onDevicePowerToggled);
    on<TemperatureChanged>(_onTemperatureChanged);
    on<HumidityChanged>(_onHumidityChanged);
    on<ClimateModeChanged>(_onClimateModeChanged);
    on<SupplyAirflowChanged>(_onSupplyAirflowChanged);
    on<ExhaustAirflowChanged>(_onExhaustAirflowChanged);
    on<PresetChanged>(_onPresetChanged);
    on<AllDevicesOff>(_onAllDevicesOff);
    on<DevicesUpdated>(_onDevicesUpdated);
    on<ClimateUpdated>(_onClimateUpdated);
    on<EnergyUpdated>(_onEnergyUpdated);
    on<OccupantsUpdated>(_onOccupantsUpdated);
    on<HvacDeviceSelected>(_onHvacDeviceSelected);
    on<HvacDevicesUpdated>(_onHvacDevicesUpdated);
  }

  Future<void> _onStarted(DashboardStarted event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    try {
      // Загружаем HVAC устройства первыми
      final hvacDevices = await _climateRepository.getAllHvacDevices();
      final selectedId = hvacDevices.isNotEmpty ? hvacDevices.first.id : null;

      // Устанавливаем выбранное устройство в репозитории
      if (selectedId != null) {
        _climateRepository.setSelectedDevice(selectedId);
      }

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
        schedule: DashboardState.defaultSchedule,
        hvacDevices: hvacDevices,
        selectedHvacDeviceId: selectedId,
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
    _hvacDevicesSubscription = _climateRepository.watchHvacDevices().listen(
      (devices) => add(HvacDevicesUpdated(devices)),
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

  Future<void> _onDevicePowerToggled(DevicePowerToggled event, Emitter<DashboardState> emit) async {
    try {
      await _climateRepository.setPower(event.isOn);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка переключения питания: $e'));
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

  Future<void> _onSupplyAirflowChanged(SupplyAirflowChanged event, Emitter<DashboardState> emit) async {
    try {
      await _climateRepository.setSupplyAirflow(event.value);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка настройки притока: $e'));
    }
  }

  Future<void> _onExhaustAirflowChanged(ExhaustAirflowChanged event, Emitter<DashboardState> emit) async {
    try {
      await _climateRepository.setExhaustAirflow(event.value);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка настройки вытяжки: $e'));
    }
  }

  Future<void> _onPresetChanged(PresetChanged event, Emitter<DashboardState> emit) async {
    try {
      await _climateRepository.setPreset(event.preset);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка смены пресета: $e'));
    }
  }

  Future<void> _onAllDevicesOff(AllDevicesOff event, Emitter<DashboardState> emit) async {
    try {
      await _climateRepository.setPower(false);
      for (final device in state.devices) {
        if (device.isOn) {
          await _deviceRepository.toggleDevice(device.id, false);
        }
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка выключения: $e'));
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

  Future<void> _onHvacDeviceSelected(HvacDeviceSelected event, Emitter<DashboardState> emit) async {
    try {
      // Устанавливаем выбранное устройство в репозитории
      _climateRepository.setSelectedDevice(event.deviceId);

      // Загружаем состояние выбранного устройства
      final climate = await _climateRepository.getDeviceState(event.deviceId);

      emit(state.copyWith(
        selectedHvacDeviceId: event.deviceId,
        climate: climate,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка выбора устройства: $e'));
    }
  }

  void _onHvacDevicesUpdated(HvacDevicesUpdated event, Emitter<DashboardState> emit) {
    emit(state.copyWith(hvacDevices: event.devices));
  }

  @override
  Future<void> close() {
    _devicesSubscription?.cancel();
    _climateSubscription?.cancel();
    _energySubscription?.cancel();
    _occupantsSubscription?.cancel();
    _hvacDevicesSubscription?.cancel();
    return super.close();
  }
}
