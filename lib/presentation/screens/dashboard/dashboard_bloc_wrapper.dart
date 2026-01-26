/// Dashboard BLoC Wrapper - Handles BLoC listeners and state combining
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hvac_control/core/navigation/app_router.dart';
import 'package:hvac_control/core/services/toast_service.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_state.dart';
import 'package:hvac_control/presentation/bloc/climate/alarms/climate_alarms_bloc.dart';
import 'package:hvac_control/presentation/bloc/climate/core/climate_core_bloc.dart';
import 'package:hvac_control/presentation/bloc/climate/parameters/climate_parameters_bloc.dart';
import 'package:hvac_control/presentation/bloc/climate/power/climate_power_bloc.dart';
import 'package:hvac_control/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:hvac_control/presentation/bloc/devices/devices_bloc.dart';
import 'package:hvac_control/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:hvac_control/presentation/bloc/schedule/schedule_bloc.dart';

/// Combined dashboard state from all BLoCs
class DashboardData {

  const DashboardData({
    required this.units,
    required this.activeIndex,
    required this.currentUnit,
    required this.coreState,
    required this.powerState,
    required this.parametersState,
    required this.alarmsState,
    required this.connectivityState,
    required this.analyticsState,
    required this.notificationsState,
    required this.scheduleState,
    this.isLoadingDevices = false,
  });
  final List<UnitState> units;
  final int activeIndex;
  final UnitState? currentUnit;
  final ClimateCoreState coreState;
  final ClimatePowerState powerState;
  final ClimateParametersState parametersState;
  final ClimateAlarmsState alarmsState;
  final ConnectivityState connectivityState;
  final AnalyticsState analyticsState;
  final NotificationsState notificationsState;
  final ScheduleState scheduleState;

  /// Loading devices
  final bool isLoadingDevices;

  // ==========================================================================
  // CONVENIENCE GETTERS (compatibility with old ClimateControlState)
  // ==========================================================================

  /// Device full state
  DeviceFullState? get deviceFullState => coreState.deviceFullState;

  /// Is toggling power
  bool get isTogglingPower => powerState.isTogglingPower;

  /// Is toggling schedule
  bool get isTogglingSchedule => powerState.isTogglingSchedule;

  /// Is syncing
  bool get isSyncing => coreState.isSyncing;

  /// Error message (combined from all blocs)
  String? get errorMessage =>
      coreState.errorMessage ??
      powerState.errorMessage ??
      parametersState.errorMessage ??
      alarmsState.errorMessage;

  /// Is pending heating temperature
  bool get isPendingHeatingTemperature => parametersState.isPendingHeatingTemperature;

  /// Is pending cooling temperature
  bool get isPendingCoolingTemperature => parametersState.isPendingCoolingTemperature;

  /// Is pending supply fan
  bool get isPendingSupplyFan => parametersState.isPendingSupplyFan;

  /// Is pending exhaust fan
  bool get isPendingExhaustFan => parametersState.isPendingExhaustFan;

  /// Is pending operating mode
  bool get isPendingOperatingMode => parametersState.isPendingOperatingMode;

  /// Pending operating mode
  String? get pendingOperatingMode => parametersState.pendingOperatingMode;

  /// Active alarms
  Map<String, AlarmInfo> get activeAlarms => alarmsState.activeAlarms;

  /// Has alarms
  bool get hasAlarms => alarmsState.hasAlarms;

  /// Alarm count
  int get alarmCount => alarmsState.alarmCount;
}

/// Wrapper that combines all BLoC listeners
class DashboardBlocListeners extends StatelessWidget {

