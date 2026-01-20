/// Desktop Layout - Grid layout for desktop
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:hvac_control/presentation/screens/dashboard/widgets/desktop_header.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';

/// Desktop layout (grid with header)
class DesktopLayout extends StatefulWidget {

  const DesktopLayout({
    required this.unit, required this.allUnits, required this.selectedUnitIndex, required this.isDark, required this.userName, required this.userRole, super.key,
    this.onTemperatureIncrease,
    this.onTemperatureDecrease,
    this.onHeatingTempIncrease,
    this.onHeatingTempDecrease,
    this.onCoolingTempIncrease,
    this.onCoolingTempDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onModeTap,
    this.onPowerToggle,
    this.onSettingsTap,
    this.isPowerLoading = false,
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onScheduleToggle,
    this.isPendingHeatingTemperature = false,
    this.isPendingCoolingTemperature = false,
    this.isPendingSupplyFan = false,
    this.isPendingExhaustFan = false,
    this.onMasterOff,
    this.onUnitSelected,
    this.onThemeToggle,
    this.onAddUnit,
    this.onLogoutTap,
    this.onNotificationsTap,
    this.unreadNotificationsCount = 0,
    this.timerSettings,
    this.onTimerSettingsChanged,
    this.activeAlarms = const {},
    this.onAlarmsReset,
  });
  final UnitState unit;
  final List<UnitState> allUnits;
  final int selectedUnitIndex;
  final bool isDark;
  final String userName;
  final String userRole;
  final ValueChanged<int>? onTemperatureIncrease;
  final ValueChanged<int>? onTemperatureDecrease;
  final VoidCallback? onHeatingTempIncrease;
  final VoidCallback? onHeatingTempDecrease;
  final VoidCallback? onCoolingTempIncrease;
  final VoidCallback? onCoolingTempDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;

  /// Callback при нажатии на режим (открывает модалку настроек)
  final ModeCallback? onModeTap;

  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool isPowerLoading;
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onScheduleToggle;
  /// Ожидание подтверждения изменения температуры нагрева
  final bool isPendingHeatingTemperature;
  /// Ожидание подтверждения изменения температуры охлаждения
  final bool isPendingCoolingTemperature;
  /// Ожидание подтверждения изменения приточного вентилятора
  final bool isPendingSupplyFan;
  /// Ожидание подтверждения изменения вытяжного вентилятора
  final bool isPendingExhaustFan;
  final VoidCallback? onMasterOff;
  final ValueChanged<int>? onUnitSelected;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onAddUnit;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onNotificationsTap;
  final int unreadNotificationsCount;

  // Data from repositories
  final Map<String, TimerSettings>? timerSettings;
  final DaySettingsCallback? onTimerSettingsChanged;
  final Map<String, AlarmInfo> activeAlarms;
  final VoidCallback? onAlarmsReset;

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isPortrait = size.height > size.width;
    // Portrait: show header with logo, Landscape: show header without logo
    final showLogoInHeader = isPortrait;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          children: [
            // Top row: Header with logo (portrait) or without logo (landscape)
            if (showLogoInHeader) ...[
              DesktopHeader(
                units: widget.allUnits,
                selectedUnitIndex: widget.selectedUnitIndex,
                onUnitSelected: widget.onUnitSelected,
                onAddUnit: widget.onAddUnit,
                isDark: widget.isDark,
                onThemeToggle: widget.onThemeToggle,
                showLogo: true,
                onNotificationsTap: widget.onNotificationsTap,
                unreadNotificationsCount: widget.unreadNotificationsCount,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            // Content row
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildLeftColumn(context)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: showLogoInHeader
                        ? _buildRightColumnContent()
                        : _buildRightColumn(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context) => Column(
      children: [
        // Main temperature card with fan sliders
        Expanded(
          flex: 5,
          child: UnitControlCard(
            unit: widget.unit,
            onTemperatureIncrease: widget.onTemperatureIncrease != null
                ? () => widget.onTemperatureIncrease!(widget.unit.temp + 1)
                : null,
            onTemperatureDecrease: widget.onTemperatureDecrease != null
                ? () => widget.onTemperatureDecrease!(widget.unit.temp - 1)
                : null,
            onHeatingTempIncrease: widget.onHeatingTempIncrease,
            onHeatingTempDecrease: widget.onHeatingTempDecrease,
            onCoolingTempIncrease: widget.onCoolingTempIncrease,
            onCoolingTempDecrease: widget.onCoolingTempDecrease,
            onSupplyFanChanged: widget.onSupplyFanChanged,
            onExhaustFanChanged: widget.onExhaustFanChanged,
            onPowerToggle: widget.onPowerToggle,
            onSettingsTap: widget.onSettingsTap,
            isPowerLoading: widget.isPowerLoading,
            isScheduleEnabled: widget.isScheduleEnabled,
            isScheduleLoading: widget.isScheduleLoading,
            onScheduleToggle: widget.onScheduleToggle,
            isPendingHeatingTemperature: widget.isPendingHeatingTemperature,
            isPendingCoolingTemperature: widget.isPendingCoolingTemperature,
            isPendingSupplyFan: widget.isPendingSupplyFan,
            isPendingExhaustFan: widget.isPendingExhaustFan,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Режимы работы (единый виджет с мобильной версией)
        // При tap открывается модалка настроек режима
        Expanded(
          flex: 2,
          child: ModeGrid(
            selectedMode: widget.unit.mode,
            onModeTap: widget.onModeTap,
          ),
        ),
      ],
    );

  Widget _buildRightColumn() => Column(
      children: [
        // Header row
        DesktopHeader(
          units: widget.allUnits,
          selectedUnitIndex: widget.selectedUnitIndex,
          onUnitSelected: widget.onUnitSelected,
          onAddUnit: widget.onAddUnit,
          isDark: widget.isDark,
          onThemeToggle: widget.onThemeToggle,
          onNotificationsTap: widget.onNotificationsTap,
          unreadNotificationsCount: widget.unreadNotificationsCount,
        ),

        const SizedBox(height: AppSpacing.sm),

        Expanded(child: _buildRightColumnContent()),
      ],
    );

  Widget _buildRightColumnContent() => Column(
      children: [
        // Schedule + Alarms row
        Expanded(
          child: Row(
            children: [
              // Daily schedule widget
              Expanded(
                child: DailyScheduleWidget(
                  timerSettings: widget.timerSettings,
                  onDaySettingsChanged: widget.onTimerSettingsChanged,
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Unit alarms widget
              Expanded(
                child: UnitAlarmsWidget(
                  alarms: widget.activeAlarms,
                  onSeeHistory: () {},
                  onResetAlarms: widget.onAlarmsReset,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // OperationGraph row (same height as Schedule/Notifications)
        // Использует BlocBuilder для прямого доступа к AnalyticsBloc
        Expanded(
          child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
            buildWhen: (prev, curr) =>
                prev.graphData != curr.graphData ||
                prev.selectedMetric != curr.selectedMetric,
            builder: (context, state) => OperationGraph(
                data: state.graphData,
                selectedMetric: state.selectedMetric,
                onMetricChanged: (metric) {
                  context.read<AnalyticsBloc>().add(
                    AnalyticsGraphMetricChanged(metric),
                  );
                },
              ),
          ),
        ),
      ],
    );
}
