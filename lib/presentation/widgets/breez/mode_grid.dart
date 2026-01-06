/// Mode Grid - адаптивная сетка режимов работы
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';
import 'mode_grid_item.dart';

/// Получить локализованные режимы работы установки
List<OperatingModeData> getOperatingModes(AppLocalizations l10n) => [
  OperatingModeData(id: 'basic', name: l10n.modeBasic, icon: Icons.air, color: AppColors.accent),
  OperatingModeData(id: 'intensive', name: l10n.modeIntensive, icon: Icons.speed, color: AppColors.accentOrange),
  OperatingModeData(id: 'economy', name: l10n.modeEconomy, icon: Icons.eco, color: AppColors.accentGreen),
  OperatingModeData(id: 'max_performance', name: l10n.modeMaxPerformance, icon: Icons.bolt, color: AppColors.accentOrange),
  OperatingModeData(id: 'kitchen', name: l10n.modeKitchen, icon: Icons.restaurant, color: Colors.brown),
  OperatingModeData(id: 'fireplace', name: l10n.modeFireplace, icon: Icons.fireplace, color: Colors.deepOrange),
  OperatingModeData(id: 'vacation', name: l10n.modeVacation, icon: Icons.flight_takeoff, color: Colors.teal),
  OperatingModeData(id: 'custom', name: l10n.modeCustom, icon: Icons.tune, color: Colors.purple),
];

/// Сетка режимов работы установки
///
/// Адаптивная сетка с автоматическим расчётом aspect ratio
/// на основе доступного пространства виджета.
///
/// По умолчанию 4 колонки x 2 ряда для 8 режимов.
class ModeGrid extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String>? onModeChanged;
  final bool isEnabled;
  final List<OperatingModeData>? modes;
  final int columns;

  const ModeGrid({
    super.key,
    required this.selectedMode,
    this.onModeChanged,
    this.isEnabled = true,
    this.modes,
    this.columns = 4,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveModes = modes ?? getOperatingModes(l10n);
    final rows = (effectiveModes.length / columns).ceil();

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Вычисляем размеры ячеек на основе доступного пространства
          const spacing = AppSpacing.sm;

          final availableWidth = constraints.maxWidth - spacing * (columns - 1);
          final availableHeight = constraints.maxHeight - spacing * (rows - 1);

          final cellWidth = availableWidth / columns;
          final cellHeight = availableHeight / rows;

          // Aspect ratio = width / height
          final aspectRatio = cellWidth / cellHeight;

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: aspectRatio.clamp(0.8, 2.0),
            ),
            itemCount: effectiveModes.length,
            itemBuilder: (context, index) {
              final mode = effectiveModes[index];
              final isSelected = selectedMode.toLowerCase() == mode.id.toLowerCase();

              return ModeGridItem(
                mode: mode,
                isSelected: isSelected,
                isEnabled: isEnabled,
                onTap: isEnabled ? () => onModeChanged?.call(mode.id) : null,
              );
            },
          );
        },
      ),
    );
  }
}
