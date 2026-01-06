/// Schedule List - List view of schedule entries
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/schedule_entry.dart';
import 'schedule_entry_card.dart';

/// Список записей расписания
class ScheduleList extends StatelessWidget {
  final List<ScheduleEntry> entries;
  final ValueChanged<ScheduleEntry> onEdit;
  final ValueChanged<ScheduleEntry> onDelete;
  final void Function(ScheduleEntry, bool) onToggle;

  const ScheduleList({
    super.key,
    required this.entries,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
}
