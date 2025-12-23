/// Section header widget for zone separation
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Visual section header for separating Device Zone and Global Zone
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? subtitle;
  final Widget? trailing;
  final Color? accentColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
    this.trailing,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Accent line
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Icon
          if (icon != null) ...[
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
          ],
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.foreground,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
              ],
            ),
          ),
          // Trailing widget
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
