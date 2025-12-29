/// Dashboard Screen - Main BREEZ HVAC control interface
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/navigation/app_router.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/services/version_check_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../data/mock/mock_data.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../domain/repositories/graph_data_repository.dart';
import '../../../domain/repositories/notification_repository.dart';
import '../../../domain/repositories/schedule_repository.dart';
import '../../widgets/breez/breez.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../../domain/entities/hvac_device.dart';
import '../../../domain/entities/climate.dart';
import 'dialogs/add_unit_dialog.dart';
import 'dialogs/update_available_dialog.dart';
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
  late List<UnitState> _units;
  late ThemeService _themeService;
  late VersionCheckService _versionCheckService;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription? _versionSubscription;

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
    // Units будут загружены из DashboardBloc, fallback на MockData
    _units = MockData.units.map((u) => UnitState.fromJson(u)).toList();
    _themeService = di.sl<ThemeService>();
    _versionCheckService = di.sl<VersionCheckService>();
    _scheduleRepository = di.sl<ScheduleRepository>();
    _notificationRepository = di.sl<NotificationRepository>();
    _graphDataRepository = di.sl<GraphDataRepository>();
    _loadData();
    _initializeVersionCheck();
  }

  /// Создать UnitState из HvacDevice и ClimateState
  UnitState _createUnitStateFromHvacDevice(HvacDevice device, ClimateState? climate) {
    return UnitState(
      id: device.id,
      name: device.name,
      power: climate?.isOn ?? false,
      temp: climate?.currentTemperature.toInt() ?? 20,
      supplyFan: climate?.supplyAirflow.toInt() ?? 50,
      exhaustFan: climate?.exhaustAirflow.toInt() ?? 50,
      mode: climate?.mode.toString().split('.').last ?? 'auto',
      humidity: climate?.humidity.toInt() ?? 45,
      outsideTemp: 15, // TODO: Получать из API
      filterPercent: 85, // TODO: Получать из API
      airflowRate: 250, // TODO: Получать из API
    );
  }

  void _initializeVersionCheck() async {
    // Initialize version checking (SignalR + fallback раз в час)
    await _versionCheckService.initialize();

    // Listen for version changes
    _versionSubscription = _versionCheckService.onVersionChanged.listen((versionInfo) {
      if (mounted) {
        UpdateAvailableDialog.show(
          context,
          version: versionInfo.version,
          changelog: versionInfo.changelog,
        );
      }
    });
  }

  @override
  void dispose() {
    _versionSubscription?.cancel();
    super.dispose();
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

  void _showUnitSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BreezColors.of(context).card,
        title: Text(
          'Настройки ${_currentUnit.name}',
          style: TextStyle(color: BreezColors.of(context).text),
        ),
        content: Text(
          'Настройки установки в разработке',
          style: TextStyle(color: BreezColors.of(context).textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _toggleTheme() {
    _themeService.toggleTheme();
    setState(() {});
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeService.isDark;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 900;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, dashboardState) {
        // Используем данные из DashboardBloc если есть, иначе fallback на MockData
        final units = dashboardState.hvacDevices.isNotEmpty
            ? dashboardState.hvacDevices
                .map((device) {
                  // Использовать climate только для выбранного устройства
                  final climate = device.id == dashboardState.selectedHvacDeviceId
                      ? dashboardState.climate
                      : null;
                  return _createUnitStateFromHvacDevice(device, climate);
                })
                .toList()
            : _units;

        // Обновляем _units если пришли новые данные
        if (units != _units && units.isNotEmpty) {
          Future.microtask(() => setState(() => _units = units));
        }

        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              // Небольшая задержка для гарантии очистки storage
              Future.delayed(const Duration(milliseconds: 100), () {
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              });
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
            body: SafeArea(
              child: Column(
                children: [
                  // Main content
                  Expanded(
                    child: isDesktop ? _buildDesktopLayout(isDark) : _buildMobileLayout(isDark, width),
                  ),
                  // Space between content and bottom bar (mobile/tablet only)
                  if (!isDesktop) const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ),
        );
      },
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
      onSettingsTap: _showUnitSettings,
      onMasterOff: _masterPowerOff,
      onUnitSelected: (index) {
        setState(() => _activeUnitIndex = index);
        _loadData();
      },
      onThemeToggle: _toggleTheme,
      onAddUnit: _showAddUnitDialog,
      onLogoutTap: _handleLogout,
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
        // Header with unit tabs
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
        ),

        // Space between header and content
        const SizedBox(height: AppSpacing.sm),

        // Content
        Expanded(
          child: MobileLayout(
            unit: _currentUnit,
            onTemperatureIncrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
            onTemperatureDecrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
            onSupplyFanChanged: (v) => _updateUnit((u) => u.copyWith(supplyFan: v)),
            onExhaustFanChanged: (v) => _updateUnit((u) => u.copyWith(exhaustFan: v)),
            onModeChanged: (m) => _updateUnit((u) => u.copyWith(mode: m)),
            onPowerToggle: () => _updateUnit((u) => u.copyWith(power: !u.power)),
            onSettingsTap: _showUnitSettings,
            compact: width <= 600,
          ),
        ),
      ],
    );
  }
}
