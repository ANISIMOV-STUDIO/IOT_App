/// Brightness Control Widget
///
/// Responsive brightness control for lamps
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BrightnessControl extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const BrightnessControl({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.muted.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ShadSlider(
              initialValue: value,
              min: 0,
              max: 1,
              onChangeEnd: onChanged,
            ),
          ),
        ),
        Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.foreground,
          ),
        ),
      ],
    );
  }
}
