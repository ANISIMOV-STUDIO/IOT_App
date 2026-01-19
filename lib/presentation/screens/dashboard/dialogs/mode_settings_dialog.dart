/// Диалог настроек режима (температуры и скорости вентиляторов)
library;

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_radius.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';

// =============================================================================
// RESULT CLASS
// =============================================================================

/// Результат диалога настроек режима
class ModeSettingsResult {
  const ModeSettingsResult({
    required this.settings,
    required this.activate,
  });

  /// Настройки режима (температуры, скорости вентиляторов)
  final ModeSettings settings;

  /// Нужно ли активировать режим (true если нажата кнопка "Включить")
  final bool activate;
}

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _DialogConstants {
  static const double maxWidth = 340;
  static const double headerIconSize = 32;
  static const double headerIconContainerSize = 56;
  static const double closeIconSize = 18;
  static const double closeButtonPadding = 6;
  static const double titleFontSize = 16;
  static const double selectedBadgeSize = 18;
  static const double selectedCheckSize = 12;
}

// =============================================================================
// MAIN DIALOG
// =============================================================================

/// Диалог настроек режима работы
class ModeSettingsDialog extends StatefulWidget {
  const ModeSettingsDialog({
    required this.modeName,
    required this.modeDisplayName,
    required this.modeIcon,
    required this.modeColor,
    required this.initialSettings,
    required this.isSelected,
    super.key,
  });

  final String modeName;
  final String modeDisplayName;
  final IconData modeIcon;
  final Color modeColor;
  final ModeSettings initialSettings;

  /// Является ли этот режим текущим активным
  final bool isSelected;

  /// Показать диалог и вернуть результат
  static Future<ModeSettingsResult?> show(
    BuildContext context, {
    required String modeName,
    required String modeDisplayName,
    required IconData modeIcon,
    required Color modeColor,
    required ModeSettings initialSettings,
    required bool isSelected,
  }) =>
      showDialog<ModeSettingsResult>(
        context: context,
        builder: (context) => ModeSettingsDialog(
          modeName: modeName,
          modeDisplayName: modeDisplayName,
          modeIcon: modeIcon,
          modeColor: modeColor,
          initialSettings: initialSettings,
          isSelected: isSelected,
        ),
      );

  @override
  State<ModeSettingsDialog> createState() => _ModeSettingsDialogState();
}

class _ModeSettingsDialogState extends State<ModeSettingsDialog> {
  late int _heatingTemperature;
  late int _coolingTemperature;
  late int _supplyFan;
  late int _exhaustFan;

  @override
  void initState() {
    super.initState();
    _heatingTemperature = widget.initialSettings.heatingTemperature;
    _coolingTemperature = widget.initialSettings.coolingTemperature;
    _supplyFan = widget.initialSettings.supplyFan;
    _exhaustFan = widget.initialSettings.exhaustFan;
  }

  ModeSettings get _currentSettings => ModeSettings(
        heatingTemperature: _heatingTemperature,
        coolingTemperature: _coolingTemperature,
        supplyFan: _supplyFan,
        exhaustFan: _exhaustFan,
      );

  void _save() {
    Navigator.of(context).pop(ModeSettingsResult(
      settings: _currentSettings,
      activate: false,
    ));
  }

