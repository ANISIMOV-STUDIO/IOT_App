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
import '../../../core/theme/breakpoints.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/devices/devices_bloc.dart';
import '../../bloc/climate/climate_bloc.dart';
import '../../bloc/analytics/analytics_bloc.dart';
import '../../bloc/notifications/notifications_bloc.dart';
import '../../bloc/schedule/schedule_bloc.dart';
import '../../widgets/common/offline_banner.dart';
import '../../../data/api/http/clients/hvac_http_client.dart';
import 'dashboard_bloc_wrapper.dart';
import 'dashboard_empty_state.dart';
import 'dialogs/add_unit_dialog.dart';
import 'dialogs/unit_settings_dialog.dart';
import 'dialogs/update_available_dialog.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import '../../widgets/breez/breez_logo.dart';
import '../../widgets/breez/unit_tab_button.dart';
import 'widgets/add_unit_button.dart';

/// Main dashboard screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final ThemeService _themeService;
  late final VersionCheckService _versionCheckService;
  StreamSubscription? _versionSubscription;

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
          return Scaffold(
            backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
            body: Column(
              children: [
                AnimatedOfflineBanner(
                  isVisible: data.connectivityState.showBanner,
                  status: data.connectivityState.status,
                ),
                Expanded(
                  child: data.currentUnit == null
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

  Widget _buildDesktopLayout(DashboardData data, user, bool isDark) {
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
      onModeChanged: (m) => context.read<ClimateBloc>().add(ClimateOperatingModeChanged(m)),
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
      isPendingTemperature: data.climateState.isPendingTemperature,
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
            onModeChanged: (m) => context.read<ClimateBloc>().add(ClimateOperatingModeChanged(m)),
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
            isOnline: data.climateState.isOnline,
            isPendingTemperature: data.climateState.isPendingTemperature,
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
            DevicesRenameRequested(deviceId: unit.id, newName: result.newName!),
          );
          ToastService.success(l10n.nameChanged);
        }
        break;
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
    if (deviceId == null) return;

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
    ).then((_) {
      // Refresh device state after update
      if (mounted) {
        context.read<ClimateBloc>().add(ClimateDeviceChanged(deviceId));
      }
    }).catchError((e) {
      if (mounted) {
        ToastService.error('Ошибка сохранения расписания: $e');
      }
    });
  }
}
