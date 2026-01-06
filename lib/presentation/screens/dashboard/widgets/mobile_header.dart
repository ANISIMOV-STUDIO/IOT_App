/// Mobile Header - Header with unit tabs for mobile layout
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/breez/breez_logo.dart';
import '../../../widgets/breez/unit_tab_button.dart';
import 'add_unit_button.dart';

/// Mobile header with unit tabs and controls
class MobileHeader extends StatelessWidget {
  final List<UnitState> units;
  final int selectedUnitIndex;
  final ValueChanged<int>? onUnitSelected;
  final VoidCallback? onAddUnit;
  final bool isDark;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onMenuTap;

  const MobileHeader({
    super.key,
    required this.units,
    required this.selectedUnitIndex,
    this.onUnitSelected,
    this.onAddUnit,
    required this.isDark,
    this.onThemeToggle,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        0, // Нет отступа снизу - будет SizedBox
      ),
      child: _buildUnitTabs(context),
    );
  }

  Widget _buildUnitTabs(BuildContext context) {
    final colors = BreezColors.of(context);
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: BreezLogo.small(),
          ),
          const SizedBox(width: 8),
          // Unit tabs list
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: units.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final unit = units[index];
                final isSelected = index == selectedUnitIndex;
                return UnitTabButton(
                  unit: unit,
                  isSelected: isSelected,
                  onTap: () => onUnitSelected?.call(index),
                );
              },
            ),
          ),
          // Add unit button
          Center(child: AddUnitButton(onTap: onAddUnit)),
        ],
      ),
    );
  }
}
