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
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_slider.dart';
import 'package:hvac_control/presentation/widgets/breez/temp_column.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _DialogConstants {
  static const double maxWidth = 340;
  static const double headerIconSize = 18;
  static const double closeButtonSize = 28;
  static const double titleFontSize = 16;
  static const double sectionTitleSize = 11;
  static const double fanSliderIconSize = 14;
  static const double fanSliderLabelSize = 12;
  static const double fanSliderValueSize = 12;
  static const int minFanSpeed = 20;
  static const int maxFanSpeed = 100;
}

// =============================================================================
// MAIN DIALOG
// =============================================================================

/// Диалог настроек режима работы
class ModeSettingsDialog extends StatefulWidget {
  const ModeSettingsDialog({
    required this.modeName,
    required this.modeDisplayName,
    required this.initialSettings,
    super.key,
  });

  final String modeName;
  final String modeDisplayName;
  final ModeSettings initialSettings;

  /// Показать диалог и вернуть результат
  static Future<ModeSettings?> show(
    BuildContext context, {
    required String modeName,
    required String modeDisplayName,
    required ModeSettings initialSettings,
  }) =>
      showDialog<ModeSettings>(
        context: context,
        builder: (context) => ModeSettingsDialog(
          modeName: modeName,
          modeDisplayName: modeDisplayName,
          initialSettings: initialSettings,
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

  void _save() {
    Navigator.of(context).pop(ModeSettings(
      heatingTemperature: _heatingTemperature,
      coolingTemperature: _coolingTemperature,
      supplyFan: _supplyFan,
      exhaustFan: _exhaustFan,
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
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _Header(
              modeName: widget.modeDisplayName,
              onClose: () => Navigator.of(context).pop(),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Temperature section
            _SectionTitle(title: l10n.temperatureSetpoints),
            const SizedBox(height: AppSpacing.xs),
            _TemperatureRow(
              heatingTemp: _heatingTemperature,
              coolingTemp: _coolingTemperature,
              onHeatingChanged: (temp) =>
                  setState(() => _heatingTemperature = temp),
              onCoolingChanged: (temp) =>
                  setState(() => _coolingTemperature = temp),
            ),

            const SizedBox(height: AppSpacing.md),

            // Fan speed section
            _SectionTitle(title: l10n.fanSpeed),
            const SizedBox(height: AppSpacing.xs),
            _FanSliderRow(
              label: l10n.intake,
              value: _supplyFan,
              icon: Icons.air,
              color: AppColors.accent,
              onChanged: (value) => setState(() => _supplyFan = value),
            ),
            const SizedBox(height: AppSpacing.xs),
            _FanSliderRow(
              label: l10n.exhaust,
              value: _exhaustFan,
              icon: Icons.air_outlined,
              color: AppColors.accentOrange,
              onChanged: (value) => setState(() => _exhaustFan = value),
            ),

            const SizedBox(height: AppSpacing.md),

            // Action buttons
            _ActionButtons(
              onCancel: () => Navigator.of(context).pop(),
              onSave: _save,
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

/// Header с названием режима и кнопкой закрытия
class _Header extends StatelessWidget {
  const _Header({
    required this.modeName,
    required this.onClose,
  });

  final String modeName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Icon(
          Icons.tune,
          size: _DialogConstants.headerIconSize,
          color: colors.textMuted,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            '${l10n.modeFor(modeName)}',
            style: TextStyle(
              fontSize: _DialogConstants.titleFontSize,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _CloseButton(onTap: onClose),
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _DialogConstants.closeButtonSize,
        height: _DialogConstants.closeButtonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.buttonBg.withValues(alpha: 0.5),
        ),
        child: Icon(
          Icons.close,
          size: _DialogConstants.headerIconSize,
          color: colors.textMuted,
        ),
      ),
    );
  }
}

/// Заголовок секции
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: _DialogConstants.sectionTitleSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
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
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.cardLight,
        borderRadius: BorderRadius.circular(AppRadius.nested),
      ),
      child: Row(
        children: [
          Expanded(
            child: TemperatureColumn(
              label: l10n.heating,
              temperature: heatingTemp,
              icon: Icons.whatshot,
              color: AppColors.accentOrange,
              isPowered: true,
              compact: true,
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
          Container(
            width: 1,
            height: AppSpacing.xxl,
            color: colors.border,
          ),
          Expanded(
            child: TemperatureColumn(
              label: l10n.cooling,
              temperature: coolingTemp,
              icon: Icons.ac_unit,
              color: AppColors.accent,
              isPowered: true,
              compact: true,
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
      ),
    );
  }
}

/// Слайдер скорости вентилятора
class _FanSliderRow extends StatelessWidget {
  const _FanSliderRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onChanged,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.cardLight,
        borderRadius: BorderRadius.circular(AppRadius.nested),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: _DialogConstants.fanSliderIconSize,
                    color: color,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: _DialogConstants.fanSliderLabelSize,
                      fontWeight: FontWeight.w500,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
              Text(
                '$value%',
                style: TextStyle(
                  fontSize: _DialogConstants.fanSliderValueSize,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          BreezSlider(
            value: value.toDouble(),
            min: _DialogConstants.minFanSpeed.toDouble(),
            max: _DialogConstants.maxFanSpeed.toDouble(),
            activeColor: color,
            onChanged: (v) => onChanged(v.round()),
            semanticLabel: '$label: $value%',
          ),
        ],
      ),
    );
  }
}

/// Кнопки действий
class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.close,
            label: l10n.cancel,
            onTap: onCancel,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _PrimaryButton(
            label: l10n.save,
            onTap: onSave,
          ),
        ),
      ],
    );
  }
}

/// Кнопка действия (secondary)
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.nested),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: colors.cardLight,
            borderRadius: BorderRadius.circular(AppRadius.nested),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppSpacing.md, color: colors.text),
              const SizedBox(width: AppSpacing.xxs),
              Flexible(
                child: Text(
                  label,
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
    );
  }
}

/// Основная кнопка (акцентная)
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.nested),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(AppRadius.nested),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, size: AppSpacing.md, color: AppColors.black),
                const SizedBox(width: AppSpacing.xxs),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
