/// Fan Speed Control
///
/// Widget for controlling fan speed
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';

class FanSpeedControl extends StatelessWidget {
  final String selectedSpeed;
  final ValueChanged<String> onSpeedChanged;
  final bool enabled;

  const FanSpeedControl({
    super.key,
    required this.selectedSpeed,
    required this.onSpeedChanged,
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
              'Fan Speed',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: FanSpeed.values.map((speed) {
                final isSelected =
                    selectedSpeed.toLowerCase() == speed.name.toLowerCase();

                return _SpeedButton(
                  label: speed.displayName,
                  isSelected: isSelected,
                  enabled: enabled,
                  onTap: () {
                    if (enabled) {
                      onSpeedChanged(speed.name);
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

class _SpeedButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _SpeedButton({
    required this.label,
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
              ? AppTheme.secondaryColor.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected && enabled
                ? AppTheme.secondaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.air,
              color: isSelected && enabled
                  ? AppTheme.secondaryColor
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
                    ? AppTheme.secondaryColor
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
