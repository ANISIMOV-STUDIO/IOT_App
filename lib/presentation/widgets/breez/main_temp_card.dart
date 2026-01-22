/// Main Temperature Card - Primary display widget
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/services/quick_sensors_service.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_loader.dart';
import 'package:hvac_control/presentation/widgets/breez/main_temp_card_header.dart';
import 'package:hvac_control/presentation/widgets/breez/main_temp_card_shimmer.dart';
import 'package:hvac_control/presentation/widgets/breez/mode_grid.dart';
import 'package:hvac_control/presentation/widgets/breez/stat_item.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для MainTempCard
abstract class _MainTempCardConstants {
  // Shadow
  static const double shadowBlurPrimary = 24;
  static const double shadowBlurGlow = 40;
  static const double shadowSpread = 4;
  static const double shadowOffsetY = 8;
  static const double shadowOpacityPrimary = 0.2;
  static const double shadowOpacityGlow = 0.1;

  // Typography
  static const double modeLabelLetterSpacing = 0.5;

  // Offline state
  static const double offlineOverlayOpacity = 0.95;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Main temperature display card with mode-colored background
///
/// Поддерживает:
/// - Цветной overlay на основе текущего режима (как ModeGridItem)
/// - Glow эффект с цветом режима
/// - Shimmer loading state
/// - Offline состояние с затемнением
/// - Accessibility через Semantics
class MainTempCard extends StatelessWidget {

  const MainTempCard({
    required this.unitName, required this.temperature, super.key,
    this.temperatureSetpoint,
    this.currentMode,
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
    this.onSettingsTap,
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
    this.updatedAt,
  });
  final String unitName;
  final String? status;
  final int temperature;

  /// Уставка температуры с пульта (readonly)
  final double? temperatureSetpoint;

  /// Текущий режим работы (basic, intensive, etc.)
  final String? currentMode;
  final int humidity;
  final double outsideTemp;
  final double indoorTemp;
  final int airflow;
  final int filterPercent;
  final bool isPowered;
  final bool isLoading;

  /// Актуальные обороты приточного вентилятора (0-100%) - readonly
  final int? supplyFan;

  /// Актуальные обороты вытяжного вентилятора (0-100%) - readonly
  final int? exhaustFan;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
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

  /// Время последней синхронизации с сервером
  final DateTime? updatedAt;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Устройство активно только если включено И онлайн
    final isActive = isPowered && isOnline;

    // Найти данные текущего режима для цвета
    final modes = getOperatingModes(l10n);
    final modeData = currentMode != null && currentMode!.isNotEmpty
        ? modes.where((m) => m.id.toLowerCase() == currentMode!.toLowerCase()).firstOrNull
        : null;
    final modeColor = modeData?.color ?? AppColors.accent;

    // Overlay цвет режима поверх базового фона (как в ModeGridItem)
    final modeOverlay = modeColor.withValues(alpha: AppColors.opacitySubtle);

