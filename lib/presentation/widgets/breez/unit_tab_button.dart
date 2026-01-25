/// Unit Tab Button - Unified tab button for unit selection with accessibility
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для UnitTabButton и UnitTabsContainer
abstract class _UnitTabConstants {
  static const double containerHeight = 48;
  static const double statusIndicatorSize = 8;
  static const double textLineHeight = 1;
}

// =============================================================================
// UNIT TAB BUTTON
// =============================================================================

/// Unified unit tab button used across all layouts (mobile, tablet, desktop)
class UnitTabButton extends StatelessWidget {

  const UnitTabButton({
    required this.unit,
    required this.isSelected,
    super.key,
    this.onTap,
    this.semanticLabel,
  });

  /// Create from unit data with name and power status
  factory UnitTabButton.fromData({
    required String name,
    required bool power,
    required bool isSelected,
    Key? key,
    VoidCallback? onTap,
    String? semanticLabel,
  }) => UnitTabButton(
      key: key,
      unit: UnitState(
        id: '',
        name: name,
        power: power,
        temp: 0,
        humidity: 0,
        mode: '',
        supplyFan: 0,
        exhaustFan: 0,
        outsideTemp: 0,
        filterPercent: 100,
      ),
      isSelected: isSelected,
      onTap: onTap,
      semanticLabel: semanticLabel,
    );
  final UnitState unit;
  final bool isSelected;
  final VoidCallback? onTap;

  /// Semantic label for screen readers (defaults to unit name + status)
  final String? semanticLabel;

  String _buildSemanticLabel(AppLocalizations l10n) {
    final status = unit.power ? l10n.unitPoweredOn : l10n.unitPoweredOff;
    final selected = isSelected ? ', ${l10n.unitSelected}' : '';
    return '${unit.name}, $status$selected';
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Цвета: выбранный — акцентный текст на прозрачном фоне с подсветкой
    final textColor = isSelected ? colors.accent : colors.textMuted;
    // Зелёный если устройство онлайн, серый если офлайн
    final indicatorColor = unit.isOnline ? AppColors.success : colors.textMuted;

    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      borderRadius: AppRadius.nested,
      backgroundColor: isSelected
          ? colors.accent.withValues(alpha: 0.15)
          : Colors.transparent,
      hoverColor: isSelected
          ? colors.accent.withValues(alpha: 0.25)
          : colors.buttonBg,
      border: isSelected
          ? Border.all(color: colors.accent.withValues(alpha: 0.3))
          : null,
      showBorder: false,
      semanticLabel: semanticLabel ?? _buildSemanticLabel(l10n),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status indicator with semantic meaning
          Semantics(
            label: unit.power ? l10n.statusRunning : l10n.statusStopped,
            child: Container(
              width: _UnitTabConstants.statusIndicatorSize,
              height: _UnitTabConstants.statusIndicatorSize,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          // Unit name
          Text(
            unit.name,
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              height: _UnitTabConstants.textLineHeight,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// UNIT TABS CONTAINER
// =============================================================================

/// Unit tabs container - wraps unit tab buttons in a styled container
class UnitTabsContainer extends StatelessWidget {

  const UnitTabsContainer({
    required this.units,
    required this.selectedIndex,
    super.key,
    this.onUnitSelected,
    this.leading,
    this.trailing,
    this.height = _UnitTabConstants.containerHeight,
  });
  final List<UnitState> units;
  final int selectedIndex;
  final ValueChanged<int>? onUnitSelected;
  final Widget? leading;
  final Widget? trailing;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: l10n.devicesList,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.cardSmall),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.xs),
            ],
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < units.length; i++) ...[
                      if (i > 0) const SizedBox(width: AppSpacing.xs),
                      UnitTabButton(
                        unit: units[i],
                        isSelected: i == selectedIndex,
                        onTap: () => onUnitSelected?.call(i),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.xs),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
