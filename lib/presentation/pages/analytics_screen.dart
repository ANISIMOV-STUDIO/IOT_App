/// Analytics Screen
///
/// Charts and statistics for unit performance with responsive design
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/temperature_reading.dart';
import '../widgets/temperature_chart.dart';
import '../widgets/common/shimmer_loading.dart';
import '../widgets/common/empty_state.dart';

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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Mock data generation moved out of UI
  List<TemperatureReading> get _temperatureData {
    final now = DateTime.now();
    return List.generate(24, (index) {
      return TemperatureReading(
        timestamp: now.subtract(Duration(hours: 23 - index)),
        temperature: 20.0 + (index % 5) * 0.8 + (index % 3) * 0.3,
      );
    });
  }

  List<TemperatureReading> get _humidityData {
    final now = DateTime.now();
    return List.generate(24, (index) {
      return TemperatureReading(
        timestamp: now.subtract(Duration(hours: 23 - index)),
        temperature: 45.0 + (index % 7) * 2.5,
      );
    });
  }

  bool get _hasData => _temperatureData.isNotEmpty;

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
              'Аналитика',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              widget.unit.name,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.mdR),
            child: DropdownButton<String>(
              value: _selectedPeriod,
              dropdownColor: AppTheme.backgroundCard,
              underline: const SizedBox(),
              style: TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              items: ['День', 'Неделя', 'Месяц'].map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(period),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPeriod = value;
                  });
                  _loadData();
                }
              },
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lgR),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryGrid(),
              SizedBox(height: AppSpacing.mdR),
              _buildChart(
                index: 0,
                child: TemperatureChart(
                  readings: _temperatureData,
                  title: 'История температуры',
                  lineColor: AppTheme.primaryOrange,
                ),
              ),
              SizedBox(height: AppSpacing.lgR),
              _buildChart(index: 1, child: _buildHumidityChart()),
              SizedBox(height: AppSpacing.lgR),
              _buildChart(index: 2, child: _buildEnergyChart()),
              SizedBox(height: AppSpacing.lgR),
              _buildChart(index: 3, child: _buildFanSpeedChart()),
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
          Row(
            children: [
              Expanded(child: ShimmerBox(height: 100.h, borderRadius: BorderRadius.circular(AppRadius.mdR))),
              SizedBox(width: AppSpacing.mdR),
              Expanded(child: ShimmerBox(height: 100.h, borderRadius: BorderRadius.circular(AppRadius.mdR))),
            ],
          ),
          SizedBox(height: AppSpacing.mdR),
          Row(
            children: [
              Expanded(child: ShimmerBox(height: 100.h, borderRadius: BorderRadius.circular(AppRadius.mdR))),
              SizedBox(width: AppSpacing.mdR),
              Expanded(child: ShimmerBox(height: 100.h, borderRadius: BorderRadius.circular(AppRadius.mdR))),
            ],
          ),
          SizedBox(height: AppSpacing.lgR),
          ShimmerBox(height: 250.h, width: double.infinity, borderRadius: BorderRadius.circular(AppRadius.mdR)),
          SizedBox(height: AppSpacing.lgR),
          ShimmerBox(height: 250.h, width: double.infinity, borderRadius: BorderRadius.circular(AppRadius.mdR)),
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
                color: AppTheme.primaryOrange,
                change: '+0.5°C',
              ),
            ),
            SizedBox(width: AppSpacing.mdR),
            Expanded(
              child: _buildSummaryCard(
                index: 1,
                label: 'Средняя влажность',
                value: '48%',
                icon: Icons.water_drop,
                color: AppTheme.info,
                change: '-2%',
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.mdR),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                index: 2,
                label: 'Время работы',
                value: '18ч 45м',
                icon: Icons.access_time,
                color: AppTheme.success,
                change: '+2ч',
              ),
            ),
            SizedBox(width: AppSpacing.mdR),
            Expanded(
              child: _buildSummaryCard(
                index: 3,
                label: 'Энергопотребление',
                value: '6.3 кВт⋅ч',
                icon: Icons.bolt,
                color: AppTheme.warning,
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

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animValue),
          child: Opacity(
            opacity: animValue,
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.mdR),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppRadius.mdR),
          border: Border.all(
            color: AppTheme.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18.sp),
                SizedBox(width: AppSpacing.xsR),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xsR),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            SizedBox(height: AppSpacing.xxsR),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12.sp,
                  color: isPositive ? AppTheme.success : AppTheme.error,
                ),
                SizedBox(width: AppSpacing.xxsR),
                Text(
                  change,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? AppTheme.success : AppTheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart({required int index, required Widget child}) {
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

  Widget _buildHumidityChart() {
    final readings = _humidityData;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lgR),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppRadius.mdR),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'История влажности',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.lgR),
          SizedBox(
            height: 200.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: AppTheme.backgroundCardBorder,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 6,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < 0 || value.toInt() >= readings.length) {
                          return const Text('');
                        }
                        final reading = readings[value.toInt()];
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            '${reading.timestamp.hour}:00',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 10.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 10.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppTheme.backgroundCardBorder,
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: (readings.length - 1).toDouble(),
                minY: 30,
                maxY: 70,
                lineBarsData: [
                  LineChartBarData(
                    spots: readings
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.temperature))
                        .toList(),
                    isCurved: true,
                    color: AppTheme.info,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.info.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyChart() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lgR),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppRadius.mdR),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Энергопотребление',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.lgR),
          SizedBox(
            height: 200.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 400,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} Вт',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const hours = ['00', '04', '08', '12', '16', '20'];
                        if (value.toInt() < hours.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              hours[value.toInt()],
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 10.sp,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}W',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 10.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppTheme.backgroundCardBorder,
                    width: 1,
                  ),
                ),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 250, color: AppTheme.warning)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 300, color: AppTheme.warning)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 350, color: AppTheme.warning)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 380, color: AppTheme.warning)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 320, color: AppTheme.warning)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 280, color: AppTheme.warning)]),
                ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: AppTheme.backgroundCardBorder,
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFanSpeedChart() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lgR),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppRadius.mdR),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Распределение скорости вентиляторов',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.lgR),
          SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: AppTheme.success,
                    value: 30,
                    title: '30%\nНизкая',
                    radius: 80.r,
                    titleStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: AppTheme.info,
                    value: 45,
                    title: '45%\nСредняя',
                    radius: 80.r,
                    titleStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: AppTheme.warning,
                    value: 20,
                    title: '20%\nВысокая',
                    radius: 80.r,
                    titleStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: AppTheme.error,
                    value: 5,
                    title: '5%\nМакс',
                    radius: 80.r,
                    titleStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
