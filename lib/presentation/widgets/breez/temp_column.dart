/// Temperature Column Widget - displays temperature with +/- controls
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';

/// Temperature column - displays label, icon, temperature value and +/- buttons
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

    final fontSize = compact ? 22.0 : 28.0;
    final iconSize = compact ? 12.0 : 14.0;
    final labelSize = compact ? 9.0 : 10.0;
    final buttonPadding = compact ? 4.0 : 6.0;
    final buttonIconSize = compact ? 16.0 : 18.0;
    final spacing = compact ? 6.0 : 8.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label with icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: isPowered ? color : colors.textMuted),
            const SizedBox(width: 4),
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
              BreezButton(
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing),
                child: Text(
                  '$temperature°',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: isPowered ? colors.text : colors.textMuted,
                  ),
                ),
              ),
              BreezButton(
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
            ],
          ),
        ),
      ],
    );
  }
}
