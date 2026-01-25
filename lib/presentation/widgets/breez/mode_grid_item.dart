/// Mode Grid Item - универсальная кнопка режима для сеток
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для ModeGridItem
abstract class _ModeGridItemConstants {
  static const double letterSpacing = 0.3;
}

// =============================================================================
// DATA CLASS
// =============================================================================

/// Данные режима для отображения в сетке
class OperatingModeData {

  const OperatingModeData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
  final String id;
  final String name;
  final IconData icon;
  final Color color;
}

/// Кнопка режима для сеток (ModeGrid)
///
/// Поддерживает:
/// - Состояние выбора (isSelected)
/// - Состояние включения (isEnabled)
/// - Цветовую схему режима
/// - Адаптивные размеры
class ModeGridItem extends StatelessWidget {

  const ModeGridItem({
    required this.mode, super.key,
    this.isSelected = false,
    this.isEnabled = true,
    this.onTap,
  });
  final OperatingModeData mode;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final color = isEnabled ? mode.color : colors.textMuted;

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: isEnabled,
      label: '${mode.name}${isSelected ? ', выбрано' : ''}',
      child: BreezButton(
        onTap: isEnabled ? onTap : null,
        padding: const EdgeInsets.all(AppSpacing.xs),
        backgroundColor: isSelected
            ? color.withValues(alpha: AppColors.opacitySubtle)
            : Colors.transparent,
        pressedColor: color.withValues(alpha: AppColors.opacityMediumLight),
        hoverColor: color.withValues(alpha: AppColors.opacityLight),
        border: Border.all(
          color: isSelected
              ? color.withValues(alpha: AppColors.opacityStrong)
              : colors.border,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Icon(
                mode.icon,
                size: AppIconSizes.standard,
                color: isSelected ? color : colors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs / 2),
            Text(
              mode.name.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.micro,
                fontWeight: FontWeight.w700,
                letterSpacing: _ModeGridItemConstants.letterSpacing,
                color: isSelected ? color : colors.textMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
