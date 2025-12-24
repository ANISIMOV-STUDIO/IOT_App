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
              child: _DashboardContent(
                unit: _currentUnit,
                onTemperatureIncrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
                onTemperatureDecrease: (v) => _updateUnit((u) => u.copyWith(temp: v.clamp(16, 32))),
                onSupplyFanChanged: (v) => _updateUnit((u) => u.copyWith(supplyFan: v)),
                onExhaustFanChanged: (v) => _updateUnit((u) => u.copyWith(exhaustFan: v)),
                onModeChanged: (m) => _updateUnit((u) => u.copyWith(mode: m)),
                onPowerToggle: () => _updateUnit((u) => u.copyWith(power: !u.power)),
                onMasterOff: _masterPowerOff,
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

/// Dashboard content area (responsive)
class _DashboardContent extends StatelessWidget {
  final UnitState unit;
  final ValueChanged<int>? onTemperatureIncrease;
  final ValueChanged<int>? onTemperatureDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onMasterOff;

  const _DashboardContent({
    required this.unit,
    this.onTemperatureIncrease,
    this.onTemperatureDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onModeChanged,
    this.onPowerToggle,
    this.onMasterOff,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 900;
    final isTablet = width > 600;

    if (isDesktop) {
      return _DesktopLayout(
        unit: unit,
        onTemperatureIncrease: onTemperatureIncrease,
        onTemperatureDecrease: onTemperatureDecrease,
        onSupplyFanChanged: onSupplyFanChanged,
        onExhaustFanChanged: onExhaustFanChanged,
        onModeChanged: onModeChanged,
        onPowerToggle: onPowerToggle,
        onMasterOff: onMasterOff,
      );
    }

    return _MobileLayout(
      unit: unit,
      onTemperatureIncrease: onTemperatureIncrease,
      onTemperatureDecrease: onTemperatureDecrease,
      onSupplyFanChanged: onSupplyFanChanged,
      onExhaustFanChanged: onExhaustFanChanged,
      onModeChanged: onModeChanged,
      onPowerToggle: onPowerToggle,
      compact: !isTablet,
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

/// Desktop layout (two columns)
class _DesktopLayout extends StatelessWidget {
  final UnitState unit;
  final ValueChanged<int>? onTemperatureIncrease;
  final ValueChanged<int>? onTemperatureDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onMasterOff;

  const _DesktopLayout({
    required this.unit,
    this.onTemperatureIncrease,
    this.onTemperatureDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onModeChanged,
    this.onPowerToggle,
    this.onMasterOff,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Climate card
          Expanded(
            flex: 6,
            child: ClimateCard(
              unitName: unit.name,
              isPowered: unit.power,
              temperature: unit.temp,
              supplyFan: unit.supplyFan,
              exhaustFan: unit.exhaustFan,
              filterPercent: unit.filterPercent,
              airflowRate: unit.airflowRate,
              humidity: unit.humidity,
              outsideTemp: unit.outsideTemp,
              onTemperatureIncrease: onTemperatureIncrease,
              onTemperatureDecrease: onTemperatureDecrease,
              onSupplyFanChanged: onSupplyFanChanged,
              onExhaustFanChanged: onExhaustFanChanged,
              onPowerTap: onPowerToggle,
            ),
          ),

          const SizedBox(width: 24),

          // Right: Controls
          Expanded(
            flex: 4,
            child: Column(
              children: [
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
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Global controls
                GlobalControls(
                  onMasterOff: onMasterOff,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
