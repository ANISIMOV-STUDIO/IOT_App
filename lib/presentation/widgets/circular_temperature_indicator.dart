/// Circular Temperature Indicator Widget
///
/// Large circular display for supply air temperature (ventilation units)
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
          color: borderColor ?? AppTheme.primaryOrange,
          width: 4,
        ),
        gradient: RadialGradient(
          colors: [
            AppTheme.backgroundCard,
            AppTheme.backgroundDark,
          ],
          stops: const [0.7, 1.0],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              temperature != null
                  ? temperature!.toStringAsFixed(1)
                  : '--',
              style: TextStyle(
                fontSize: size * 0.24, // 48 for size=200
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -1,
              ),
            ),
            Text(
              '°C',
              style: TextStyle(
                fontSize: size * 0.12, // 24 for size=200
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: size * 0.04),
            Text(
              label,
              style: TextStyle(
                fontSize: size * 0.06, // 12 for size=200
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
