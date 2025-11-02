/// Unit Detail Screen - Responsive Version
///
/// Tablet-optimized view of a ventilation unit with adaptive layouts
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/widgets/adaptive_container.dart';
import '../../domain/entities/hvac_unit.dart';
import '../widgets/unit_detail/overview_tab.dart';
import '../widgets/unit_detail/air_quality_tab.dart';
import '../widgets/unit_detail/alerts_history_tab.dart';
import '../widgets/unit_detail/diagnostics_tab.dart';
import 'analytics_screen.dart';

class UnitDetailScreenResponsive extends StatefulWidget {
  final HvacUnit unit;

  const UnitDetailScreenResponsive({
    super.key,
    required this.unit,
  });

  @override
  State<UnitDetailScreenResponsive> createState() =>
      _UnitDetailScreenResponsiveState();
}

class _UnitDetailScreenResponsiveState
    extends State<UnitDetailScreenResponsive>
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
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          OverviewTab(unit: widget.unit),
          AirQualityTab(unit: widget.unit),
          AlertsHistoryTab(unit: widget.unit),
          DiagnosticsTab(unit: widget.unit),
        ],
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
          // Left sidebar with navigation
          _buildTabletSidebar(),

          // Main content area
          Expanded(
            child: AdaptiveContainer(
              padding: EdgeInsets.all(AppSpacing.lgR),
              child: _getTabContent(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundCard,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 24.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.unit.name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            widget.unit.location ?? 'Неизвестно',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: _buildAppBarActions(),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.primaryOrange,
        labelColor: AppTheme.primaryOrange,
        unselectedLabelColor: AppTheme.textSecondary,
        isScrollable: ResponsiveUtils.isMobile(context),
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
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 24.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.unit.name,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                widget.unit.location ?? 'Неизвестно',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Quick stats for tablet
          _buildQuickStats(),
        ],
      ),
      actions: _buildAppBarActions(),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatChip(
          icon: Icons.power_settings_new,
          label: widget.unit.power ? 'ON' : 'OFF',
          color: widget.unit.power
              ? AppTheme.successGreen
              : AppTheme.textSecondary,
        ),
        SizedBox(width: AppSpacing.mdR),
        _buildStatChip(
          icon: Icons.thermostat,
          label: '${widget.unit.temperature.round()}°C',
          color: AppTheme.primaryOrange,
        ),
        SizedBox(width: AppSpacing.mdR),
        _buildStatChip(
          icon: Icons.air,
          label: widget.unit.ventilationMode.displayName,
          color: AppTheme.primaryBlue,
        ),
      ],
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.smR,
        vertical: AppSpacing.xsV,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: AppSpacing.xsR),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
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
      ),
      if (ResponsiveUtils.isTablet(context)) ...[
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
      ],
    ];
  }

  Widget _buildTabletSidebar() {
    return Container(
      width: ResponsiveUtils.isDesktop(context) ? 280.w : 240.w,
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        border: Border(
          right: BorderSide(
            color: AppTheme.backgroundCardBorder,
            width: 1.w,
          ),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: AppSpacing.lgV),
          // Navigation items
          _buildSidebarItem(
            index: 0,
            icon: Icons.dashboard,
            label: 'Обзор',
            isSelected: _selectedIndex == 0,
          ),
          _buildSidebarItem(
            index: 1,
            icon: Icons.air,
            label: 'Качество воздуха',
            isSelected: _selectedIndex == 1,
          ),
          _buildSidebarItem(
            index: 2,
            icon: Icons.warning,
            label: 'История аварий',
            isSelected: _selectedIndex == 2,
          ),
          _buildSidebarItem(
            index: 3,
            icon: Icons.build,
            label: 'Диагностика',
            isSelected: _selectedIndex == 3,
          ),
          const Spacer(),
          // Additional info at bottom
          Padding(
            padding: EdgeInsets.all(AppSpacing.lgR),
            child: Column(
              children: [
                _buildInfoRow('Модель:', widget.unit.model ?? 'N/A'),
                SizedBox(height: AppSpacing.smV),
                _buildInfoRow('IP:', widget.unit.ipAddress ?? 'N/A'),
                SizedBox(height: AppSpacing.smV),
                _buildInfoRow('MAC:', widget.unit.macAddress ?? 'N/A'),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lgV),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Material(
      color: isSelected
          ? AppTheme.primaryOrange.withOpacity(0.1)
          : Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
            _tabController.animateTo(index);
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lgR,
            vertical: AppSpacing.mdV,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: isSelected
                    ? AppTheme.primaryOrange
                    : AppTheme.textSecondary,
              ),
              SizedBox(width: AppSpacing.mdR),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppTheme.primaryOrange
                        : AppTheme.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 3.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _getTabContent(int index) {
    switch (index) {
      case 0:
        return OverviewTab(unit: widget.unit);
      case 1:
        return AirQualityTab(unit: widget.unit);
      case 2:
        return AlertsHistoryTab(unit: widget.unit);
      case 3:
        return DiagnosticsTab(unit: widget.unit);
      default:
        return OverviewTab(unit: widget.unit);
    }
  }
}