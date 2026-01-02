/// Dashboard BLoC — состояние главного экрана
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/api_exception.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../domain/entities/smart_device.dart';
import '../../../domain/entities/climate.dart';
import '../../../domain/entities/hvac_device.dart';
import '../../../domain/entities/energy_stats.dart';
import '../../../domain/entities/occupant.dart';
import '../../../domain/entities/schedule_entry.dart';
import '../../../domain/entities/unit_notification.dart';
import '../../../domain/entities/graph_data.dart';
import '../../../domain/entities/device_full_state.dart';
import '../../../domain/entities/alarm_info.dart';
import '../../../domain/repositories/smart_device_repository.dart';
import '../../../domain/repositories/climate_repository.dart';
import '../../../domain/repositories/energy_repository.dart';
import '../../../domain/repositories/occupant_repository.dart';
import '../../../domain/repositories/schedule_repository.dart';
import '../../../domain/repositories/notification_repository.dart';
import '../../../domain/repositories/graph_data_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final SmartDeviceRepository _deviceRepository;
  final ClimateRepository _climateRepository;
  final EnergyRepository _energyRepository;
  final OccupantRepository _occupantRepository;
  final ScheduleRepository _scheduleRepository;
  final NotificationRepository _notificationRepository;
  final GraphDataRepository _graphDataRepository;
  final ConnectivityService? _connectivityService;

  StreamSubscription<List<SmartDevice>>? _devicesSubscription;
  StreamSubscription<ClimateState>? _climateSubscription;
  StreamSubscription<EnergyStats>? _energySubscription;
  StreamSubscription<List<Occupant>>? _occupantsSubscription;
  StreamSubscription<List<HvacDevice>>? _hvacDevicesSubscription;
  StreamSubscription<List<ScheduleEntry>>? _scheduleSubscription;
  StreamSubscription<List<UnitNotification>>? _notificationsSubscription;
  StreamSubscription<List<GraphDataPoint>>? _graphDataSubscription;
  StreamSubscription<NetworkStatus>? _connectivitySubscription;

  DashboardBloc({
    required SmartDeviceRepository deviceRepository,
    required ClimateRepository climateRepository,
    required EnergyRepository energyRepository,
    required OccupantRepository occupantRepository,
    required ScheduleRepository scheduleRepository,
    required NotificationRepository notificationRepository,
    required GraphDataRepository graphDataRepository,
    ConnectivityService? connectivityService,
  })  : _deviceRepository = deviceRepository,
        _climateRepository = climateRepository,
        _energyRepository = energyRepository,
        _occupantRepository = occupantRepository,
        _scheduleRepository = scheduleRepository,
        _notificationRepository = notificationRepository,
        _graphDataRepository = graphDataRepository,
        _connectivityService = connectivityService,
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
    // New event handlers
    on<ScheduleLoaded>(_onScheduleLoaded);
    on<ScheduleEntryToggled>(_onScheduleEntryToggled);
    on<NotificationsLoaded>(_onNotificationsLoaded);
    on<NotificationRead>(_onNotificationRead);
    on<NotificationDismissed>(_onNotificationDismissed);
    on<GraphDataLoaded>(_onGraphDataLoaded);
    on<GraphMetricChanged>(_onGraphMetricChanged);
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<DeviceFullStateLoaded>(_onDeviceFullStateLoaded);
    on<AlarmHistoryLoaded>(_onAlarmHistoryLoaded);
    on<LoadAlarmHistory>(_onLoadAlarmHistory);
    on<RegisterDeviceRequested>(_onRegisterDeviceRequested);
    on<ClearRegistrationError>(_onClearRegistrationError);
    on<DeleteDeviceRequested>(_onDeleteDeviceRequested);
    on<RenameDeviceRequested>(_onRenameDeviceRequested);
  }

  void _onClearRegistrationError(
    ClearRegistrationError event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(registrationError: null));
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

      // Load additional data for selected device
      final weeklySchedule = selectedId != null
          ? await _scheduleRepository.getSchedule(selectedId)
          : <ScheduleEntry>[];
      final notifications = await _notificationRepository.getNotifications(
        deviceId: selectedId,
      );
      final graphData = selectedId != null
          ? await _graphDataRepository.getGraphData(
              deviceId: selectedId,
              metric: GraphMetric.temperature,
              from: DateTime.now().subtract(const Duration(days: 7)),
              to: DateTime.now(),
            )
          : <GraphDataPoint>[];

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
        weeklySchedule: weeklySchedule,
        unitNotifications: notifications,
        graphData: graphData,
      ));

      _subscribeToUpdates(selectedId);
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _subscribeToUpdates(String? selectedDeviceId) {
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
    // Subscribe to new streams
    if (selectedDeviceId != null) {
      _scheduleSubscription = _scheduleRepository.watchSchedule(selectedDeviceId).listen(
        (schedule) => add(ScheduleLoaded(schedule)),
      );
      _graphDataSubscription = _graphDataRepository.watchGraphData(
        deviceId: selectedDeviceId,
        metric: state.selectedGraphMetric,
      ).listen(
        (data) => add(GraphDataLoaded(data)),
      );
    }
    _notificationsSubscription = _notificationRepository
        .watchNotifications(deviceId: selectedDeviceId)
        .listen(
          (notifications) => add(NotificationsLoaded(notifications)),
        );
    // Подписка на изменения сети
    _connectivitySubscription = _connectivityService?.onStatusChange.listen(
      (status) => add(ConnectivityChanged(status == NetworkStatus.offline)),
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

  // Schedule handlers
  void _onScheduleLoaded(ScheduleLoaded event, Emitter<DashboardState> emit) {
    emit(state.copyWith(weeklySchedule: event.schedule));
  }

  Future<void> _onScheduleEntryToggled(
    ScheduleEntryToggled event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await _scheduleRepository.toggleEntry(event.entryId, event.isActive);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка изменения расписания: $e'));
    }
  }

  // Notification handlers
  void _onNotificationsLoaded(NotificationsLoaded event, Emitter<DashboardState> emit) {
    emit(state.copyWith(unitNotifications: event.notifications));
  }

  Future<void> _onNotificationRead(
    NotificationRead event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await _notificationRepository.markAsRead(event.notificationId);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка отметки уведомления: $e'));
    }
  }

  Future<void> _onNotificationDismissed(
    NotificationDismissed event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await _notificationRepository.dismiss(event.notificationId);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка удаления уведомления: $e'));
    }
  }

  // Graph handlers
  void _onGraphDataLoaded(GraphDataLoaded event, Emitter<DashboardState> emit) {
    emit(state.copyWith(graphData: event.data));
  }

  Future<void> _onGraphMetricChanged(
    GraphMetricChanged event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(selectedGraphMetric: event.metric));

    // Reload graph data for new metric
    final deviceId = state.selectedHvacDeviceId;
    if (deviceId != null) {
      try {
        final data = await _graphDataRepository.getGraphData(
          deviceId: deviceId,
          metric: event.metric,
          from: DateTime.now().subtract(const Duration(days: 7)),
          to: DateTime.now(),
        );
        emit(state.copyWith(graphData: data));
      } catch (e) {
        emit(state.copyWith(errorMessage: 'Ошибка загрузки графика: $e'));
      }
    }
  }

  // DeviceFullState handlers
  void _onDeviceFullStateLoaded(
    DeviceFullStateLoaded event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(deviceFullState: event.deviceFullState));
  }

  void _onAlarmHistoryLoaded(
    AlarmHistoryLoaded event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(alarmHistory: event.alarmHistory));
  }

  Future<void> _onLoadAlarmHistory(
    LoadAlarmHistory event,
    Emitter<DashboardState> emit,
  ) async {
    // TODO: Implement when repository method available
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(isOffline: event.isOffline));
  }

  Future<void> _onRegisterDeviceRequested(
    RegisterDeviceRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isRegistering: true, registrationError: null));
    try {
      final device = await _climateRepository.registerDevice(
        event.macAddress,
        event.name,
      );
      // Обновляем список устройств
      final updatedDevices = [...state.hvacDevices, device];
      emit(state.copyWith(
        isRegistering: false,
        hvacDevices: updatedDevices,
        selectedHvacDeviceId: device.id,
      ));
    } catch (e) {
      // Извлекаем только сообщение для пользователя
      String errorMessage;
      if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Не удалось зарегистрировать устройство';
      }
      emit(state.copyWith(
        isRegistering: false,
        registrationError: errorMessage,
      ));
    }
  }

  Future<void> _onDeleteDeviceRequested(
    DeleteDeviceRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await _climateRepository.deleteDevice(event.deviceId);

      // Удаляем из локального списка
      final updatedDevices = state.hvacDevices
          .where((d) => d.id != event.deviceId)
          .toList();

      // Выбираем другое устройство если удалено текущее
      String? newSelectedId;
      if (state.selectedHvacDeviceId == event.deviceId) {
        newSelectedId = updatedDevices.isNotEmpty ? updatedDevices.first.id : null;
        if (newSelectedId != null) {
          _climateRepository.setSelectedDevice(newSelectedId);
        }
      }

      emit(state.copyWith(
        hvacDevices: updatedDevices,
        selectedHvacDeviceId: newSelectedId ?? state.selectedHvacDeviceId,
      ));
    } catch (e) {
      String errorMessage;
      if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Не удалось удалить устройство';
      }
      emit(state.copyWith(registrationError: errorMessage));
    }
  }

  Future<void> _onRenameDeviceRequested(
    RenameDeviceRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await _climateRepository.renameDevice(event.deviceId, event.newName);

      // Обновляем имя в локальном списке
      final updatedDevices = state.hvacDevices.map((d) {
        if (d.id == event.deviceId) {
          return d.copyWith(name: event.newName);
        }
        return d;
      }).toList();

      emit(state.copyWith(hvacDevices: updatedDevices));
    } catch (e) {
      String errorMessage;
      if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'Не удалось переименовать устройство';
      }
      emit(state.copyWith(registrationError: errorMessage));
    }
  }

  @override
  Future<void> close() {
    _devicesSubscription?.cancel();
    _climateSubscription?.cancel();
    _energySubscription?.cancel();
    _occupantsSubscription?.cancel();
    _hvacDevicesSubscription?.cancel();
    _scheduleSubscription?.cancel();
    _notificationsSubscription?.cancel();
    _graphDataSubscription?.cancel();
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
