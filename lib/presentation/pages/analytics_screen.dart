/// Analytics Screen
///
/// Charts and statistics for unit performance with responsive design
/// Refactored with new HVAC UI Kit components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/temperature_reading.dart';
import '../widgets/common/empty_state.dart';
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

    // Reset animation
    _animationController.reset();

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
      backgroundColor: HvacColors.backgroundDark,
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
    if (_hasError) {
      return _buildErrorState();
    }

    if (!_hasData && !_isLoading) {
      return EmptyState(
        icon: Icons.analytics_outlined,
        title: 'Нет данных',
        message: 'Статистика пока недоступна для выбранного периода',
        actionLabel: 'Обновить',
        onAction: _loadData,
      );
    }

    return HvacRefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        child: HvacSkeletonLoader(
          isLoading: _isLoading,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryGrid(),
            const SizedBox(height: HvacSpacing.mdR),
            _buildAnimatedChart(
              index: 0,
              child: _buildTemperatureChart(),
            ),
            const SizedBox(height: HvacSpacing.lgR),
            _buildAnimatedChart(
              index: 1,
              child: _buildHumidityChart(),
            ),
            const SizedBox(height: HvacSpacing.lgR),
            _buildAnimatedChart(
              index: 2,
              child: _buildEnergyChart(),
            ),
            const SizedBox(height: HvacSpacing.lgR),
            _buildAnimatedChart(
              index: 3,
              child: _buildFanSpeedChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                index: 0,
                label: 'Средняя температура',
                value: '21.5°C',
                icon: Icons.thermostat,
                color: HvacColors.primaryOrange,
                change: '+0.5°C',
              ),
            ),
            const SizedBox(width: HvacSpacing.mdR),
            Expanded(
              child: _buildSummaryCard(
                index: 1,
                label: 'Средняя влажность',
                value: '48%',
                icon: Icons.water_drop,
                color: HvacColors.info,
                change: '-2%',
              ),
            ),
          ],
        ),
        const SizedBox(height: HvacSpacing.mdR),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                index: 2,
                label: 'Время работы',
                value: '18ч 45м',
                icon: Icons.access_time,
                color: HvacColors.success,
                change: '+2ч',
              ),
            ),
            const SizedBox(width: HvacSpacing.mdR),
            Expanded(
              child: _buildSummaryCard(
                index: 3,
                label: 'Энергопотребление',
                value: '6.3 кВт⋅ч',
                icon: Icons.bolt,
                color: HvacColors.warning,
                change: '+0.8 кВт⋅ч',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required int index,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required String change,
  }) {
    final isPositive = change.startsWith('+');

    return HvacInteractiveScale(
      child: HvacGradientBorder(
        gradientColors: [
          color.withValues(alpha:0.5),
          color.withValues(alpha:0.2),
        ],
        borderWidth: 1.5,
        child: Container(
          padding: const EdgeInsets.all(HvacSpacing.mdR),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 18.sp),
                  const SizedBox(width: HvacSpacing.xsR),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: HvacColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: HvacSpacing.xsR),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: HvacSpacing.xxsR),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12.sp,
                    color: isPositive ? HvacColors.success : HvacColors.error,
                  ),
                  const SizedBox(width: HvacSpacing.xxsR),
                  Text(
                    change,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isPositive ? HvacColors.success : HvacColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureChart() {
    if (_isLoading) {
      return _buildLoadingChartContainer('История температуры');
    }

    final spots = _temperatureData
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.temperature))
        .toList();

    return Container(
      padding: const EdgeInsets.all(HvacSpacing.xlR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.show_chart,
                color: HvacColors.primaryOrange,
                size: 20.sp,
              ),
              const SizedBox(width: HvacSpacing.xsR),
              Text(
                'История температуры',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.lgR),
          HvacAnimatedLineChart(
            spots: spots,
            lineColor: HvacColors.primaryOrange,
            gradientStartColor: HvacColors.primaryOrange,
            gradientEndColor: HvacColors.primaryOrange,
            showDots: true,
            showGrid: true,
            animationDuration: const Duration(milliseconds: 1200),
          ),
        ],
      ),
    );
  }

  Widget _buildHumidityChart() {
    if (_isLoading) {
      return _buildLoadingChartContainer('История влажности');
    }

    final spots = _humidityData
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.temperature))
        .toList();

    return Container(
      padding: const EdgeInsets.all(HvacSpacing.xlR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.water_drop,
                color: HvacColors.info,
                size: 20.sp,
              ),
              const SizedBox(width: HvacSpacing.xsR),
              Text(
                'История влажности',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.lgR),
          HvacAnimatedLineChart(
            spots: spots,
            lineColor: HvacColors.info,
            gradientStartColor: HvacColors.info,
            gradientEndColor: HvacColors.info,
            showDots: true,
            showGrid: true,
            animationDuration: const Duration(milliseconds: 1200),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyChart() {
    if (_isLoading) {
      return _buildLoadingChartContainer('Энергопотребление');
    }

    final energyData = [250.0, 300.0, 350.0, 380.0, 320.0, 280.0];
    final labels = ['00', '04', '08', '12', '16', '20'];

    return Container(
      padding: const EdgeInsets.all(HvacSpacing.xlR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bolt,
                color: HvacColors.warning,
                size: 20.sp,
              ),
              const SizedBox(width: HvacSpacing.xsR),
              Text(
                'Энергопотребление',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.lgR),
          HvacAnimatedBarChart(
            values: energyData,
            labels: labels,
            barColor: HvacColors.warning,
            animationDuration: const Duration(milliseconds: 1200),
          ),
        ],
      ),
    );
  }

  Widget _buildFanSpeedChart() {
    if (_isLoading) {
      return _buildLoadingChartContainer('Скорость вентилятора');
    }

    final fanSpeedData = [30.0, 45.0, 60.0, 75.0, 60.0, 40.0];
    final labels = ['00', '04', '08', '12', '16', '20'];

    return Container(
      padding: const EdgeInsets.all(HvacSpacing.xlR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.air,
                color: HvacColors.primaryBlue,
                size: 20.sp,
              ),
              const SizedBox(width: HvacSpacing.xsR),
              Text(
                'Скорость вентилятора',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.lgR),
          HvacAnimatedBarChart(
            values: fanSpeedData,
            labels: labels,
            barColor: HvacColors.primaryBlue,
            animationDuration: const Duration(milliseconds: 1200),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingChartContainer(String title) {
    return Container(
      height: 300.h,
      padding: const EdgeInsets.all(HvacSpacing.xlR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: HvacColors.backgroundElevated,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: HvacSpacing.lgR),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: HvacColors.backgroundElevated,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
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
    if (_isLoading) {
      return child;
    }

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
