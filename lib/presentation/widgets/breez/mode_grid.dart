/// Mode Grid - адаптивная сетка режимов работы
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/breez/mode_grid_item.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для ModeGrid
abstract class _ModeGridConstants {
  static const double minAspectRatio = 0.8;
  static const double maxAspectRatio = 2;
  static const int defaultColumns = 4;
}

// =============================================================================
// HELPERS
// =============================================================================

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

/// Callback для нажатия на режим
typedef ModeCallback = void Function(OperatingModeData mode);

/// Сетка режимов работы установки
///
/// Адаптивная сетка с автоматическим расчётом aspect ratio
/// на основе доступного пространства виджета.
///
/// По умолчанию 4 колонки x 2 ряда для 8 режимов.
class ModeGrid extends StatelessWidget {

  const ModeGrid({
    required this.selectedMode, super.key,
    this.onModeTap,
    this.isEnabled = true,
    this.modes,
    this.columns = _ModeGridConstants.defaultColumns,
    this.showCard = true,
  });
  final String selectedMode;

  /// Callback при нажатии на режим
  /// Передаёт полные данные режима (id, name, icon, color)
  final ModeCallback? onModeTap;

  final bool isEnabled;
  final List<OperatingModeData>? modes;
  final int columns;
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveModes = modes ?? getOperatingModes(l10n);
    final rows = (effectiveModes.length / columns).ceil();

    // Найти выбранный режим для Semantics
    final selectedModeName = effectiveModes
        .where((m) => m.id.toLowerCase() == selectedMode.toLowerCase())
        .map((m) => m.name)
        .firstOrNull ?? selectedMode;

    final grid = LayoutBuilder(
      builder: (context, constraints) {
        const spacing = AppSpacing.xs;

        final availableWidth = constraints.maxWidth - spacing * (columns - 1);
        final availableHeight = constraints.maxHeight - spacing * (rows - 1);

        final cellWidth = availableWidth / columns;
        final cellHeight = availableHeight / rows;
        final aspectRatio = cellWidth / cellHeight;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: aspectRatio.clamp(
              _ModeGridConstants.minAspectRatio,
              _ModeGridConstants.maxAspectRatio,
            ),
          ),
          itemCount: effectiveModes.length,
          itemBuilder: (context, index) {
            final mode = effectiveModes[index];
            final isSelected = selectedMode.toLowerCase() == mode.id.toLowerCase();

            return ModeGridItem(
              mode: mode,
              isSelected: isSelected,
              isEnabled: isEnabled,
              onTap: isEnabled ? () => onModeTap?.call(mode) : null,
            );
          },
        );
      },
    );

    final content = showCard
        ? BreezCard(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: grid,
          )
        : grid;

    return Semantics(
      label: '${l10n.operatingMode}: $selectedModeName',
      child: content,
    );
  }
}
