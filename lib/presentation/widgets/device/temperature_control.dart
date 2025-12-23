/// Temperature Control Widget
///
/// Responsive temperature control for air conditioners
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TemperatureControl extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  const TemperatureControl({
    super.key,
    required this.value,
    this.min = 15,
    this.max = 29,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            min.toInt().toString(),
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    '${value.toInt()}°',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: theme.colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShadSlider(
                    initialValue: value,
                    min: min,
                    max: max,
                    onChangeEnd: onChanged,
                  ),
                ],
              ),
            ),
          ),
          Text(
            max.toInt().toString(),
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
