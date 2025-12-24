/// Mode Selector with consistent styling
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';

/// Mode button data
class ModeData {
  final String id;
  final String label;
  final IconData icon;

  const ModeData({
    required this.id,
    required this.label,
    required this.icon,
  });
}

/// Available modes
const List<ModeData> defaultModes = [
  ModeData(id: 'auto', label: 'АВТО', icon: Icons.bolt),
  ModeData(id: 'eco', label: 'ЭКО', icon: Icons.wb_sunny_outlined),
  ModeData(id: 'night', label: 'НОЧЬ', icon: Icons.nightlight_outlined),
  ModeData(id: 'boost', label: 'ТУРБО', icon: Icons.air),
];

/// Single mode button
class ModeButton extends StatelessWidget {
  final ModeData mode;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool compact;

  const ModeButton({
    super.key,
    required this.mode,
    this.isSelected = false,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return BreezButton(
      onTap: onTap,
      // Minimum 48px touch target height
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 16,
        vertical: compact ? 14 : 12, // 14*2 + icon = 48px min
      ),
      backgroundColor: isSelected
          ? AppColors.accent
          : Colors.white.withValues(alpha: 0.05),
      hoverColor: isSelected
          ? AppColors.accentLight
          : Colors.white.withValues(alpha: 0.1),
      border: Border.all(
        color: isSelected ? AppColors.accent : Colors.transparent,
      ),
      shadows: isSelected
          ? [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 12,
              ),
            ]
          : null,
      child: compact
          ? Center(
              child: Icon(
                mode.icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.darkTextMuted,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  mode.icon,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.darkTextMuted,
                ),
                const SizedBox(width: 8),
                Text(
                  mode.label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: isSelected ? Colors.white : AppColors.darkTextMuted,
                  ),
                ),
              ],
            ),
    );
  }
}

/// Mode selector card
class ModeSelector extends StatelessWidget {
  final String unitName;
  final String selectedMode;
  final ValueChanged<String>? onModeChanged;
  final List<ModeData> modes;
  final bool compact;

  const ModeSelector({
    super.key,
    required this.unitName,
    required this.selectedMode,
    this.onModeChanged,
    this.modes = defaultModes,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return BreezCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreezLabel('Режим $unitName'),
          const SizedBox(height: 16),
          compact
              ? Row(
                  children: modes.map((mode) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ModeButton(
                          mode: mode,
                          isSelected: selectedMode == mode.id,
                          onTap: () => onModeChanged?.call(mode.id),
                          compact: true,
                        ),
                      ),
                    );
                  }).toList(),
                )
              : GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.8,
                  physics: const NeverScrollableScrollPhysics(),
                  children: modes.map((mode) {
                    return ModeButton(
                      mode: mode,
                      isSelected: selectedMode == mode.id,
                      onTap: () => onModeChanged?.call(mode.id),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
