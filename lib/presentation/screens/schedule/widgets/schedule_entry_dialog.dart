/// Schedule Entry Dialog - Add/Edit schedule entry
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/schedule_entry.dart';

/// Диалог добавления/редактирования записи расписания
class ScheduleEntryDialog extends StatefulWidget {
  final String deviceId;
  final ScheduleEntry? entry;
  final ValueChanged<ScheduleEntry> onSave;

  const ScheduleEntryDialog({
    super.key,
    required this.deviceId,
    this.entry,
    required this.onSave,
  });

  @override
  State<ScheduleEntryDialog> createState() => _ScheduleEntryDialogState();
}

class _ScheduleEntryDialogState extends State<ScheduleEntryDialog> {
  late String _selectedDay;
  late String _selectedMode;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late int _tempDay;
  late int _tempNight;
  late bool _isActive;

  static const List<String> _days = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье',
  ];

  static const List<String> _modes = [
    'Авто',
    'Охлаждение',
    'Нагрев',
    'Вентиляция',
    'Эко',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _selectedDay = widget.entry!.day;
      _selectedMode = widget.entry!.mode;
      _parseTimeRange(widget.entry!.timeRange);
      _tempDay = widget.entry!.tempDay;
      _tempNight = widget.entry!.tempNight;
      _isActive = widget.entry!.isActive;
    } else {
      _selectedDay = _days[0];
      _selectedMode = _modes[0];
      _startTime = const TimeOfDay(hour: 8, minute: 0);
      _endTime = const TimeOfDay(hour: 22, minute: 0);
      _tempDay = 22;
      _tempNight = 18;
      _isActive = true;
    }
  }

  void _parseTimeRange(String timeRange) {
    try {
      final parts = timeRange.split(' - ');
      if (parts.length == 2) {
        _startTime = _parseTime(parts[0]);
        _endTime = _parseTime(parts[1]);
      } else {
        _startTime = const TimeOfDay(hour: 8, minute: 0);
        _endTime = const TimeOfDay(hour: 22, minute: 0);
      }
    } catch (e) {
      _startTime = const TimeOfDay(hour: 8, minute: 0);
      _endTime = const TimeOfDay(hour: 22, minute: 0);
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getTimeRange() {
    return '${_formatTime(_startTime)} - ${_formatTime(_endTime)}';
  }

  void _save() {
    final entry = ScheduleEntry(
      id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      deviceId: widget.deviceId,
      day: _selectedDay,
      mode: _selectedMode,
      timeRange: _getTimeRange(),
      tempDay: _tempDay,
      tempNight: _tempNight,
      isActive: _isActive,
    );
    widget.onSave(entry);
  }

  Future<void> _pickTime(bool isStart) async {
    final initialTime = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
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

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isEditing = widget.entry != null;

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  isEditing ? Icons.edit : Icons.add,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 12),
                Text(
                  isEditing ? 'Редактировать запись' : 'Новая запись',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colors.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Day selector
            _buildDropdown(
              label: 'День недели',
              value: _selectedDay,
              items: _days,
              onChanged: (value) => setState(() => _selectedDay = value!),
            ),
            const SizedBox(height: AppSpacing.md),

            // Time range
            Row(
              children: [
                Expanded(
                  child: _buildTimeButton(
                    label: 'Начало',
                    time: _startTime,
                    onTap: () => _pickTime(true),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildTimeButton(
                    label: 'Конец',
                    time: _endTime,
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Mode selector
            _buildDropdown(
              label: 'Режим',
              value: _selectedMode,
              items: _modes,
              onChanged: (value) => setState(() => _selectedMode = value!),
            ),
            const SizedBox(height: AppSpacing.md),

            // Temperature sliders
            _buildTemperatureSlider(
              label: 'Дневная температура',
              value: _tempDay,
              onChanged: (value) => setState(() => _tempDay = value.round()),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildTemperatureSlider(
              label: 'Ночная температура',
              value: _tempNight,
              onChanged: (value) => setState(() => _tempNight = value.round()),
            ),
            const SizedBox(height: AppSpacing.md),

            // Active toggle
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.buttonBg,
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Активно',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.text,
                    ),
                  ),
                  Switch(
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                    activeTrackColor: AppColors.accent,
                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return null;
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Отмена',
                    style: TextStyle(color: colors.textMuted),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(isEditing ? 'Сохранить' : 'Добавить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final colors = BreezColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
              fontSize: 14,
              color: colors.text,
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeButton({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    final colors = BreezColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: colors.buttonBg,
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: colors.textMuted,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(time),
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureSlider({
    required String label,
    required int value,
    required ValueChanged<double> onChanged,
  }) {
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
                fontSize: 12,
                color: colors.textMuted,
              ),
            ),
            Text(
              '$value°C',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 16,
          max: 30,
          divisions: 14,
          activeColor: AppColors.accent,
          inactiveColor: colors.buttonBg,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
