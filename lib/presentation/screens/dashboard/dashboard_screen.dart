/// Dashboard Screen - Main BREEZ HVAC control interface
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/navigation/app_router.dart';
import '../../../core/services/dialog_service.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/services/toast_service.dart';
import '../../../core/services/version_check_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/unit_state.dart';
import '../../bloc/schedule/schedule_bloc.dart';
import '../../widgets/breez/breez.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/devices/devices_bloc.dart';
import '../../bloc/climate/climate_bloc.dart';
import '../../bloc/connectivity/connectivity_bloc.dart';
import '../../bloc/analytics/analytics_bloc.dart';
import '../../bloc/notifications/notifications_bloc.dart';
import '../../../domain/entities/hvac_device.dart';
import '../../../domain/entities/climate.dart';
import '../../../domain/entities/device_full_state.dart';
import '../../../domain/entities/user.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'dialogs/add_unit_dialog.dart';
import 'dialogs/unit_settings_dialog.dart';
import 'dialogs/update_available_dialog.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'widgets/mobile_header.dart';
import '../../widgets/common/offline_banner.dart';

/// Main dashboard screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ThemeService _themeService;
  late VersionCheckService _versionCheckService;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription? _versionSubscription;


  @override
  void initState() {
    super.initState();
    _themeService = di.sl<ThemeService>();
    _versionCheckService = di.sl<VersionCheckService>();
    _initializeVersionCheck();
    // Note: BLoC-и инициализируются в MainScreen.didChangeDependencies
  }

  /// Создать UnitState из HvacDevice, ClimateState и DeviceFullState
  UnitState _createUnitStateFromHvacDevice(
    HvacDevice device,
    ClimateState? climate,
    DeviceFullState? fullState,
  ) {
    return UnitState(
      id: device.id,
      name: device.name,
      power: climate?.isOn ?? false,
      temp: climate?.currentTemperature.toInt() ?? 20,
      heatingTemp: fullState?.heatingTemperature ?? 21,
      coolingTemp: fullState?.coolingTemperature ?? 24,
      supplyFan: climate?.supplyAirflow.toInt() ?? 50,
      exhaustFan: climate?.exhaustAirflow.toInt() ?? 50,
      mode: climate?.mode.toString().split('.').last ?? 'auto',
      humidity: climate?.humidity.toInt() ?? 45,
      outsideTemp: fullState?.outdoorTemperature?.toInt() ?? 0,
      filterPercent: fullState?.kpdRecuperator ?? 0,
      airflowRate: fullState?.devicePower ?? 0,
      // Новые датчики из DeviceFullState
      indoorTemp: fullState?.indoorTemperature?.toInt() ?? climate?.currentTemperature.toInt() ?? 22,
      supplyTemp: fullState?.supplyTemperature?.toInt() ?? 20,
      supplyTempAfterRecup: fullState?.supplyTempAfterRecup?.toInt() ?? 18,
      co2Level: fullState?.co2Level ?? 450,
      recuperatorEfficiency: fullState?.kpdRecuperator ?? 85,
      freeCooling: fullState?.freeCooling ?? 0,
      heaterPerformance: fullState?.heaterPerformance ?? 0,
      coolerStatus: fullState?.coolerStatus ?? 0,
      ductPressure: fullState?.ductPressure ?? 120,
    );
  }

  void _initializeVersionCheck() async {
    // Initialize version checking (SignalR + fallback раз в час)
    await _versionCheckService.initialize();

    // Listen for version changes
    _versionSubscription = _versionCheckService.onVersionChanged.listen((versionInfo) {
      if (mounted) {
        UpdateAvailableDialog.show(
          context,
          version: versionInfo.version,
          changelog: versionInfo.changelog,
        );
      }
    });
  }

  @override
  void dispose() {
    _versionSubscription?.cancel();
    super.dispose();
  }

  /// Обработчик смены метрики графика - делегируем в AnalyticsBloc
  void _onGraphMetricChanged(GraphMetric? metric) {
    if (metric == null) return;
    context.read<AnalyticsBloc>().add(AnalyticsGraphMetricChanged(metric));
  }

  /// Обработчик смены устройства
  void _onDeviceSelected(String deviceId) {
    context.read<DevicesBloc>().add(DevicesDeviceSelected(deviceId));
    context.read<ClimateBloc>().add(ClimateDeviceChanged(deviceId));
    context.read<AnalyticsBloc>().add(AnalyticsDeviceChanged(deviceId));
    context.read<NotificationsBloc>().add(NotificationsDeviceChanged(deviceId));
    context.read<ScheduleBloc>().add(ScheduleDeviceChanged(deviceId));
  }

  void _handlePowerToggle(ClimateControlState climateState) {
    final isOn = climateState.isOn;
    // Отправляем команду на сервер через ClimateBloc
    context.read<ClimateBloc>().add(ClimatePowerToggled(!isOn));
  }

  Future<void> _masterPowerOff() async {
    final confirmed = await DialogService.confirmMasterOff(context);
    if (!confirmed || !mounted) return;

    // Отправляем команду на выключение всех устройств
    context.read<DevicesBloc>().add(const DevicesMasterPowerOffRequested());
  }

  Future<void> _showAddUnitDialog() async {
    final result = await AddUnitDialog.show(context);
    if (result != null && mounted) {
      context.read<DevicesBloc>().add(
        DevicesRegistrationRequested(
          macAddress: result.macAddress,
          name: result.name,
        ),
      );
    }
  }

  Future<void> _showUnitSettings(UnitState unit) async {
    final result = await UnitSettingsDialog.show(context, unit);
    if (result == null || !mounted) return;

    final l10n = AppLocalizations.of(context)!;
    switch (result.action) {
      case UnitSettingsAction.delete:
        context.read<DevicesBloc>().add(DevicesDeletionRequested(unit.id));
        ToastService.success(l10n.deviceDeleted);
        break;
      case UnitSettingsAction.rename:
        if (result.newName != null) {
          context.read<DevicesBloc>().add(
                DevicesRenameRequested(
                  deviceId: unit.id,
                  newName: result.newName!,
                ),
              );
          ToastService.success(l10n.nameChanged);
        }
        break;
    }
  }

  void _toggleTheme() {
    _themeService.toggleTheme();
    setState(() {});
  }

  Future<void> _handleLogout() async {
    final confirmed = await DialogService.confirmLogout(context);
    if (!confirmed) return;

    if (!mounted) return;
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  void _showNotifications() {
    context.push(AppRoutes.notifications);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeService.isDark;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 900;

    // Получаем данные пользователя из AuthBloc
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return MultiBlocListener(
      listeners: [
        // Слушатель для ошибок регистрации устройства (DevicesBloc)
        BlocListener<DevicesBloc, DevicesState>(
          listenWhen: (previous, current) =>
              previous.registrationError != current.registrationError &&
              current.registrationError != null,
          listener: (context, state) {
            ToastService.error(state.registrationError!);
            context.read<DevicesBloc>().add(const DevicesRegistrationErrorCleared());
          },
        ),
        // Слушатель для Master Power Off - успех
        BlocListener<DevicesBloc, DevicesState>(
          listenWhen: (previous, current) =>
              !previous.masterPowerOffSuccess && current.masterPowerOffSuccess,
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            ToastService.success(l10n.allDevicesTurnedOff);
          },
        ),
        // Слушатель для Master Power Off - ошибка
        BlocListener<DevicesBloc, DevicesState>(
          listenWhen: (previous, current) =>
              previous.masterPowerOffError != current.masterPowerOffError &&
              current.masterPowerOffError != null,
          listener: (context, state) {
            ToastService.error(state.masterPowerOffError!);
          },
        ),
        // Слушатель для logout
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
        // Синхронизация: при смене устройства загружаем его данные
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
      child: BlocBuilder<DevicesBloc, DevicesState>(
        buildWhen: (previous, current) =>
            previous.devices != current.devices ||
            previous.selectedDeviceId != current.selectedDeviceId,
        builder: (context, devicesState) {
          return BlocBuilder<ClimateBloc, ClimateControlState>(
            buildWhen: (previous, current) =>
                previous.climate != current.climate ||
                previous.isTogglingPower != current.isTogglingPower ||
                previous.deviceFullState != current.deviceFullState,
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
                          // Преобразуем HvacDevice в UnitState для UI
                          final units = devicesState.devices.map((device) {
                            final isSelected = device.id == devicesState.selectedDeviceId;
                            final climate = isSelected ? climateState.climate : null;
                            final fullState = isSelected ? climateState.deviceFullState : null;
                            return _createUnitStateFromHvacDevice(device, climate, fullState);
                          }).toList();

                          // Находим индекс выбранного устройства
                          final selectedIndex = devicesState.selectedDeviceId != null
                              ? devicesState.devices.indexWhere(
                                  (d) => d.id == devicesState.selectedDeviceId,
                                )
                              : -1;
                          final activeIndex = selectedIndex >= 0 ? selectedIndex : 0;

                          // Текущий unit для layouts
                          final currentUnit = units.isNotEmpty && activeIndex < units.length
                              ? units[activeIndex]
                              : null;

                          return Scaffold(
                            key: _scaffoldKey,
                            backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
                            body: Column(
                              children: [
                                AnimatedOfflineBanner(
                                  isVisible: connectivityState.showBanner,
                                  status: connectivityState.status,
                                ),
                                Expanded(
                                  child: currentUnit == null
                                      ? _buildEmptyState(isDark)
                                      : isDesktop
                                          ? _buildDesktopLayout(
                                              isDark,
                                              user,
                                              currentUnit,
                                              units,
                                              activeIndex,
                                              climateState,
                                              analyticsState,
                                              notificationsState,
                                              scheduleState,
                                            )
                                          : _buildMobileLayout(
                                              isDark,
                                              width,
                                              currentUnit,
                                              units,
                                              activeIndex,
                                              climateState,
                                              scheduleState,
                                            ),
                                ),
                              ],
                            ),
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
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ac_unit_outlined,
            size: 80,
            color: colors.textMuted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noDevices,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addFirstDeviceByMac,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showAddUnitDialog,
            icon: const Icon(Icons.add),
            label: Text(l10n.addUnit),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    bool isDark,
    User? user,
    UnitState currentUnit,
    List<UnitState> units,
    int activeIndex,
    ClimateControlState climateState,
    AnalyticsState analyticsState,
    NotificationsState notificationsState,
    ScheduleState scheduleState,
  ) {
    return DesktopLayout(
      unit: currentUnit,
      allUnits: units,
      selectedUnitIndex: activeIndex,
      isDark: isDark,
      userName: user?.fullName ?? AppLocalizations.of(context)!.defaultUserName,
      userRole: user?.role ?? 'User',
      onTemperatureIncrease: (v) =>
          context.read<ClimateBloc>().add(ClimateTemperatureChanged(v.toDouble())),
      onTemperatureDecrease: (v) =>
          context.read<ClimateBloc>().add(ClimateTemperatureChanged(v.toDouble())),
      onHeatingTempIncrease: () =>
          context.read<ClimateBloc>().add(ClimateHeatingTempChanged(currentUnit.heatingTemp + 1)),
      onHeatingTempDecrease: () =>
          context.read<ClimateBloc>().add(ClimateHeatingTempChanged(currentUnit.heatingTemp - 1)),
      onCoolingTempIncrease: () =>
          context.read<ClimateBloc>().add(ClimateCoolingTempChanged(currentUnit.coolingTemp + 1)),
      onCoolingTempDecrease: () =>
          context.read<ClimateBloc>().add(ClimateCoolingTempChanged(currentUnit.coolingTemp - 1)),
      onSupplyFanChanged: (v) =>
          context.read<ClimateBloc>().add(ClimateSupplyAirflowChanged(v.toDouble())),
      onExhaustFanChanged: (v) =>
          context.read<ClimateBloc>().add(ClimateExhaustAirflowChanged(v.toDouble())),
      onModeChanged: (m) =>
          context.read<ClimateBloc>().add(ClimateOperatingModeChanged(m)),
      onPowerToggle: () => _handlePowerToggle(climateState),
      onSettingsTap: () => _showUnitSettings(currentUnit),
      isPowerLoading: climateState.isTogglingPower,
      onMasterOff: _masterPowerOff,
      onUnitSelected: (index) {
        if (index < units.length) {
          _onDeviceSelected(units[index].id);
        }
      },
      onThemeToggle: _toggleTheme,
      onAddUnit: _showAddUnitDialog,
      onLogoutTap: _handleLogout,
      onNotificationsTap: _showNotifications,
      unreadNotificationsCount: notificationsState.unreadCount,
      schedule: scheduleState.entries,
      graphData: analyticsState.graphData,
      selectedGraphMetric: analyticsState.selectedMetric,
      onGraphMetricChanged: _onGraphMetricChanged,
      activeAlarms: climateState.activeAlarms,
    );
  }

  Widget _buildMobileLayout(
    bool isDark,
    double width,
    UnitState currentUnit,
    List<UnitState> units,
    int activeIndex,
    ClimateControlState climateState,
    ScheduleState scheduleState,
  ) {
    return Column(
      children: [
        MobileHeader(
          units: units,
          selectedUnitIndex: activeIndex,
          onUnitSelected: (index) {
            if (index < units.length) {
              _onDeviceSelected(units[index].id);
            }
          },
          onAddUnit: _showAddUnitDialog,
          isDark: isDark,
          onThemeToggle: _toggleTheme,
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: MobileLayout(
            unit: currentUnit,
            onHeatingTempIncrease: () =>
                context.read<ClimateBloc>().add(ClimateHeatingTempChanged(currentUnit.heatingTemp + 1)),
            onHeatingTempDecrease: () =>
                context.read<ClimateBloc>().add(ClimateHeatingTempChanged(currentUnit.heatingTemp - 1)),
            onCoolingTempIncrease: () =>
                context.read<ClimateBloc>().add(ClimateCoolingTempChanged(currentUnit.coolingTemp + 1)),
            onCoolingTempDecrease: () =>
                context.read<ClimateBloc>().add(ClimateCoolingTempChanged(currentUnit.coolingTemp - 1)),
            onSupplyFanChanged: (v) =>
                context.read<ClimateBloc>().add(ClimateSupplyAirflowChanged(v.toDouble())),
            onExhaustFanChanged: (v) =>
                context.read<ClimateBloc>().add(ClimateExhaustAirflowChanged(v.toDouble())),
            onModeChanged: (m) =>
                context.read<ClimateBloc>().add(ClimateOperatingModeChanged(m)),
            onPowerToggle: () => _handlePowerToggle(climateState),
            onSettingsTap: () => _showUnitSettings(currentUnit),
            isPowerLoading: climateState.isTogglingPower,
            schedule: scheduleState.entries,
            activeAlarms: climateState.activeAlarms,
            onScheduleSeeAll: () => context.goToSchedule(
              currentUnit.id,
              currentUnit.name,
            ),
            onAlarmsSeeHistory: () => context.goToAlarmHistory(
              currentUnit.id,
              currentUnit.name,
            ),
          ),
        ),
      ],
    );
  }
}
