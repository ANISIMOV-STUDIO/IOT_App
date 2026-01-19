/// Main Temperature Card - Primary display widget
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/services/quick_sensors_service.dart';
import 'package:hvac_control/core/theme/app_radius.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart' show TemperatureLimits;
import 'package:hvac_control/presentation/widgets/breez/breez_loader.dart';
import 'package:hvac_control/presentation/widgets/breez/fan_slider.dart';
import 'package:hvac_control/presentation/widgets/breez/main_temp_card_header.dart';
import 'package:hvac_control/presentation/widgets/breez/main_temp_card_shimmer.dart';
import 'package:hvac_control/presentation/widgets/breez/stat_item.dart';
import 'package:hvac_control/presentation/widgets/breez/temp_column.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для MainTempCard
abstract class _MainTempCardConstants {
  static const double borderWidthOn = 1.5;
  static const double borderWidthOff = 1;
  static const double borderOpacity = 0.5;
  static const double shadowBlurPrimary = 24;
  static const double shadowBlurGlow = 40;
  static const double shadowSpread = 4;
  static const double shadowOffsetY = 8;
  static const double shadowOpacityPrimary = 0.2;
  static const double shadowOpacityGlow = 0.1;
  static const double dividerHeight = 80;
  static const double dividerWidth = 1;
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

  const MainTempCard({
    required this.unitName, required this.temperature, super.key,
    this.heatingTemp,
    this.coolingTemp,
    this.status,
    this.humidity = 45,
    this.outsideTemp = 0.0,
    this.indoorTemp = 22.0,
    this.airflow = 420,
    this.filterPercent = 88,
    this.isPowered = true,
    this.isLoading = false,
    this.supplyFan,
    this.exhaustFan,
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
    this.selectedSensors = QuickSensorsService.defaultSensors,
    this.isPendingHeatingTemperature = false,
    this.isPendingCoolingTemperature = false,
    this.isPendingSupplyFan = false,
    this.isPendingExhaustFan = false,
    this.deviceTime,
  });
  final String unitName;
  final String? status;
  final int temperature;
  final int? heatingTemp;
  final int? coolingTemp;
  final int humidity;
  final double outsideTemp;
  final double indoorTemp;
  final int airflow;
  final int filterPercent;
  final bool isPowered;
  final bool isLoading;
  final int? supplyFan;
  final int? exhaustFan;
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
  /// Выбранные показатели для отображения
  final List<QuickSensorType> selectedSensors;
  /// Ожидание подтверждения изменения температуры нагрева
  final bool isPendingHeatingTemperature;

  /// Ожидание подтверждения изменения температуры охлаждения
  final bool isPendingCoolingTemperature;

  /// Ожидание подтверждения изменения приточного вентилятора
  final bool isPendingSupplyFan;

  /// Ожидание подтверждения изменения вытяжного вентилятора
  final bool isPendingExhaustFan;

  /// Время устройства (если null, используется системное время)
  final DateTime? deviceTime;

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
                    offset: const Offset(0, _MainTempCardConstants.shadowOffsetY),
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
        padding: const EdgeInsets.all(AppSpacing.xs),
      child: isLoading
          ? const MainTempCardShimmer()
          : Stack(
              children: [
                // Основной контент
                Column(
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
                  deviceTime: deviceTime,
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
                            isPendingHeatingTemperature: isPendingHeatingTemperature,
                            isPendingCoolingTemperature: isPendingCoolingTemperature,
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
                                fontSize: AppFontSizes.body,
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
                    outsideTemp: outsideTemp,
                    indoorTemp: indoorTemp,
                    humidity: humidity,
                    airflow: airflow,
                    filterPercent: filterPercent,
                    selectedSensors: selectedSensors,
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
                    isPendingSupplyFan: isPendingSupplyFan,
                    isPendingExhaustFan: isPendingExhaustFan,
                  ),
                ),
                  ],
                ),
                // Overlay блокировки при переключении питания
                if (isPowerLoading)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.card.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(AppRadius.nested),
                      ),
                      child: const Center(
                        child: BreezLoader.large(),
                      ),
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
    this.isPendingHeatingTemperature = false,
    this.isPendingCoolingTemperature = false,
  });
  final int? heatingTemp;
  final int? coolingTemp;
  final bool isPowered;
  final BreezColors colors;
  final AppLocalizations l10n;
  final VoidCallback? onHeatingTempIncrease;
  final VoidCallback? onHeatingTempDecrease;
  final VoidCallback? onCoolingTempIncrease;
  final VoidCallback? onCoolingTempDecrease;
  final bool isPendingHeatingTemperature;
  final bool isPendingCoolingTemperature;

  @override
  Widget build(BuildContext context) => Row(
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
            isPending: isPendingHeatingTemperature,
            minTemp: TemperatureLimits.min,
            maxTemp: TemperatureLimits.max,
          ),
        ),
        // Divider
        Container(
          width: _MainTempCardConstants.dividerWidth,
          height: _MainTempCardConstants.dividerHeight,
          color: colors.border,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
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
            isPending: isPendingCoolingTemperature,
            minTemp: TemperatureLimits.min,
            maxTemp: TemperatureLimits.max,
          ),
        ),
      ],
    );
}

