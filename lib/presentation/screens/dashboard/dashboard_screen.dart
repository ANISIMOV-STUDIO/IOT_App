/// Dashboard Screen - Main BREEZ HVAC control interface
library;

import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/services/theme_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock/mock_data.dart';
import '../../widgets/breez/breez.dart';

/// Unit state model
class UnitState {
  final String id;
  final String name;
  bool power;
  int temp;
  int supplyFan;
  int exhaustFan;
  String mode;
  int humidity;
  int outsideTemp;
  int filterPercent;
  int airflowRate;

  UnitState({
    required this.id,
    required this.name,
    required this.power,
    required this.temp,
    required this.supplyFan,
    required this.exhaustFan,
    required this.mode,
    required this.humidity,
    required this.outsideTemp,
    required this.filterPercent,
    required this.airflowRate,
  });

  factory UnitState.fromJson(Map<String, dynamic> json) {
    return UnitState(
      id: json['id'] as String,
      name: json['name'] as String,
      power: json['power'] as bool,
      temp: json['temp'] as int,
      supplyFan: json['supplyFan'] as int,
      exhaustFan: json['exhaustFan'] as int,
      mode: json['mode'] as String,
      humidity: json['humidity'] as int,
      outsideTemp: json['outsideTemp'] as int,
      filterPercent: json['filterPercent'] as int,
      airflowRate: json['airflowRate'] as int,
    );
  }

  UnitState copyWith({
    bool? power,
    int? temp,
    int? supplyFan,
    int? exhaustFan,
    String? mode,
  }) {
    return UnitState(
      id: id,
      name: name,
      power: power ?? this.power,
      temp: temp ?? this.temp,
      supplyFan: supplyFan ?? this.supplyFan,
      exhaustFan: exhaustFan ?? this.exhaustFan,
      mode: mode ?? this.mode,
      humidity: humidity,
      outsideTemp: outsideTemp,
      filterPercent: filterPercent,
      airflowRate: airflowRate,
    );
  }
}

/// Main dashboard screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeUnitIndex = 0;
  late List<UnitState> _units;
  late ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    _units = MockData.units.map((u) => UnitState.fromJson(u)).toList();
    _themeService = di.sl<ThemeService>();
  }

  UnitState get _currentUnit => _units[_activeUnitIndex];

  void _updateUnit(UnitState Function(UnitState) update) {
    setState(() {
      _units[_activeUnitIndex] = update(_currentUnit);
    });
  }

  void _masterPowerOff() {
    setState(() {
      for (var i = 0; i < _units.length; i++) {
        _units[i] = _units[i].copyWith(power: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeService.isDark;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 900;

    // Desktop layout - full custom layout without header/footer
    if (isDesktop) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        body: SafeArea(
          child: _DesktopLayout(
            unit: _currentUnit,
            allUnits: _units,
            selectedUnitIndex: _activeUnitIndex,
            isDark: isDark,
            userName: 'Алексей Б.',
            userRole: 'Админ',
            onTemperatureIncrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
            onTemperatureDecrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
            onSupplyFanChanged: (v) => _updateUnit((u) => u.copyWith(supplyFan: v)),
            onExhaustFanChanged: (v) => _updateUnit((u) => u.copyWith(exhaustFan: v)),
            onModeChanged: (m) => _updateUnit((u) => u.copyWith(mode: m)),
            onPowerToggle: () => _updateUnit((u) => u.copyWith(power: !u.power)),
            onMasterOff: _masterPowerOff,
            onUnitSelected: (index) => setState(() => _activeUnitIndex = index),
            onThemeToggle: () {
              _themeService.toggleTheme();
              setState(() {});
            },
          ),
        ),
      );
    }

    // Mobile/Tablet layout with header and footer
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              isDark: isDark,
              onThemeToggle: () {
                _themeService.toggleTheme();
                setState(() {}); // Rebuild to reflect theme change
              },
              hasNotifications: true,
              userName: 'Алексей Б.',
              userRole: 'Админ',
            ),

            // Unit tabs
            UnitTabs(
              units: _units.map((u) => UnitTabData(
                id: u.id,
                name: u.name,
                isActive: u.power,
              )).toList(),
              selectedIndex: _activeUnitIndex,
              onUnitSelected: (index) => setState(() => _activeUnitIndex = index),
            ),

            // Content
            Expanded(
              child: _MobileLayout(
                unit: _currentUnit,
                onTemperatureIncrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
                onTemperatureDecrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
                onSupplyFanChanged: (v) => _updateUnit((u) => u.copyWith(supplyFan: v)),
                onExhaustFanChanged: (v) => _updateUnit((u) => u.copyWith(exhaustFan: v)),
                onModeChanged: (m) => _updateUnit((u) => u.copyWith(mode: m)),
                onPowerToggle: () => _updateUnit((u) => u.copyWith(power: !u.power)),
                compact: width <= 600,
              ),
            ),

            // Footer
            const AppFooter(
              outsideTemp: 18,
            ),
          ],
        ),
      ),
    );
  }
}

/// Mobile layout (single column)
class _MobileLayout extends StatelessWidget {
  final UnitState unit;
  final ValueChanged<int>? onTemperatureIncrease;
  final ValueChanged<int>? onTemperatureDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
  final bool compact;

