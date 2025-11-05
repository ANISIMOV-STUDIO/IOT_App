/// Overview Tab Widget
///
/// Overview tab for unit detail screen showing status, stats, fans, and maintenance
/// Enhanced with charts, gradient borders, and neumorphic buttons
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/ventilation_mode.dart';
import 'unit_stat_card.dart';

class OverviewTab extends StatelessWidget {
  final HvacUnit unit;

  const OverviewTab({
    super.key,
    required this.unit,
  });

  /// Generate mock temperature data for the last 24 hours
  List<FlSpot> _generateTemperatureData() {
    final baseTemp = unit.supplyAirTemp ?? 22.0;
    final spots = <FlSpot>[];

    for (int i = 0; i < 24; i++) {
      final variance = (i % 3) * 0.8 - 0.4; // Small variations
      spots.add(FlSpot(i.toDouble(), baseTemp + variance));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Temperature Display with Gradient Border
          _buildHeroTemperatureCard(),
          const SizedBox(height: 20.0),

          // Temperature Chart
          _buildTemperatureChart(),
          const SizedBox(height: 20.0),

          // Status card
          _buildStatusCard(),
          const SizedBox(height: 20.0),

          // Quick stats
          const Row(
            children: [
              Expanded(
                child: UnitStatCard(
                  label: 'Время работы',
                  value: '2ч 15м',
                  icon: Icons.access_time,
                  color: HvacColors.info,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: UnitStatCard(
                  label: 'Энергия',
                  value: '350 Вт',
                  icon: Icons.bolt,
                  color: HvacColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: UnitStatCard(
                  label: 'Температура притока',
                  value: '${unit.supplyAirTemp?.toInt() ?? 0}°C',
                  icon: Icons.thermostat,
                  color: HvacColors.success,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: UnitStatCard(
                  label: 'Влажность',
                  value: '${unit.humidity.toInt()}%',
                  icon: Icons.water_drop,
                  color: HvacColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),

          // Control Buttons with Neumorphic Design
          _buildControlButtons(),
          const SizedBox(height: 20.0),

          // Fan speeds card
          _buildFanSpeedsCard(),
          const SizedBox(height: 20.0),

          // Maintenance card
          _buildMaintenanceCard(),
        ],
      ),
    );
  }

  /// Hero temperature card with gradient border
  Widget _buildHeroTemperatureCard() {
    final temp = unit.supplyAirTemp?.toInt() ?? 0;
    return HvacGradientBorder(
      gradientColors: const [
        HvacColors.primaryOrange,
        HvacColors.info,
      ],
      borderWidth: 3,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.thermostat,
                  color: HvacColors.primaryOrange,
                  size: 28.0,
                ),
                const SizedBox(width: 12.0),
                Text(
                  'Текущая температура',
                  style: HvacTypography.titleLarge.copyWith(
                    fontSize: 16.0,
                    color: HvacColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (unit.power)
                  const HvacPulsingDot(
                    color: HvacColors.success,
                    size: 12,
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            HvacTemperatureHero(
              tag: 'unit_temp_${unit.id}',
              temperature: '$temp°C',
              style: const TextStyle(
                fontSize: 52.0,
                fontWeight: FontWeight.w700,
                color: HvacColors.textPrimary,
                height: 1,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Режим: ${unit.ventMode != null ? _getModeDisplayName(unit.ventMode!) : "Не установлен"}',
              style: HvacTypography.bodyMedium.copyWith(
                fontSize: 14.0,
                color: HvacColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Temperature chart for last 24 hours
  Widget _buildTemperatureChart() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart,
                color: HvacColors.primaryOrange,
                size: 20.0,
              ),
              const SizedBox(width: 12.0),
              Text(
                'Температура за 24 часа',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.0,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          HvacAnimatedLineChart(
            spots: _generateTemperatureData(),
            lineColor: HvacColors.primaryOrange,
            gradientStartColor: HvacColors.primaryOrange,
            gradientEndColor: HvacColors.info,
            showDots: false,
            showGrid: true,
          ),
        ],
      ),
    );
  }

  /// Control buttons with neumorphic design
  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Управление',
            style: HvacTypography.titleLarge.copyWith(
              fontSize: 16.0,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: HvacInteractiveScale(
                  onTap: () {
                    // TODO: Toggle power
                  },
                  child: HvacNeumorphicButton(
                    onPressed: () {
                      // TODO: Toggle power
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          unit.power ? Icons.power_off : Icons.power_settings_new,
                          color: unit.power ? HvacColors.error : HvacColors.success,
                          size: 20.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          unit.power ? 'Выключить' : 'Включить',
                          style: HvacTypography.bodyMedium.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: HvacColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: HvacInteractiveScale(
                  onTap: () {
                    // TODO: Open mode selector
                  },
                  child: HvacNeumorphicButton(
                    onPressed: () {
                      // TODO: Open mode selector
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.settings,
                          color: HvacColors.primaryOrange,
                          size: 20.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Режим',
                          style: HvacTypography.bodyMedium.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: HvacColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Row(
        children: [
          // Status indicator with pulsing dot
          Stack(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: unit.power
                      ? HvacColors.success.withValues(alpha: 0.2)
                      : HvacColors.error.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  unit.power ? Icons.check_circle : Icons.power_off,
                  color: unit.power ? HvacColors.success : HvacColors.error,
                  size: 40.0,
                ),
              ),
              if (unit.power)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: HvacPulsingDot(
                    color: HvacColors.success,
                    size: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20.0),

          // Status text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      unit.power ? 'Работает' : 'Выключено',
                      style: HvacTypography.displaySmall.copyWith(
                        fontSize: 24.0,
                        color: unit.power ? HvacColors.success : HvacColors.error,
                      ),
                    ),
                    if (unit.power) ...[
                      const SizedBox(width: 8.0),
                      Text(
                        'ONLINE',
                        style: HvacTypography.bodySmall.copyWith(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          color: HvacColors.success,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Режим: ${unit.ventMode != null ? _getModeDisplayName(unit.ventMode!) : "Не установлен"}',
                  style: HvacTypography.bodyMedium.copyWith(
                    fontSize: 14.0,
                    color: HvacColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'ID устройства: ${unit.id}',
                  style: HvacTypography.bodyMedium.copyWith(
                    fontSize: 14.0,
                    color: HvacColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFanSpeedsCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Скорости вентиляторов',
            style: HvacTypography.titleLarge.copyWith(
              fontSize: 16.0,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16.0),

          // Supply fan
          _buildFanRow(
            'Приточный',
            unit.supplyFanSpeed ?? 0,
            HvacColors.primaryOrange,
          ),
          const SizedBox(height: 12.0),

          // Exhaust fan
          _buildFanRow(
            'Вытяжной',
            unit.exhaustFanSpeed ?? 0,
            HvacColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildFanRow(String label, int speed, Color color) {
    return Row(
      children: [
        Icon(Icons.air, color: color, size: 20.0),
        const SizedBox(width: 12.0),
        Text(
          label,
          style: HvacTypography.bodyMedium.copyWith(
            fontSize: 14.0,
            color: HvacColors.textSecondary,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: HvacRadius.smRadius,
          ),
          child: Text(
            '$speed%',
            style: HvacTypography.titleLarge.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaintenanceCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.build, color: HvacColors.warning, size: 20.0),
              const SizedBox(width: 12.0),
              Text(
                'Обслуживание',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.0,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          _buildMaintenanceItem('Последнее обслуживание', '15 дней назад'),
          const SizedBox(height: 8.0),
          _buildMaintenanceItem('Фильтр приточный', '70% ресурса'),
          const SizedBox(height: 8.0),
          _buildMaintenanceItem('Фильтр вытяжной', '85% ресурса'),
          const SizedBox(height: 8.0),
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
          style: HvacTypography.bodySmall.copyWith(
            fontSize: 13.0,
            color: HvacColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: HvacTypography.bodySmall.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
      ],
    );
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
