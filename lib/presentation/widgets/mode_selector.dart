/// Mode Selector
///
/// Widget for selecting HVAC operating mode
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';

class ModeSelector extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onModeChanged;
  final bool enabled;

  const ModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operating Mode',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: HvacMode.values.map((mode) {
                final isSelected =
                    selectedMode.toLowerCase() == mode.name.toLowerCase();
                final modeColor = AppTheme.getModeColor(mode.name);
                final modeIcon = AppTheme.getModeIcon(mode.name);

                return _ModeButton(
                  label: mode.displayName,
                  icon: modeIcon,
                  color: modeColor,
                  isSelected: isSelected,
                  enabled: enabled,
                  onTap: () {
                    if (enabled) {
                      onModeChanged(mode.name);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected && enabled
              ? color.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected && enabled ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected && enabled
                  ? color
                  : enabled
                      ? AppTheme.textSecondary
                      : AppTheme.textHint,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected && enabled
                    ? color
                    : enabled
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