  void _activate() {
    Navigator.of(context).pop(ModeSettingsResult(
      settings: _currentSettings,
      activate: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final maxWidth = min(
      MediaQuery.of(context).size.width - AppSpacing.xl,
      _DialogConstants.maxWidth,
    );

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        side: BorderSide(color: colors.border),
      ),
      child: Container(
        width: maxWidth,
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header с иконкой режима
            _ModeHeader(
              modeName: widget.modeDisplayName,
              modeIcon: widget.modeIcon,
              modeColor: widget.modeColor,
              isSelected: widget.isSelected,
              onClose: () => Navigator.of(context).pop(),
            ),

            const SizedBox(height: AppSpacing.xs),

            // Temperature section
            _TemperatureRow(
              heatingTemp: _heatingTemperature,
              coolingTemp: _coolingTemperature,
              onHeatingChanged: (temp) =>
                  setState(() => _heatingTemperature = temp),
              onCoolingChanged: (temp) =>
                  setState(() => _coolingTemperature = temp),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Fan speed section
            Row(
              children: [
                Expanded(
                  child: FanSlider(
                    label: l10n.intake,
                    value: _supplyFan,
                    color: AppColors.accent,
                    icon: Icons.arrow_downward_rounded,
                    onChanged: (value) => setState(() => _supplyFan = value),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: FanSlider(
                    label: l10n.exhaust,
                    value: _exhaustFan,
                    color: AppColors.accentOrange,
                    icon: Icons.arrow_upward_rounded,
                    onChanged: (value) => setState(() => _exhaustFan = value),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Action buttons
            _ActionButtons(
              isSelected: widget.isSelected,
              onSave: _save,
              onActivate: _activate,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

/// Header с иконкой режима, названием и кнопкой закрытия
class _ModeHeader extends StatelessWidget {
  const _ModeHeader({
    required this.modeName,
    required this.modeIcon,
    required this.modeColor,
    required this.isSelected,
    required this.onClose,
  });

  final String modeName;
  final IconData modeIcon;
  final Color modeColor;
  final bool isSelected;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Stack(
      children: [
        // Центрированный контент
        Center(
          child: Column(
            children: [
              // Иконка режима с индикатором выбора
              Stack(
                children: [
                  Container(
                    width: _DialogConstants.headerIconContainerSize,
                    height: _DialogConstants.headerIconContainerSize,
                    decoration: BoxDecoration(
                      color: modeColor.withValues(alpha: AppColors.opacitySubtle),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppColors.accent, width: 2)
                          : null,
                    ),
                    child: Icon(
                      modeIcon,
                      size: _DialogConstants.headerIconSize,
                      color: modeColor,
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: _DialogConstants.selectedBadgeSize,
                        height: _DialogConstants.selectedBadgeSize,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: _DialogConstants.selectedCheckSize,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              // Название режима
              Text(
                modeName,
                style: TextStyle(
                  fontSize: _DialogConstants.titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: colors.text,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Кнопка закрытия в правом верхнем углу
        Positioned(
          top: 0,
          right: 0,
          child: _CloseButton(onTap: onClose),
        ),
      ],
    );
  }
}

/// Кнопка закрытия
class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: onTap,
      enforceMinTouchTarget: false,
      showBorder: false,
      backgroundColor: colors.buttonBg.withValues(alpha: AppColors.opacityMedium),
      hoverColor: colors.text.withValues(alpha: AppColors.opacitySubtle),
      padding: const EdgeInsets.all(_DialogConstants.closeButtonPadding),
      semanticLabel: 'Закрыть',
      child: Icon(
        Icons.close,
        size: _DialogConstants.closeIconSize,
        color: colors.textMuted,
      ),
    );
  }
}

/// Ряд с температурами нагрева и охлаждения
class _TemperatureRow extends StatelessWidget {
  const _TemperatureRow({
    required this.heatingTemp,
    required this.coolingTemp,
    required this.onHeatingChanged,
    required this.onCoolingChanged,
  });

  final int heatingTemp;
  final int coolingTemp;
  final ValueChanged<int> onHeatingChanged;
  final ValueChanged<int> onCoolingChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: TemperatureColumn(
            label: l10n.heating,
            temperature: heatingTemp,
            icon: Icons.whatshot,
            color: AppColors.accentOrange,
            isPowered: true,
            minTemp: TemperatureLimits.min,
            maxTemp: TemperatureLimits.max,
            onIncrease: () => onHeatingChanged(
              (heatingTemp + 1).clamp(
                TemperatureLimits.min,
                TemperatureLimits.max,
              ),
            ),
            onDecrease: () => onHeatingChanged(
              (heatingTemp - 1).clamp(
                TemperatureLimits.min,
                TemperatureLimits.max,
              ),
            ),
          ),
        ),
        Expanded(
          child: TemperatureColumn(
            label: l10n.cooling,
            temperature: coolingTemp,
            icon: Icons.ac_unit,
            color: AppColors.accent,
            isPowered: true,
            minTemp: TemperatureLimits.min,
            maxTemp: TemperatureLimits.max,
            onIncrease: () => onCoolingChanged(
              (coolingTemp + 1).clamp(
                TemperatureLimits.min,
                TemperatureLimits.max,
              ),
            ),
            onDecrease: () => onCoolingChanged(
              (coolingTemp - 1).clamp(
                TemperatureLimits.min,
                TemperatureLimits.max,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Кнопки действий
class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.isSelected,
    required this.onSave,
    required this.onActivate,
  });

  final bool isSelected;
  final VoidCallback onSave;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // Кнопка "Сохранить" (secondary)
        Expanded(
          child: BreezButton(
            onTap: onSave,
            backgroundColor: colors.cardLight,
            showBorder: false,
            borderRadius: AppRadius.nested,
            padding: const EdgeInsets.all(AppSpacing.xs),
            semanticLabel: l10n.save,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_outlined, size: AppSpacing.md, color: colors.text),
                const SizedBox(width: AppSpacing.xxs),
                Flexible(
                  child: Text(
                    l10n.save,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: FontWeight.w500,
                      color: colors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        // Кнопка "Включить" (primary, disabled если isSelected)
        Expanded(
          child: BreezButton(
            onTap: isSelected ? null : onActivate,
            backgroundColor: isSelected ? colors.buttonBg : AppColors.accent,
            showBorder: false,
            borderRadius: AppRadius.nested,
            padding: const EdgeInsets.all(AppSpacing.xs),
            enableGlow: !isSelected,
            semanticLabel: l10n.enable,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.power_settings_new,
                  size: AppSpacing.md,
                  color: isSelected ? colors.textMuted : AppColors.black,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Flexible(
                  child: Text(
                    l10n.enable,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? colors.textMuted : AppColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
