/// Dashboard Screen - Main BREEZ HVAC control interface
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hvac_control/core/di/injection_container.dart' as di;
import 'package:hvac_control/core/navigation/app_router.dart';
import 'package:hvac_control/core/services/dialog_service.dart';
import 'package:hvac_control/core/services/native_loading_service.dart';
import 'package:hvac_control/core/services/theme_service.dart';
import 'package:hvac_control/core/services/toast_service.dart';
import 'package:hvac_control/core/services/version_check_service.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/breakpoints.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/data/api/http/clients/hvac_http_client.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/domain/entities/user.dart';
import 'package:hvac_control/domain/entities/version_info.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_event.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_state.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart';
import 'package:hvac_control/presentation/bloc/devices/devices_bloc.dart';
import 'package:hvac_control/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:hvac_control/presentation/bloc/schedule/schedule_bloc.dart';
import 'package:hvac_control/presentation/screens/dashboard/dashboard_bloc_wrapper.dart';
import 'package:hvac_control/presentation/screens/dashboard/dashboard_empty_state.dart';
import 'package:hvac_control/presentation/screens/dashboard/dialogs/add_unit_dialog.dart';
import 'package:hvac_control/presentation/screens/dashboard/dialogs/mode_settings_dialog.dart';
import 'package:hvac_control/presentation/screens/dashboard/dialogs/unit_settings_dialog.dart';
import 'package:hvac_control/presentation/screens/dashboard/dialogs/update_available_dialog.dart';
import 'package:hvac_control/presentation/screens/dashboard/layouts/desktop_layout.dart';
import 'package:hvac_control/presentation/screens/dashboard/layouts/mobile_layout.dart';
import 'package:hvac_control/presentation/screens/dashboard/widgets/add_unit_button.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';
import 'package:hvac_control/presentation/widgets/common/offline_banner.dart';

