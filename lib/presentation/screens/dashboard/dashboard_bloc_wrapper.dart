/// Dashboard BLoC Wrapper - Handles BLoC listeners and state combining
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hvac_control/core/navigation/app_router.dart';
import 'package:hvac_control/core/services/toast_service.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_state.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart';
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
    required this.climateState,
    required this.connectivityState,
    required this.analyticsState,
    required this.notificationsState,
    required this.scheduleState,
    this.isLoadingDevices = false,
  });
  final List<UnitState> units;
  final int activeIndex;
  final UnitState? currentUnit;
  final ClimateControlState climateState;
  final ConnectivityState connectivityState;
  final AnalyticsState analyticsState;
  final NotificationsState notificationsState;
  final ScheduleState scheduleState;

  /// Идёт загрузка списка устройств
  final bool isLoadingDevices;
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
              // Показать предупреждение о истечении сессии
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
        // Device selection sync
        BlocListener<DevicesBloc, DevicesState>(
          listenWhen: (previous, current) =>
              previous.selectedDeviceId != current.selectedDeviceId &&
              current.selectedDeviceId != null,
          listener: (context, state) {
            final deviceId = state.selectedDeviceId!;
            context.read<ClimateBloc>().add(ClimateDeviceChanged(deviceId));
            context.read<AnalyticsBloc>().add(AnalyticsDeviceChanged(deviceId));
            context.read<NotificationsBloc>().add(NotificationsDeviceChanged(deviceId));
            context.read<ScheduleBloc>().add(ScheduleDeviceChanged(deviceId));
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
      builder: (context, devicesState) => BlocBuilder<ClimateBloc, ClimateControlState>(
          buildWhen: (previous, current) =>
              previous.climate != current.climate ||
              previous.isTogglingPower != current.isTogglingPower ||
              previous.isSyncing != current.isSyncing ||
              previous.deviceFullState != current.deviceFullState ||
              previous.activeAlarms != current.activeAlarms ||
              previous.isPendingHeatingTemperature != current.isPendingHeatingTemperature ||
              previous.isPendingCoolingTemperature != current.isPendingCoolingTemperature ||
              previous.isPendingSupplyFan != current.isPendingSupplyFan ||
              previous.isPendingExhaustFan != current.isPendingExhaustFan ||
              previous.isPendingOperatingMode != current.isPendingOperatingMode ||
              previous.pendingOperatingMode != current.pendingOperatingMode,
          builder: (context, climateState) => BlocBuilder<ConnectivityBloc, ConnectivityState>(
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
                              climateState,
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
    );

  DashboardData _buildDashboardData(
    DevicesState devicesState,
    ClimateControlState climateState,
    ConnectivityState connectivityState,
    AnalyticsState analyticsState,
    NotificationsState notificationsState,
    ScheduleState scheduleState,
  ) {
    final units = devicesState.devices.map((device) {
      final isSelected = device.id == devicesState.selectedDeviceId;
      final climate = isSelected ? climateState.climate : null;
      final fullState = isSelected ? climateState.deviceFullState : null;
      // Передаём climateState только для выбранного устройства (для pending значений)
      return _createUnitState(device, climate, fullState, isSelected ? climateState : null);
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
      climateState: climateState,
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
    ClimateControlState? climateControlState,
  ) {
    // Получаем текущий режим: приоритет pending режима над SignalR данными
    // Если пользователь изменил режим, показываем его даже если SignalR ещё не подтвердил
    final currentMode = climateControlState?.pendingOperatingMode
        ?? fullState?.operatingMode
        ?? climate?.preset
        ?? '';
    final modeSettings = fullState?.modeSettings?[currentMode];

    // Приоритет pending значений над modeSettings:
    // Если пользователь изменил значение, показываем его даже если SignalR
    // ещё не подтвердил (или перезаписал на старое значение)
    final heatingTemp = climateControlState?.pendingHeatingTemp
        ?? modeSettings?.heatingTemperature;
    final coolingTemp = climateControlState?.pendingCoolingTemp
        ?? modeSettings?.coolingTemperature;
    final supplyFan = climateControlState?.pendingSupplyFan
        ?? modeSettings?.supplyFan;
    final exhaustFan = climateControlState?.pendingExhaustFan
        ?? modeSettings?.exhaustFan;

    return UnitState(
      id: device.id,
      name: device.name,
      macAddress: fullState?.macAddress ?? '',
      power: fullState?.power ?? climate?.isOn ?? device.isActive,
      temp: climate?.currentTemperature.toInt(),
      // Используем pending значения если есть, иначе из настроек режима
      heatingTemp: heatingTemp,
      coolingTemp: coolingTemp,
      supplyFan: supplyFan,
      exhaustFan: exhaustFan,
      mode: currentMode, // Пустая строка = ничего не выбрано
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
