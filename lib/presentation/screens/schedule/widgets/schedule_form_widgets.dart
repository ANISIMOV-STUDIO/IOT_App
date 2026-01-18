/// Schedule Form Widgets - Reusable form components for schedule dialogs
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../widgets/breez/breez_card.dart';
import '../../../widgets/breez/breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _ScheduleFormConstants {
  static const double labelFontSize = 12.0;
  static const double valueFontSize = 14.0;
  static const double headerFontSize = 18.0;
  static const double iconSize = 18.0;
}

/// Dropdown selector with label
class ScheduleDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const ScheduleDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: _ScheduleFormConstants.labelFontSize,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: colors.buttonBg,
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: colors.card,
            style: TextStyle(
              fontSize: _ScheduleFormConstants.valueFontSize,
              color: colors.text,
            ),
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// Time picker button with label
class ScheduleTimeButton extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  const ScheduleTimeButton({
    super.key,
    required this.label,
    required this.time,
    required this.onTap,
  });

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: _ScheduleFormConstants.labelFontSize,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        BreezButton(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: _ScheduleFormConstants.valueFontSize,
          ),
          backgroundColor: colors.buttonBg,
          hoverColor: colors.buttonHover,
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                size: _ScheduleFormConstants.iconSize,
                color: colors.textMuted,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _formatTime(time),
                style: TextStyle(
                  fontSize: _ScheduleFormConstants.valueFontSize,
                  color: colors.text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Temperature slider with label and value display
class ScheduleTemperatureSlider extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const ScheduleTemperatureSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 16,
    this.max = 30,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: _ScheduleFormConstants.labelFontSize,
                color: colors.textMuted,
              ),
            ),
            Text(
              '$value°C',
              style: const TextStyle(
                fontSize: _ScheduleFormConstants.valueFontSize,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: AppColors.accent,
          inactiveColor: colors.buttonBg,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Active toggle switch with label
class ScheduleActiveToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ScheduleActiveToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.buttonBg,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: _ScheduleFormConstants.valueFontSize,
              color: colors.text,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.accent,
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.white;
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }
}

/// Dialog header with icon and title
class ScheduleDialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const ScheduleDialogHeader({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Row(
      children: [
        Icon(icon, color: AppColors.accent),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: TextStyle(
            fontSize: _ScheduleFormConstants.headerFontSize,
            fontWeight: FontWeight.w600,
            color: colors.text,
          ),
        ),
      ],
    );
  }
}

/// Dialog action buttons (Cancel + Save/Add)
class ScheduleDialogActions extends StatelessWidget {
  final String cancelLabel;
  final String saveLabel;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const ScheduleDialogActions({
    super.key,
    required this.cancelLabel,
    required this.saveLabel,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BreezButton(
          onTap: onCancel,
          backgroundColor: Colors.transparent,
          hoverColor: colors.cardLight,
          pressedColor: colors.buttonBg,
          showBorder: false,
          semanticLabel: cancelLabel,
          child: Text(cancelLabel, style: TextStyle(color: colors.textMuted)),
        ),
        const SizedBox(width: AppSpacing.md),
        BreezButton(
          onTap: onSave,
          backgroundColor: AppColors.accent,
          hoverColor: AppColors.accentLight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lgx,
            vertical: AppSpacing.sm,
          ),
          enableGlow: true,
          semanticLabel: saveLabel,
          child: Text(
            saveLabel,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Shows time picker dialog with themed styling
Future<TimeOfDay?> showScheduleTimePicker(
  BuildContext context,
  TimeOfDay initialTime,
) {
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.accent,
            surface: BreezColors.of(context).card,
          ),
        ),
        child: child!,
      );
    },
  );
}
