/// Event Logs Screen - Журнал событий устройства для сервисных инженеров
///
/// Использует BreezListCard.log() для отображения записей.
/// Доступна только для пользователей с ролью ServiceEngineer или Admin.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
// ignore: directives_ordering
import 'package:hvac_control/core/navigation/app_router.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/data/api/http/clients/hvac_http_client.dart';
import 'package:hvac_control/domain/entities/device_event_log.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/devices/devices_bloc.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_list_card.dart';
import 'package:intl/intl.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _LogsScreenConstants {
  static const double labelColumnWidth = 100;
  static const double closeButtonPadding = 6;
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
    if (_logs == null) {
      return [];
    }
    if (_filterType == null) {
      return _logs!.items;
    }
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

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.cardSmall)),
        side: BorderSide(color: colors.border),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
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
                    color: typeColor.withValues(alpha: AppColors.opacitySubtle),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
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
                // Close button
                BreezButton(
                  onTap: () => Navigator.pop(context),
                  enforceMinTouchTarget: false,
                  showBorder: false,
                  backgroundColor: colors.buttonBg.withValues(alpha: AppColors.opacityMedium),
                  hoverColor: colors.text.withValues(alpha: AppColors.opacitySubtle),
                  padding: const EdgeInsets.all(_LogsScreenConstants.closeButtonPadding),
                  semanticLabel: l10n.close,
                  child: Icon(
                    Icons.close,
                    size: AppIconSizes.standard,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Details
            _DetailRow(l10n.logColumnCategory, _getCategoryName(log.category, l10n), colors),
            _DetailRow(l10n.logColumnProperty, log.property, colors),
            if (log.oldValue != null)
              _DetailRow(l10n.logColumnOldValue, log.oldValue!, colors),
            _DetailRow(l10n.logColumnNewValue, log.newValue, colors),
            if (log.description.isNotEmpty)
              _DetailRow(l10n.logColumnDescription, log.description, colors),
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
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: BreezSectionHeader.screen(
                title: l10n.eventLogs,
                icon: Icons.history,
                backButton: BreezIconButton(
                  icon: Icons.arrow_back,
                  onTap: () => context.goToHomeTab(MainTab.profile),
                  size: AppIconSizes.standard,
                ),
                trailing: BreezIconButton(
                  icon: Icons.refresh,
                  onTap: _isLoading ? null : _loadLogs,
                  size: AppIconSizes.standard,
                ),
              ),
            ),

            // Filter chips
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
              ),
              child: BreezSegmentedControl<DeviceEventType?>(
                value: _filterType,
                segments: [
                  BreezSegment(
                    value: null,
                    label: l10n.filterAll,
                    icon: Icons.filter_list,
                  ),
                  BreezSegment(
                    value: DeviceEventType.settingsChange,
                    label: l10n.logTypeSettings,
                    icon: Icons.settings_outlined,
                  ),
                  BreezSegment(
                    value: DeviceEventType.alarm,
                    label: l10n.logTypeAlarm,
                    icon: Icons.warning_amber,
                  ),
                ],
                onChanged: _setFilter,
              ),
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
            Icon(
              Icons.error_outline,
              size: AppSpacing.xxl,
              color: AppColors.critical.withValues(alpha: AppColors.opacityMedium),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error!,
              style: TextStyle(color: colors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            BreezButton(
              onTap: _loadLogs,
              backgroundColor: AppColors.accent,
              hoverColor: AppColors.accentLight,
              showBorder: false,
              borderRadius: AppRadius.nested,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              enableGlow: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, size: AppSpacing.md, color: AppColors.black),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    l10n.retry,
                    style: const TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
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
// DETAIL ROW (for bottom sheet)
// =============================================================================

class _DetailRow extends StatelessWidget {

  const _DetailRow(this.label, this.value, this.colors);
  final String label;
  final String value;
  final BreezColors colors;

  @override
  Widget build(BuildContext context) => Padding(
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

// =============================================================================
// PAGINATION FOOTER
// =============================================================================

class _PaginationFooter extends StatelessWidget {

  const _PaginationFooter({
    required this.logs,
    required this.filteredCount,
    required this.isLoading,
    required this.onLoadMore,
    required this.colors,
    required this.l10n,
  });
  final PaginatedLogs logs;
  final int filteredCount;
  final bool isLoading;
  final VoidCallback onLoadMore;
  final BreezColors colors;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
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
                    backgroundColor: AppColors.accent.withValues(alpha: AppColors.opacitySubtle),
                    hoverColor: AppColors.accent.withValues(alpha: AppColors.opacityLow),
                    showBorder: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.expand_more,
                          size: AppIconSizes.standard,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(
                          l10n.logLoadMore,
                          style: const TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
        ],
      ),
    );
}
