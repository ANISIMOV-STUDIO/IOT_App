/// Material 3 Chip Component
/// Provides input, filter, choice, and action chips with HVAC theming
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

/// Basic HVAC chip component
class HvacChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool selected;
  final bool enabled;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? labelColor;
  final EdgeInsetsGeometry? padding;

  const HvacChip({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.onDelete,
    this.selected = false,
    this.enabled = true,
    this.backgroundColor,
    this.selectedColor,
    this.labelColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (onDelete != null) {
      return InputChip(
        label: Text(label),
        avatar: icon != null ? Icon(icon, size: 18) : null,
        onDeleted: enabled ? onDelete : null,
        onPressed: enabled ? onTap : null,
        selected: selected,
        backgroundColor: backgroundColor ?? HvacColors.backgroundCard,
        selectedColor: selectedColor ?? HvacColors.primaryOrange.withValues(alpha: 0.2),
        deleteIconColor: HvacColors.textSecondary,
        labelStyle: HvacTypography.caption.copyWith(
          color: labelColor ??
              (selected ? HvacColors.primaryOrange : HvacColors.textPrimary),
        ),
        side: BorderSide(
          color: selected
              ? HvacColors.primaryOrange
              : HvacColors.backgroundCardBorder,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: HvacSpacing.xs),
      );
    }

    if (selected) {
      return FilterChip(
        label: Text(label),
        avatar: icon != null ? Icon(icon, size: 18) : null,
        onSelected: enabled ? (val) => onTap?.call() : null,
        selected: selected,
        backgroundColor: backgroundColor ?? HvacColors.backgroundCard,
        selectedColor: selectedColor ?? HvacColors.primaryOrange.withValues(alpha: 0.2),
        checkmarkColor: HvacColors.primaryOrange,
        labelStyle: HvacTypography.caption.copyWith(
          color: labelColor ?? HvacColors.primaryOrange,
        ),
        side: const BorderSide(
          color: HvacColors.primaryOrange,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: HvacSpacing.xs),
      );
    }

    return ActionChip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: 18) : null,
      onPressed: enabled ? onTap : null,
      backgroundColor: backgroundColor ?? HvacColors.backgroundCard,
      labelStyle: HvacTypography.caption.copyWith(
        color: labelColor ?? HvacColors.textPrimary,
      ),
      side: const BorderSide(
        color: HvacColors.backgroundCardBorder,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: HvacSpacing.xs),
    );
  }
}

/// Filter chip for filtering content
class HvacFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final bool enabled;
  final Color? selectedColor;

  const HvacFilterChip({
    super.key,
    required this.label,
    this.icon,
    required this.selected,
    this.onSelected,
    this.enabled = true,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: 18) : null,
      selected: selected,
      onSelected: enabled ? onSelected : null,
      backgroundColor: HvacColors.backgroundCard,
      selectedColor: selectedColor ?? HvacColors.primaryOrange.withValues(alpha: 0.2),
      checkmarkColor: HvacColors.primaryOrange,
      labelStyle: HvacTypography.caption.copyWith(
        color: selected ? HvacColors.primaryOrange : HvacColors.textPrimary,
      ),
      side: BorderSide(
        color: selected
            ? HvacColors.primaryOrange
            : HvacColors.backgroundCardBorder,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

/// Choice chip for single selection
class HvacChoiceChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final bool enabled;
  final Color? selectedColor;

  const HvacChoiceChip({
    super.key,
    required this.label,
    this.icon,
    required this.selected,
    this.onSelected,
    this.enabled = true,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: 18) : null,
      selected: selected,
      onSelected: enabled ? onSelected : null,
      backgroundColor: HvacColors.backgroundCard,
      selectedColor: selectedColor ?? HvacColors.primaryOrange.withValues(alpha: 0.2),
      labelStyle: HvacTypography.caption.copyWith(
        color: selected ? HvacColors.primaryOrange : HvacColors.textPrimary,
      ),
      side: BorderSide(
        color: selected
            ? HvacColors.primaryOrange
            : HvacColors.backgroundCardBorder,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

/// Chip group for multiple selection
class HvacChipGroup extends StatelessWidget {
  final List<String> labels;
  final Set<int> selectedIndices;
  final ValueChanged<Set<int>>? onSelectionChanged;
  final bool multiSelect;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;

  const HvacChipGroup({
    super.key,
    required this.labels,
    this.selectedIndices = const {},
    this.onSelectionChanged,
    this.multiSelect = true,
    this.spacing = HvacSpacing.xs,
    this.runSpacing = HvacSpacing.xs,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: List.generate(
          labels.length,
          (index) {
            final isSelected = selectedIndices.contains(index);
            return HvacFilterChip(
              label: labels[index],
              selected: isSelected,
              onSelected: onSelectionChanged != null
                  ? (selected) {
                      final newSelection = Set<int>.from(selectedIndices);
                      if (selected) {
                        if (!multiSelect) {
                          newSelection.clear();
                        }
                        newSelection.add(index);
                      } else {
                        newSelection.remove(index);
                      }
                      onSelectionChanged!(newSelection);
                    }
                  : null,
            );
          },
        ),
      ),
    );
  }
}
