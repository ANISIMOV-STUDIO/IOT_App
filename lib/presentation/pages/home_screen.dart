/// Home Screen
///
/// Modern smart home dashboard with live room view
/// Refactored to respect 300-line limit with extracted components
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/hvac_unit.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_states.dart';
import '../widgets/home/home_dashboard_layout.dart';
import '../widgets/home/home_control_cards.dart';
import '../mixins/snackbar_mixin.dart';
import 'home/home_screen_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SnackbarMixin, HomeScreenLogic {
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
      onUnitSelected: (unit) =>
          handleUnitSelection(unit, (u) => setState(() => _selectedUnit = u)),
      onSettingsPressed: navigateToSettings,
      onAddUnitPressed: handleAddUnit,
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
            currentUnit != null ? updatePower(currentUnit, power) : null,
        onDetailsPressed:
            currentUnit != null ? () => navigateToDetails(currentUnit) : null,
        buildControlCards: _buildControlCards,
        onRuleToggled: handleRuleToggled,
        onManageRules: handleManageRules,
        onPresetSelected: (preset) =>
            currentUnit != null ? applyPreset(currentUnit, preset) : null,
        onPowerAllOn: powerAllOn,
        onPowerAllOff: powerAllOff,
        onSyncSettings: () =>
            currentUnit != null ? syncSettings(currentUnit) : null,
        onApplyScheduleToAll: () =>
            currentUnit != null ? applyScheduleToAll(currentUnit) : null,
        onSchedulePressed:
            currentUnit != null ? () => navigateToSchedule(currentUnit) : null,
      ),
    );
  }

  Widget _buildControlCards(HvacUnit? currentUnit, BuildContext context) {
    return HomeControlCards(
      currentUnit: currentUnit,
      onModeChanged: (mode) => updateVentilationMode(currentUnit!, mode),
      onSupplyFanChanged: (speed) =>
          updateFanSpeeds(currentUnit!, supplySpeed: speed),
      onExhaustFanChanged: (speed) =>
          updateFanSpeeds(currentUnit!, exhaustSpeed: speed),
      onSchedulePressed: () => navigateToSchedule(currentUnit!),
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
}
