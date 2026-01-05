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

  const TemperatureColumn({
    super.key,
    required this.label,
    required this.temperature,
    required this.icon,
    required this.color,
    required this.isPowered,
    this.onIncrease,
    this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label with icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isPowered ? color : colors.textMuted),
            const SizedBox(width: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: isPowered ? color : colors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Temperature value with +/- buttons in one row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            BreezButton(
              onTap: isPowered ? onDecrease : null,
              enforceMinTouchTarget: false,
              showBorder: false,
              backgroundColor: colors.buttonBg.withValues(alpha: 0.5),
              hoverColor: color.withValues(alpha: 0.15),
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.remove,
                size: 18,
                color: isPowered ? color : colors.textMuted,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '$temperature°',
                style: TextStyle(
                  fontSize: 28,
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
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.add,
                size: 18,
                color: isPowered ? color : colors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
