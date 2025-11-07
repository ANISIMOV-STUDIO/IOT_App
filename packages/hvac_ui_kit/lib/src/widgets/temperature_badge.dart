/// Mini temperature badge for inline use
library;

import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Mini temperature badge for inline use
class TemperatureBadge extends StatelessWidget {
  final double? temperature;
  final String label;

  const TemperatureBadge({
    super.key,
    required this.temperature,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.thermostat_outlined,
            size: 14.0,
            color: HvacColors.neutral200,
          ),
          SizedBox(width: 6.0),
          Text(
            temperature != null ? '${temperature!.toStringAsFixed(1)}°C' : '—',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          if (label.isNotEmpty) ...[
            SizedBox(width: 4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.0,
                color: HvacColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
