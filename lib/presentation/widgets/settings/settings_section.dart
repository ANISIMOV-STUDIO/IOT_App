/// Reusable Settings Section Components
///
/// Common widgets for settings sections
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Reusable Settings Section Container
class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return HvacGradientBorder(
      borderWidth: 2,
      gradientColors: [
        HvacColors.primaryOrange.withValues(alpha: 0.3),
        HvacColors.primaryBlue.withValues(alpha: 0.3),
      ],
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: HvacColors.primaryOrange, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: HvacTypography.headlineSmall.copyWith(
                    fontSize: 18,
                    color: HvacColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Reusable Switch Tile with Accessibility
class SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title: $subtitle',
      toggled: value,
      hint: 'Tap to toggle',
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: HvacTypography.titleMedium.copyWith(
                        fontSize: 14,
                        color: HvacColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: HvacTypography.labelLarge.copyWith(
                        fontSize: 12,
                        color: HvacColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Ensure minimum tap target of 48x48
              SizedBox(
                width: 48,
                height: 48,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return HvacColors.primaryOrange;
                    }
                    return null;
                  }),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (!states.contains(WidgetState.selected)) {
                      return HvacColors.textSecondary.withValues(alpha: 0.3);
                    }
                    return null;
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable Info Row for About Section
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: HvacTypography.bodyMedium.copyWith(
            fontSize: 14,
            color: HvacColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: HvacTypography.titleMedium.copyWith(
            fontSize: 14,
            color: HvacColors.textPrimary,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: content,
        ),
      );
    }

    return content;
  }
}
