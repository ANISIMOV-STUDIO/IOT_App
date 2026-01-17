/// Event Logs Screen - Журнал событий устройства для сервисных инженеров
///
/// Использует BreezListCard.log() для отображения записей.
/// Доступна только для пользователей с ролью ServiceEngineer или Admin.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
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
  static const double labelColumnWidth = 100.0;
  static const double smallIconSize = 18.0;
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

    final isAlarm = log.eventType == DeviceEventType.alarm;
    final typeColor = isAlarm ? AppColors.accentRed : AppColors.accent;
    final typeText = isAlarm ? l10n.logTypeAlarm : l10n.logTypeSettings;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                // Type badge inline
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.xxs),
                  ),
                  child: Text(
                    typeText,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: FontWeight.w500,
                      color: typeColor,
                    ),
                  ),
                ),
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
      body: SafeArea(
        child: Column(
          children: [
            // Header (кастомный, как в profile_screen)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  BreezIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.goToHomeTab(MainTab.profile),
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.eventLogs,
                      style: TextStyle(
                        fontSize: AppFontSizes.h2,
                        fontWeight: FontWeight.bold,
                        color: colors.text,
                      ),
                    ),
                  ),
                  BreezIconButton(
                    icon: Icons.refresh,
                    onTap: _isLoading ? null : _loadLogs,
                    size: 24,
                  ),
                ],
              ),
            ),

            // Filter chips
            _FilterBar(
              selectedType: _filterType,
              onFilterChanged: _setFilter,
              l10n: l10n,
            ),

            // Content
            Expanded(child: _buildBody(colors, l10n)),
          ],
        ),
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
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat('dd.MM.yy HH:mm', locale);

    if (filteredLogs.isEmpty) {
      return BreezEmptyState(
        icon: Icons.history,
        title: l10n.logNoData,
        subtitle: l10n.logNoDataHint,
      );
    }

    return Column(
      children: [
        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            itemCount: filteredLogs.length,
            cacheExtent: 500,
            itemBuilder: (context, index) {
              final log = filteredLogs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: BreezListCard.log(
                  key: ValueKey(log.id),
                  log: log,
                  formattedTime: dateFormat.format(log.serverTimestamp),
                  onTap: () => _showLogDetails(log),
                ),
              );
            },
          ),
        ),

        // Pagination footer
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
// FILTER BAR (по паттерну MobileTabBar)
// =============================================================================

/// Константы фильтр-бара (как в MobileTabBar)
abstract class _FilterBarConstants {
  static const double height = 36.0;
  static const double iconSize = 14.0;
  static const double fontSize = 11.0;
  static const double segmentPadding = 3.0;
}

/// Данные фильтра
class _FilterOption {
  final DeviceEventType? value;
  final IconData icon;
  final String label;

  const _FilterOption({
    required this.value,
    required this.icon,
    required this.label,
  });
}

class _FilterBar extends StatelessWidget {
  final DeviceEventType? selectedType;
  final ValueChanged<DeviceEventType?> onFilterChanged;
  final AppLocalizations l10n;

  const _FilterBar({
    required this.selectedType,
    required this.onFilterChanged,
    required this.l10n,
  });

  List<_FilterOption> _buildOptions() => [
        _FilterOption(value: null, icon: Icons.filter_list, label: l10n.filterAll),
        _FilterOption(value: DeviceEventType.settingsChange, icon: Icons.settings_outlined, label: l10n.logTypeSettings),
        _FilterOption(value: DeviceEventType.alarm, icon: Icons.warning_amber, label: l10n.logTypeAlarm),
      ];

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final options = _buildOptions();

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Container(
        height: _FilterBarConstants.height,
        padding: const EdgeInsets.all(_FilterBarConstants.segmentPadding),
        decoration: BoxDecoration(
          color: colors.buttonBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        child: Row(
          children: options.map((option) {
            final isSelected = selectedType == option.value;
            return Expanded(
              child: _FilterSegment(
                option: option,
                isSelected: isSelected,
                onTap: () => onFilterChanged(option.value),
                colors: colors,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Кнопка-сегмент фильтра (как _SegmentButton в MobileTabBar)
class _FilterSegment extends StatelessWidget {
  final _FilterOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final BreezColors colors;

  const _FilterSegment({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected ? AppColors.accent : colors.textMuted;

    return Semantics(
      label: option.label,
      selected: isSelected,
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accent.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: isSelected
                ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  option.icon,
                  size: _FilterBarConstants.iconSize,
                  color: textColor,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  option.label,
                  style: TextStyle(
                    fontSize: _FilterBarConstants.fontSize,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
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
            width: _LogsScreenConstants.labelColumnWidth,
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
            l10n.logShowing(filteredCount, logs.totalCount),
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: colors.textMuted,
            ),
          ),

          // Load more button
          if (logs.hasMore)
            isLoading
                ? const BreezLoader.small()
                : BreezButton(
                    onTap: onLoadMore,
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.expand_more,
                          size: _LogsScreenConstants.smallIconSize,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(
                          l10n.logLoadMore,
                          style: const TextStyle(color: AppColors.accent),
                        ),
                      ],
                    ),
                  ),
        ],
      ),
    );
  }
}
