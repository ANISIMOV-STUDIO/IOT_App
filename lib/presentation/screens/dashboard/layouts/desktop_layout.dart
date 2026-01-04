/// Desktop Layout - Grid layout with sidebar for desktop
library;

import 'package:flutter/material.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../../domain/entities/alarm_info.dart';
import '../../../widgets/breez/breez.dart';
import '../widgets/desktop_header.dart';

/// Desktop layout (grid with sidebar, drawer on tablet)
class DesktopLayout extends StatefulWidget {
  final UnitState unit;
  final List<UnitState> allUnits;
  final int selectedUnitIndex;
  final bool isDark;
  final String userName;
  final String userRole;
  final ValueChanged<int>? onTemperatureIncrease;
  final ValueChanged<int>? onTemperatureDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool isPowerLoading;
  final VoidCallback? onMasterOff;
  final ValueChanged<int>? onUnitSelected;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onAddUnit;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onNotificationsTap;

  // Data from repositories
  final List<ScheduleEntry> schedule;
  final List<UnitNotification> notifications;
  final List<GraphDataPoint> graphData;
  final Map<String, AlarmInfo> activeAlarms;
  final GraphMetric selectedGraphMetric;
  final ValueChanged<GraphMetric>? onGraphMetricChanged;

  const DesktopLayout({
    super.key,
    required this.unit,
    required this.allUnits,
    required this.selectedUnitIndex,
    required this.isDark,
    required this.userName,
    required this.userRole,
    this.onTemperatureIncrease,
    this.onTemperatureDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onModeChanged,
    this.onPowerToggle,
    this.onSettingsTap,
    this.isPowerLoading = false,
    this.onMasterOff,
    this.onUnitSelected,
    this.onThemeToggle,
    this.onAddUnit,
    this.onLogoutTap,
    this.onNotificationsTap,
    this.schedule = const [],
    this.notifications = const [],
    this.graphData = const [],
    this.activeAlarms = const {},
    this.selectedGraphMetric = GraphMetric.temperature,
    this.onGraphMetricChanged,
  });

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  String? _activePresetId;

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
                userName: widget.userName,
                userRole: widget.userRole,
                showLogo: true,
                onNotificationsTap: widget.onNotificationsTap,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            // Content row
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildLeftColumn()),
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

  Widget _buildLeftColumn() {
    return Column(
      children: [
        // Main temperature card with fan sliders
        Expanded(
          flex: 4,
          child: UnitControlCard(
            unit: widget.unit,
            onTemperatureIncrease: widget.onTemperatureIncrease != null
                ? () => widget.onTemperatureIncrease!(widget.unit.temp + 1)
                : null,
            onTemperatureDecrease: widget.onTemperatureDecrease != null
                ? () => widget.onTemperatureDecrease!(widget.unit.temp - 1)
                : null,
            onSupplyFanChanged: widget.onSupplyFanChanged,
            onExhaustFanChanged: widget.onExhaustFanChanged,
            onModeChanged: widget.onModeChanged,
            onPowerToggle: widget.onPowerToggle,
            onSettingsTap: widget.onSettingsTap,
            isPowerLoading: widget.isPowerLoading,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Presets (small, icon-only)
        Expanded(
          flex: 1,
          child: PresetsWidget(
            presets: DefaultPresets.all,
            activePresetId: _activePresetId,
            onPresetSelected: (id) => setState(() => _activePresetId = id),
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        // Header row
        DesktopHeader(
          units: widget.allUnits,
          selectedUnitIndex: widget.selectedUnitIndex,
          onUnitSelected: widget.onUnitSelected,
          onAddUnit: widget.onAddUnit,
          isDark: widget.isDark,
          onThemeToggle: widget.onThemeToggle,
          userName: widget.userName,
          userRole: widget.userRole,
          onNotificationsTap: widget.onNotificationsTap,
        ),

        const SizedBox(height: AppSpacing.sm),

        Expanded(child: _buildRightColumnContent()),
      ],
    );
  }

  Widget _buildRightColumnContent() {
    return Column(
      children: [
        // Schedule + Notifications row
        Expanded(
          child: Row(
            children: [
              // Schedule widget
              Expanded(
                child: ScheduleWidget(
                  entries: widget.schedule,
                  onSeeAll: () => context.goToSchedule(
                    widget.unit.id,
                    widget.unit.name,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Unit alarms widget
              Expanded(
                child: UnitAlarmsWidget(
                  alarms: widget.activeAlarms,
                  onSeeHistory: () {},
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Unit notifications widget
              Expanded(
                child: UnitNotificationsWidget(
                  unitName: widget.unit.name,
                  notifications: widget.notifications,
                  onSeeAll: () {},
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // OperationGraph row (same height as Schedule/Notifications)
        Expanded(
          child: OperationGraph(
            data: widget.graphData,
            selectedMetric: widget.selectedGraphMetric,
            onMetricChanged: widget.onGraphMetricChanged,
          ),
        ),
      ],
    );
  }
}
