import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';
import 'temperature_dial.dart';
import 'airflow_slider.dart';

/// Main climate control card
class ClimateCard extends StatelessWidget {
  final String unitName;
  final bool isPowered;
  final int temperature;
  final int supplyFan;
  final int exhaustFan;
  final int filterPercent;
  final int airflowRate;
  final int? humidity;
  final int? outsideTemp;
  final ValueChanged<int>? onTemperatureIncrease;
  final ValueChanged<int>? onTemperatureDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final VoidCallback? onPowerTap;
  final VoidCallback? onSettingsTap;

  const ClimateCard({
    super.key,
    required this.unitName,
    required this.isPowered,
    required this.temperature,
    required this.supplyFan,
    required this.exhaustFan,
    this.filterPercent = 88,
    this.airflowRate = 420,
    this.humidity,
    this.outsideTemp,
    this.onTemperatureIncrease,
    this.onTemperatureDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onPowerTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 600;

    return BreezCard(
      padding: EdgeInsets.all(isWide ? 32 : 20),
      child: Column(
        children: [
          // Header row
          _buildHeader(context, isWide),

          // Temperature dial
          Expanded(
            child: Center(
              child: TemperatureDial(
                temperature: temperature,
                isActive: isPowered,
                onIncrease: onTemperatureIncrease,
                onDecrease: onTemperatureDecrease,
              ),
            ),
          ),

          // Sliders
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isPowered ? 1.0 : 0.2,
            child: IgnorePointer(
              ignoring: !isPowered,
              child: Column(
                children: [
                  SupplyAirflowSlider(
                    value: supplyFan,
                    onChanged: onSupplyFanChanged,
                  ),
                  const SizedBox(height: 12),
                  ExhaustAirflowSlider(
                    value: exhaustFan,
                    onChanged: onExhaustFanChanged,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Footer stats
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWide) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Unit info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreezLabel(unitName, fontSize: 8),
            const SizedBox(height: 4),
            Row(
              children: [
                StatusDot(isActive: isPowered),
                const SizedBox(width: 6),
                Text(
                  isPowered ? 'В РАБОТЕ' : 'ОСТАНОВЛЕНО',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Right side
        Row(
          children: [
            // Stats (desktop)
            if (isWide && humidity != null) ...[
              _StatColumn(label: 'Влажность', value: '$humidity%'),
              const SizedBox(width: 16),
            ],
            if (isWide && outsideTemp != null) ...[
              _StatColumn(label: 'Внешняя', value: '$outsideTemp°C'),
              const SizedBox(width: 16),
            ],

            // Controls (both mobile and desktop)
            BreezIconButton(
              icon: Icons.settings_outlined,
              onTap: onSettingsTap,
            ),
            const SizedBox(width: 8),
            BreezIconButton(
              icon: Icons.power_settings_new,
              iconColor: isPowered ? AppColors.accentRed : AppColors.accentGreen,
              onTap: onPowerTap,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.darkBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.refresh,
                size: 12,
                color: AppColors.accentGreen,
              ),
              const SizedBox(width: 6),
              Text(
                'ФИЛЬТР: $filterPercent%',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.swap_horiz,
                size: 12,
                color: AppColors.accent,
              ),
              const SizedBox(width: 6),
              Text(
                '$airflowRate М³/Ч',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BreezLabel(label, fontSize: 7),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
