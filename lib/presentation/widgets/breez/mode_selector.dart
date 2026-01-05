/// Mode Selector with consistent styling
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
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

/// Get localized modes
List<ModeData> getDefaultModes(AppLocalizations l10n) => [
  ModeData(id: 'auto', label: l10n.modeAuto, icon: Icons.bolt),
  ModeData(id: 'eco', label: l10n.modeEco, icon: Icons.wb_sunny_outlined),
  ModeData(id: 'night', label: l10n.modeNight, icon: Icons.nightlight_outlined),
  ModeData(id: 'boost', label: l10n.modeBoost, icon: Icons.air),
];

/// Single mode button
class ModeButton extends StatelessWidget {
  final ModeData mode;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool compact;
  final bool enabled;

  const ModeButton({
    super.key,
    required this.mode,
    this.isSelected = false,
    this.onTap,
    this.compact = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final effectiveOnTap = enabled ? onTap : null;
    final iconColor = !enabled
        ? colors.textMuted.withValues(alpha: 0.3)
        : (isSelected ? Colors.white : colors.textMuted);

    return BreezButton(
      onTap: effectiveOnTap,
      // Minimum 48px touch target height
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 16,
        vertical: compact ? 14 : 12, // 14*2 + icon = 48px min
      ),
      backgroundColor: !enabled
          ? colors.buttonBg.withValues(alpha: 0.5)
          : (isSelected ? AppColors.accent : colors.buttonBg),
      hoverColor: !enabled
          ? colors.buttonBg.withValues(alpha: 0.5)
          : (isSelected ? AppColors.accentLight : colors.cardLight),
      border: Border.all(
        color: !enabled
            ? Colors.transparent
            : (isSelected ? AppColors.accent : Colors.transparent),
      ),
      shadows: isSelected && enabled
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
                color: iconColor,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  mode.icon,
                  size: 16,
                  color: iconColor,
                ),
                const SizedBox(width: 8),
                Text(
                  mode.label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: iconColor,
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
  final List<ModeData>? modes;
  final bool compact;
  final bool enabled;

  const ModeSelector({
    super.key,
    required this.unitName,
    required this.selectedMode,
    this.onModeChanged,
    this.modes,
    this.compact = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveModes = modes ?? getDefaultModes(l10n);

    // В компактном режиме убираем подложку и заголовок
    if (compact) {
      return Row(
        children: effectiveModes.map((mode) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ModeButton(
                mode: mode,
                isSelected: selectedMode == mode.id,
                onTap: () => onModeChanged?.call(mode.id),
                compact: true,
                enabled: enabled,
              ),
            ),
          );
        }).toList(),
      );
    }

    // В обычном режиме оставляем с подложкой
    return BreezCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreezLabel(l10n.modeFor(unitName)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.8,
            physics: const NeverScrollableScrollPhysics(),
            children: effectiveModes.map((mode) {
              return ModeButton(
                mode: mode,
                isSelected: selectedMode == mode.id,
                onTap: () => onModeChanged?.call(mode.id),
                enabled: enabled,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
