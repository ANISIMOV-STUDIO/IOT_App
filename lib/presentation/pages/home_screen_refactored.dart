/// Home Screen - Refactored with Responsive Design
///
/// Modern smart home dashboard with responsive design and clean architecture
/// Compliant with 300-line limit and SOLID principles
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart' as ui_kit;
import '../../generated/l10n/app_localizations.dart';
import '../../domain/entities/hvac_unit.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_states.dart';
import '../widgets/home/home_dashboard_layout.dart';
import '../widgets/home/home_control_cards.dart';
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
          width: 280.w,
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
          width: 320.w,
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
            constraints: BoxConstraints(maxWidth: 1200.w),
            child: _buildContent(),
          ),
        ),
        // Right sidebar (notifications/quick actions)
        Container(
          width: 320.w,
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
      padding: EdgeInsets.all(16.w),
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
          padding: EdgeInsets.all(16.w),
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
    final isSelected = unit.name == _selectedUnit;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: ui_kit.HvacCard(
        variant: ui_kit.HvacCardVariant.outlined,
        onTap: () => _handleUnitSelection(unit.name),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              ui_kit.StatusIndicator(
                isActive: unit.power,
                size: 8.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit.name,
                      style: ui_kit.HvacTypography.titleMedium.copyWith(
                        fontSize: 14.sp,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      unit.location ?? '',
                      style: ui_kit.HvacTypography.bodySmall.copyWith(
                        fontSize: 12.sp,
                        color: ui_kit.HvacColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Quick actions panel for desktop
  Widget _buildQuickActionsPanel() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.quickActions,
            style:
                ui_kit.HvacTypography.headlineSmall.copyWith(fontSize: 18.sp),
          ),
          SizedBox(height: 16.h),
          // Quick action buttons
          _buildQuickActionButton(
            icon: Icons.power_settings_new,
            label: AppLocalizations.of(context)!.allOn,
            onPressed: () => _logic.powerAllOn(),
          ),
          SizedBox(height: 8.h),
          _buildQuickActionButton(
            icon: Icons.power_off,
            label: AppLocalizations.of(context)!.allOff,
            onPressed: () => _logic.powerAllOff(),
          ),
        ],
      ),
    );
  }

  /// Quick action button
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ui_kit.HvacOutlineButton(
        onPressed: onPressed,
        label: label,
        icon: icon,
      ),
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
