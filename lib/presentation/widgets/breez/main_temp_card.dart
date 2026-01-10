/// Main Temperature Card - Primary display widget
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'fan_slider.dart';
import 'main_temp_card_header.dart';
import 'main_temp_card_shimmer.dart';
import 'sensors_grid.dart';
import 'stat_item.dart';
import 'temp_column.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для MainTempCard
abstract class _MainTempCardConstants {
  static const double borderWidthOn = 1.5;
  static const double borderWidthOff = 1.0;
  static const double borderOpacity = 0.5;
  static const double shadowBlurPrimary = 24.0;
  static const double shadowBlurGlow = 40.0;
  static const double shadowSpread = 4.0;
  static const double shadowOffsetY = 8.0;
  static const double shadowOpacityPrimary = 0.2;
  static const double shadowOpacityGlow = 0.1;
  static const double dividerHeight = 80.0;
  static const double dividerWidth = 1.0;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Main temperature display card with gradient background
///
/// Поддерживает:
/// - Градиентный фон когда устройство включено
/// - Glow эффект
/// - Shimmer loading state
/// - Accessibility через Semantics
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
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onScheduleToggle;
  final UnitState? sensorUnit;
  final bool showStats;
  final bool isOnline;

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
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onScheduleToggle,
    this.sensorUnit,
    this.showStats = true,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Устройство активно только если включено И онлайн
    final isActive = isPowered && isOnline;

    final poweredGradient = isDark
        ? AppColors.darkCardGradientColors
        : AppColors.lightCardGradientColors;
    final offGradient = [colors.card, colors.card];

    return Semantics(
      label: '$unitName: ${isActive ? status ?? 'включено' : isOnline ? 'выключено' : 'не в сети'}',
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive ? poweredGradient : offGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isActive
                ? AppColors.accent.withValues(alpha: _MainTempCardConstants.borderOpacity)
                : colors.border,
            width: isActive
                ? _MainTempCardConstants.borderWidthOn
                : _MainTempCardConstants.borderWidthOff,
          ),
          boxShadow: isActive
              ? [
                  // Основная тень
                  BoxShadow(
                    color: AppColors.accent.withValues(
                      alpha: _MainTempCardConstants.shadowOpacityPrimary,
                    ),
                    blurRadius: _MainTempCardConstants.shadowBlurPrimary,
                    offset: Offset(0, _MainTempCardConstants.shadowOffsetY),
                  ),
                  // Glow эффект
                  BoxShadow(
                    color: AppColors.accent.withValues(
                      alpha: _MainTempCardConstants.shadowOpacityGlow,
                    ),
                    blurRadius: _MainTempCardConstants.shadowBlurGlow,
                    spreadRadius: _MainTempCardConstants.shadowSpread,
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.all(AppSpacing.xs),
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
                  isScheduleEnabled: isScheduleEnabled,
                  isScheduleLoading: isScheduleLoading,
                  onPowerToggle: isOnline ? onPowerToggle : null,
                  onScheduleToggle: isOnline ? onScheduleToggle : null,
                  onSettingsTap: isOnline ? onSettingsTap : null,
                  onAlarmsTap: onAlarmsTap,
                  isOnline: isOnline,
                ),

                // Temperature display - Two columns: Heating & Cooling
                // Expanded чтобы занять центр карточки
                Expanded(
                  child: Stack(
                    children: [
                      // Температурные колонки (с opacity если offline)
                      Opacity(
                        opacity: isOnline ? 1.0 : 0.4,
                        child: Center(
                          child: _TemperatureSection(
                            heatingTemp: heatingTemp,
                            coolingTemp: coolingTemp,
                            isPowered: isActive,
                            colors: colors,
                            l10n: l10n,
                            onHeatingTempIncrease: isActive ? onHeatingTempIncrease : null,
                            onHeatingTempDecrease: isActive ? onHeatingTempDecrease : null,
                            onCoolingTempIncrease: isActive ? onCoolingTempIncrease : null,
                            onCoolingTempDecrease: isActive ? onCoolingTempDecrease : null,
                          ),
                        ),
                      ),
                      // Надпись "Устройство не в сети" поверх
                      if (!isOnline)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: colors.card.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(AppRadius.nested),
                              border: Border.all(color: colors.border),
                            ),
                            child: Text(
                              'Устройство не в сети',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.textMuted,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
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

                // Fan sliders - всегда видимы, но отключены когда устройство выключено или offline
                Opacity(
                  opacity: isOnline ? 1.0 : 0.4,
                  child: _FanSlidersSection(
                    supplyFan: supplyFan,
                    exhaustFan: exhaustFan,
                    onSupplyFanChanged: isActive ? onSupplyFanChanged : null,
                    onExhaustFanChanged: isActive ? onExhaustFanChanged : null,
                    colors: colors,
                    l10n: l10n,
                  ),
                ),
              ],
            ),
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
    return Row(
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
          width: _MainTempCardConstants.dividerWidth,
          height: _MainTempCardConstants.dividerHeight,
          color: colors.border,
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
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
      padding: EdgeInsets.only(top: AppSpacing.xs),
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
        SizedBox(height: AppSpacing.xs),
        Container(
          padding: EdgeInsets.only(top: AppSpacing.xs),
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
              SizedBox(width: AppSpacing.xs),
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
