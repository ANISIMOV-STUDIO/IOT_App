/// Schedule Screen - Full schedule management
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../domain/entities/schedule_entry.dart';
import '../../bloc/schedule/schedule_bloc.dart';
import '../../widgets/breez/breez_card.dart';
import 'widgets/schedule_entry_dialog.dart';

/// Экран управления расписанием устройства
class ScheduleScreen extends StatelessWidget {
  final String deviceId;
  final String deviceName;

  const ScheduleScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.schedule,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.text,
              ),
            ),
            Text(
              deviceName,
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.accent),
            onPressed: () => _showAddDialog(context),
            tooltip: l10n.tooltipAdd,
          ),
        ],
      ),
      body: BlocConsumer<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            SnackBarUtils.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          if (state.status == ScheduleStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.entries.isEmpty) {
            return _EmptyState(onAdd: () => _showAddDialog(context));
          }

          return _ScheduleList(
            entries: state.entries,
            onEdit: (entry) => _showEditDialog(context, entry),
            onDelete: (entry) => _confirmDelete(context, entry),
            onToggle: (entry, isActive) {
              context.read<ScheduleBloc>().add(
                    ScheduleEntryToggled(
                      entryId: entry.id,
                      isActive: isActive,
                    ),
                  );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ScheduleEntryDialog(
        deviceId: deviceId,
        onSave: (entry) {
          context.read<ScheduleBloc>().add(ScheduleEntryAdded(entry));
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, ScheduleEntry entry) {
    showDialog(
      context: context,
      builder: (dialogContext) => ScheduleEntryDialog(
        deviceId: deviceId,
        entry: entry,
        onSave: (updatedEntry) {
          context.read<ScheduleBloc>().add(ScheduleEntryUpdated(updatedEntry));
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, ScheduleEntry entry) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.card,
        title: Text(
          l10n.scheduleDeleteConfirm,
          style: TextStyle(color: colors.text),
        ),
        content: Text(
          l10n.scheduleDeleteMessage('${entry.day} - ${entry.mode}'),
          style: TextStyle(color: colors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: colors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ScheduleBloc>().add(ScheduleEntryDeleted(entry.id));
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              l10n.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Список записей расписания
class _ScheduleList extends StatelessWidget {
  final List<ScheduleEntry> entries;
  final ValueChanged<ScheduleEntry> onEdit;
  final ValueChanged<ScheduleEntry> onDelete;
  final void Function(ScheduleEntry, bool) onToggle;

  const _ScheduleList({
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
          child: _ScheduleEntryCard(
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

/// Карточка записи расписания
class _ScheduleEntryCard extends StatelessWidget {
  final ScheduleEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const _ScheduleEntryCard({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  IconData _getModeIcon() {
    final mode = entry.mode.toLowerCase();
    if (mode == 'cooling') {
      return Icons.ac_unit;
    } else if (mode == 'heating') {
      return Icons.whatshot;
    } else if (mode == 'ventilation') {
      return Icons.air;
    } else if (mode == 'auto') {
      return Icons.autorenew;
    } else if (mode == 'eco') {
      return Icons.eco;
    } else {
      return Icons.thermostat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Day
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: entry.isActive
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : colors.buttonBg,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: Text(
                  entry.day,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: entry.isActive ? AppColors.accent : colors.text,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Time range
              Icon(
                Icons.access_time,
                size: 16,
                color: colors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                entry.timeRange,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textMuted,
                ),
              ),

              const Spacer(),

              // Toggle
              Switch(
                value: entry.isActive,
                onChanged: onToggle,
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

          const SizedBox(height: 12),

          // Mode and temperature row
          Row(
            children: [
              // Mode icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Icon(
                  _getModeIcon(),
                  size: 18,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),

              // Mode name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.mode,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colors.text,
                      ),
                    ),
                    Text(
                      l10n.scheduleDayNightTemp(entry.tempDay, entry.tempNight),
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons
              IconButton(
                icon: Icon(Icons.edit_outlined, color: colors.textMuted),
                onPressed: onEdit,
                tooltip: l10n.tooltipEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
                tooltip: l10n.tooltipDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Пустое состояние
class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: AppColors.accent.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.emptyNoScheduleTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.emptyNoScheduleMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(l10n.scheduleAdd),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
