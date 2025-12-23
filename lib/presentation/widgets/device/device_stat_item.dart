/// Device Stat Item Widget
///
/// Responsive stat display for device cards
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DeviceStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DeviceStatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.mutedForeground,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.foreground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
      ],
    );
  }
}