/// Main dashboard screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final ThemeService _themeService;
  late final VersionCheckService _versionCheckService;
  StreamSubscription<VersionInfo>? _versionSubscription;

  @override
  void initState() {
    super.initState();
    _themeService = di.sl<ThemeService>();
    _versionCheckService = di.sl<VersionCheckService>();
    _initializeVersionCheck();
  }

  @override
  void dispose() {
    _versionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeVersionCheck() async {
    try {
      await _versionCheckService.initialize();
      _versionSubscription = _versionCheckService.onVersionChanged.listen((versionInfo) {
        if (mounted) {
          UpdateAvailableDialog.show(
            context,
            version: versionInfo.version,
            changelog: versionInfo.changelog,
          );
        }
      });
    } catch (e) {
      // Ошибка инициализации проверки версий не критична
      debugPrint('Version check initialization failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Получаем тему из контекста - автоматически обновляется при смене темы
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = context.isDesktop;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return DashboardBlocListeners(
      child: DashboardBlocBuilder(
        builder: (context, data) {
          // Скрыть HTML loading когда данные загружены
          if (!data.isLoadingDevices) {
            NativeLoadingService.hide();
          }

          return Scaffold(
            backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
            body: Column(
              children: [
                AnimatedOfflineBanner(
                  isVisible: data.connectivityState.showBanner,
                  status: data.connectivityState.status,
                ),
                Expanded(
                  child: data.isLoadingDevices
                      ? const Center(child: BreezLoaderWithText())
                      : data.currentUnit == null
                          ? DashboardEmptyState(onAddUnit: _showAddUnitDialog)
                          : isDesktop
                              ? _buildDesktopLayout(data, user, isDark)
                              : _buildMobileLayout(data, isDark, width),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(DashboardData data, User? user, bool isDark) {
    final unit = data.currentUnit!;
    return DesktopLayout(
      unit: unit,
      allUnits: data.units,
      selectedUnitIndex: data.activeIndex,
      isDark: isDark,
      userName: user?.fullName ?? AppLocalizations.of(context)!.defaultUserName,
      userRole: user?.role ?? 'User',
      onTemperatureIncrease: (v) =>
          context.read<ClimateBloc>().add(ClimateTemperatureChanged(v.toDouble())),
      onTemperatureDecrease: (v) =>
          context.read<ClimateBloc>().add(ClimateTemperatureChanged(v.toDouble())),
      onHeatingTempIncrease: () =>
          context.read<ClimateBloc>().add(ClimateHeatingTempChanged(unit.heatingTemp + 1)),
      onHeatingTempDecrease: () =>
          context.read<ClimateBloc>().add(ClimateHeatingTempChanged(unit.heatingTemp - 1)),
      onCoolingTempIncrease: () =>
          context.read<ClimateBloc>().add(ClimateCoolingTempChanged(unit.coolingTemp + 1)),
      onCoolingTempDecrease: () =>
          context.read<ClimateBloc>().add(ClimateCoolingTempChanged(unit.coolingTemp - 1)),
      onSupplyFanChanged: (v) =>
          context.read<ClimateBloc>().add(ClimateSupplyAirflowChanged(v.toDouble())),
      onExhaustFanChanged: (v) =>
          context.read<ClimateBloc>().add(ClimateExhaustAirflowChanged(v.toDouble())),
      onModeTap: _handleModeTap,
      onPowerToggle: () => _handlePowerToggle(data.climateState),
      onSettingsTap: () => _showUnitSettings(unit),
      isPowerLoading: data.climateState.isTogglingPower,
      isScheduleEnabled: data.climateState.isScheduleEnabled,
      isScheduleLoading: data.climateState.isTogglingSchedule,
      onScheduleToggle: () => _handleScheduleToggle(data.climateState),
      onMasterOff: _masterPowerOff,
      onUnitSelected: (index) => _onUnitSelected(data.units, index),
      onThemeToggle: _toggleTheme,
      onAddUnit: _showAddUnitDialog,
      onLogoutTap: _handleLogout,
      onNotificationsTap: _showNotifications,
      unreadNotificationsCount: data.notificationsState.unreadCount,
      timerSettings: data.climateState.deviceFullState?.timerSettings,
      onTimerSettingsChanged: _handleTimerSettingsChanged,
      activeAlarms: data.climateState.activeAlarms,
      isPendingHeatingTemperature: data.climateState.isPendingHeatingTemperature,
      isPendingCoolingTemperature: data.climateState.isPendingCoolingTemperature,
      isPendingSupplyFan: data.climateState.isPendingSupplyFan,
      isPendingExhaustFan: data.climateState.isPendingExhaustFan,
    );
  }

  Widget _buildMobileLayout(DashboardData data, bool isDark, double width) {
    final unit = data.currentUnit!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            0,
          ),
          child: UnitTabsContainer(
            units: data.units,
            selectedIndex: data.activeIndex,
            onUnitSelected: (index) => _onUnitSelected(data.units, index),
            leading: const BreezLogo.small(),
            trailing: AddUnitButton(onTap: _showAddUnitDialog),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: MobileLayout(
            unit: unit,
            onHeatingTempIncrease: () =>
                context.read<ClimateBloc>().add(ClimateHeatingTempChanged(unit.heatingTemp + 1)),
            onHeatingTempDecrease: () =>
                context.read<ClimateBloc>().add(ClimateHeatingTempChanged(unit.heatingTemp - 1)),
            onCoolingTempIncrease: () =>
                context.read<ClimateBloc>().add(ClimateCoolingTempChanged(unit.coolingTemp + 1)),
            onCoolingTempDecrease: () =>
                context.read<ClimateBloc>().add(ClimateCoolingTempChanged(unit.coolingTemp - 1)),
            onSupplyFanChanged: (v) =>
                context.read<ClimateBloc>().add(ClimateSupplyAirflowChanged(v.toDouble())),
            onExhaustFanChanged: (v) =>
                context.read<ClimateBloc>().add(ClimateExhaustAirflowChanged(v.toDouble())),
            onModeTap: _handleModeTap,
            onPowerToggle: () => _handlePowerToggle(data.climateState),
            onSettingsTap: () => _showUnitSettings(unit),
            isPowerLoading: data.climateState.isTogglingPower,
            isScheduleEnabled: data.climateState.isScheduleEnabled,
            isScheduleLoading: data.climateState.isTogglingSchedule,
            onScheduleToggle: () => _handleScheduleToggle(data.climateState),
            timerSettings: data.climateState.deviceFullState?.timerSettings,
            onTimerSettingsChanged: _handleTimerSettingsChanged,
            activeAlarms: data.climateState.activeAlarms,
            onAlarmsSeeHistory: () => context.goToAlarmHistory(unit.id, unit.name),
            isOnline: unit.isOnline,
            isPendingHeatingTemperature: data.climateState.isPendingHeatingTemperature,
            isPendingCoolingTemperature: data.climateState.isPendingCoolingTemperature,
            isPendingSupplyFan: data.climateState.isPendingSupplyFan,
            isPendingExhaustFan: data.climateState.isPendingExhaustFan,
          ),
        ),
      ],
    );
  }

  // Event handlers
  void _onUnitSelected(List<UnitState> units, int index) {
    if (index < units.length) {
      final deviceId = units[index].id;
      context.read<DevicesBloc>().add(DevicesDeviceSelected(deviceId));
      context.read<ClimateBloc>().add(ClimateDeviceChanged(deviceId));
      context.read<AnalyticsBloc>().add(AnalyticsDeviceChanged(deviceId));
      context.read<NotificationsBloc>().add(NotificationsDeviceChanged(deviceId));
      context.read<ScheduleBloc>().add(ScheduleDeviceChanged(deviceId));
    }
  }

  void _handlePowerToggle(ClimateControlState climateState) {
    context.read<ClimateBloc>().add(ClimatePowerToggled(!climateState.isOn));
  }

  void _handleScheduleToggle(ClimateControlState climateState) {
    context.read<ClimateBloc>().add(ClimateScheduleToggled(!climateState.isScheduleEnabled));
  }

  Future<void> _masterPowerOff() async {
    final confirmed = await DialogService.confirmMasterOff(context);
    if (confirmed && mounted) {
      context.read<DevicesBloc>().add(const DevicesMasterPowerOffRequested());
    }
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
    if (result == null || !mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    switch (result.action) {
      case UnitSettingsAction.delete:
        context.read<DevicesBloc>().add(DevicesDeletionRequested(unit.id));
        ToastService.success(l10n.deviceDeleted);
      case UnitSettingsAction.rename:
        if (result.newName != null) {
          context.read<DevicesBloc>().add(
            DevicesRenameRequested(deviceId: unit.id, newName: result.newName!),
          );
          ToastService.success(l10n.nameChanged);
        }
      case UnitSettingsAction.setTime:
        if (result.time != null) {
          context.read<DevicesBloc>().add(
            DevicesTimeSetRequested(deviceId: unit.id, time: result.time!),
          );
          ToastService.success(l10n.timeSet);
        }
    }
  }

  Future<void> _handleModeTap(OperatingModeData mode) async {
    final climateState = context.read<ClimateBloc>().state;
    final deviceFullState = climateState.deviceFullState;
    if (deviceFullState == null) {
      return;
    }

    final currentMode = deviceFullState.operatingMode;
    final isSelected = currentMode.toLowerCase() == mode.id.toLowerCase();

    // Получаем текущие настройки режима или создаём дефолтные
    final currentSettings = deviceFullState.modeSettings?[mode.id] ??
        const ModeSettings(
          heatingTemperature: 22,
          coolingTemperature: 24,
        );

    final result = await ModeSettingsDialog.show(
      context,
      modeName: mode.id,
      modeDisplayName: mode.name,
      modeIcon: mode.icon,
      modeColor: mode.color,
      initialSettings: currentSettings,
      isSelected: isSelected,
    );

    if (result != null && mounted) {
      // Сохраняем настройки режима
      context.read<ClimateBloc>().add(ClimateModeSettingsChanged(
        modeName: mode.id,
        settings: result.settings,
      ));

      // Если пользователь нажал "Включить" — активируем режим
      if (result.activate) {
        context.read<ClimateBloc>().add(ClimateOperatingModeChanged(mode.id));
      }
    }
  }

  void _toggleTheme() {
    _themeService.toggleTheme();
    // setState не нужен - MaterialApp перестроится через ListenableBuilder в main.dart
    // и Theme.of(context) обновится автоматически
  }

  Future<void> _handleLogout() async {
    final confirmed = await DialogService.confirmLogout(context);
    if (confirmed && mounted) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }

  void _showNotifications() {
    context.push(AppRoutes.notifications);
  }

  void _handleTimerSettingsChanged(
    String day,
    int onHour,
    int onMinute,
    int offHour,
    int offMinute,
    bool enabled,
  ) {
    // Get current device ID and call HTTP client
    final climateState = context.read<ClimateBloc>().state;
    final deviceId = climateState.deviceFullState?.id;
    if (deviceId == null) {
      return;
    }

    // Use HTTP client directly for timer settings
    final httpClient = di.sl<HvacHttpClient>();
    httpClient.setTimerSettings(
      deviceId,
      day: day,
      onHour: onHour,
      onMinute: onMinute,
      offHour: offHour,
      offMinute: offMinute,
      enabled: enabled,
    ).catchError((Object e) {
      if (mounted) {
        ToastService.error('Ошибка сохранения расписания: $e');
      }
    });
  }
}
