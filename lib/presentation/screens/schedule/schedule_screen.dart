/// Schedule Screen - Full schedule management
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../widgets/breez/breez_button.dart';
import '../../bloc/schedule/schedule_bloc.dart';
import '../../widgets/breez/schedule_widget.dart';
import 'widgets/schedule_entry_dialog.dart';
import 'widgets/schedule_empty_state.dart';
import 'widgets/schedule_list.dart';

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
      appBar: _buildAppBar(colors, l10n, context),
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
            return ScheduleEmptyState(onAdd: () => _showAddDialog(context));
          }

          return ScheduleList(
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
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  AppBar _buildAppBar(BreezColors colors, AppLocalizations l10n, BuildContext context) {
    return AppBar(
      backgroundColor: colors.card,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.schedule,
            style: TextStyle(
              fontSize: AppFontSizes.h3,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
          ),
          Text(
            deviceName,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
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
          l10n.scheduleDeleteMessage('${ScheduleWidget.translateDayName(entry.day, l10n)} - ${entry.mode}'),
          style: TextStyle(color: colors.textMuted),
        ),
        actions: [
          BreezButton(
            onTap: () => Navigator.of(dialogContext).pop(),
            backgroundColor: Colors.transparent,
            showBorder: false,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: colors.textMuted),
            ),
          ),
          BreezButton(
            onTap: () {
              context.read<ScheduleBloc>().add(ScheduleEntryDeleted(entry.id));
              Navigator.of(dialogContext).pop();
            },
            backgroundColor: Colors.transparent,
            showBorder: false,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
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
