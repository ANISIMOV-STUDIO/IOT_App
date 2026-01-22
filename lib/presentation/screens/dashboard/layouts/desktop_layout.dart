/// Desktop Layout - Grid layout for desktop
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
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
