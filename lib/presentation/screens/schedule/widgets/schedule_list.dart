/// Schedule List - List view of schedule entries
library;

// Callback typedef uses positional bool for Widget consistency with Flutter patterns
// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';

import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/schedule_entry.dart';
import 'package:hvac_control/presentation/screens/schedule/widgets/schedule_entry_card.dart';

/// Список записей расписания
class ScheduleList extends StatelessWidget {

  const ScheduleList({
    required this.entries,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    super.key,
  });
  final List<ScheduleEntry> entries;
  final ValueChanged<ScheduleEntry> onEdit;
  final ValueChanged<ScheduleEntry> onDelete;
  final void Function(ScheduleEntry, bool) onToggle;

  @override
  Widget build(BuildContext context) => ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ScheduleEntryCard(
            entry: entry,
            onEdit: () => onEdit(entry),
            onDelete: () => onDelete(entry),
            onToggle: (isActive) => onToggle(entry, isActive),
          ),
        );
      },
    );
}
