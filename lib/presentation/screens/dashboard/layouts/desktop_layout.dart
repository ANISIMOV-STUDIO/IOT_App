/// Desktop Layout - Grid layout with sidebar for desktop
library;

import 'package:flutter/material.dart';
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
  final VoidCallback? onSettingsTap;
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
    this.onSettingsTap,
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
    NavigationItem(icon: Icons.dashboard_outlined, label: 'Панель'),
    NavigationItem(icon: Icons.devices_outlined, label: 'Устройства'),
    NavigationItem(icon: Icons.schedule_outlined, label: 'Расписание'),
    NavigationItem(icon: Icons.analytics_outlined, label: 'Аналитика'),
    NavigationItem(icon: Icons.settings_outlined, label: 'Настройки'),
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
                    onLogoutTap: () {
                      // TODO: Implement logout
                    },
                  ),

                // Main content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      children: [
                        // Top row: Header with logo
                        if (showBottomBar) ...[
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
                                child: showBottomBar
                                    ? _buildRightColumnContent()
                                    : _buildRightColumn(),
                              ),
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
    return BreezNavigationBar(
      items: _menuItems,
      selectedIndex: _sidebarIndex,
      onItemSelected: (index) => setState(() => _sidebarIndex = index),
      // Кнопки темы и уведомлений не нужны - они уже в DesktopHeader сверху
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
            onSupplyFanChanged: widget.onSupplyFanChanged,
            onExhaustFanChanged: widget.onExhaustFanChanged,
            onModeChanged: widget.onModeChanged,
            onPowerToggle: widget.onPowerToggle,
            onSettingsTap: widget.onSettingsTap,
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
