/// Temperature Column Widget - displays temperature with +/- controls
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_loader.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для TemperatureColumn
abstract class _TempColumnConstants {
  // Размеры - обычный режим
  static const double fontSizeNormal = 28;
  static const double iconSizeNormal = 14;
  static const double labelSizeNormal = 10;
  static const double buttonPaddingNormal = 6;
  static const double buttonIconSizeNormal = 18;

  // Размеры - компактный режим
  static const double fontSizeCompact = 22;
  static const double iconSizeCompact = 12;
  static const double labelSizeCompact = 9;
  static const double buttonPaddingCompact = 4;
  static const double buttonIconSizeCompact = 16;

  // Отступы
  static const double iconTextGap = 4;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Temperature column - displays label, icon, temperature value and +/- buttons
///
/// Поддерживает:
/// - Компактный режим для mobile
/// - +/- кнопки для управления температурой
/// - Disabled state когда устройство выключено
/// - Accessibility через Semantics
class TemperatureColumn extends StatelessWidget {

  const TemperatureColumn({
    required this.label,
    required this.temperature,
    required this.icon,
    required this.color,
    required this.isPowered,
    super.key,
    this.onIncrease,
    this.onDecrease,
    this.compact = false,
    this.isPending = false,
    this.minTemp,
    this.maxTemp,
  });
  final String label;
  final int? temperature;
  final IconData icon;
  final Color color;
  final bool isPowered;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final bool compact;

  /// Ожидание подтверждения от устройства - показывает пульсацию
  final bool isPending;

  /// Минимальная температура (кнопка - отключается при достижении)
  final int? minTemp;

  /// Максимальная температура (кнопка + отключается при достижении)
  final int? maxTemp;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    // Выбор размеров на основе режима
    final fontSize = compact
        ? _TempColumnConstants.fontSizeCompact
        : _TempColumnConstants.fontSizeNormal;
    final iconSize = compact
        ? _TempColumnConstants.iconSizeCompact
        : _TempColumnConstants.iconSizeNormal;
    final labelSize = compact
        ? _TempColumnConstants.labelSizeCompact
        : _TempColumnConstants.labelSizeNormal;
    final buttonPadding = compact
        ? _TempColumnConstants.buttonPaddingCompact
        : _TempColumnConstants.buttonPaddingNormal;
    final buttonIconSize = compact
        ? _TempColumnConstants.buttonIconSizeCompact
        : _TempColumnConstants.buttonIconSizeNormal;
    final spacing = compact ? AppSpacing.xxs + 2 : AppSpacing.xs;

    // Проверка достижения границ температуры
    // Блокируем кнопки если ожидаем ответа от сервера или температура неизвестна
    final hasTemperature = temperature != null;
    final canDecrease = hasTemperature && !isPending && (minTemp == null || temperature! > minTemp!);
    final canIncrease = hasTemperature && !isPending && (maxTemp == null || temperature! < maxTemp!);

    final temperatureLabel = temperature != null
        ? '$label: $temperature градусов'
        : '$label: нет данных';

    return Semantics(
      label: temperatureLabel,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: isPowered ? color : colors.textMuted),
              const SizedBox(width: _TempColumnConstants.iconTextGap),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: labelSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: isPowered ? color : colors.textMuted,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          // Temperature value with +/- buttons in one row
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  button: true,
                  label: 'Уменьшить $label',
                  child: BreezButton(
                    onTap: isPowered && canDecrease ? onDecrease : null,
                    enforceMinTouchTarget: false,
                    showBorder: false,
                    backgroundColor: colors.buttonBg.withValues(alpha: 0.5),
                    hoverColor: color.withValues(alpha: 0.15),
                    padding: EdgeInsets.all(buttonPadding),
                    child: Icon(
                      Icons.remove,
                      size: buttonIconSize,
                      color: isPowered && canDecrease ? color : colors.textMuted,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing),
                  child: isPending
                      ? BreezLoader.small(color: color)
                      : Text(
                          temperature != null ? '$temperature°C' : '—',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w700,
                            color: isPowered && temperature != null
                                ? colors.text
                                : colors.textMuted,
                          ),
                        ),
                ),
                Semantics(
                  button: true,
                  label: 'Увеличить $label',
                  child: BreezButton(
                    onTap: isPowered && canIncrease ? onIncrease : null,
                    enforceMinTouchTarget: false,
                    showBorder: false,
                    backgroundColor: colors.buttonBg.withValues(alpha: 0.5),
                    hoverColor: color.withValues(alpha: 0.15),
                    padding: EdgeInsets.all(buttonPadding),
                    child: Icon(
                      Icons.add,
                      size: buttonIconSize,
                      color: isPowered && canIncrease ? color : colors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
