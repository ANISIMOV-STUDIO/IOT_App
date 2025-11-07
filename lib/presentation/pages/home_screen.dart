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
import '../../core/navigation/app_router.dart';
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
import '../bloc/hvac_list/hvac_list_event.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_states.dart';
import '../widgets/home/home_dashboard_layout.dart';
import '../widgets/home/home_control_cards.dart';
import '../mixins/snackbar_mixin.dart';

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
          final isLoading = state is HvacListLoading;

          if (state is HvacListError) {
            return HomeErrorState(message: state.message);
          }

          if (state is HvacListLoaded && state.units.isEmpty) {
            return const HomeEmptyState();
          }

          // Show skeleton loader while loading or show actual dashboard
          final units = state is HvacListLoaded ? state.units : <HvacUnit>[];
          return _buildDashboardWithRefresh(units, isLoading);
        },
      ),
    );
  }

  Widget _buildDashboardWithRefresh(List<HvacUnit> units, bool isLoading) {
    return HvacRefreshIndicator(
      onRefresh: _handleRefresh,
      child: _buildDashboard(units, isLoading),
    );
  }

  Future<void> _handleRefresh() async {
    if (!mounted) return;
    context.read<HvacListBloc>().add(const LoadHvacUnitsEvent());
    // Wait for the bloc to finish loading
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _buildDashboard(List<HvacUnit> units, bool isLoading) {
    if (!isLoading) {
      _initializeSelectedUnit(units);
    }
    final currentUnit = !isLoading ? _getCurrentUnit(units) : null;

    return HvacSkeletonLoader(
      isLoading: isLoading,
      child: HomeDashboard(
        currentUnit: currentUnit,
        units: units,
        selectedUnit: _selectedUnit,
        onPowerChanged: (power) =>
            currentUnit != null ? _updatePower(currentUnit, power) : null,
        onDetailsPressed:
            currentUnit != null ? () => _navigateToDetails(currentUnit) : null,
        buildControlCards: _buildControlCards,
        onRuleToggled: _handleRuleToggled,
        onManageRules: _handleManageRules,
        onPresetSelected: (preset) =>
            currentUnit != null ? _applyPreset(currentUnit, preset) : null,
        onPowerAllOn: _powerAllOn,
        onPowerAllOff: _powerAllOff,
        onSyncSettings: () =>
            currentUnit != null ? _syncSettings(currentUnit) : null,
        onApplyScheduleToAll: () =>
            currentUnit != null ? _applyScheduleToAll(currentUnit) : null,
        onSchedulePressed:
            currentUnit != null ? () => _navigateToSchedule(currentUnit) : null,
      ),
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
        (unit) => unit.name == _selectedUnit || unit.location == _selectedUnit,
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
    context.goToSettings();
  }

  void _navigateToDetails(HvacUnit unit) {
    HapticFeedback.lightImpact();
    context.goToUnitDetail(unit.id);
  }

  void _navigateToSchedule(HvacUnit unit) {
    context.goToSchedule(unit.id);
  }

  // API Operations
  Future<void> _updatePower(HvacUnit unit, bool power) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<HvacRepository>().updateUnitEntity(unit.copyWith(power: power));
    } catch (e) {
      showErrorSnackbar('${l10n.errorChangingPower}: $e');
    }
  }

  Future<void> _updateVentilationMode(
      HvacUnit unit, VentilationMode mode) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      await sl<UpdateVentilationMode>()(unit.id, mode);
    } catch (e) {
      showErrorSnackbar('${l10n.errorUpdatingMode}: $e');
    }
  }

  Future<void> _updateFanSpeeds(HvacUnit unit,
      {int? supplySpeed, int? exhaustSpeed}) async {
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
      showSuccessSnackbar('${l10n.presetApplied}: ${preset.mode.displayName}');
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
