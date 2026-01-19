/// Mode Grid Item - универсальная кнопка режима для сеток
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для ModeGridItem
abstract class _ModeGridItemConstants {
  static const double iconSize = 20;
  static const double labelFontSize = 8;
  static const double letterSpacing = 0.3;
  static const double selectedAlpha = 0.15;
  static const double pressedAlpha = 0.2;
  static const double hoverAlpha = 0.1;
  static const double borderSelectedAlpha = 0.4;
  static const double settingsIconSize = 14;
  static const double settingsButtonSize = 20;
  static const double settingsButtonAlpha = 0.6;
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
/// - Иконка настроек (onSettingsTap)
class ModeGridItem extends StatelessWidget {

  const ModeGridItem({
    required this.mode, super.key,
    this.isSelected = false,
    this.isEnabled = true,
    this.onTap,
    this.onSettingsTap,
  });
  final OperatingModeData mode;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  /// Callback для открытия настроек режима
  /// Если не null, показывается иконка шестерёнки
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final color = isEnabled ? mode.color : colors.textMuted;

    return Stack(
      children: [
        // Основная кнопка режима
        Positioned.fill(
          child: Semantics(
            button: true,
            selected: isSelected,
            enabled: isEnabled,
            label: '${mode.name}${isSelected ? ', выбрано' : ''}',
            child: BreezButton(
              onTap: isEnabled ? onTap : null,
              padding: const EdgeInsets.all(AppSpacing.xs),
              backgroundColor: isSelected
                  ? color.withValues(alpha: _ModeGridItemConstants.selectedAlpha)
                  : Colors.transparent,
              pressedColor: color.withValues(alpha: _ModeGridItemConstants.pressedAlpha),
              hoverColor: color.withValues(alpha: _ModeGridItemConstants.hoverAlpha),
              border: Border.all(
                color: isSelected
                    ? color.withValues(alpha: _ModeGridItemConstants.borderSelectedAlpha)
                    : colors.border,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Icon(
                      mode.icon,
                      size: _ModeGridItemConstants.iconSize,
                      color: isSelected ? color : colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs / 2),
                  Text(
                    mode.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: _ModeGridItemConstants.labelFontSize,
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
          ),
        ),

        // Иконка настроек в правом верхнем углу
        if (onSettingsTap != null)
          Positioned(
            top: AppSpacing.xxs / 2,
            right: AppSpacing.xxs / 2,
            child: _SettingsButton(
              color: color,
              onTap: onSettingsTap!,
            ),
          ),
      ],
    );
  }
}

/// Кнопка настроек (шестерёнка)
class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    required this.color,
    required this.onTap,
  });

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Semantics(
      button: true,
      label: 'Настройки режима',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: _ModeGridItemConstants.settingsButtonSize,
          height: _ModeGridItemConstants.settingsButtonSize,
          decoration: BoxDecoration(
            color: colors.card.withValues(
              alpha: _ModeGridItemConstants.settingsButtonAlpha,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.settings,
            size: _ModeGridItemConstants.settingsIconSize,
            color: color,
          ),
        ),
      ),
    );
  }
}
