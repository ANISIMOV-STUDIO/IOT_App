/// Unit Detail Screen
///
/// Detailed view of a ventilation unit with history and diagnostics
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/alert.dart';
import '../../domain/entities/ventilation_mode.dart';
import 'analytics_screen.dart';
import '../widgets/air_quality_indicator.dart';
import '../widgets/airflow_animation.dart';
import '../widgets/animated_stat_card.dart';

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
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.unit.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              widget.unit.location ?? 'Неизвестно',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics, color: AppTheme.primaryOrange),
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
          labelStyle: const TextStyle(
            fontSize: 14,
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
          _buildOverviewTab(),
          _buildAirQualityTab(),
          _buildAlertsHistoryTab(),
          _buildDiagnosticsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          _buildStatusCard(),

          const SizedBox(height: 20),

          // Quick stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Время работы',
                  '2ч 15м',
                  Icons.access_time,
                  AppTheme.info,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Энергия',
                  '350 Вт',
                  Icons.bolt,
                  AppTheme.warning,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Температура притока',
                  '${widget.unit.supplyAirTemp?.toInt() ?? 0}°C',
                  Icons.thermostat,
                  AppTheme.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Влажность',
                  '${widget.unit.humidity.toInt()}%',
                  Icons.water_drop,
                  AppTheme.info,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Fan speeds
          _buildFanSpeedsCard(),

          const SizedBox(height: 20),

          // Maintenance info
          _buildMaintenanceCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: widget.unit.power
                  ? AppTheme.success.withValues(alpha: 0.2)
                  : AppTheme.error.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.unit.power ? Icons.check_circle : Icons.power_off,
              color: widget.unit.power ? AppTheme.success : AppTheme.error,
              size: 40,
            ),
          ),

          const SizedBox(width: 20),

          // Status text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.unit.power ? 'Работает' : 'Выключено',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: widget.unit.power ? AppTheme.success : AppTheme.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Режим: ${widget.unit.ventMode != null ? _getModeDisplayName(widget.unit.ventMode!) : "Не установлен"}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ID устройства: ${widget.unit.id}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFanSpeedsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Скорости вентиляторов',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Supply fan
          Row(
            children: [
              const Icon(Icons.air, color: AppTheme.primaryOrange, size: 20),
              const SizedBox(width: 12),
              const Text(
                'Приточный',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.unit.supplyFanSpeed ?? 0}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Exhaust fan
          Row(
            children: [
              const Icon(Icons.air, color: AppTheme.info, size: 20),
              const SizedBox(width: 12),
              const Text(
                'Вытяжной',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.info.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.unit.exhaustFanSpeed ?? 0}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.info,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.build, color: AppTheme.warning, size: 20),
              SizedBox(width: 12),
              Text(
                'Обслуживание',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildMaintenanceItem('Последнее обслуживание', '15 дней назад'),
          const SizedBox(height: 8),
          _buildMaintenanceItem('Фильтр приточный', '70% ресурса'),
          const SizedBox(height: 8),
          _buildMaintenanceItem('Фильтр вытяжной', '85% ресурса'),
          const SizedBox(height: 8),
          _buildMaintenanceItem('Следующее ТО', 'через 45 дней'),
        ],
      ),
    );
  }

  Widget _buildMaintenanceItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAirQualityTab() {
    // Mock data for air quality
    const airQualityLevel = AirQualityLevel.good;
    const co2Level = 650;
    const pm25Level = 12.5;
    const vocLevel = 180.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Air quality indicator
          const AirQualityIndicator(
            level: airQualityLevel,
            co2Level: co2Level,
            pm25Level: pm25Level,
            vocLevel: vocLevel,
          ),

          const SizedBox(height: 20),

          // Airflow animation
          AirflowAnimation(
            isActive: widget.unit.power,
            speed: widget.unit.supplyFanSpeed ?? 0,
          ),

          const SizedBox(height: 20),

          // Stats with animation
          const Text(
            'Текущие показатели',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: AnimatedStatCard(
                  label: 'Температура',
                  value: '${widget.unit.supplyAirTemp?.toInt() ?? 0}°C',
                  icon: Icons.thermostat,
                  color: AppTheme.primaryOrange,
                  trend: '+0.5°C',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedStatCard(
                  label: 'Влажность',
                  value: '${widget.unit.humidity.toInt()}%',
                  icon: Icons.water_drop,
                  color: AppTheme.info,
                  trend: '-2%',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: AnimatedStatCard(
                  label: 'Приточный',
                  value: '${widget.unit.supplyFanSpeed ?? 0}%',
                  icon: Icons.air,
                  color: AppTheme.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedStatCard(
                  label: 'Вытяжной',
                  value: '${widget.unit.exhaustFanSpeed ?? 0}%',
                  icon: Icons.air,
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Recommendations
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.info.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.info,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Рекомендация',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Качество воздуха хорошее. Рекомендуем поддерживать текущий режим вентиляции.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsHistoryTab() {
    final alerts = widget.unit.alerts ?? [];

    if (alerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppTheme.success.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Нет аварий',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Установка работает без ошибок',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(Alert alert) {
    Color severityColor;
    IconData severityIcon;

    switch (alert.severity) {
      case AlertSeverity.critical:
        severityColor = AppTheme.error;
        severityIcon = Icons.error;
        break;
      case AlertSeverity.error:
        severityColor = AppTheme.error;
        severityIcon = Icons.error_outline;
        break;
      case AlertSeverity.warning:
        severityColor = AppTheme.warning;
        severityIcon = Icons.warning;
        break;
      case AlertSeverity.info:
        severityColor = AppTheme.info;
        severityIcon = Icons.info;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(severityIcon, color: severityColor, size: 20),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Авария: код ${alert.code}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  alert.timestamp != null
                      ? '${alert.timestamp!.day.toString().padLeft(2, '0')}.${alert.timestamp!.month.toString().padLeft(2, '0')}.${alert.timestamp!.year} ${alert.timestamp!.hour.toString().padLeft(2, '0')}:${alert.timestamp!.minute.toString().padLeft(2, '0')}'
                      : 'Время неизвестно',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System health
          _buildSystemHealthCard(),

          const SizedBox(height: 20),

          // Sensor readings
          _buildSensorReadingsCard(),

          const SizedBox(height: 20),

          // Network status
          _buildNetworkStatusCard(),

          const SizedBox(height: 20),

          // Run diagnostics button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _runDiagnostics,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Запустить диагностику',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSystemHealthCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.health_and_safety, color: AppTheme.success, size: 20),
              SizedBox(width: 12),
              Text(
                'Состояние системы',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildHealthItem('Приточный вентилятор', true),
          _buildHealthItem('Вытяжной вентилятор', true),
          _buildHealthItem('Нагреватель', true),
          _buildHealthItem('Рекуператор', true),
          _buildHealthItem('Датчики', true),
        ],
      ),
    );
  }

  Widget _buildHealthItem(String label, bool isOk) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          Row(
            children: [
              Icon(
                isOk ? Icons.check_circle : Icons.error,
                color: isOk ? AppTheme.success : AppTheme.error,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                isOk ? 'Норма' : 'Ошибка',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isOk ? AppTheme.success : AppTheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorReadingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.sensors, color: AppTheme.info, size: 20),
              SizedBox(width: 12),
              Text(
                'Показания датчиков',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildSensorItem(
            'Температура притока',
            '${widget.unit.supplyAirTemp?.toInt() ?? 0}°C',
            AppTheme.primaryOrange,
          ),
          _buildSensorItem(
            'Температура улицы',
            '${widget.unit.outdoorTemp?.toInt() ?? 0}°C',
            AppTheme.info,
          ),
          _buildSensorItem(
            'Влажность',
            '${widget.unit.humidity.toInt()}%',
            AppTheme.success,
          ),
          _buildSensorItem(
            'Давление',
            '1013 Па',
            AppTheme.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildSensorItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
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
              Icon(
                widget.unit.wifiStatus?.isConnected == true ? Icons.wifi : Icons.wifi_off,
                color: widget.unit.wifiStatus?.isConnected == true
                    ? AppTheme.success
                    : AppTheme.error,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                'Сетевое подключение',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildNetworkItem('Статус', widget.unit.wifiStatus?.isConnected == true ? 'Подключено' : 'Отключено'),
          _buildNetworkItem('Сеть', widget.unit.wifiStatus?.connectedSSID ?? 'Не подключено'),
          _buildNetworkItem('Сигнал', '${widget.unit.wifiStatus?.signalQuality ?? 0}%'),
          _buildNetworkItem('IP адрес', widget.unit.wifiStatus?.ipAddress ?? 'Не назначен'),
        ],
      ),
    );
  }

  Widget _buildNetworkItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _runDiagnostics() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        backgroundColor: AppTheme.backgroundCard,
        title: Text(
          'Диагностика',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppTheme.primaryOrange,
            ),
            SizedBox(height: 16),
            Text(
              'Выполняется диагностика системы...',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );

    // Simulate diagnostics
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Диагностика завершена. Система в норме.'),
          backgroundColor: AppTheme.success,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  String _getModeDisplayName(VentilationMode mode) {
    return switch (mode) {
      VentilationMode.basic => 'Базовый',
      VentilationMode.intensive => 'Интенсивный',
      VentilationMode.economic => 'Экономичный',
      VentilationMode.maximum => 'Максимальный',
      VentilationMode.kitchen => 'Кухня',
      VentilationMode.fireplace => 'Камин',
      VentilationMode.vacation => 'Отпуск',
      VentilationMode.custom => 'Пользовательский',
    };
  }
}
