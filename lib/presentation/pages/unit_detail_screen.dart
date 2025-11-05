/// Unit Detail Screen - Compact Responsive Version
///
/// Tablet-optimized view with extracted components
/// Enhanced with Hero animations, charts, and UI Kit components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../core/widgets/adaptive_layout_widgets.dart';
import '../../domain/entities/hvac_unit.dart';
import '../widgets/unit_detail/overview_tab.dart';
import '../widgets/unit_detail/air_quality_tab.dart';
import '../widgets/unit_detail/alerts_history_tab.dart';
import '../widgets/unit_detail/diagnostics_tab.dart';
import '../widgets/unit_detail/tablet_sidebar.dart';
import '../widgets/unit_detail/quick_stats_chips.dart';
import 'analytics_screen.dart';

class UnitDetailScreen extends StatefulWidget {
  final HvacUnit unit;

  const UnitDetailScreen({
    super.key,
    required this.unit,
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
    final isTablet = ResponsiveUtils.isTablet(context);

    if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: _buildMobileAppBar(),
      body: HvacRefreshIndicator(
        onRefresh: _refreshData,
        child: TabBarView(
          controller: _tabController,
          children: _getTabViews(),
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: _buildTabletAppBar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnitDetailTabletSidebar(
            unit: widget.unit,
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
                  child: _getTabViews()[_selectedIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: HvacColors.backgroundCard,
      elevation: 0,
      leading: _buildBackButton(),
      title: _buildTitle(),
      actions: [_buildAnalyticsButton()],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: HvacColors.primaryOrange,
        labelColor: HvacColors.primaryOrange,
        unselectedLabelColor: HvacColors.textSecondary,
        isScrollable: true,
        labelStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Обзор'),
          Tab(text: 'Качество воздуха'),
          Tab(text: 'История аварий'),
          Tab(text: 'Диагностика'),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildTabletAppBar() {
    return AppBar(
      backgroundColor: HvacColors.backgroundCard,
      elevation: 0,
      leading: _buildBackButton(),
      title: Row(
        children: [
          _buildTitle(),
          const Spacer(),
          QuickStatsChips(unit: widget.unit),
        ],
      ),
      actions: _buildTabletActions(),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: HvacColors.textPrimary, size: 24.0),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            HvacIconHero(
              tag: 'unit_icon_${widget.unit.id}',
              icon: widget.unit.power ? Icons.air : Icons.power_off,
              size: ResponsiveUtils.isTablet(context) ? 24.0 : 20.0,
              color: widget.unit.power ? HvacColors.success : HvacColors.error,
            ),
            const SizedBox(width: 8.0),
            HvacStatusHero(
              tag: 'unit_name_${widget.unit.id}',
              child: Text(
                widget.unit.name,
                style: TextStyle(
                  fontSize: ResponsiveUtils.isTablet(context) ? 20.0 : 18.0,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (widget.unit.power) ...[
              const HvacPulsingDot(
                color: HvacColors.success,
                size: 8,
              ),
              const SizedBox(width: 6.0),
            ],
            Text(
              widget.unit.location ?? 'Неизвестно',
              style: TextStyle(
                fontSize: ResponsiveUtils.isTablet(context) ? 14.0 : 12.0,
                color: HvacColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsButton() {
    return IconButton(
      icon: const Icon(Icons.analytics, color: HvacColors.primaryOrange, size: 24.0),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalyticsScreen(unit: widget.unit),
          ),
        );
      },
      tooltip: 'Аналитика',
    );
  }

  List<Widget> _buildTabletActions() {
    return [
      _buildAnalyticsButton(),
      IconButton(
        icon: const Icon(Icons.settings, color: HvacColors.textSecondary, size: 24.0),
        onPressed: () {
          // Navigate to unit settings
        },
        tooltip: 'Настройки',
      ),
      IconButton(
        icon: const Icon(Icons.share, color: HvacColors.textSecondary, size: 24.0),
        onPressed: () {
          // Share unit data
        },
        tooltip: 'Поделиться',
      ),
    ];
  }

  List<Widget> _getTabViews() {
    return [
      OverviewTab(unit: widget.unit),
      AirQualityTab(unit: widget.unit),
      AlertsHistoryTab(unit: widget.unit),
      DiagnosticsTab(unit: widget.unit),
    ];
  }
}