  const DashboardBlocListeners({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiBlocListener(
      listeners: [
        // Device registration error
        BlocListener<DevicesBloc, DevicesState>(
          listenWhen: (previous, current) =>
              previous.registrationError != current.registrationError &&
              current.registrationError != null,
          listener: (context, state) {
            ToastService.error(state.registrationError!);
            context.read<DevicesBloc>().add(const DevicesRegistrationErrorCleared());
          },
        ),
        // Master Power Off - success
        BlocListener<DevicesBloc, DevicesState>(
          listenWhen: (previous, current) =>
              !previous.masterPowerOffSuccess && current.masterPowerOffSuccess,
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            ToastService.success(l10n.allDevicesTurnedOff);
          },
        ),
        // Master Power Off - error
        BlocListener<DevicesBloc, DevicesState>(
          listenWhen: (previous, current) =>
              previous.masterPowerOffError != current.masterPowerOffError &&
              current.masterPowerOffError != null,
          listener: (context, state) {
            ToastService.error(state.masterPowerOffError!);
          },
        ),
        // Auth logout
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSessionExpiredState) {
              // Show session expired warning
              final l10n = AppLocalizations.of(context)!;
              ToastService.warning(l10n.sessionExpired);
            } else if (state is AuthUnauthenticated) {
              Future.delayed(AppStagger.card, () {
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              });
            }
          },
        ),
        // Device selection sync - forward to all climate BLoCs
        BlocListener<DevicesBloc, DevicesState>(
          listenWhen: (previous, current) =>
              previous.selectedDeviceId != current.selectedDeviceId &&
              current.selectedDeviceId != null,
          listener: (context, state) {
            final deviceId = state.selectedDeviceId!;

            // Reset all climate BLoCs for new device
            context.read<ClimatePowerBloc>().add(const ClimatePowerReset());
            context.read<ClimateParametersBloc>().add(const ClimateParametersReset());
            context.read<ClimateAlarmsBloc>().add(const ClimateAlarmsReset());

            // Then trigger device change on core bloc
            context.read<ClimateCoreBloc>().add(ClimateCoreDeviceChanged(deviceId));
            context.read<AnalyticsBloc>().add(AnalyticsDeviceChanged(deviceId));
            context.read<NotificationsBloc>().add(NotificationsDeviceChanged(deviceId));
            context.read<ScheduleBloc>().add(ScheduleDeviceChanged(deviceId));
          },
        ),
        // SignalR coordination: forward deviceFullState updates to feature BLoCs
        BlocListener<ClimateCoreBloc, ClimateCoreState>(
          listenWhen: (prev, curr) => prev.deviceFullState != curr.deviceFullState,
          listener: (context, state) {
            final fullState = state.deviceFullState;
            if (fullState == null) {
              return;
            }

            // Forward confirmations to feature BLoCs
            context.read<ClimatePowerBloc>().add(ClimatePowerSignalRReceived(
              power: fullState.power,
              isScheduleEnabled: fullState.isScheduleEnabled,
            ));

            context.read<ClimateParametersBloc>().add(ClimateParametersSignalRReceived(
              operatingMode: fullState.operatingMode,
              modeSettings: fullState.modeSettings,
            ));

            context.read<ClimateAlarmsBloc>().add(
              ClimateAlarmsActiveUpdated(fullState.activeAlarms ?? {}),
            );
          },
        ),
      ],
      child: child,
    );
}

/// Builder that combines all BLoC states into DashboardData
class DashboardBlocBuilder extends StatelessWidget {

  const DashboardBlocBuilder({required this.builder, super.key});
  final Widget Function(BuildContext context, DashboardData data) builder;

  @override
  Widget build(BuildContext context) => BlocBuilder<DevicesBloc, DevicesState>(
      buildWhen: (previous, current) =>
          previous.devices != current.devices ||
          previous.selectedDeviceId != current.selectedDeviceId ||
          previous.status != current.status,
      builder: (context, devicesState) => BlocBuilder<ClimateCoreBloc, ClimateCoreState>(
          buildWhen: (previous, current) =>
              previous.climate != current.climate ||
              previous.isSyncing != current.isSyncing ||
              previous.errorMessage != current.errorMessage ||
              previous.deviceFullState != current.deviceFullState,
          builder: (context, coreState) => BlocBuilder<ClimatePowerBloc, ClimatePowerState>(
              buildWhen: (previous, current) =>
                  previous.isTogglingPower != current.isTogglingPower ||
                  previous.isTogglingSchedule != current.isTogglingSchedule ||
                  previous.errorMessage != current.errorMessage,
              builder: (context, powerState) => BlocBuilder<ClimateParametersBloc, ClimateParametersState>(
                  buildWhen: (previous, current) =>
                      previous.isPendingHeatingTemperature != current.isPendingHeatingTemperature ||
                      previous.isPendingCoolingTemperature != current.isPendingCoolingTemperature ||
                      previous.isPendingSupplyFan != current.isPendingSupplyFan ||
                      previous.isPendingExhaustFan != current.isPendingExhaustFan ||
                      previous.isPendingOperatingMode != current.isPendingOperatingMode ||
                      previous.pendingOperatingMode != current.pendingOperatingMode ||
                      previous.pendingHeatingTemp != current.pendingHeatingTemp ||
                      previous.pendingCoolingTemp != current.pendingCoolingTemp ||
                      previous.pendingSupplyFan != current.pendingSupplyFan ||
                      previous.pendingExhaustFan != current.pendingExhaustFan,
                  builder: (context, parametersState) => BlocBuilder<ClimateAlarmsBloc, ClimateAlarmsState>(
                      buildWhen: (previous, current) =>
                          previous.activeAlarms != current.activeAlarms ||
                          previous.alarmHistory != current.alarmHistory,
                      builder: (context, alarmsState) => BlocBuilder<ConnectivityBloc, ConnectivityState>(
                          buildWhen: (previous, current) =>
                              previous.showBanner != current.showBanner ||
                              previous.status != current.status,
                          builder: (context, connectivityState) => BlocBuilder<AnalyticsBloc, AnalyticsState>(
                              buildWhen: (previous, current) =>
                                  previous.graphData != current.graphData ||
                                  previous.selectedMetric != current.selectedMetric,
                              builder: (context, analyticsState) => BlocBuilder<NotificationsBloc, NotificationsState>(
                                  buildWhen: (previous, current) =>
                                      previous.notifications != current.notifications ||
                                      previous.unreadCount != current.unreadCount,
                                  builder: (context, notificationsState) => BlocBuilder<ScheduleBloc, ScheduleState>(
                                      buildWhen: (previous, current) =>
                                          previous.entries != current.entries,
                                      builder: (context, scheduleState) {
                                        final data = _buildDashboardData(
                                          devicesState,
                                          coreState,
                                          powerState,
                                          parametersState,
                                          alarmsState,
                                          connectivityState,
                                          analyticsState,
                                          notificationsState,
                                          scheduleState,
                                        );
                                        return builder(context, data);
                                      },
                                    ),
                                ),
                            ),
                        ),
                    ),
                ),
            ),
        ),
    );

