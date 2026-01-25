/// Desktop Layout - Grid layout for desktop
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:hvac_control/presentation/screens/dashboard/widgets/desktop_header.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для DesktopLayout
abstract class _DesktopLayoutConstants {
  /// Фиксированная высота ModeGrid
  static const double modeGridHeight = 200;
}

/// Desktop layout (grid with header)
class DesktopLayout extends StatefulWidget {

  const DesktopLayout({
    required this.unit, required this.allUnits, required this.selectedUnitIndex, required this.userName, required this.userRole, super.key,
    this.onModeTap,
    this.onPowerToggle,
    this.onSettingsTap,
    this.isPowerLoading = false,
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onScheduleToggle,
    this.isPendingOperatingMode = false,
    this.onMasterOff,
    this.onUnitSelected,
    this.onAddUnit,
    this.onLogoutTap,
    this.timerSettings,
    this.onTimerSettingsChanged,
    this.activeAlarms = const {},
    this.onAlarmsReset,
    this.onSyncTap,
    this.isSyncing = false,
  });
  final UnitState unit;
  final List<UnitState> allUnits;
  final int selectedUnitIndex;
  final String userName;
  final String userRole;

  /// Callback при нажатии на режим (открывает модалку настроек)
  final ModeCallback? onModeTap;

  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool isPowerLoading;
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onScheduleToggle;
  /// Ожидание подтверждения смены режима работы
  final bool isPendingOperatingMode;
  final VoidCallback? onMasterOff;
  final ValueChanged<int>? onUnitSelected;
  final VoidCallback? onAddUnit;
  final VoidCallback? onLogoutTap;

  // Data from repositories
  final Map<String, TimerSettings>? timerSettings;
  final DaySettingsCallback? onTimerSettingsChanged;
  final Map<String, AlarmInfo> activeAlarms;
  final VoidCallback? onAlarmsReset;
  /// Callback для принудительного обновления данных
  final VoidCallback? onSyncTap;
  /// Флаг синхронизации (для анимации вращения иконки)
  final bool isSyncing;

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
      backgroundColor: BreezColors.of(context).bg.withValues(alpha: 0),
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
                showLogo: true,
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
            onPowerToggle: widget.onPowerToggle,
            onSettingsTap: widget.onSettingsTap,
            onSyncTap: widget.onSyncTap,
            isSyncing: widget.isSyncing,
            isPowerLoading: widget.isPowerLoading,
            isScheduleEnabled: widget.isScheduleEnabled,
            isScheduleLoading: widget.isScheduleLoading,
            onScheduleToggle: widget.onScheduleToggle,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Режимы работы (единый виджет с мобильной версией)
        // При tap открывается модалка настроек режима
        SizedBox(
          height: _DesktopLayoutConstants.modeGridHeight,
          child: ModeGrid(
            selectedMode: widget.unit.mode,
            onModeTap: widget.onModeTap,
            isPending: widget.isPendingOperatingMode,
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
        ),

        const SizedBox(height: AppSpacing.sm),

        Expanded(child: _buildRightColumnContent()),
      ],
    );

  Widget _buildRightColumnContent() {
    final l10n = AppLocalizations.of(context)!;
    final colors = BreezColors.of(context);
    final unit = widget.unit;

    // Показатели (короткие лейблы, как на мобильной аналитике)
    final sensors = [
      SensorData(
        key: 'outside_temp',
        icon: Icons.thermostat_outlined,
        value: unit.outsideTemp != null ? '${unit.outsideTemp!.toStringAsFixed(1)}°C' : '—',
        label: l10n.outdoor,
        description: l10n.outdoorTempDesc,
        color: colors.accent,
      ),
      SensorData(
        key: 'indoor_temp',
        icon: Icons.home_outlined,
        value: unit.indoorTemp != null ? '${unit.indoorTemp!.toStringAsFixed(1)}°C' : '—',
        label: l10n.indoor,
        description: l10n.indoorTempDesc,
        color: AppColors.accentGreen,
      ),
      SensorData(
        key: 'supply_temp',
        icon: Icons.air,
        value: unit.supplyTemp != null ? '${unit.supplyTemp!.toStringAsFixed(1)}°C' : '—',
        label: l10n.supply,
        description: l10n.supplyTempDesc,
        color: AppColors.accentOrange,
      ),
      SensorData(
        key: 'supply_temp_after_recup',
        icon: Icons.air,
        value: unit.recuperatorTemperature != null ? '${unit.recuperatorTemperature!.toStringAsFixed(1)}°C' : '—',
        label: l10n.afterRecup,
        description: l10n.recuperatorTemperatureDesc,
        color: AppColors.accentGreen,
      ),
      SensorData(
        key: 'humidity',
        icon: Icons.water_drop_outlined,
        value: unit.humidity != null ? '${unit.humidity}%' : '—',
        label: l10n.humidity,
        description: l10n.humidityDesc,
        color: colors.accent,
      ),
      SensorData(
        key: 'co_indicator',
        icon: Icons.cloud_outlined,
        value: unit.coIndicator != null ? '${unit.coIndicator}' : '—',
        label: 'CO',
        description: l10n.coIndicatorDesc,
        color: AppColors.accentGreen,
      ),
      SensorData(
        key: 'recuperator_eff',
        icon: Icons.recycling,
        value: unit.recuperatorEfficiency != null ? '${unit.recuperatorEfficiency}%' : '—',
        label: l10n.efficiency,
        description: l10n.recuperatorEfficiencyDesc,
        color: colors.accent,
      ),
      SensorData(
        key: 'heater_perf',
        icon: Icons.local_fire_department_outlined,
        value: unit.heaterPower != null ? '${unit.heaterPower}%' : '—',
        label: l10n.heater,
        description: l10n.heaterPerformanceDesc,
        color: AppColors.accentOrange,
      ),
      SensorData(
        key: 'cooler_status',
        icon: Icons.ac_unit,
        value: unit.coolerStatus ?? '—',
        label: l10n.cooler,
        description: l10n.coolerStatusDesc,
        color: colors.accent,
      ),
      SensorData(
        key: 'duct_pressure',
        icon: Icons.speed,
        value: unit.ductPressure != null ? '${unit.ductPressure}' : '—',
        label: l10n.pressure,
        description: l10n.ductPressureDesc,
        color: colors.textMuted,
      ),
      SensorData(
        key: 'free_cooling',
        icon: Icons.ac_unit,
        value: unit.freeCooling ? l10n.on : l10n.off,
        label: l10n.freeCool,
        description: l10n.freeCoolingDesc,
        color: unit.freeCooling ? AppColors.accentGreen : colors.textMuted,
      ),
      SensorData(
        key: 'filter_percent',
        icon: Icons.filter_alt_outlined,
        value: unit.filterPercent != null ? '${unit.filterPercent}%' : '—',
        label: l10n.filter,
        description: l10n.filterDesc,
        color: colors.accent,
      ),
    ];

    return Column(
      children: [
        // Sensors (4 per row) + (Schedule/Alarms) row
        Expanded(
          child: Row(
            children: [
              // All sensors in grid (4 per row, expand to fill height)
              Expanded(
                child: BreezCard(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: AnalyticsSensorsGrid(
                    sensors: sensors,
                    expandHeight: true,
                    selectable: true,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Schedule + Alarms stacked vertically
              Expanded(
                child: Column(
                  children: [
                    // Daily schedule widget
                    Expanded(
                      child: DailyScheduleWidget(
                        timerSettings: widget.timerSettings,
                        onDaySettingsChanged: widget.onTimerSettingsChanged,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

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
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // OperationGraph row
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
}
