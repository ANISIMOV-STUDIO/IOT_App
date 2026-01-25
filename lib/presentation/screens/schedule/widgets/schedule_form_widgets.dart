/// Schedule Form Widgets - Reusable form components for schedule dialogs
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';

/// Dropdown selector with label
class ScheduleDropdown extends StatelessWidget {

  const ScheduleDropdown({
    required this.label, required this.value, required this.items, required this.onChanged, super.key,
  });
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
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
              fontSize: AppFontSizes.body,
              color: colors.text,
            ),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// Time picker button with label
class ScheduleTimeButton extends StatelessWidget {

  const ScheduleTimeButton({
    required this.label, required this.time, required this.onTap, super.key,
  });
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  String _formatTime(TimeOfDay time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        BreezButton(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppFontSizes.body,
          ),
          backgroundColor: colors.buttonBg,
          hoverColor: colors.buttonHover,
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                size: AppIconSizes.standard,
                color: colors.textMuted,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _formatTime(time),
                style: TextStyle(
                  fontSize: AppFontSizes.body,
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

  const ScheduleTemperatureSlider({
    required this.label, required this.value, required this.onChanged, super.key,
    this.min = 16,
    this.max = 30,
  });
  final String label;
  final int value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

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
                fontSize: AppFontSizes.caption,
                color: colors.textMuted,
              ),
            ),
            Text(
              '$value°C',
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: FontWeight.w600,
                color: colors.accent,
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: colors.accent,
          inactiveColor: colors.buttonBg,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Active toggle switch with label
class ScheduleActiveToggle extends StatelessWidget {

  const ScheduleActiveToggle({
    required this.label, required this.value, required this.onChanged, super.key,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

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
              fontSize: AppFontSizes.body,
              color: colors.text,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: colors.accent,
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

  const ScheduleDialogHeader({
    required this.icon, required this.title, super.key,
  });
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Row(
      children: [
        Icon(icon, color: colors.accent),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.h3Small,
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

  const ScheduleDialogActions({
    required this.cancelLabel, required this.saveLabel, required this.onCancel, required this.onSave, super.key,
  });
  final String cancelLabel;
  final String saveLabel;
  final VoidCallback onCancel;
  final VoidCallback onSave;

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
          backgroundColor: colors.accent,
          hoverColor: colors.accentLight,
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
  final colors = BreezColors.of(context);
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: colors.accent,
            surface: colors.card,
          ),
        ),
        child: child!,
      ),
  );
}
