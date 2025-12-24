/// Desktop Layout - Grid layout with sidebar for desktop
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/breez/breez.dart';
import '../widgets/desktop_header.dart';

/// Desktop layout (grid with sidebar)
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
  });

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  int _sidebarIndex = 0;
  GraphMetric _selectedMetric = GraphMetric.temperature;
  String? _activePresetId;

  // Sample graph data
  List<GraphDataPoint> get _graphData => const [
        GraphDataPoint(label: 'Пн', value: 21),
        GraphDataPoint(label: 'Вт', value: 22),
        GraphDataPoint(label: 'Ср', value: 20),
        GraphDataPoint(label: 'Чт', value: 23),
        GraphDataPoint(label: 'Пт', value: 22),
        GraphDataPoint(label: 'Сб', value: 19),
        GraphDataPoint(label: 'Вс', value: 21),
      ];

  // Sample notifications data
  List<UnitNotification> get _unitNotifications => [
        UnitNotification(
          id: '1',
          title: 'Замена фильтра',
          message: 'Рекомендуется заменить фильтр в течение 7 дней',
          type: NotificationType.warning,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        UnitNotification(
          id: '2',
          title: 'Температура достигнута',
          message: 'Целевая температура 22°C достигнута',
          type: NotificationType.success,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
        ),
        UnitNotification(
          id: '3',
          title: 'Обновление системы',
          message: 'Доступна новая версия прошивки v2.1.4',
          type: NotificationType.info,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

  // Sample schedule data
  List<ScheduleEntry> get _scheduleData => const [
        ScheduleEntry(
          day: 'Понедельник',
          mode: 'Охлаждение',
          timeRange: '08:00 - 22:00',
          tempDay: 22,
          tempNight: 19,
          isActive: true,
        ),
        ScheduleEntry(
          day: 'Вторник',
          mode: 'Авто',
          timeRange: '08:00 - 22:00',
          tempDay: 22,
          tempNight: 19,
        ),
        ScheduleEntry(
          day: 'Среда',
          mode: 'Охлаждение',
          timeRange: '08:00 - 22:00',
          tempDay: 21,
          tempNight: 18,
        ),
        ScheduleEntry(
          day: 'Четверг',
          mode: 'Эко',
          timeRange: '09:00 - 21:00',
          tempDay: 23,
          tempNight: 20,
        ),
        ScheduleEntry(
          day: 'Пятница',
          mode: 'Авто',
          timeRange: '08:00 - 23:00',
          tempDay: 22,
          tempNight: 19,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar
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
                      Expanded(flex: 2, child: _buildRightColumn()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

        SizedBox(height: AppSpacing.md),

        // Schedule + Notifications row
        Expanded(
          child: Row(
            children: [
              // Schedule widget
              Expanded(
                child: ScheduleWidget(
                  entries: _scheduleData,
                  onSeeAll: () {},
                ),
              ),

              SizedBox(width: AppSpacing.md),

              // Unit notifications widget
              Expanded(
                child: UnitNotificationsWidget(
                  unitName: widget.unit.name,
                  notifications: _unitNotifications,
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
            data: _graphData,
            selectedMetric: _selectedMetric,
            onMetricChanged: (metric) =>
                setState(() => _selectedMetric = metric),
          ),
        ),
      ],
    );
  }
}
