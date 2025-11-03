/// Home Screen
///
/// Modern smart home dashboard with live room view
/// Refactored to respect 300-line limit with extracted components
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/ventilation_mode.dart';
import '../../domain/entities/mode_preset.dart';
import '../../domain/entities/automation_rule.dart';
import '../../domain/repositories/hvac_repository.dart';
import '../../domain/usecases/update_ventilation_mode.dart';
import '../../domain/usecases/update_fan_speeds.dart';
import '../../domain/usecases/apply_preset.dart';
import '../../domain/usecases/group_power_control.dart';
import '../../domain/usecases/sync_settings_to_all.dart';
import '../../domain/usecases/apply_schedule_to_all.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_states.dart';
import '../widgets/home/home_dashboard_layout.dart';
import '../widgets/home/home_control_cards.dart';
import '../mixins/snackbar_mixin.dart';
import 'schedule_screen.dart';
import 'unit_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SnackbarMixin {
  String? _selectedUnit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return HomeAppBar(
      selectedUnit: _selectedUnit,
      onUnitSelected: _handleUnitSelection,
      onSettingsPressed: _navigateToSettings,
      onAddUnitPressed: _handleAddUnit,
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: BlocBuilder<HvacListBloc, HvacListState>(
        builder: (context, state) {
          if (state is HvacListLoading) {
            return const HomeLoadingState();
          }

          if (state is HvacListError) {
            return HomeErrorState(message: state.message);
          }

          if (state is HvacListLoaded) {
            if (state.units.isEmpty) {
              return const HomeEmptyState();
            }
            return _buildDashboard(state.units);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboard(List<HvacUnit> units) {
    _initializeSelectedUnit(units);
    final currentUnit = _getCurrentUnit(units);

    return HomeDashboard(
      currentUnit: currentUnit,
      units: units,
      selectedUnit: _selectedUnit,
      onPowerChanged: (power) => _updatePower(currentUnit!, power),
      onDetailsPressed: currentUnit != null
          ? () => _navigateToDetails(currentUnit)
          : null,
      buildControlCards: _buildControlCards,
      onRuleToggled: _handleRuleToggled,
      onManageRules: _handleManageRules,
      onPresetSelected: (preset) => _applyPreset(currentUnit!, preset),
      onPowerAllOn: _powerAllOn,
      onPowerAllOff: _powerAllOff,
      onSyncSettings: () => _syncSettings(currentUnit!),
      onApplyScheduleToAll: () => _applyScheduleToAll(currentUnit!),
      onSchedulePressed: currentUnit != null
          ? () => _navigateToSchedule(currentUnit)
          : null,
    );
  }

  Widget _buildControlCards(HvacUnit? currentUnit, BuildContext context) {
    return HomeControlCards(
      currentUnit: currentUnit,
      onModeChanged: (mode) => _updateVentilationMode(currentUnit!, mode),
      onSupplyFanChanged: (speed) =>
          _updateFanSpeeds(currentUnit!, supplySpeed: speed),
      onExhaustFanChanged: (speed) =>
          _updateFanSpeeds(currentUnit!, exhaustSpeed: speed),
      onSchedulePressed: () => _navigateToSchedule(currentUnit!),
    );
  }

  void _initializeSelectedUnit(List<HvacUnit> units) {
    if (_selectedUnit == null && units.isNotEmpty) {
      _selectedUnit = units.first.name;
    }
  }

  HvacUnit? _getCurrentUnit(List<HvacUnit> units) {
    try {
      return units.firstWhere(
        (unit) => unit.name == _selectedUnit ||
                  unit.location == _selectedUnit,
      );
    } catch (e) {
      return units.isNotEmpty ? units.first : null;
    }
  }

  // Event Handlers
  void _handleUnitSelection(String? unit) {
    HapticFeedback.selectionClick();
    setState(() => _selectedUnit = unit);
  }

  void _handleAddUnit() {
    HapticFeedback.lightImpact();
    showInfoSnackbar(AppLocalizations.of(context)!.addUnitComingSoon);
  }

  void _handleRuleToggled(AutomationRule rule) {
    final l10n = AppLocalizations.of(context)!;
    final status = rule.enabled ? l10n.activated : l10n.deactivated;
    showSuccessSnackbar('${rule.name} $status');
  }

  void _handleManageRules() {
    showInfoSnackbar(AppLocalizations.of(context)!.manageRules);
  }

  // Navigation
  void _navigateToSettings() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _navigateToDetails(HvacUnit unit) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UnitDetailScreen(unit: unit)),
    );
  }

  void _navigateToSchedule(HvacUnit unit) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ScheduleScreen(unit: unit)),
    );
  }

  // API Operations
  Future<void> _updatePower(HvacUnit unit, bool power) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<HvacRepository>().updateUnitEntity(
        unit.copyWith(power: power)
      );
    } catch (e) {
      showErrorSnackbar('${l10n.errorChangingPower}: $e');
    }
  }

  Future<void> _updateVentilationMode(
    HvacUnit unit,
    VentilationMode mode
  ) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<UpdateVentilationMode>()(unit.id, mode);
    } catch (e) {
      showErrorSnackbar('${l10n.errorUpdatingMode}: $e');
    }
  }

  Future<void> _updateFanSpeeds(
    HvacUnit unit, {
    int? supplySpeed,
    int? exhaustSpeed
  }) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<UpdateFanSpeeds>().call(
        unitId: unit.id,
        supplyFanSpeed: supplySpeed,
        exhaustFanSpeed: exhaustSpeed,
      );
    } catch (e) {
      showErrorSnackbar('${l10n.errorUpdatingFanSpeed}: $e');
    }
  }

  Future<void> _applyPreset(HvacUnit unit, ModePreset preset) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<ApplyPreset>()(unit.id, preset);
      showSuccessSnackbar(
        '${l10n.presetApplied}: ${preset.mode.displayName}'
      );
    } catch (e) {
      showErrorSnackbar('${l10n.errorApplyingPreset}: $e');
    }
  }

  Future<void> _powerAllOn() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<GroupPowerControl>().powerOnAll();
      showSuccessSnackbar(l10n.allUnitsOn);
    } catch (e) {
      showErrorSnackbar('${l10n.errorTurningOnUnits}: $e');
    }
  }

  Future<void> _powerAllOff() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<GroupPowerControl>().powerOffAll();
      showSuccessSnackbar(l10n.allUnitsOff);
    } catch (e) {
      showErrorSnackbar('${l10n.errorTurningOffUnits}: $e');
    }
  }

  Future<void> _syncSettings(HvacUnit sourceUnit) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<SyncSettingsToAll>()(sourceUnit.id);
      showSuccessSnackbar(l10n.settingsSynced);
    } catch (e) {
      showErrorSnackbar('${l10n.errorSyncingSettings}: $e');
    }
  }

  Future<void> _applyScheduleToAll(HvacUnit sourceUnit) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<ApplyScheduleToAll>()(sourceUnit.id);
      showSuccessSnackbar(l10n.scheduleAppliedToAll);
    } catch (e) {
      showErrorSnackbar('${l10n.errorApplyingSchedule}: $e');
    }
  }
}