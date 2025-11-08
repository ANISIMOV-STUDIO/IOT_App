/// Home Screen - Refactored with Responsive Design
///
/// Modern smart home dashboard with responsive design and clean architecture
/// Compliant with 300-line limit and SOLID principles
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart' as ui_kit;
import '../../domain/entities/hvac_unit.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_states.dart';
import '../widgets/home/home_dashboard_layout.dart';
import '../widgets/home/home_control_cards.dart';
import '../widgets/home/home_quick_actions.dart';
import '../widgets/home/home_unit_list_item.dart';
import '../mixins/snackbar_mixin.dart';
import 'home_screen_logic.dart';

/// Home Screen Widget - UI Only (Following SOLID principles)
/// Business logic is extracted to HomeScreenLogic
class HomeScreenRefactored extends StatefulWidget {
  const HomeScreenRefactored({super.key});

  @override
  State<HomeScreenRefactored> createState() => _HomeScreenRefactoredState();
}

class _HomeScreenRefactoredState extends State<HomeScreenRefactored>
    with SnackbarMixin {
  late final HomeScreenLogic _logic;
  String? _selectedUnit;

  @override
  void initState() {
    super.initState();
    _logic = HomeScreenLogic(
      context: context,
      showSuccessSnackbar: showSuccessSnackbar,
      showErrorSnackbar: showErrorSnackbar,
      showInfoSnackbar: showInfoSnackbar,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize responsive system
    ui_kit.responsive.init(context);

    return ui_kit.ResponsiveInit(
      child: Scaffold(
        backgroundColor: ui_kit.HvacColors.backgroundDark,
        body: SafeArea(
          child: ui_kit.AdaptiveLayout(
            mobile: _buildMobileLayout(),
            tablet: _buildTabletLayout(),
            desktop: _buildDesktopLayout(),
          ),
        ),
      ),
    );
  }

  /// Mobile Layout (Single Column)
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(child: _buildContent()),
      ],
    );
  }

  /// Tablet Layout (Two Column)
  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Sidebar
        Container(
          width: 280,
          color: ui_kit.HvacColors.backgroundCard,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildSidebarContent()),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  /// Desktop Layout (Three Column)
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar
        Container(
          width: 320,
          color: ui_kit.HvacColors.backgroundCard,
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildSidebarContent()),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1200),
            child: _buildContent(),
          ),
        ),
        // Right sidebar (notifications/quick actions)
        Container(
          width: 320,
          color: ui_kit.HvacColors.backgroundCard,
          child: _buildQuickActionsPanel(),
        ),
      ],
    );
  }

  /// App Bar with responsive sizing
  Widget _buildAppBar() {
    return HomeAppBar(
      selectedUnit: _selectedUnit,
      onUnitSelected: _handleUnitSelection,
      onSettingsPressed: () => _logic.navigateToSettings(),
      onAddUnitPressed: () => _logic.handleAddUnit(),
    );
  }

  /// Main content area with BLoC state management
  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: BlocBuilder<HvacListBloc, HvacListState>(
        builder: (context, state) {
          final isLoading = state is HvacListLoading;

          if (state is HvacListError) {
            return HomeErrorState(
              message: state.message,
              onRetry: _handleRefresh,
            );
          }

          if (state is HvacListLoaded && state.units.isEmpty) {
            return HomeEmptyState(
              onAddDevice: () => _logic.handleAddUnit(),
            );
          }

          final units = state is HvacListLoaded ? state.units : <HvacUnit>[];
          return _buildDashboardWithRefresh(units, isLoading);
        },
      ),
    );
  }

  /// Dashboard with pull-to-refresh
  Widget _buildDashboardWithRefresh(List<HvacUnit> units, bool isLoading) {
    return ui_kit.HvacRefreshIndicator(
      onRefresh: _handleRefresh,
      child: _buildDashboard(units, isLoading),
    );
  }

  /// Main dashboard
  Widget _buildDashboard(List<HvacUnit> units, bool isLoading) {
    if (!isLoading && _selectedUnit == null && units.isNotEmpty) {
      _selectedUnit = units.first.name;
    }

    final currentUnit = !isLoading ? _getCurrentUnit(units) : null;

    return ui_kit.HvacSkeletonLoader(
      isLoading: isLoading,
      child: HomeDashboard(
        currentUnit: currentUnit,
        units: units,
        selectedUnit: _selectedUnit,
        onPowerChanged: (power) => _logic.updatePower(currentUnit!, power),
        onDetailsPressed: () => _logic.navigateToDetails(currentUnit!),
        buildControlCards: _buildControlCards,
        onRuleToggled: _logic.handleRuleToggled,
        onManageRules: () => _logic.handleManageRules(),
        onPresetSelected: (preset) => _logic.applyPreset(currentUnit!, preset),
        onPowerAllOn: () => _logic.powerAllOn(),
        onPowerAllOff: () => _logic.powerAllOff(),
        onSyncSettings: () => _logic.syncSettings(currentUnit!),
        onApplyScheduleToAll: () => _logic.applyScheduleToAll(currentUnit!),
        onSchedulePressed: () => _logic.navigateToSchedule(currentUnit!),
      ),
    );
  }

  /// Control cards builder
  Widget _buildControlCards(HvacUnit? currentUnit, BuildContext context) {
    if (currentUnit == null) return const SizedBox.shrink();

    return HomeControlCards(
      currentUnit: currentUnit,
      onModeChanged: (mode) => _logic.updateVentilationMode(currentUnit, mode),
      onSupplyFanChanged: (speed) =>
          _logic.updateFanSpeeds(currentUnit, supplySpeed: speed),
      onExhaustFanChanged: (speed) =>
          _logic.updateFanSpeeds(currentUnit, exhaustSpeed: speed),
      onSchedulePressed: () => _logic.navigateToSchedule(currentUnit),
    );
  }

  /// Sidebar content for tablet/desktop
  Widget _buildSidebarContent() {
    return BlocBuilder<HvacListBloc, HvacListState>(
      builder: (context, state) {
        if (state is! HvacListLoaded) return const SizedBox.shrink();

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: state.units.length,
          itemBuilder: (context, index) {
            final unit = state.units[index];
            return _buildUnitListItem(unit);
          },
        );
      },
    );
  }

  /// Unit list item for sidebar
  Widget _buildUnitListItem(HvacUnit unit) {
    return HomeUnitListItem(
      unit: unit,
      isSelected: unit.name == _selectedUnit,
      onTap: () => _handleUnitSelection(unit.name),
    );
  }

  /// Quick actions panel for desktop
  Widget _buildQuickActionsPanel() {
    return HomeQuickActionsPanel(
      onPowerAllOn: () => _logic.powerAllOn(),
      onPowerAllOff: () => _logic.powerAllOff(),
    );
  }

  /// Get current unit based on selection
  HvacUnit? _getCurrentUnit(List<HvacUnit> units) {
    try {
      return units.firstWhere(
        (unit) => unit.name == _selectedUnit || unit.location == _selectedUnit,
      );
    } catch (e) {
      return units.isNotEmpty ? units.first : null;
    }
  }

  /// Handle unit selection
  void _handleUnitSelection(String? unit) {
    HapticFeedback.selectionClick();
    setState(() => _selectedUnit = unit);
  }

  /// Handle refresh
  Future<void> _handleRefresh() async {
    if (!mounted) return;
    context.read<HvacListBloc>().add(const LoadHvacUnitsEvent());
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
