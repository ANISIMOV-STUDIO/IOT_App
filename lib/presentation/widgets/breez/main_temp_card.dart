/// Main Temperature Card - Primary display widget
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';
import 'fan_slider.dart';
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
  final UnitState? sensorUnit; // For full sensors grid
  final bool showStats; // Show stats row (airflow, humidity, filter)

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

    // Theme-aware gradients (using centralized tokens)
    final poweredGradient = isDark
        ? AppColors.darkCardGradientColors
        : AppColors.lightCardGradientColors;
    final offGradient = [colors.card, colors.card];

    final cardWidget = Container(
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
              ? _buildShimmer(context, colors, isDark)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(context, l10n),
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            unitName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colors.text,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: colors.textMuted,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Alarm badge (if any)
                  if (alarmCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: onAlarmsTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentRed.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppRadius.button),
                            border: Border.all(
                              color: AppColors.accentRed.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 12,
                                color: AppColors.accentRed,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$alarmCount',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accentRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  // Controls or Status badge
                  if (showControls)
                    Row(
                      children: [
                        BreezIconButton(
                          icon: Icons.settings_outlined,
                          onTap: onSettingsTap,
                        ),
                        const SizedBox(width: 8),
                        isPowerLoading
                            ? const SizedBox(
                                width: 32,
                                height: 32,
                                child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.accent,
                                  ),
                                ),
                              )
                            : BreezIconButton(
                                icon: Icons.power_settings_new,
                                iconColor: isPowered ? AppColors.accentRed : AppColors.accentGreen,
                                onTap: onPowerToggle,
                              ),
                      ],
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPowered
                            ? AppColors.accentGreen.withValues(alpha: 0.15)
                            : AppColors.accentRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        border: Border.all(
                          color: isPowered
                              ? AppColors.accentGreen.withValues(alpha: 0.3)
                              : AppColors.accentRed.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isPowered ? AppColors.accentGreen : AppColors.accentRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status ?? l10n.statusRunning,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isPowered ? AppColors.accentGreen : AppColors.accentRed,
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Temperature display with +/- controls - Two columns: Heating & Cooling
              Expanded(
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
              ),

              // Stats/Sensors section (only if showStats or sensorUnit provided)
              if (showStats || sensorUnit != null)
                Container(
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
                ),

              // Fan sliders
              if (isPowered) ...[
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

            ],
        ),
    );

    return cardWidget;
  }

  Widget _buildShimmer(BuildContext context, BreezColors colors, bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
      highlightColor: isDark ? AppColors.darkShimmerHighlight : AppColors.lightShimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 11,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.indicator),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 120,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.indicator),
                    ),
                  ),
                ],
              ),
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Temperature shimmer
          Center(
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 120,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 140,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.indicator),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Stats shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              3,
              (index) => Column(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.indicator),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.indicator),
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

  String _formatDate(BuildContext context, AppLocalizations l10n) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat('d MMM', locale);
    return l10n.todayDate(dateFormat.format(now));
  }
}
