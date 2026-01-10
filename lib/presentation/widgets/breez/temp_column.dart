/// Temperature Column Widget - displays temperature with +/- controls
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import 'breez_card.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для TemperatureColumn
abstract class _TempColumnConstants {
  // Размеры - обычный режим
  static const double fontSizeNormal = 28.0;
  static const double iconSizeNormal = 14.0;
  static const double labelSizeNormal = 10.0;
  static const double buttonPaddingNormal = 6.0;
  static const double buttonIconSizeNormal = 18.0;

  // Размеры - компактный режим
  static const double fontSizeCompact = 22.0;
  static const double iconSizeCompact = 12.0;
  static const double labelSizeCompact = 9.0;
  static const double buttonPaddingCompact = 4.0;
  static const double buttonIconSizeCompact = 16.0;

  // Отступы
  static const double iconTextGap = 4.0;
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
  final String label;
  final int temperature;
  final IconData icon;
  final Color color;
  final bool isPowered;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final bool compact;

  const TemperatureColumn({
    super.key,
    required this.label,
    required this.temperature,
    required this.icon,
    required this.color,
    required this.isPowered,
    this.onIncrease,
    this.onDecrease,
    this.compact = false,
  });

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

    return Semantics(
      label: '$label: $temperature градусов',
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
              SizedBox(width: _TempColumnConstants.iconTextGap),
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
                    onTap: isPowered ? onDecrease : null,
                    enforceMinTouchTarget: false,
                    showBorder: false,
                    backgroundColor: colors.buttonBg.withValues(alpha: 0.5),
                    hoverColor: color.withValues(alpha: 0.15),
                    padding: EdgeInsets.all(buttonPadding),
                    child: Icon(
                      Icons.remove,
                      size: buttonIconSize,
                      color: isPowered ? color : colors.textMuted,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing),
                  child: Text(
                    '$temperature°C',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      color: isPowered ? colors.text : colors.textMuted,
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Увеличить $label',
                  child: BreezButton(
                    onTap: isPowered ? onIncrease : null,
                    enforceMinTouchTarget: false,
                    showBorder: false,
                    backgroundColor: colors.buttonBg.withValues(alpha: 0.5),
                    hoverColor: color.withValues(alpha: 0.15),
                    padding: EdgeInsets.all(buttonPadding),
                    child: Icon(
                      Icons.add,
                      size: buttonIconSize,
                      color: isPowered ? color : colors.textMuted,
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
