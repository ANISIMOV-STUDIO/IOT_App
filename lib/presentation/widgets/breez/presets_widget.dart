/// Presets Widget - Quick access to HVAC presets
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/preset_data.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';

export '../../../domain/entities/preset_data.dart';

/// Presets widget - adaptive icon/text layout
class PresetsWidget extends StatelessWidget {
  final List<PresetData> presets;
  final String? activePresetId;
  final ValueChanged<String>? onPresetSelected;

  const PresetsWidget({
    super.key,
    required this.presets,
    this.activePresetId,
    this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивно определяем режим отображения
        final isCompact = constraints.maxHeight < 100;

        // Вычисляем правильный aspect ratio чтобы влезло 2 ряда
        const cardPadding = AppSpacing.sm * 2;
        const headerHeight = 20.0;
        const headerSpacing = AppSpacing.sm;

        final availableHeight = constraints.maxHeight - cardPadding - headerHeight - headerSpacing;
        final availableWidth = constraints.maxWidth - cardPadding;

        // 2 ряда с отступом между ними
        final rowHeight = (availableHeight - AppSpacing.sm) / 2;
        // 3 колонки с отступами между ними (2 отступа между 3 колонками)
        final columnWidth = (availableWidth - AppSpacing.sm * 2) / 3;

        final aspectRatio = columnWidth / rowHeight;

        return BreezCard(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.presets.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: colors.textMuted,
                    ),
                  ),
                  if (activePresetId != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.indicator),
                        border: Border.all(
                          color: AppColors.accentGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        presets
                            .firstWhere(
                              (p) => p.id == activePresetId,
                              orElse: () => presets.first,
                            )
                            .name
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              // Presets grid (2 rows)
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: aspectRatio,
                  physics: const NeverScrollableScrollPhysics(),
                  children: presets.map((preset) {
                    final isActive = preset.id == activePresetId;
                    return _PresetButton(
                      preset: preset,
                      isActive: isActive,
                      isCompact: isCompact,
                      onTap: () => onPresetSelected?.call(preset.id),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Modern preset button using BreezButton
class _PresetButton extends StatelessWidget {
  final PresetData preset;
  final bool isActive;
  final bool isCompact;
  final VoidCallback? onTap;

  const _PresetButton({
    required this.preset,
    this.isActive = false,
    this.isCompact = false,
    this.onTap,
  });

  Color get _color => preset.color ?? AppColors.accent;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.all(6),
      backgroundColor: isActive
          ? _color.withValues(alpha: 0.15)
          : Colors.transparent,
      hoverColor: isActive
          ? _color.withValues(alpha: 0.25)
          : colors.buttonBg,
      border: Border.all(
        color: isActive ? _color.withValues(alpha: 0.4) : colors.border,
        width: 1,
      ),
      shadows: isActive
          ? [
              BoxShadow(
                color: _color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            preset.icon,
            size: isCompact ? 16 : 18,
            color: isActive ? _color : colors.textMuted,
          ),
          const SizedBox(height: 4),
          Text(
            preset.name.toUpperCase(),
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: isActive ? _color : colors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
