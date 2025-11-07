/// Analytics Screen
///
/// Main analytics screen that orchestrates chart widgets and state management
/// Refactored to follow SOLID principles with extracted components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/temperature_reading.dart';
import '../widgets/analytics/analytics_app_bar.dart';
import '../widgets/analytics/analytics_content.dart';
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
  // State management
  String _selectedPeriod = 'День';
  bool _isLoading = true;
  bool _hasError = false;

  // Animation controllers
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

  // Animation setup
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

  // Data loading
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

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

  // Event handlers
  void _handlePeriodChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedPeriod = value;
      });
      _loadData();
    }
  }

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

  Widget _buildBody() {
    // Error state
    if (_hasError) {
      return _buildErrorState();
    }

    // Empty state
    if (!_hasData && !_isLoading) {
      return EmptyState(
        icon: Icons.analytics_outlined,
        title: 'Нет данных',
        message: 'Статистика пока недоступна для выбранного периода',
        actionLabel: 'Обновить',
        onAction: _loadData,
      );
    }

    // Content with refresh indicator
    return HvacRefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        child: HvacSkeletonLoader(
          isLoading: _isLoading,
          child: AnalyticsContent(
            unit: widget.unit,
            fadeAnimation: _fadeAnimation,
            slideAnimation: _slideAnimation,
            temperatureData: _temperatureData,
            humidityData: _humidityData,
            isLoading: _isLoading,
          ),
        ),
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
}