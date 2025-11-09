/// Circular Temperature Indicator Widget
///
/// Large circular display for supply air temperature (ventilation units)
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class CircularTemperatureIndicator extends StatelessWidget {
  final double? temperature;
  final String label;
  final Color? borderColor;
  final double size;

  const CircularTemperatureIndicator({
    super.key,
    required this.temperature,
    required this.label,
    this.borderColor,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? HvacColors.primaryOrange,
          width: 4,
        ),
        gradient: const RadialGradient(
          colors: [
            HvacColors.backgroundCard,
            HvacColors.backgroundSecondary,
          ],
          stops: [0.7, 1.0],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              temperature != null ? temperature!.toStringAsFixed(1) : '--',
              style: HvacTypography.displayLarge.copyWith(
                fontSize: size * 0.24, // 48 for size=200
                color: HvacColors.textPrimary,
                letterSpacing: -1,
              ),
            ),
            Text(
              '°C',
              style: HvacTypography.titleLarge.copyWith(
                fontSize: size * 0.12, // 24 for size=200
                color: HvacColors.textSecondary,
              ),
            ),
            SizedBox(height: size * 0.04),
            Text(
              label,
              style: HvacTypography.caption.copyWith(
                fontSize: size * 0.06, // 12 for size=200
                color: HvacColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
