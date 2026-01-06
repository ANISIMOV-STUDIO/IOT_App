/// Main Temperature Card - Primary display widget
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'fan_slider.dart';
import 'main_temp_card_header.dart';
import 'main_temp_card_shimmer.dart';
import 'sensors_grid.dart';
import 'stat_item.dart';
import 'temp_column.dart';

/// Main temperature display card with gradient background
class MainTempCard extends StatelessWidget {
  final String unitName;
  final String? status;
  final int temperature;
  final int heatingTemp;
  final int coolingTemp;
  final int humidity;
  final int airflow;
  final int filterPercent;
  final bool isPowered;
  final bool isLoading;
  final int supplyFan;
  final int exhaustFan;
  final VoidCallback? onPowerToggle;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onHeatingTempIncrease;
  final VoidCallback? onHeatingTempDecrease;
  final VoidCallback? onCoolingTempIncrease;
  final VoidCallback? onCoolingTempDecrease;
  final bool showControls;
  final int alarmCount;
  final VoidCallback? onAlarmsTap;
  final bool isPowerLoading;
  final UnitState? sensorUnit;
  final bool showStats;

  const MainTempCard({
    super.key,
    required this.unitName,
    required this.temperature,
    this.heatingTemp = 21,
    this.coolingTemp = 24,
    this.status,
    this.humidity = 45,
    this.airflow = 420,
    this.filterPercent = 88,
    this.isPowered = true,
    this.isLoading = false,
    this.supplyFan = 50,
    this.exhaustFan = 50,
    this.onPowerToggle,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onSettingsTap,
    this.onHeatingTempIncrease,
    this.onHeatingTempDecrease,
    this.onCoolingTempIncrease,
    this.onCoolingTempDecrease,
    this.showControls = false,
    this.alarmCount = 0,
    this.onAlarmsTap,
    this.isPowerLoading = false,
    this.sensorUnit,
    this.showStats = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final poweredGradient = isDark
        ? AppColors.darkCardGradientColors
        : AppColors.lightCardGradientColors;
    final offGradient = [colors.card, colors.card];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPowered ? poweredGradient : offGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isPowered
              ? AppColors.accent.withValues(alpha: 0.3)
              : colors.border,
        ),
        boxShadow: isPowered
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(24),
      child: isLoading
          ? const MainTempCardShimmer()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                MainTempCardHeader(
                  unitName: unitName,
                  status: status,
                  isPowered: isPowered,
                  showControls: showControls,
                  alarmCount: alarmCount,
                  isPowerLoading: isPowerLoading,
                  onPowerToggle: onPowerToggle,
                  onSettingsTap: onSettingsTap,
                  onAlarmsTap: onAlarmsTap,
                ),

                // Temperature display - Two columns: Heating & Cooling
                _TemperatureSection(
                  heatingTemp: heatingTemp,
                  coolingTemp: coolingTemp,
                  isPowered: isPowered,
                  colors: colors,
                  l10n: l10n,
                  onHeatingTempIncrease: onHeatingTempIncrease,
                  onHeatingTempDecrease: onHeatingTempDecrease,
                  onCoolingTempIncrease: onCoolingTempIncrease,
                  onCoolingTempDecrease: onCoolingTempDecrease,
                ),

                // Stats/Sensors section
                if (showStats || sensorUnit != null)
                  _StatsSection(
                    sensorUnit: sensorUnit,
                    airflow: airflow,
                    humidity: humidity,
                    filterPercent: filterPercent,
                    colors: colors,
                    l10n: l10n,
                  ),

                // Fan sliders
                if (isPowered)
                  _FanSlidersSection(
                    supplyFan: supplyFan,
                    exhaustFan: exhaustFan,
                    onSupplyFanChanged: onSupplyFanChanged,
                    onExhaustFanChanged: onExhaustFanChanged,
                    colors: colors,
                    l10n: l10n,
                  ),
              ],
            ),
    );
  }
}

/// Temperature section with heating and cooling columns
class _TemperatureSection extends StatelessWidget {
  final int heatingTemp;
  final int coolingTemp;
  final bool isPowered;
  final BreezColors colors;
  final AppLocalizations l10n;
  final VoidCallback? onHeatingTempIncrease;
  final VoidCallback? onHeatingTempDecrease;
  final VoidCallback? onCoolingTempIncrease;
  final VoidCallback? onCoolingTempDecrease;

  const _TemperatureSection({
    required this.heatingTemp,
    required this.coolingTemp,
    required this.isPowered,
    required this.colors,
    required this.l10n,
    this.onHeatingTempIncrease,
    this.onHeatingTempDecrease,
    this.onCoolingTempIncrease,
    this.onCoolingTempDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Heating temperature
            Expanded(
              child: TemperatureColumn(
                label: l10n.heating,
                temperature: heatingTemp,
                icon: Icons.whatshot,
                color: AppColors.accentOrange,
                isPowered: isPowered,
                onIncrease: onHeatingTempIncrease,
                onDecrease: onHeatingTempDecrease,
              ),
            ),
            // Divider
            Container(
              width: 1,
              height: 80,
              color: colors.border,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            // Cooling temperature
            Expanded(
              child: TemperatureColumn(
                label: l10n.cooling,
                temperature: coolingTemp,
                icon: Icons.ac_unit,
                color: AppColors.accent,
                isPowered: isPowered,
                onIncrease: onCoolingTempIncrease,
                onDecrease: onCoolingTempDecrease,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stats section with sensors grid or stat items
class _StatsSection extends StatelessWidget {
  final UnitState? sensorUnit;
  final int airflow;
  final int humidity;
  final int filterPercent;
  final BreezColors colors;
  final AppLocalizations l10n;

  const _StatsSection({
    this.sensorUnit,
    required this.airflow,
    required this.humidity,
    required this.filterPercent,
    required this.colors,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.border),
        ),
      ),
      child: sensorUnit != null
          ? SensorsGrid(unit: sensorUnit!)
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  icon: Icons.air,
                  value: '$airflow м³/ч',
                  label: l10n.airflowRate,
                ),
                StatItem(
                  icon: Icons.water_drop_outlined,
                  value: '$humidity%',
                  label: l10n.humidity,
                ),
                StatItem(
                  icon: Icons.filter_alt_outlined,
                  value: '$filterPercent%',
                  label: l10n.filter,
                ),
              ],
            ),
    );
  }
}

/// Fan sliders section
class _FanSlidersSection extends StatelessWidget {
  final int supplyFan;
  final int exhaustFan;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final BreezColors colors;
  final AppLocalizations l10n;

  const _FanSlidersSection({
    required this.supplyFan,
    required this.exhaustFan,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    required this.colors,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: colors.border),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: FanSlider(
                  label: l10n.intake,
                  value: supplyFan,
                  color: AppColors.accent,
                  icon: Icons.arrow_downward_rounded,
                  onChanged: onSupplyFanChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FanSlider(
                  label: l10n.exhaust,
                  value: exhaustFan,
                  color: AppColors.accentOrange,
                  icon: Icons.arrow_upward_rounded,
                  onChanged: onExhaustFanChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