  DashboardData _buildDashboardData(
    DevicesState devicesState,
    ClimateCoreState coreState,
    ClimatePowerState powerState,
    ClimateParametersState parametersState,
    ClimateAlarmsState alarmsState,
    ConnectivityState connectivityState,
    AnalyticsState analyticsState,
    NotificationsState notificationsState,
    ScheduleState scheduleState,
  ) {
    final units = devicesState.devices.map((device) {
      final isSelected = device.id == devicesState.selectedDeviceId;
      final climate = isSelected ? coreState.climate : null;
      final fullState = isSelected ? coreState.deviceFullState : null;
      // Pass parametersState only for selected device (for pending values)
      return _createUnitState(device, climate, fullState, isSelected ? parametersState : null);
    }).toList();

    final selectedIndex = devicesState.selectedDeviceId != null
        ? devicesState.devices.indexWhere(
            (d) => d.id == devicesState.selectedDeviceId,
          )
        : -1;
    final activeIndex = selectedIndex >= 0 ? selectedIndex : 0;

    final currentUnit = units.isNotEmpty && activeIndex < units.length
        ? units[activeIndex]
        : null;

    final isLoading = devicesState.status == DevicesStatus.initial ||
        devicesState.status == DevicesStatus.loading;

    return DashboardData(
      units: units,
      activeIndex: activeIndex,
      currentUnit: currentUnit,
      coreState: coreState,
      powerState: powerState,
      parametersState: parametersState,
      alarmsState: alarmsState,
      connectivityState: connectivityState,
      analyticsState: analyticsState,
      notificationsState: notificationsState,
      scheduleState: scheduleState,
      isLoadingDevices: isLoading,
    );
  }

  UnitState _createUnitState(
    HvacDevice device,
    ClimateState? climate,
    DeviceFullState? fullState,
    ClimateParametersState? parametersState,
  ) {
    // Get current mode: pending mode takes priority over SignalR data
    // If user changed mode, show it even if SignalR hasn't confirmed yet
    final currentMode = parametersState?.pendingOperatingMode
        ?? fullState?.operatingMode
        ?? climate?.preset
        ?? '';
    final modeSettings = fullState?.modeSettings?[currentMode];

    // Pending values take priority over modeSettings:
    // If user changed value, show it even if SignalR
    // hasn't confirmed yet (or overwrote with old value)
    final heatingTemp = parametersState?.pendingHeatingTemp
        ?? modeSettings?.heatingTemperature;
    final coolingTemp = parametersState?.pendingCoolingTemp
        ?? modeSettings?.coolingTemperature;
    final supplyFan = parametersState?.pendingSupplyFan
        ?? modeSettings?.supplyFan;
    final exhaustFan = parametersState?.pendingExhaustFan
        ?? modeSettings?.exhaustFan;

    return UnitState(
      id: device.id,
      name: device.name,
      macAddress: fullState?.macAddress ?? '',
      power: fullState?.power ?? climate?.isOn ?? device.isActive,
      temp: climate?.currentTemperature.toInt(),
      // Use pending values if available, otherwise from mode settings
      heatingTemp: heatingTemp,
      coolingTemp: coolingTemp,
      supplyFan: supplyFan,
      exhaustFan: exhaustFan,
      mode: currentMode, // Empty string = nothing selected
      humidity: climate?.humidity.toInt(),
      outsideTemp: fullState?.outdoorTemperature,
      filterPercent: fullState?.kpdRecuperator,
      indoorTemp: fullState?.indoorTemperature,
      supplyTemp: fullState?.supplyTemperature,
      recuperatorTemperature: fullState?.recuperatorTemperature,
      coIndicator: fullState?.coIndicator,
      recuperatorEfficiency: fullState?.kpdRecuperator,
      freeCooling: fullState?.freeCooling ?? false,
      heaterPower: fullState?.heaterPower,
      coolerStatus: fullState?.coolerStatus,
      ductPressure: fullState?.ductPressure,
      actualSupplyFan: fullState?.actualSupplyFan,
      actualExhaustFan: fullState?.actualExhaustFan,
      temperatureSetpoint: fullState?.temperatureSetpoint,
      isOnline: fullState?.isOnline ?? device.isOnline,
      quickSensors: fullState?.quickSensors ?? const ['outside_temp', 'indoor_temp', 'humidity'],
      deviceTime: fullState?.deviceTime,
      updatedAt: fullState?.updatedAt,
    );
  }
}