/// Stats section - Динамически отображает выбранные показатели
class _StatsSection extends StatelessWidget {

  const _StatsSection({
    required this.outsideTemp, required this.indoorTemp, required this.humidity, required this.airflow, required this.filterPercent, required this.selectedSensors, required this.colors, required this.l10n, this.sensorUnit,
  });
  final UnitState? sensorUnit;
  final double outsideTemp;
  final double indoorTemp;
  final int humidity;
  final int airflow;
  final int filterPercent;
  final List<QuickSensorType> selectedSensors;
  final BreezColors colors;
  final AppLocalizations l10n;

  /// Получить значение для типа сенсора
  String _getSensorValue(QuickSensorType type) {
    final unit = sensorUnit;
    return switch (type) {
      QuickSensorType.outsideTemp =>
        '${(unit?.outsideTemp ?? outsideTemp).toStringAsFixed(1)}°',
      QuickSensorType.indoorTemp =>
        '${(unit?.indoorTemp ?? indoorTemp).toStringAsFixed(1)}°',
      QuickSensorType.humidity =>
        '${unit?.humidity ?? humidity}%',
      QuickSensorType.co2Level =>
        '${unit?.co2Level ?? 0}',
      QuickSensorType.supplyTemp =>
        '${(unit?.supplyTemp ?? 0).toStringAsFixed(1)}°',
      QuickSensorType.recuperatorEfficiency =>
        '${unit?.recuperatorEfficiency ?? 0}%',
      QuickSensorType.heaterPerformance =>
        '${unit?.heaterPerformance ?? 0}%',
      QuickSensorType.ductPressure =>
        '${unit?.ductPressure ?? 0} Па',
      QuickSensorType.filterPercent =>
        '${unit?.filterPercent ?? filterPercent}%',
      QuickSensorType.airflowRate =>
        '${unit?.airflowRate ?? airflow}',
    };
  }

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: selectedSensors.map((sensor) => StatItem(
            icon: sensor.icon,
            value: _getSensorValue(sensor),
            label: sensor.getLabel(l10n),
            iconColor: sensor.color,
          )).toList(),
      ),
    );
}

/// Fan sliders section
class _FanSlidersSection extends StatelessWidget {

  const _FanSlidersSection({
    required this.supplyFan,
    required this.exhaustFan,
    required this.colors, required this.l10n, this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.isPendingSupplyFan = false,
    this.isPendingExhaustFan = false,
  });
  final int? supplyFan;
  final int? exhaustFan;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final BreezColors colors;
  final AppLocalizations l10n;
  final bool isPendingSupplyFan;
  final bool isPendingExhaustFan;

  @override
  Widget build(BuildContext context) => Column(
      children: [
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
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
                  isPending: isPendingSupplyFan,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: FanSlider(
                  label: l10n.exhaust,
                  value: exhaustFan,
                  color: AppColors.accentOrange,
                  icon: Icons.arrow_upward_rounded,
                  onChanged: onExhaustFanChanged,
                  isPending: isPendingExhaustFan,
                ),
              ),
            ],
          ),
        ),
      ],
    );
}
