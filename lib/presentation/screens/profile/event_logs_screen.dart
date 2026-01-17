/// Event Logs Screen - Журнал событий устройства для сервисных инженеров
///
/// Таблица с историей изменений настроек и аварий.
/// Доступна только для пользователей с ролью ServiceEngineer или Admin.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../data/api/http/clients/hvac_http_client.dart';
import '../../../domain/entities/device_event_log.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/devices/devices_bloc.dart';
import '../../widgets/breez/breez.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _LogsScreenConstants {
  static const double headerFontSize = 24.0;
  static const double tableFontSize = 12.0;
  static const double filterChipHeight = 36.0;
  static const int pageSize = 50;
}

// =============================================================================
// MAIN SCREEN
// =============================================================================

/// Экран журнала событий устройства
class EventLogsScreen extends StatefulWidget {
  const EventLogsScreen({super.key});

  @override
  State<EventLogsScreen> createState() => _EventLogsScreenState();
}

class _EventLogsScreenState extends State<EventLogsScreen> {
  PaginatedLogs? _logs;
  bool _isLoading = true;
  String? _error;
  int _currentOffset = 0;

  // Фильтр по типу события
  DeviceEventType? _filterType;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs({bool loadMore = false}) async {
    final devicesState = context.read<DevicesBloc>().state;
    final deviceId = devicesState.selectedDeviceId;

    if (deviceId == null) {
      setState(() {
        _error = 'No device selected';
        _isLoading = false;
      });
      return;
    }

    if (!loadMore) {
      setState(() {
        _isLoading = true;
        _error = null;
        _currentOffset = 0;
      });
    }

    try {
      final httpClient = GetIt.instance<HvacHttpClient>();
      final response = await httpClient.getDeviceLogs(
        deviceId,
        limit: _LogsScreenConstants.pageSize,
        offset: _currentOffset,
      );

      final newLogs = PaginatedLogs.fromJson(response);

      setState(() {
        if (loadMore && _logs != null) {
          _logs = PaginatedLogs(
            items: [..._logs!.items, ...newLogs.items],
            totalCount: newLogs.totalCount,
            limit: newLogs.limit,
            offset: _currentOffset,
          );
        } else {
          _logs = newLogs;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _loadMore() {
    if (_logs != null && _logs!.hasMore) {
      _currentOffset += _LogsScreenConstants.pageSize;
      _loadLogs(loadMore: true);
    }
  }

  void _setFilter(DeviceEventType? type) {
    setState(() {
      _filterType = type;
    });
  }

  List<DeviceEventLog> get _filteredLogs {
    if (_logs == null) return [];
    if (_filterType == null) return _logs!.items;
    return _logs!.items.where((log) => log.eventType == _filterType).toList();
  }

  void _showLogDetails(DeviceEventLog log) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm:ss', locale);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                _TypeBadge(log.eventType, l10n, colors),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    dateFormat.format(log.serverTimestamp),
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      color: colors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Details
            _DetailRow(l10n.logColumnCategory, _getCategoryName(log.category, l10n), colors),
            _DetailRow(l10n.logColumnProperty, log.property, colors),
            if (log.oldValue != null)
              _DetailRow(l10n.logColumnOldValue, log.oldValue!, colors),
            _DetailRow(l10n.logColumnNewValue, log.newValue, colors),
            if (log.description.isNotEmpty)
              _DetailRow(l10n.logColumnDescription, log.description, colors),

            const SizedBox(height: AppSpacing.lg),

            // Close button
            SizedBox(
              width: double.infinity,
              child: BreezButton(
                onTap: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(String category, AppLocalizations l10n) {
    final categoryMap = {
      'mode': l10n.logCategoryMode,
      'timer': l10n.logCategoryTimer,
      'alarm': l10n.logCategoryAlarm,
      'common': 'Общее',
    };
    return categoryMap[category.toLowerCase()] ?? category;
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.eventLogs,
          style: TextStyle(
            fontSize: _LogsScreenConstants.headerFontSize,
            fontWeight: FontWeight.bold,
            color: colors.text,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colors.text),
            onPressed: _isLoading ? null : _loadLogs,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          _FilterBar(
            selectedType: _filterType,
            onFilterChanged: _setFilter,
            colors: colors,
            l10n: l10n,
          ),

          // Content
          Expanded(child: _buildBody(colors, l10n)),
        ],
      ),
    );
  }

  Widget _buildBody(BreezColors colors, AppLocalizations l10n) {
    if (_isLoading && _logs == null) {
      return const Center(child: BreezLoader.large());
    }

    if (_error != null && _logs == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.critical),
            const SizedBox(height: AppSpacing.md),
            Text(
              _error!,
              style: TextStyle(color: colors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            BreezButton(
              onTap: _loadLogs,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final filteredLogs = _filteredLogs;

    if (filteredLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 48, color: colors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.logNoData,
              style: TextStyle(color: colors.textMuted),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Table
        Expanded(
          child: _LogsTable(
            logs: filteredLogs,
            colors: colors,
            l10n: l10n,
            onRowTap: _showLogDetails,
          ),
        ),

        // Pagination info + Load more
        _PaginationFooter(
          logs: _logs!,
          filteredCount: filteredLogs.length,
          isLoading: _isLoading,
          onLoadMore: _loadMore,
          colors: colors,
          l10n: l10n,
        ),
      ],
    );
  }
}

// =============================================================================
// FILTER BAR
// =============================================================================

class _FilterBar extends StatelessWidget {
  final DeviceEventType? selectedType;
  final ValueChanged<DeviceEventType?> onFilterChanged;
  final BreezColors colors;
  final AppLocalizations l10n;

  const _FilterBar({
    required this.selectedType,
    required this.onFilterChanged,
    required this.colors,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _LogsScreenConstants.filterChipHeight + AppSpacing.md * 2,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _FilterChip(
            label: 'Все',
            isSelected: selectedType == null,
            onTap: () => onFilterChanged(null),
            colors: colors,
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: l10n.logTypeSettings,
            isSelected: selectedType == DeviceEventType.settingsChange,
            onTap: () => onFilterChanged(DeviceEventType.settingsChange),
            colors: colors,
            activeColor: AppColors.accent,
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: l10n.logTypeAlarm,
            isSelected: selectedType == DeviceEventType.alarm,
            onTap: () => onFilterChanged(DeviceEventType.alarm),
            colors: colors,
            activeColor: AppColors.accentRed,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final BreezColors colors;
  final Color? activeColor;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.accent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _LogsScreenConstants.filterChipHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : colors.buttonBg,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: isSelected ? color : colors.border,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? color : colors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// LOGS TABLE
// =============================================================================

class _LogsTable extends StatelessWidget {
  final List<DeviceEventLog> logs;
  final BreezColors colors;
  final AppLocalizations l10n;
  final ValueChanged<DeviceEventLog> onRowTap;

  const _LogsTable({
    required this.logs,
    required this.colors,
    required this.l10n,
    required this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat('dd.MM.yy HH:mm', locale);

    return ListView.builder(
      key: PageStorageKey<int>(logs.length),
      itemCount: logs.length,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        final log = logs[index];
        return _LogRow(
          key: ValueKey(log.id),
          log: log,
          dateFormat: dateFormat,
          colors: colors,
          l10n: l10n,
          onTap: () => onRowTap(log),
        );
      },
    );
  }
}

class _LogRow extends StatelessWidget {
  final DeviceEventLog log;
  final DateFormat dateFormat;
  final BreezColors colors;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _LogRow({
    super.key,
    required this.log,
    required this.dateFormat,
    required this.colors,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAlarm = log.eventType == DeviceEventType.alarm;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isAlarm ? AppColors.accentRed.withValues(alpha: 0.08) : null,
          border: Border(
            bottom: BorderSide(color: colors.border.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            // Time
            SizedBox(
              width: 100,
              child: Text(
                dateFormat.format(log.serverTimestamp),
                style: TextStyle(
                  fontSize: _LogsScreenConstants.tableFontSize,
                  color: colors.textMuted,
                ),
              ),
            ),

            // Type badge
            _TypeBadge(log.eventType, l10n, colors),
            const SizedBox(width: AppSpacing.sm),

            // Property (main info)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    log.property,
                    style: TextStyle(
                      fontSize: _LogsScreenConstants.tableFontSize,
                      fontWeight: FontWeight.w500,
                      color: colors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (log.description.isNotEmpty)
                    Text(
                      log.description,
                      style: TextStyle(
                        fontSize: AppFontSizes.captionSmall,
                        color: colors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              size: 20,
              color: colors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// DETAIL ROW (for bottom sheet)
// =============================================================================

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final BreezColors colors;

  const _DetailRow(this.label, this.value, this.colors);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                color: colors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                color: colors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TYPE BADGE
// =============================================================================

class _TypeBadge extends StatelessWidget {
  final DeviceEventType type;
  final AppLocalizations l10n;
  final BreezColors colors;

  const _TypeBadge(this.type, this.l10n, this.colors);

  @override
  Widget build(BuildContext context) {
    final isAlarm = type == DeviceEventType.alarm;
    final color = isAlarm ? AppColors.accentRed : AppColors.accent;
    final text = isAlarm ? l10n.logTypeAlarm : l10n.logTypeSettings;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: _LogsScreenConstants.tableFontSize,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

// =============================================================================
// PAGINATION FOOTER
// =============================================================================

class _PaginationFooter extends StatelessWidget {
  final PaginatedLogs logs;
  final int filteredCount;
  final bool isLoading;
  final VoidCallback onLoadMore;
  final BreezColors colors;
  final AppLocalizations l10n;

  const _PaginationFooter({
    required this.logs,
    required this.filteredCount,
    required this.isLoading,
    required this.onLoadMore,
    required this.colors,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(
          top: BorderSide(color: colors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Count info
          Text(
            'Показано: $filteredCount из ${logs.totalCount}',
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: colors.textMuted,
            ),
          ),

          // Load more button
          if (logs.hasMore)
            isLoading
                ? const BreezLoader.small()
                : TextButton.icon(
                    onPressed: onLoadMore,
                    icon: const Icon(Icons.expand_more, size: 18),
                    label: Text(l10n.logLoadMore),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.accent,
                    ),
                  ),
        ],
      ),
    );
  }
}
