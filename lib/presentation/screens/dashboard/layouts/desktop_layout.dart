/// Desktop Layout - Grid layout with sidebar for desktop
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
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

  // Menu items for bottom bar
  static const _menuItems = [
    (Icons.dashboard_outlined, 'Панель'),
    (Icons.devices_outlined, 'Устройства'),
    (Icons.schedule_outlined, 'Расписание'),
    (Icons.analytics_outlined, 'Аналитика'),
    (Icons.notifications_outlined, 'Уведомления'),
    (Icons.settings_outlined, 'Настройки'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isPortrait = size.height > size.width;
    // Portrait: bottom bar, Landscape: sidebar
    final showBottomBar = isPortrait;
    final showSidebar = !isPortrait;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Main content
          Expanded(
            child: Row(
              children: [
                // Sidebar (landscape only)
                if (showSidebar)
                  Sidebar(
                    selectedIndex: _sidebarIndex,
                    onItemSelected: (index) => setState(() => _sidebarIndex = index),
                  ),

                // Main content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _buildLeftColumn()),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(flex: 2, child: _buildRightColumn()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom navigation bar (portrait only)
          if (showBottomBar) _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final colors = BreezColors.of(context);
    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(AppSpacing.sm, 0, AppSpacing.sm, AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == _sidebarIndex;
          return Tooltip(
            message: item.$2,
            child: GestureDetector(
              onTap: () => setState(() => _sidebarIndex = index),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: Icon(
                  item.$1,
                  size: 24,
                  color: isSelected ? AppColors.accent : colors.textMuted,
                ),
              ),
            ),
          );
        }).toList(),
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
            onSupplyFanChanged: widget.onSupplyFanChanged,
            onExhaustFanChanged: widget.onExhaustFanChanged,
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
        ),

        const SizedBox(height: AppSpacing.sm),

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
