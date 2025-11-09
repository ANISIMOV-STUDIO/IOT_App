/// Unit Detail Screen - Compact Responsive Version
///
/// Tablet-optimized view with extracted components
/// Enhanced with Hero animations, charts, and UI Kit components
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../core/widgets/adaptive_layout_widgets.dart';
import '../../core/navigation/app_router.dart';
import '../../domain/entities/hvac_unit.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../widgets/unit_detail/overview_tab.dart';
import '../widgets/unit_detail/air_quality_tab.dart';
import '../widgets/unit_detail/alerts_history_tab.dart';
import '../widgets/unit_detail/diagnostics_tab.dart';
import '../widgets/unit_detail/tablet_sidebar.dart';
import '../widgets/unit_detail/quick_stats_chips.dart';

class UnitDetailScreen extends StatefulWidget {
  final String unitId;

  const UnitDetailScreen({
    super.key,
    required this.unitId,
  });

  @override
  State<UnitDetailScreen> createState() => _UnitDetailScreenState();
}

class _UnitDetailScreenState extends State<UnitDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Refresh unit data
  Future<void> _refreshData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HvacListBloc, HvacListState>(
      builder: (context, state) {
        if (state is HvacListLoaded) {
          final unit = state.units.firstWhere(
            (u) => u.id == widget.unitId,
            orElse: () => state.units.first,
          );
          return _buildContent(unit);
        }

        // Show loading state
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildContent(HvacUnit unit) {
    final isTablet = ResponsiveUtils.isTablet(context);

    if (isTablet) {
      return _buildTabletLayout(unit);
    } else {
      return _buildMobileLayout(unit);
    }
  }

  Widget _buildMobileLayout(HvacUnit unit) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundSecondary,
      appBar: _buildMobileAppBar(unit),
      body: HvacRefreshIndicator(
        onRefresh: _refreshData,
        child: TabBarView(
          controller: _tabController,
          children: _getTabViews(unit),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(HvacUnit unit) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundSecondary,
      appBar: _buildTabletAppBar(unit),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnitDetailTabletSidebar(
            unit: unit,
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
                _tabController.animateTo(index);
              });
            },
          ),
          Expanded(
            child: HvacRefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: AdaptiveContainer(
                  padding: const EdgeInsets.all(HvacSpacing.lgR),
                  child: _getTabViews(unit)[_selectedIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar(HvacUnit unit) {
    return HvacAppBar(
      backgroundColor: HvacColors.backgroundCard,
      centerTitle: false,
      leading: _buildBackButton(),
      title: _buildTitle(unit),
      actions: [_buildAnalyticsButton(unit)],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: HvacColors.primaryOrange,
        labelColor: HvacColors.primaryOrange,
        unselectedLabelColor: HvacColors.textSecondary,
        isScrollable: true,
        labelStyle: HvacTypography.labelMedium,
        tabs: const [
          Tab(text: 'Обзор'),
          Tab(text: 'Качество воздуха'),
          Tab(text: 'История аварий'),
          Tab(text: 'Диагностика'),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildTabletAppBar(HvacUnit unit) {
    return HvacAppBar(
      backgroundColor: HvacColors.backgroundCard,
      centerTitle: false,
      leading: _buildBackButton(),
      title: Row(
        children: [
          _buildTitle(unit),
          const Spacer(),
          QuickStatsChips(unit: unit),
        ],
      ),
      actions: _buildTabletActions(unit),
    );
  }

  Widget _buildBackButton() {
    return HvacIconButton(
      icon: Icons.arrow_back,
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildTitle(HvacUnit unit) {
    final isTablet = ResponsiveUtils.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            HvacIconHero(
              tag: 'unit_icon_${unit.id}',
              icon: unit.power ? Icons.air : Icons.power_off,
              size: isTablet ? 24.0 : 20.0,
              color: unit.power ? HvacColors.success : HvacColors.error,
            ),
            const SizedBox(width: 8.0),
            HvacStatusHero(
              tag: 'unit_name_${unit.id}',
              child: Text(
                unit.name,
                style: isTablet
                    ? HvacTypography.titleLarge
                    : HvacTypography.titleMedium,
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (unit.power) ...[
              const HvacPulsingDot(
                color: HvacColors.success,
                size: 8,
              ),
              const SizedBox(width: 6.0),
            ],
            Text(
              unit.location ?? 'Неизвестно',
              style: isTablet
                  ? HvacTypography.bodyMedium
                  : HvacTypography.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsButton(HvacUnit unit) {
    return HvacIconButton(
      icon: Icons.analytics,
      color: HvacColors.primaryOrange,
      onPressed: () {
        context.goToAnalytics();
      },
      tooltip: 'Аналитика',
    );
  }

  List<Widget> _buildTabletActions(HvacUnit unit) {
    return [
      _buildAnalyticsButton(unit),
      HvacIconButton(
        icon: Icons.settings,
        color: HvacColors.textSecondary,
        onPressed: () {
          // Navigate to unit settings
        },
        tooltip: 'Настройки',
      ),
      HvacIconButton(
        icon: Icons.share,
        color: HvacColors.textSecondary,
        onPressed: () {
          // Share unit data
        },
        tooltip: 'Поделиться',
      ),
    ];
  }

  List<Widget> _getTabViews(HvacUnit unit) {
    return [
      OverviewTab(unit: unit),
      AirQualityTab(unit: unit),
      AlertsHistoryTab(unit: unit),
      DiagnosticsTab(unit: unit),
    ];
  }
}