  const _MobileLayout({
    required this.unit,
    this.onTemperatureIncrease,
    this.onTemperatureDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onModeChanged,
    this.onPowerToggle,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Climate card
          SizedBox(
            height: 480,
            child: ClimateCard(
              unitName: unit.name,
              isPowered: unit.power,
              temperature: unit.temp,
              supplyFan: unit.supplyFan,
              exhaustFan: unit.exhaustFan,
              filterPercent: unit.filterPercent,
              airflowRate: unit.airflowRate,
              onTemperatureIncrease: onTemperatureIncrease,
              onTemperatureDecrease: onTemperatureDecrease,
              onSupplyFanChanged: onSupplyFanChanged,
              onExhaustFanChanged: onExhaustFanChanged,
              onPowerTap: onPowerToggle,
            ),
          ),

          const SizedBox(height: 12),

          // Mode selector
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: unit.power ? 1.0 : 0.3,
            child: IgnorePointer(
              ignoring: !unit.power,
              child: ModeSelector(
                unitName: unit.name,
                selectedMode: unit.mode,
                onModeChanged: onModeChanged,
                compact: compact,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Desktop layout (grid with sidebar)
class _DesktopLayout extends StatefulWidget {
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

  const _DesktopLayout({
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
  });

  @override
  State<_DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<_DesktopLayout> {
  int _sidebarIndex = 0;
  GraphMetric _selectedMetric = GraphMetric.temperature;
  String? _activePresetId;

  // Sample graph data
  List<GraphDataPoint> get _graphData => [
    const GraphDataPoint(label: 'Пн', value: 21),
    const GraphDataPoint(label: 'Вт', value: 22),
    const GraphDataPoint(label: 'Ср', value: 20),
    const GraphDataPoint(label: 'Чт', value: 23),
    const GraphDataPoint(label: 'Пт', value: 22),
    const GraphDataPoint(label: 'Сб', value: 19),
    const GraphDataPoint(label: 'Вс', value: 21),
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
  List<ScheduleEntry> get _scheduleData => [
    const ScheduleEntry(
      day: 'Понедельник',
      mode: 'Охлаждение',
      timeRange: '08:00 - 22:00',
      tempDay: 22,
      tempNight: 19,
      isActive: true,
    ),
    const ScheduleEntry(
      day: 'Вторник',
      mode: 'Авто',
      timeRange: '08:00 - 22:00',
      tempDay: 22,
      tempNight: 19,
    ),
    const ScheduleEntry(
      day: 'Среда',
      mode: 'Охлаждение',
      timeRange: '08:00 - 22:00',
      tempDay: 21,
      tempNight: 18,
    ),
    const ScheduleEntry(
      day: 'Четверг',
      mode: 'Эко',
      timeRange: '09:00 - 21:00',
      tempDay: 23,
      tempNight: 20,
    ),
    const ScheduleEntry(
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Main content row
                Expanded(
                  child: Row(
                    children: [
                      // Left column: MainTempCard + Presets
                      Expanded(
                        child: Column(
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

                            const SizedBox(height: 16),

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
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Right column: Header + Schedule/Notifications + OperationGraph
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            // Header row
                            _DesktopHeader(
                              units: widget.allUnits,
                              selectedUnitIndex: widget.selectedUnitIndex,
                              onUnitSelected: widget.onUnitSelected,
                              isDark: widget.isDark,
                              onThemeToggle: widget.onThemeToggle,
                              userName: widget.userName,
                              userRole: widget.userRole,
                            ),

                            const SizedBox(height: 16),

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

                                  const SizedBox(width: 16),

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

                            const SizedBox(height: 16),

                            // OperationGraph row (same height as Schedule/Notifications)
                            Expanded(
                              child: OperationGraph(
                                data: _graphData,
                                selectedMetric: _selectedMetric,
                                onMetricChanged: (metric) => setState(() => _selectedMetric = metric),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}

/// Desktop header with unit tabs
class _DesktopHeader extends StatelessWidget {
  final List<UnitState> units;
  final int selectedUnitIndex;
  final ValueChanged<int>? onUnitSelected;
  final bool isDark;
  final VoidCallback? onThemeToggle;
  final String userName;
  final String userRole;

  const _DesktopHeader({
    required this.units,
    required this.selectedUnitIndex,
    this.onUnitSelected,
    required this.isDark,
    this.onThemeToggle,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Unit tabs (instead of search)
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: units.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final unit = units[index];
                final isSelected = index == selectedUnitIndex;

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onUnitSelected?.call(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: unit.power
                                  ? (isSelected ? Colors.white : AppColors.accentGreen)
                                  : AppColors.darkTextMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            unit.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Colors.white : AppColors.darkTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Theme toggle
        _HeaderIconButton(
          icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          onTap: onThemeToggle,
        ),

        const SizedBox(width: 8),

        // Notifications
        _HeaderIconButton(
          icon: Icons.notifications_outlined,
          badge: '3',
          onTap: () {},
        ),

        const SizedBox(width: 16),

        // User info
        Row(
          children: [
            Text(
              userName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accent, AppColors.accentLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Header icon button
class _HeaderIconButton extends StatefulWidget {
  final IconData icon;
  final String? badge;
  final VoidCallback? onTap;

  const _HeaderIconButton({
    required this.icon,
    this.badge,
    this.onTap,
  });

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withValues(alpha: 0.05) : AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: _isHovered ? Colors.white : AppColors.darkTextMuted,
                ),
              ),
              if (widget.badge != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.accentRed,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.badge!,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
