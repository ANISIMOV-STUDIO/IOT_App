/// Breez Time Picker - кастомный выбор времени в стиле приложения
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n/app_localizations.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _TimePickerConstants {
  static const double dialogWidth = 280.0;
  static const double wheelHeight = 150.0;
  static const double itemExtent = 50.0;
  static const double selectedFontSize = 32.0;
  static const double unselectedFontSize = 20.0;
  static const double colonFontSize = 32.0;
}

// =============================================================================
// PUBLIC API
// =============================================================================

/// Показать кастомный time picker в стиле Breez
Future<TimeOfDay?> showBreezTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) {
  return showDialog<TimeOfDay>(
    context: context,
    builder: (context) => _BreezTimePickerDialog(initialTime: initialTime),
  );
}

// =============================================================================
// DIALOG
// =============================================================================

class _BreezTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;

  const _BreezTimePickerDialog({required this.initialTime});

  @override
  State<_BreezTimePickerDialog> createState() => _BreezTimePickerDialogState();
}

class _BreezTimePickerDialogState extends State<_BreezTimePickerDialog> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop(TimeOfDay(hour: _selectedHour, minute: _selectedMinute));
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: colors.border),
      ),
      child: Container(
        width: _TimePickerConstants.dialogWidth,
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              l10n.selectTime,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: FontWeight.w500,
                color: colors.textMuted,
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // Time wheels
            SizedBox(
              height: _TimePickerConstants.wheelHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hours wheel
                  SizedBox(
                    width: 80,
                    child: _TimeWheel(
                      controller: _hourController,
                      itemCount: 24,
                      onChanged: (value) {
                        setState(() => _selectedHour = value);
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),

                  // Colon separator
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: _TimePickerConstants.colonFontSize,
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                  ),

                  // Minutes wheel
                  SizedBox(
                    width: 80,
                    child: _TimeWheel(
                      controller: _minuteController,
                      itemCount: 60,
                      onChanged: (value) {
                        setState(() => _selectedMinute = value);
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.md),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    label: l10n.cancel,
                    onTap: _onCancel,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _DialogButton(
                    label: l10n.confirm,
                    isPrimary: true,
                    onTap: _onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TIME WHEEL
// =============================================================================

class _TimeWheel extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final ValueChanged<int> onChanged;

  const _TimeWheel({
    required this.controller,
    required this.itemCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.card,
            Colors.transparent,
            Colors.transparent,
            colors.card,
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstOut,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _TimePickerConstants.itemExtent,
        perspective: 0.005,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            return _WheelItem(
              value: index,
              controller: controller,
            );
          },
        ),
      ),
    );
  }
}

class _WheelItem extends StatelessWidget {
  final int value;
  final FixedExtentScrollController controller;

  const _WheelItem({
    required this.value,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final selected = controller.selectedItem == value;

        return Container(
          alignment: Alignment.center,
          decoration: selected
              ? BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3),
                  ),
                )
              : null,
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: selected
                  ? _TimePickerConstants.selectedFontSize
                  : _TimePickerConstants.unselectedFontSize,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? AppColors.accent : colors.textMuted,
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// DIALOG BUTTON
// =============================================================================

class _DialogButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _DialogButton({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.accent : colors.buttonBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: FontWeight.w600,
                color: isPrimary ? AppColors.black : colors.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
