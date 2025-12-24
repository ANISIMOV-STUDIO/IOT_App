/// Dashboard Screen - Main BREEZ HVAC control interface
library;

import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/services/theme_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mock/mock_data.dart';
import '../../../domain/entities/unit_state.dart';
import '../../widgets/breez/breez.dart';
import 'dialogs/add_unit_dialog.dart';
import 'layouts/desktop_layout.dart';
import 'layouts/mobile_layout.dart';

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
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
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
      onUnitSelected: (index) => setState(() => _activeUnitIndex = index),
      onThemeToggle: _toggleTheme,
      onAddUnit: _showAddUnitDialog,
    );
  }

  Widget _buildMobileLayout(bool isDark, double width) {
    return Column(
      children: [
        // Header
        AppHeader(
          isDark: isDark,
          onThemeToggle: _toggleTheme,
          hasNotifications: true,
          userName: 'Алексей Б.',
          userRole: 'Админ',
        ),

        // Unit tabs
        UnitTabs(
          units: _units
              .map((u) => UnitTabData(
                    id: u.id,
                    name: u.name,
                    isActive: u.power,
                  ))
              .toList(),
          selectedIndex: _activeUnitIndex,
          onUnitSelected: (index) => setState(() => _activeUnitIndex = index),
        ),

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
            compact: width <= 600,
          ),
        ),

        // Footer
        const AppFooter(outsideTemp: 18),
      ],
    );
  }
}
