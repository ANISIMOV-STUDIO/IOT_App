/// Dashboard Screen - Main BREEZ HVAC control interface
library;

import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/services/theme_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock/mock_data.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../domain/repositories/graph_data_repository.dart';
import '../../../domain/repositories/notification_repository.dart';
import '../../../domain/repositories/schedule_repository.dart';
import '../../widgets/breez/breez.dart';
import 'dialogs/add_unit_dialog.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';
import 'widgets/mobile_header.dart';

/// Main dashboard screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeUnitIndex = 0;
  int _sidebarIndex = 0;
  late List<UnitState> _units;
  late ThemeService _themeService;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Repositories
  late ScheduleRepository _scheduleRepository;
  late NotificationRepository _notificationRepository;
  late GraphDataRepository _graphDataRepository;

  // Data from repositories
  List<ScheduleEntry> _schedule = [];
  List<UnitNotification> _notifications = [];
  List<GraphDataPoint> _graphData = [];
  GraphMetric _selectedGraphMetric = GraphMetric.temperature;

  @override
  void initState() {
    super.initState();
    _units = MockData.units.map((u) => UnitState.fromJson(u)).toList();
    _themeService = di.sl<ThemeService>();
    _scheduleRepository = di.sl<ScheduleRepository>();
    _notificationRepository = di.sl<NotificationRepository>();
    _graphDataRepository = di.sl<GraphDataRepository>();
    _loadData();
  }

  Future<void> _loadData() async {
    final deviceId = _units[_activeUnitIndex].id;
    try {
      final results = await Future.wait([
        _scheduleRepository.getSchedule(deviceId),
        _notificationRepository.getNotifications(deviceId: deviceId),
        _graphDataRepository.getGraphData(
          deviceId: deviceId,
          metric: _selectedGraphMetric,
          from: DateTime.now().subtract(const Duration(days: 7)),
          to: DateTime.now(),
        ),
      ]);
      setState(() {
        _schedule = results[0] as List<ScheduleEntry>;
        _notifications = results[1] as List<UnitNotification>;
        _graphData = results[2] as List<GraphDataPoint>;
      });
    } catch (_) {
      // Silently handle errors - data will remain empty
    }
  }

  void _onGraphMetricChanged(GraphMetric? metric) {
    if (metric == null) return;
    setState(() => _selectedGraphMetric = metric);
    _loadGraphData();
  }

  Future<void> _loadGraphData() async {
    final deviceId = _units[_activeUnitIndex].id;
    try {
      final data = await _graphDataRepository.getGraphData(
        deviceId: deviceId,
        metric: _selectedGraphMetric,
        from: DateTime.now().subtract(const Duration(days: 7)),
        to: DateTime.now(),
      );
      setState(() => _graphData = data);
    } catch (_) {}
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

  Future<void> _showAddUnitDialog() async {
    final name = await AddUnitDialog.show(context);
    if (name != null && name.isNotEmpty) {
      setState(() {
        _units.add(UnitState.create(name: name));
        _activeUnitIndex = _units.length - 1;
      });
    }
  }

  void _toggleTheme() {
    _themeService.toggleTheme();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeService.isDark;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      drawer: isDesktop
          ? null
          : Drawer(
              backgroundColor: AppColors.darkCard,
              child: Sidebar(
                selectedIndex: _sidebarIndex,
                onItemSelected: (index) {
                  setState(() => _sidebarIndex = index);
                  Navigator.of(context).pop();
                },
              ),
            ),
      body: SafeArea(
        child: isDesktop ? _buildDesktopLayout(isDark) : _buildMobileLayout(isDark, width),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isDark) {
    return DesktopLayout(
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
      onUnitSelected: (index) {
        setState(() => _activeUnitIndex = index);
        _loadData(); // Reload data for new device
      },
      onThemeToggle: _toggleTheme,
      onAddUnit: _showAddUnitDialog,
      // Data from repositories
      schedule: _schedule,
      notifications: _notifications,
      graphData: _graphData,
      selectedGraphMetric: _selectedGraphMetric,
      onGraphMetricChanged: _onGraphMetricChanged,
    );
  }

  Widget _buildMobileLayout(bool isDark, double width) {
    return Column(
      children: [
        // Header with unit tabs (like desktop)
        MobileHeader(
          units: _units,
          selectedUnitIndex: _activeUnitIndex,
          onUnitSelected: (index) {
            setState(() => _activeUnitIndex = index);
            _loadData();
          },
          onAddUnit: _showAddUnitDialog,
          isDark: isDark,
          onThemeToggle: _toggleTheme,
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),

        // Content (no footer)
        Expanded(
          child: MobileLayout(
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
      ],
    );
  }
}
