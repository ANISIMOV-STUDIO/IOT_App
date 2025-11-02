/// Unit Detail Screen
///
/// Detailed view of a ventilation unit with history and diagnostics
/// Refactored from 1,065 lines to ~110 lines
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/hvac_unit.dart';
import '../widgets/unit_detail/overview_tab.dart';
import '../widgets/unit_detail/air_quality_tab.dart';
import '../widgets/unit_detail/alerts_history_tab.dart';
import '../widgets/unit_detail/diagnostics_tab.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
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
        actions: [
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
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryOrange,
          labelColor: AppTheme.primaryOrange,
          unselectedLabelColor: AppTheme.textSecondary,
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
      ),
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
}
