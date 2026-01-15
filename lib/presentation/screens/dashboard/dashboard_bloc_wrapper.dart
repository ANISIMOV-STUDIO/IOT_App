/// Dashboard BLoC Wrapper - Handles BLoC listeners and state combining
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/services/toast_service.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../domain/entities/hvac_device.dart';
import '../../../domain/entities/climate.dart';
import '../../../domain/entities/device_full_state.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/devices/devices_bloc.dart';
import '../../bloc/climate/climate_bloc.dart';
import '../../bloc/connectivity/connectivity_bloc.dart';
import '../../bloc/analytics/analytics_bloc.dart';
import '../../bloc/notifications/notifications_bloc.dart';
import '../../bloc/schedule/schedule_bloc.dart';

/// Combined dashboard state from all BLoCs
class DashboardData {
  final List<UnitState> units;
  final int activeIndex;
  final UnitState? currentUnit;
  final ClimateControlState climateState;
  final ConnectivityState connectivityState;
  final AnalyticsState analyticsState;
  final NotificationsState notificationsState;
  final ScheduleState scheduleState;

  const DashboardData({
    required this.units,
    required this.activeIndex,
    required this.currentUnit,
    required this.climateState,
    required this.connectivityState,
    required this.analyticsState,
    required this.notificationsState,
    required this.scheduleState,
  });
}

/// Wrapper that combines all BLoC listeners
class DashboardBlocListeners extends StatelessWidget {
  final Widget child;

  const DashboardBlocListeners({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
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
            if (state is AuthUnauthenticated) {
              Future.delayed(const Duration(milliseconds: 100), () {
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
}

/// Builder that combines all BLoC states into DashboardData
class DashboardBlocBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DashboardData data) builder;

  const DashboardBlocBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesBloc, DevicesState>(
      buildWhen: (previous, current) =>
          previous.devices != current.devices ||
          previous.selectedDeviceId != current.selectedDeviceId,
      builder: (context, devicesState) {
        return BlocBuilder<ClimateBloc, ClimateControlState>(
          buildWhen: (previous, current) =>
              previous.climate != current.climate ||
              previous.isTogglingPower != current.isTogglingPower ||
              previous.deviceFullState != current.deviceFullState ||
              previous.activeAlarms != current.activeAlarms,
          builder: (context, climateState) {
            return BlocBuilder<ConnectivityBloc, ConnectivityState>(
              buildWhen: (previous, current) =>
                  previous.showBanner != current.showBanner ||
                  previous.status != current.status,
              builder: (context, connectivityState) {
                return BlocBuilder<AnalyticsBloc, AnalyticsState>(
                  buildWhen: (previous, current) =>
                      previous.graphData != current.graphData ||
                      previous.selectedMetric != current.selectedMetric,
                  builder: (context, analyticsState) {
                    return BlocBuilder<NotificationsBloc, NotificationsState>(
                      buildWhen: (previous, current) =>
                          previous.notifications != current.notifications ||
                          previous.unreadCount != current.unreadCount,
                      builder: (context, notificationsState) {
                        return BlocBuilder<ScheduleBloc, ScheduleState>(
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
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

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
      return _createUnitState(device, climate, fullState);
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

    return DashboardData(
      units: units,
      activeIndex: activeIndex,
      currentUnit: currentUnit,
      climateState: climateState,
      connectivityState: connectivityState,
      analyticsState: analyticsState,
      notificationsState: notificationsState,
      scheduleState: scheduleState,
    );
  }

  UnitState _createUnitState(
    HvacDevice device,
    ClimateState? climate,
    DeviceFullState? fullState,
  ) {
    return UnitState(
      id: device.id,
      name: device.name,
      power: fullState?.power ?? climate?.isOn ?? device.isActive,
      temp: climate?.currentTemperature.toInt() ?? 20,
      heatingTemp: fullState?.heatingTemperature ?? 21,
      coolingTemp: fullState?.coolingTemperature ?? 24,
      supplyFan: _parseFanValue(fullState?.supplyFan) ?? climate?.supplyAirflow.toInt() ?? 50,
      exhaustFan: _parseFanValue(fullState?.exhaustFan) ?? climate?.exhaustAirflow.toInt() ?? 50,
      mode: fullState?.operatingMode ?? climate?.preset ?? '', // Пустая строка = ничего не выбрано
      humidity: climate?.humidity.toInt() ?? 45,
      outsideTemp: fullState?.outdoorTemperature ?? 0.0,
      filterPercent: fullState?.kpdRecuperator ?? 0,
      airflowRate: fullState?.devicePower ?? 0,
      indoorTemp: fullState?.indoorTemperature ?? climate?.currentTemperature ?? 22.0,
      supplyTemp: fullState?.supplyTemperature ?? 20.0,
      supplyTempAfterRecup: fullState?.supplyTempAfterRecup ?? 18.0,
      co2Level: fullState?.co2Level ?? 450,
      recuperatorEfficiency: fullState?.kpdRecuperator ?? 85,
      freeCooling: fullState?.freeCooling ?? 0,
      heaterPerformance: fullState?.heaterPerformance ?? 0,
      coolerStatus: fullState?.coolerStatus ?? 'Н/Д',
      ductPressure: fullState?.ductPressure ?? 120,
      isOnline: fullState?.isOnline ?? device.isOnline,
      quickSensors: fullState?.quickSensors ?? const ['outside_temp', 'indoor_temp', 'humidity'],
    );
  }

  /// Parse fan value from String to int (fan speed is 20-100)
  int? _parseFanValue(String? value) {
    if (value == null || value.isEmpty) return null;
    return int.tryParse(value);
  }
}
