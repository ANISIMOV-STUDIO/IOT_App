/// Home Screen
///
/// Modern smart home dashboard with live room view
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';
import '../../core/di/injection_container.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../widgets/room_preview_card.dart';
import '../widgets/activity_timeline.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/ventilation_mode.dart';
import '../../domain/entities/alert.dart';
import '../../domain/repositories/hvac_repository.dart';
import '../../domain/usecases/update_ventilation_mode.dart';
import '../../domain/usecases/update_fan_speeds.dart';
import '../widgets/ventilation_mode_control.dart';
import '../widgets/ventilation_temperature_control.dart';
import '../widgets/ventilation_schedule_control.dart';
import '../widgets/quick_presets_panel.dart';
import '../widgets/group_control_panel.dart';
import '../widgets/automation_panel.dart';
import '../../domain/entities/mode_preset.dart';
import '../../domain/entities/automation_rule.dart';
import '../../domain/usecases/apply_preset.dart';
import '../../domain/usecases/group_power_control.dart';
import '../../domain/usecases/sync_settings_to_all.dart';
import '../../domain/usecases/apply_schedule_to_all.dart';
import 'schedule_screen.dart';
import 'unit_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedUnit;
  bool _showAllNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/zilon-logo.svg',
                        height: 48,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFF9D5C), // Более яркий оранжевый
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),

                  // Center - HVAC Unit tabs (dynamic from units)
                  Expanded(
                    child: BlocBuilder<HvacListBloc, HvacListState>(
                      builder: (context, state) {
                        if (state is HvacListLoaded) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...state.units.map((unit) {
                                final label = unit.name;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: _buildUnitTab(
                                    label,
                                    _selectedUnit == label,
                                  ),
                                );
                              }),
                              // Add new unit button
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    // TODO: Navigate to add unit screen
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppTheme.backgroundCard,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.backgroundCardBorder,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 20,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  // User profile and Settings
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.settings_outlined,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppTheme.backgroundCard,
                        backgroundImage: null, // Add user avatar here
                        child: Icon(
                          Icons.person_outline,
                          size: 20,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: BlocBuilder<HvacListBloc, HvacListState>(
                builder: (context, state) {
                  if (state is HvacListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryOrange,
                      ),
                    );
                  }

                  if (state is HvacListError) {
                    return _buildError(context, state.message);
                  }

                  if (state is HvacListLoaded) {
                    return _buildDashboard(context, state.units);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitTab(String label, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _selectedUnit = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.backgroundCard : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.backgroundCardBorder : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.error,
          ),
          const SizedBox(height: 24),
          Text(
            'Connection Error',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, List<HvacUnit> units) {
    // Initialize selected unit if not set
    if (_selectedUnit == null && units.isNotEmpty) {
      _selectedUnit = units.first.name;
    }

    // Find unit matching selected tab, or use first unit as fallback
    HvacUnit? currentUnit;
    try {
      currentUnit = units.firstWhere(
        (unit) => unit.name == _selectedUnit || unit.location == _selectedUnit,
      );
    } catch (e) {
      currentUnit = units.isNotEmpty ? units.first : null;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), // Добавлен нижний отступ 20
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content area
          Expanded(
            flex: 7,
            child: Column(
              children: [
                // Unit preview with live feed
                RoomPreviewCard(
                  roomName: currentUnit?.location ?? _selectedUnit ?? 'Unit',
                  isLive: currentUnit?.power ?? false,
                  onPowerChanged: (power) {
                    if (currentUnit != null) {
                      _updatePower(currentUnit, power);
                    }
                  },
                  onDetailsPressed: currentUnit != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UnitDetailScreen(unit: currentUnit!),
                            ),
                          );
                        }
                      : null,
                  badges: currentUnit != null && currentUnit.isVentilation
                      ? [
                          StatusBadge(
                            icon: Icons.air,
                            value: currentUnit.ventMode?.displayName ?? 'Авто',
                          ),
                          StatusBadge(
                            icon: Icons.thermostat,
                            value:
                                '${currentUnit.supplyAirTemp?.toInt() ?? 0}°C',
                          ),
                          StatusBadge(
                            icon: Icons.water_drop,
                            value: '${currentUnit.humidity.toInt()}%',
                          ),
                          StatusBadge(
                            icon: Icons.speed,
                            value: '${currentUnit.supplyFanSpeed ?? 0}%',
                          ),
                        ]
                      : [
                          StatusBadge(
                            icon: Icons.thermostat,
                            value: currentUnit?.fanSpeed ?? "auto",
                          ),
                          StatusBadge(
                            icon: Icons.water_drop,
                            value: '${currentUnit?.humidity.toInt() ?? 0}%',
                          ),
                          StatusBadge(
                            icon: Icons.thermostat,
                            value: '${currentUnit?.currentTemp.toInt() ?? 21}°C',
                          ),
                          const StatusBadge(
                            icon: Icons.bolt,
                            value: '350W',
                          ),
                        ],
                ),

                const SizedBox(height: 20),

                // Ventilation control cards
                currentUnit != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mode and Fan Control
                          Expanded(
                            child: VentilationModeControl(
                              unit: currentUnit,
                              onModeChanged: (mode) {
                                if (currentUnit != null) {
                                  _updateVentilationMode(currentUnit, mode);
                                }
                              },
                              onSupplyFanChanged: (speed) {
                                if (currentUnit != null) {
                                  _updateFanSpeeds(
                                    currentUnit,
                                    supplySpeed: speed,
                                  );
                                }
                              },
                              onExhaustFanChanged: (speed) {
                                if (currentUnit != null) {
                                  _updateFanSpeeds(
                                    currentUnit,
                                    exhaustSpeed: speed,
                                  );
                                }
                              },
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Temperature Control
                          Expanded(
                            child: VentilationTemperatureControl(
                              unit: currentUnit,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Schedule Control
                          Expanded(
                            child: VentilationScheduleControl(
                              unit: currentUnit,
                              onSchedulePressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScheduleScreen(unit: currentUnit!),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          'Устройство не выбрано',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),

                const SizedBox(height: 20),

                // Automation panel
                if (currentUnit != null)
                  AutomationPanel(
                    rules: AutomationRule.defaults,
                    onRuleToggled: (rule) {
                      // Handle rule toggle
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${rule.name} ${rule.enabled ? "активировано" : "деактивировано"}',
                          ),
                          backgroundColor: AppTheme.success,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    onManageRules: () {
                      // Navigate to automation management screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Управление правилами (в разработке)'),
                          backgroundColor: AppTheme.info,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),

                const Spacer(),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Right sidebar with presets, group control and notifications
          SizedBox(
            width: 320,
            child: BlocBuilder<HvacListBloc, HvacListState>(
              builder: (context, state) {
                if (state is HvacListLoaded && currentUnit != null) {
                  return Column(
                    children: [
                      // Quick presets panel
                      QuickPresetsPanel(
                        onPresetSelected: (preset) {
                          _applyPreset(currentUnit!, preset);
                        },
                      ),

                      const SizedBox(height: 20),

                      // Group control panel
                      if (state.units.length > 1)
                        GroupControlPanel(
                          units: state.units,
                          onPowerAllOn: _powerAllOn,
                          onPowerAllOff: _powerAllOff,
                          onSyncSettings: () => _syncSettings(currentUnit!),
                          onApplyScheduleToAll: () => _applyScheduleToAll(currentUnit!),
                        ),

                      if (state.units.length > 1)
                        const SizedBox(height: 20),

                      // Notifications panel
                      Expanded(
                        child: _buildNotificationsPanel(currentUnit),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsPanel(HvacUnit unit) {
    final now = DateTime.now();

    // Группируем уведомления по важности
    final critical = <ActivityItem>[];
    final errors = <ActivityItem>[];
    final warnings = <ActivityItem>[];
    final info = <ActivityItem>[];

    // Добавляем уведомления об авариях
    if (unit.alerts != null && unit.alerts!.isNotEmpty) {
      for (final alert in unit.alerts!) {
        if (alert.code != 0) {
          final severity = _mapAlertSeverityToNotification(alert.severity);
          final activity = ActivityItem(
            time: alert.timestamp != null
                ? '${alert.timestamp!.hour.toString().padLeft(2, '0')}:${alert.timestamp!.minute.toString().padLeft(2, '0')}'
                : '--:--',
            title: 'Авария: код ${alert.code}',
            description: alert.description,
            severity: severity,
            icon: _getSeverityIcon(severity),
          );

          switch (severity) {
            case NotificationSeverity.critical:
              critical.add(activity);
              break;
            case NotificationSeverity.error:
              errors.add(activity);
              break;
            case NotificationSeverity.warning:
              warnings.add(activity);
              break;
            case NotificationSeverity.info:
              info.add(activity);
              break;
          }
        }
      }
    }

    // Добавляем информацию о работе
    if (unit.power) {
      info.add(ActivityItem(
        time: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        title: '${unit.name} работает',
        description: 'Режим: ${unit.ventMode?.displayName ?? "Авто"}',
        severity: NotificationSeverity.info,
        icon: Icons.power_settings_new,
      ));
    }

    // Добавляем информацию о расписании
    final todaySchedule = unit.schedule?.getDaySchedule(now.weekday);
    if (todaySchedule != null && todaySchedule.timerEnabled) {
      if (todaySchedule.turnOnTime != null) {
        info.add(ActivityItem(
          time:
              '${todaySchedule.turnOnTime!.hour.toString().padLeft(2, '0')}:${todaySchedule.turnOnTime!.minute.toString().padLeft(2, '0')}',
          title: 'Запланированное включение',
          description: 'Автоматический запуск по расписанию',
          severity: NotificationSeverity.info,
          icon: Icons.schedule,
        ));
      }
    }

    final totalCount = critical.length + errors.length + warnings.length + info.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Уведомления',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalCount',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Счётчики по категориям
          if (totalCount > 0)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (critical.isNotEmpty)
                  _buildCategoryBadge('Критические', critical.length, AppTheme.error),
                if (errors.isNotEmpty)
                  _buildCategoryBadge('Ошибки', errors.length, const Color(0xFFE57373)),
                if (warnings.isNotEmpty)
                  _buildCategoryBadge('Предупреждения', warnings.length, AppTheme.warning),
                if (info.isNotEmpty)
                  _buildCategoryBadge('Инфо', info.length, AppTheme.info),
              ],
            ),

          const SizedBox(height: 20),

          // Уведомления
          if (totalCount == 0)
            _buildEmptyState()
          else
            ..._buildGroupedNotifications(critical, errors, warnings, info),

          // Кнопка "Показать всё"
          if (totalCount > 3 && !_showAllNotifications)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllNotifications = true;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Показать все ($totalCount)',
                        style: const TextStyle(
                          color: AppTheme.primaryOrange,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.expand_more,
                        color: AppTheme.primaryOrange,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Кнопка "Свернуть"
          if (_showAllNotifications && totalCount > 3)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllNotifications = false;
                    });
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Свернуть',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.expand_less,
                        color: AppTheme.textSecondary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  NotificationSeverity _mapAlertSeverityToNotification(AlertSeverity alertSeverity) {
    switch (alertSeverity) {
      case AlertSeverity.critical:
        return NotificationSeverity.critical;
      case AlertSeverity.error:
        return NotificationSeverity.error;
      case AlertSeverity.warning:
        return NotificationSeverity.warning;
      case AlertSeverity.info:
        return NotificationSeverity.info;
    }
  }

  IconData _getSeverityIcon(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.critical:
        return Icons.error;
      case NotificationSeverity.error:
        return Icons.error_outline;
      case NotificationSeverity.warning:
        return Icons.warning;
      case NotificationSeverity.info:
        return Icons.info_outline;
    }
  }

  Widget _buildCategoryBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(
              Icons.notifications_none,
              size: 48,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'Нет уведомлений',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Все системы работают нормально',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupedNotifications(
    List<ActivityItem> critical,
    List<ActivityItem> errors,
    List<ActivityItem> warnings,
    List<ActivityItem> info,
  ) {
    final widgets = <Widget>[];
    int itemCount = 0;
    final maxItems = _showAllNotifications ? 1000 : 3;

    // Добавляем критические
    for (final activity in critical) {
      if (itemCount >= maxItems) break;
      widgets.add(_buildActivityItem(activity));
      itemCount++;
    }

    // Добавляем ошибки
    for (final activity in errors) {
      if (itemCount >= maxItems) break;
      widgets.add(_buildActivityItem(activity));
      itemCount++;
    }

    // Добавляем предупреждения
    for (final activity in warnings) {
      if (itemCount >= maxItems) break;
      widgets.add(_buildActivityItem(activity));
      itemCount++;
    }

    // Добавляем информационные
    for (final activity in info) {
      if (itemCount >= maxItems) break;
      widgets.add(_buildActivityItem(activity));
      itemCount++;
    }

    return widgets;
  }

  Widget _buildActivityItem(ActivityItem activity) {
    final severityColor = _getSeverityColor(activity.severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon with severity color
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity.icon ?? Icons.notifications,
              size: 18,
              color: severityColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      activity.time,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: severityColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.critical:
        return AppTheme.error;
      case NotificationSeverity.error:
        return const Color(0xFFE57373);
      case NotificationSeverity.warning:
        return AppTheme.warning;
      case NotificationSeverity.info:
        return AppTheme.info;
    }
  }

  /// Update power state
  Future<void> _updatePower(HvacUnit unit, bool power) async {
    if (!mounted) return;

    try {
      final updatedUnit = unit.copyWith(power: power);
      final repository = sl<HvacRepository>();
      await repository.updateUnitEntity(updatedUnit);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка изменения питания: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  /// Update ventilation mode
  Future<void> _updateVentilationMode(HvacUnit unit, VentilationMode mode) async {
    if (!mounted) return;

    try {
      final updateModeUseCase = sl<UpdateVentilationMode>();
      await updateModeUseCase(unit.id, mode);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка обновления режима: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  /// Update fan speeds
  Future<void> _updateFanSpeeds(
    HvacUnit unit, {
    int? supplySpeed,
    int? exhaustSpeed,
  }) async {
    if (!mounted) return;

    try {
      final updateFanSpeedsUseCase = sl<UpdateFanSpeeds>();
      await updateFanSpeedsUseCase.call(
        unitId: unit.id,
        supplyFanSpeed: supplySpeed,
        exhaustFanSpeed: exhaustSpeed,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка обновления скорости вентилятора: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  /// Apply preset
  Future<void> _applyPreset(HvacUnit unit, ModePreset preset) async {
    if (!mounted) return;

    try {
      final applyPresetUseCase = sl<ApplyPreset>();
      await applyPresetUseCase(unit.id, preset);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Применён режим: ${preset.mode.displayName}'),
            backgroundColor: AppTheme.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка применения пресета: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  /// Power on all units
  Future<void> _powerAllOn() async {
    if (!mounted) return;

    try {
      final groupPowerControl = sl<GroupPowerControl>();
      await groupPowerControl.powerOnAll();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Все установки включены'),
            backgroundColor: AppTheme.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка включения установок: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  /// Power off all units
  Future<void> _powerAllOff() async {
    if (!mounted) return;

    try {
      final groupPowerControl = sl<GroupPowerControl>();
      await groupPowerControl.powerOffAll();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Все установки выключены'),
            backgroundColor: AppTheme.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка выключения установок: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  /// Sync settings to all units
  Future<void> _syncSettings(HvacUnit sourceUnit) async {
    if (!mounted) return;

    try {
      final syncSettingsUseCase = sl<SyncSettingsToAll>();
      await syncSettingsUseCase(sourceUnit.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Настройки синхронизированы со всеми установками'),
            backgroundColor: AppTheme.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка синхронизации: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  /// Apply schedule to all units
  Future<void> _applyScheduleToAll(HvacUnit sourceUnit) async {
    if (!mounted) return;

    try {
      final applyScheduleUseCase = sl<ApplyScheduleToAll>();
      await applyScheduleUseCase(sourceUnit.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Расписание применено ко всем установкам'),
            backgroundColor: AppTheme.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка применения расписания: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }
}