    return Semantics(
      label: '$unitName: ${isActive ? status ?? 'включено' : isOnline ? 'выключено' : 'не в сети'}',
      child: Container(
        // Clip чтобы overlay не выходил за границы borderRadius
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          // Базовый фон карточки (как BreezCard)
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          // Border как в ModeGridItem
          border: Border.all(
            color: isActive
                ? modeColor.withValues(alpha: AppColors.opacityStrong)
                : colors.border,
          ),
          boxShadow: isActive
              ? [
                  // Основная тень
                  BoxShadow(
                    color: modeColor.withValues(
                      alpha: _MainTempCardConstants.shadowOpacityPrimary,
                    ),
                    blurRadius: _MainTempCardConstants.shadowBlurPrimary,
                    offset: const Offset(0, _MainTempCardConstants.shadowOffsetY),
                  ),
                  // Glow эффект
                  BoxShadow(
                    color: modeColor.withValues(
                      alpha: _MainTempCardConstants.shadowOpacityGlow,
                    ),
                    blurRadius: _MainTempCardConstants.shadowBlurGlow,
                    spreadRadius: _MainTempCardConstants.shadowSpread,
                  ),
                ]
              : null,
        ),
        // Padding убран отсюда - добавлен к содержимому, чтобы overlay покрывал всю карточку
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(AppSpacing.xs),
              child: MainTempCardShimmer(),
            )
          : Stack(
              children: [
                // Overlay цвета режима (как в ModeGridItem)
                // borderRadius не нужен - Container с clipBehavior обрежет
                if (isActive)
                  Positioned.fill(
                    child: ColoredBox(color: modeOverlay),
                  ),
                // Основной контент с padding
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    MainTempCardHeader(
                  unitName: unitName,
                  status: status,
                  isPowered: isPowered,
                  showControls: showControls,
                  alarmCount: alarmCount,
                  isScheduleEnabled: isScheduleEnabled,
                  isScheduleLoading: isScheduleLoading,
                  onPowerToggle: isOnline ? onPowerToggle : null,
                  onScheduleToggle: isOnline ? onScheduleToggle : null,
                  onSettingsTap: isOnline ? onSettingsTap : null,
                  onAlarmsTap: onAlarmsTap,
                  isOnline: isOnline,
                  updatedAt: updatedAt,
                ),

                // Temperature display - Single setpoint (readonly)
                // Expanded чтобы занять центр карточки
                Expanded(
                  child: Stack(
                    children: [
                      // Уставка температуры (с opacity если offline)
                      Opacity(
                        opacity: isOnline ? 1.0 : AppColors.opacityStrong,
                        child: Center(
                          child: _TemperatureSetpointSection(
                            temperatureSetpoint: temperatureSetpoint,
                            modeColor: modeColor,
                            modeIcon: modeData?.icon,
                            modeName: modeData?.name,
                            isPowered: isActive,
                            colors: colors,
                            l10n: l10n,
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
                              color: colors.card.withValues(alpha: _MainTempCardConstants.offlineOverlayOpacity),
                              borderRadius: BorderRadius.circular(AppRadius.nested),
                              border: Border.all(color: colors.border),
                            ),
                            child: Text(
                              l10n.deviceOffline,
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

                // Fan display - readonly показатели актуальных оборотов
                Opacity(
                  opacity: isOnline ? 1.0 : AppColors.opacityStrong,
                  child: _FanDisplaySection(
                    supplyFan: supplyFan,
                    exhaustFan: exhaustFan,
                    colors: colors,
                    l10n: l10n,
                  ),
                ),
                    ],
                  ),
                ),
                // Overlay блокировки при переключении питания
                if (isPowerLoading)
                  Positioned.fill(
                    child: ColoredBox(
                      color: colors.card.withValues(alpha: AppColors.opacityHigh),
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

/// Temperature setpoint display section - readonly
class _TemperatureSetpointSection extends StatelessWidget {

  const _TemperatureSetpointSection({
    required this.temperatureSetpoint,
    required this.modeColor,
    required this.isPowered,
    required this.colors,
    required this.l10n,
    this.modeIcon,
    this.modeName,
  });
  final double? temperatureSetpoint;
  final Color modeColor;
  final IconData? modeIcon;
  final String? modeName;
  final bool isPowered;
  final BreezColors colors;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final displayTemp = temperatureSetpoint != null
        ? '${temperatureSetpoint!.toStringAsFixed(0)}°C'
        : '—';

    // Fallback для иконки и названия
    final effectiveIcon = modeIcon ?? Icons.thermostat;
    final effectiveName = modeName ?? l10n.temperatureSetpoint;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label with mode icon and name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                effectiveIcon,
                size: AppIconSizes.standard,
                color: isPowered ? modeColor : colors.textMuted,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                effectiveName.toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSizes.captionSmall,
                  fontWeight: FontWeight.w600,
                  letterSpacing: _MainTempCardConstants.modeLabelLetterSpacing,
                  color: isPowered ? modeColor : colors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Temperature value (увеличенный размер)
          Text(
            displayTemp,
            style: TextStyle(
              fontSize: AppFontSizes.display,
              fontWeight: FontWeight.w700,
              color: isPowered && temperatureSetpoint != null
                  ? colors.text
                  : colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
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
      QuickSensorType.heaterPower =>
        '${unit?.heaterPower ?? 0}%',
      QuickSensorType.ductPressure =>
        '${unit?.ductPressure ?? 0} Па',
      QuickSensorType.filterPercent =>
        '${unit?.filterPercent ?? filterPercent}%',
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
        children: selectedSensors.map((sensor) => Expanded(
            child: StatItem(
              icon: sensor.icon,
              value: _getSensorValue(sensor),
              label: sensor.getLabel(l10n),
              iconColor: sensor.color,
            ),
          )).toList(),
      ),
    );
}

/// Fan display section - readonly показатели актуальных оборотов
class _FanDisplaySection extends StatelessWidget {

  const _FanDisplaySection({
    required this.supplyFan,
    required this.exhaustFan,
    required this.colors,
    required this.l10n,
  });
  final int? supplyFan;
  final int? exhaustFan;
  final BreezColors colors;
  final AppLocalizations l10n;

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
                child: _FanIndicator(
                  label: l10n.intake,
                  value: supplyFan,
                  color: AppColors.accent,
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _FanIndicator(
                  label: l10n.exhaust,
                  value: exhaustFan,
                  color: AppColors.accentOrange,
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
}

/// Readonly индикатор оборотов вентилятора
class _FanIndicator extends StatelessWidget {

  const _FanIndicator({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
  final String label;
  final int? value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final displayValue = value != null ? '$value%' : '—';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.buttonBg.withValues(alpha: AppColors.opacityLow),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppIconSizes.standard, color: color),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                color: colors.textMuted,
              ),
            ),
          ),
          Text(
            displayValue,
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: FontWeight.w600,
              color: value != null ? colors.text : colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
