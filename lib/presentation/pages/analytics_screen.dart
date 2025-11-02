/// Analytics Screen
///
/// Charts and statistics for unit performance with responsive design
/// Refactored to respect 300-line limit with extracted components
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/temperature_reading.dart';
import '../widgets/temperature_chart.dart';
import '../widgets/common/shimmer_loading.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/analytics/analytics_summary_grid.dart';
import '../widgets/analytics/humidity_chart.dart';
import '../widgets/analytics/energy_chart.dart';
import '../widgets/analytics/fan_speed_chart.dart';
import '../widgets/analytics/analytics_app_bar.dart';
import '../providers/analytics_data_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  final HvacUnit unit;

  const AnalyticsScreen({
    super.key,
    required this.unit,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedPeriod = 'День';
  bool _isLoading = true;
  bool _hasError = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _animationController.forward();
    }
  }

  // Data accessors
  List<TemperatureReading> get _temperatureData =>
      AnalyticsDataProvider.generateTemperatureData();

  List<TemperatureReading> get _humidityData =>
      AnalyticsDataProvider.generateHumidityData();

  bool get _hasData => AnalyticsDataProvider.hasData(_temperatureData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AnalyticsAppBar(
        unitName: widget.unit.name,
        selectedPeriod: _selectedPeriod,
        onPeriodChanged: _handlePeriodChanged,
        onBack: () => Navigator.pop(context),
      ),
      body: _buildBody(),
    );
  }

  void _handlePeriodChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedPeriod = value;
      });
      _loadData();
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (!_hasData) {
      return EmptyState(
        icon: Icons.analytics_outlined,
        title: 'Нет данных',
        message: 'Статистика пока недоступна для выбранного периода',
        actionLabel: 'Обновить',
        onAction: _loadData,
      );
    }

    return _buildContent();
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lgR),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnalyticsSummaryGrid(),
              SizedBox(height: AppSpacing.mdR),
              _buildAnimatedChart(
                index: 0,
                child: TemperatureChart(
                  readings: _temperatureData,
                  title: 'История температуры',
                  lineColor: AppTheme.primaryOrange,
                ),
              ),
              SizedBox(height: AppSpacing.lgR),
              _buildAnimatedChart(
                index: 1,
                child: HumidityChart(readings: _humidityData),
              ),
              SizedBox(height: AppSpacing.lgR),
              _buildAnimatedChart(
                index: 2,
                child: const EnergyChart(),
              ),
              SizedBox(height: AppSpacing.lgR),
              _buildAnimatedChart(
                index: 3,
                child: const FanSpeedChart(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lgR),
      child: Column(
        children: [
          _buildLoadingRow(),
          SizedBox(height: AppSpacing.mdR),
          _buildLoadingRow(),
          SizedBox(height: AppSpacing.lgR),
          ShimmerBox(
            height: 250.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(AppRadius.mdR),
          ),
          SizedBox(height: AppSpacing.lgR),
          ShimmerBox(
            height: 250.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(AppRadius.mdR),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingRow() {
    return Row(
      children: [
        Expanded(
          child: ShimmerBox(
            height: 100.h,
            borderRadius: BorderRadius.circular(AppRadius.mdR),
          ),
        ),
        SizedBox(width: AppSpacing.mdR),
        Expanded(
          child: ShimmerBox(
            height: 100.h,
            borderRadius: BorderRadius.circular(AppRadius.mdR),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Ошибка загрузки',
      message: 'Не удалось загрузить данные аналитики',
      actionLabel: 'Повторить',
      onAction: _loadData,
    );
  }

  Widget _buildAnimatedChart({
    required int index,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}