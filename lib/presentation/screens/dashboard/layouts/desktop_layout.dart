/// Desktop Layout - Grid layout with sidebar for desktop
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
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
  final VoidCallback? onMasterOff;
  final ValueChanged<int>? onUnitSelected;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onAddUnit;

  // Data from repositories
  final List<ScheduleEntry> schedule;
  final List<UnitNotification> notifications;
  final List<GraphDataPoint> graphData;
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
    this.onMasterOff,
    this.onUnitSelected,
    this.onThemeToggle,
    this.onAddUnit,
    this.schedule = const [],
    this.notifications = const [],
    this.graphData = const [],
    this.selectedGraphMetric = GraphMetric.temperature,
    this.onGraphMetricChanged,
  });

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  int _sidebarIndex = 0;
  String? _activePresetId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final showPermanentSidebar = width > 1100;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: showPermanentSidebar
          ? null
          : Drawer(
              backgroundColor: AppColors.darkCard,
              child: Sidebar(
                selectedIndex: _sidebarIndex,
                onItemSelected: (index) {
                  setState(() => _sidebarIndex = index);
                  Navigator.of(context).pop(); // Close drawer
                },
              ),
            ),
      body: Row(
        children: [
          // Permanent sidebar (desktop only)
          if (showPermanentSidebar)
            Sidebar(
              selectedIndex: _sidebarIndex,
              onItemSelected: (index) => setState(() => _sidebarIndex = index),
            ),

          // Main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // Main content row
                  Expanded(
                    child: Row(
                      children: [
                        // Left column: MainTempCard + Presets
                        Expanded(child: _buildLeftColumn()),
                        SizedBox(width: AppSpacing.md),
                        // Right column: Header + Schedule/Notifications + OperationGraph
                        Expanded(flex: 2, child: _buildRightColumn(showPermanentSidebar)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      children: [
        // Main temperature card with fan sliders
        Expanded(
          flex: 4,
          child: MainTempCard(
            unitName: widget.unit.name,
            temperature: widget.unit.temp,
            status: widget.unit.power ? 'В работе' : 'Выключен',
            humidity: widget.unit.humidity,
            airflow: widget.unit.airflowRate,
            filterPercent: widget.unit.filterPercent,
            isPowered: widget.unit.power,
            supplyFan: widget.unit.supplyFan,
            exhaustFan: widget.unit.exhaustFan,
            onTap: widget.onPowerToggle,
            onSupplyFanChanged: widget.onSupplyFanChanged,
            onExhaustFanChanged: widget.onExhaustFanChanged,
          ),
        ),

        SizedBox(height: AppSpacing.md),

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

  Widget _buildRightColumn(bool showPermanentSidebar) {
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
          showMenuButton: !showPermanentSidebar,
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),

        SizedBox(height: AppSpacing.md),

        // Schedule + Notifications row
        Expanded(
          child: Row(
            children: [
              // Schedule widget
              Expanded(
                child: ScheduleWidget(
                  entries: widget.schedule,
                  onSeeAll: () {},
                ),
              ),

              SizedBox(width: AppSpacing.md),

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

        SizedBox(height: AppSpacing.md),

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
