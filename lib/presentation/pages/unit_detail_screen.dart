/// Unit Detail Screen - Compact Responsive Version
///
/// Tablet-optimized view with extracted components
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/responsive_utils.dart';
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

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);

    if (isTablet || isDesktop) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: _buildMobileAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: _getTabViews(),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
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
            child: AdaptiveContainer(
              padding: EdgeInsets.all(AppSpacing.lgR),
              child: _getTabViews()[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundCard,
      elevation: 0,
      leading: _buildBackButton(),
      title: _buildTitle(),
      actions: [_buildAnalyticsButton()],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.primaryOrange,
        labelColor: AppTheme.primaryOrange,
        unselectedLabelColor: AppTheme.textSecondary,
        isScrollable: true,
        labelStyle: TextStyle(
          fontSize: 14.sp,
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
      backgroundColor: AppTheme.backgroundCard,
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
      icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 24.sp),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.unit.name,
          style: TextStyle(
            fontSize: ResponsiveUtils.isTablet(context) ? 20.sp : 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          widget.unit.location ?? 'Неизвестно',
          style: TextStyle(
            fontSize: ResponsiveUtils.isTablet(context) ? 14.sp : 12.sp,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsButton() {
    return IconButton(
      icon: Icon(Icons.analytics, color: AppTheme.primaryOrange, size: 24.sp),
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
        icon: Icon(Icons.settings, color: AppTheme.textSecondary, size: 24.sp),
        onPressed: () {
          // Navigate to unit settings
        },
        tooltip: 'Настройки',
      ),
      IconButton(
        icon: Icon(Icons.share, color: AppTheme.textSecondary, size: 24.sp),
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