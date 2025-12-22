/// Main dashboard screen - modular architecture with Device/Global zone separation
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';

import '../../../core/l10n/l10n.dart';
import '../../../domain/entities/app_notification.dart';
import '../../../domain/entities/climate.dart';
import '../../../domain/entities/device_schedule.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../widgets/common/common.dart';
import '../../widgets/device_zone/device_zone.dart';
import '../../widgets/devices/device_switcher_card.dart';
import '../../widgets/global_zone/global_zone.dart';

/// Main dashboard screen with Device Zone / Global Zone architecture
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const L10nProvider(
      child: _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  int _navIndex = 0;

  List<NeumorphicNavItem> _navItems(AppStrings s) => [
        NeumorphicNavItem(icon: Icons.dashboard, label: s.dashboard),
        NeumorphicNavItem(icon: Icons.meeting_room, label: s.rooms),
        NeumorphicNavItem(icon: Icons.calendar_today, label: s.schedule),
        NeumorphicNavItem(icon: Icons.bar_chart, label: s.statistics),
        NeumorphicNavItem(
          icon: Icons.notifications_outlined,
          label: s.notifications,
          badge: '2',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return NeumorphicTheme(
      data: NeumorphicThemeData.light(),
      child: ResponsiveDashboardShell(
        selectedIndex: _navIndex,
        onIndexChanged: (i) => setState(() => _navIndex = i),
        navItems: _navItems(s),
        userName: 'Артём',
        logoWidget: SvgPicture.asset('assets/images/breez-logo.svg'),
        headerActions: [
          _ThemeToggle(),
          _LanguageSwitch(),
        ],
        pages: [
          _DashboardPage(onNavigate: (i) => setState(() => _navIndex = i)),
          _PlaceholderPage(title: s.rooms, icon: Icons.meeting_room),
          _PlaceholderPage(title: s.schedule, icon: Icons.calendar_today),
          _PlaceholderPage(title: s.statistics, icon: Icons.bar_chart),
          _PlaceholderPage(
            title: s.notifications,
            icon: Icons.notifications_outlined,
          ),
        ],
        rightPanelBuilder: (ctx) => _RightPanel(),
        footerBuilder: (ctx) => _Footer(),
      ),
    );
  }
}

/// Main dashboard page with Device Zone / Global Zone
class _DashboardPage extends StatelessWidget {
  final ValueChanged<int>? onNavigate;

  const _DashboardPage({this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final isMobile = ResponsiveDashboardShell.isMobile(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading) {
          return const Center(child: NeumorphicLoadingIndicator());
        }
        if (state.status == DashboardStatus.failure) {
          return _ErrorView(message: state.errorMessage);
        }

        if (isMobile) {
          return _MobileDashboard(state: state, onNavigate: onNavigate);
        }
        return _DesktopDashboard(state: state, strings: s);
      },
    );
  }
}

/// Desktop layout with clear Device Zone / Global Zone separation
class _DesktopDashboard extends StatelessWidget {
  final DashboardState state;
  final AppStrings strings;

  const _DesktopDashboard({required this.state, required this.strings});

  @override
  Widget build(BuildContext context) {
    return NeumorphicMainContent(
      title: strings.dashboard,
      scrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === DEVICE ZONE with visual container ===
          Expanded(
            flex: 6,
            child: DeviceZoneContainer(
              header: _buildDeviceSelectorHeader(context),
              padding: const EdgeInsets.fromLTRB(
                NeumorphicSpacing.md,
                NeumorphicSpacing.sm,
                NeumorphicSpacing.md,
                NeumorphicSpacing.md,
              ),
              child: _DeviceZoneGrid(state: state, strings: strings),
            ),
          ),

          // === ZONE DIVIDER ===
          const ZoneDivider(
            label: 'ОБЩИЕ ДАННЫЕ',
            icon: Icons.dashboard_outlined,
          ),

          // === GLOBAL ZONE ===
          Expanded(
            flex: 4,
            child: _GlobalZoneGrid(state: state, strings: strings),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceSelectorHeader(BuildContext context) {
    final devices = state.hvacDevices
        .map((d) => DeviceSelectorItem(
              id: d.id,
              name: d.name,
              brand: d.brand,
              type: d.type,
              isOnline: d.isOnline,
              isActive: d.isActive,
              icon: d.icon,
            ))
        .toList();

    return DeviceSelectorHeader(
      devices: devices,
      selectedDeviceId: state.selectedHvacDeviceId,
      onDeviceSelected: (id) =>
          context.read<DashboardBloc>().add(HvacDeviceSelected(id)),
      onAddDevice: () {
        // TODO: Navigate to add device flow
      },
      onManageDevices: () {
        // TODO: Navigate to device management
      },
    );
  }
}

/// Device Zone grid with device-specific widgets
class _DeviceZoneGrid extends StatelessWidget {
  final DashboardState state;
  final AppStrings strings;

  const _DeviceZoneGrid({required this.state, required this.strings});

  @override
  Widget build(BuildContext context) {
    final climate = state.climate;

    return BentoGrid(
      columns: 4,
      gap: 16,
      cellHeight: null,
      items: [
        // Row 1: Device status + Sensors
        BentoItem(
          size: BentoSize.square,
          child: DeviceHeaderCard(
            deviceName: climate?.deviceName ?? 'HVAC',
            deviceType: _getDeviceType(state),
            isOn: climate?.isOn ?? false,
            isOnline: _isDeviceOnline(state),
            onPowerChanged: (v) =>
                context.read<DashboardBloc>().add(DevicePowerToggled(v)),
          ),
        ),

        BentoItem(
          size: BentoSize.square,
          child: SensorCard(
            icon: Icons.thermostat,
            value: climate?.currentTemperature.toStringAsFixed(1) ?? '--',
            unit: '°C',
            label: strings.temperature,
            color: NeumorphicColors.modeHeating,
          ),
        ),

        BentoItem(
          size: BentoSize.square,
          child: SensorCard(
            icon: Icons.water_drop,
            value: climate?.humidity.toStringAsFixed(0) ?? '--',
            unit: '%',
            label: strings.humidity,
            color: NeumorphicColors.modeCooling,
          ),
        ),

        BentoItem(
          size: BentoSize.square,
          child: SensorCard(
            icon: Icons.cloud_outlined,
            value: '${climate?.co2Ppm ?? '--'}',
            unit: 'ppm',
            label: 'CO₂',
            color: _co2Color(climate?.co2Ppm),
          ),
        ),

        // Row 2: Schedule + Alerts + System Info
        BentoItem(
          size: BentoSize.wide,
          child: UnifiedScheduleCard(
            schedules: _getMockSchedules(),
            currentDeviceId: state.selectedHvacDeviceId,
            currentDeviceName: climate?.deviceName,
            title: strings.schedule,
          ),
        ),

        BentoItem(
          size: BentoSize.square,
          child: DeviceAlertsCard(
            alerts: _getMockDeviceAlerts(state),
            title: strings.notifications,
          ),
        ),

        BentoItem(
          size: BentoSize.square,
          child: _CompactSystemInfoCard(
            deviceName: climate?.deviceName ?? 'HVAC',
            isOnline: _isDeviceOnline(state),
            filterPercent: 78,
            strings: strings,
          ),
        ),
      ],
    );
  }

  String? _getDeviceType(DashboardState state) {
    if (state.hvacDevices.isEmpty) return null;
    final device = state.hvacDevices.firstWhere(
      (d) => d.id == state.selectedHvacDeviceId,
      orElse: () => state.hvacDevices.first,
    );
    return device.type;
  }

  bool _isDeviceOnline(DashboardState state) {
    if (state.hvacDevices.isEmpty) return false;
    final device = state.hvacDevices.firstWhere(
      (d) => d.id == state.selectedHvacDeviceId,
      orElse: () => state.hvacDevices.first,
    );
    return device.isOnline;
  }

  Color _co2Color(int? ppm) {
    if (ppm == null) return NeumorphicColors.airQualityGood;
    if (ppm < 600) return NeumorphicColors.airQualityExcellent;
    if (ppm < 800) return NeumorphicColors.airQualityGood;
    if (ppm < 1000) return NeumorphicColors.airQualityModerate;
    return NeumorphicColors.airQualityPoor;
  }

  List<DeviceSchedule> _getMockSchedules() => [
        // Device-specific schedules
        DeviceSchedule(
          id: '1',
          deviceId: 'zilon-1',
          time: const TimeOfDay(hour: 7, minute: 0),
          action: ScheduleAction.turnOn,
          temperature: 22,
          repeatDays: {
            DayOfWeek.monday,
            DayOfWeek.tuesday,
            DayOfWeek.wednesday,
            DayOfWeek.thursday,
            DayOfWeek.friday
          },
          label: 'Подъём',
        ),
        DeviceSchedule(
          id: '2',
          deviceId: 'zilon-1',
          time: const TimeOfDay(hour: 9, minute: 0),
          action: ScheduleAction.setTemperature,
          temperature: 18,
          repeatDays: DayOfWeek.values.toSet(),
          label: 'Уход на работу',
          isEnabled: false,
        ),
        DeviceSchedule(
          id: '3',
          deviceId: 'zilon-1',
          time: const TimeOfDay(hour: 18, minute: 0),
          action: ScheduleAction.setTemperature,
          temperature: 21,
          repeatDays: DayOfWeek.values.toSet(),
          label: 'Возвращение',
        ),
        // Global schedules (for all devices)
        DeviceSchedule(
          id: '4',
          deviceId: null, // Global
          time: const TimeOfDay(hour: 23, minute: 0),
          action: ScheduleAction.turnOff,
          repeatDays: DayOfWeek.values.toSet(),
          label: 'Ночной режим',
        ),
      ];

  List<DeviceAlert> _getMockDeviceAlerts(DashboardState state) => [
        DeviceAlert(
          id: '1',
          title: 'Замена фильтра',
          message: 'Рекомендуется заменить фильтр',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          priority: NotificationPriority.normal,
          deviceId: state.selectedHvacDeviceId ?? 'zilon-1',
          deviceName: state.climate?.deviceName ?? 'HVAC',
          type: DeviceAlertType.filterChange,
          dueDate: DateTime.now().add(const Duration(days: 14)),
        ),
        DeviceAlert(
          id: '2',
          title: 'Обновление прошивки',
          message: 'Доступна версия v2.5.0',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          priority: NotificationPriority.low,
          deviceId: state.selectedHvacDeviceId ?? 'zilon-1',
          deviceName: state.climate?.deviceName ?? 'HVAC',
          type: DeviceAlertType.firmwareUpdate,
        ),
      ];
}

/// Compact system info card for square bento cell
class _CompactSystemInfoCard extends StatelessWidget {
  final String deviceName;
  final bool isOnline;
  final int filterPercent;
  final AppStrings strings;

  const _CompactSystemInfoCard({
    required this.deviceName,
    required this.isOnline,
    required this.filterPercent,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final t = NeumorphicTheme.of(context);

    return NeumorphicCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxHeight < 100;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    strings.systemStatus,
                    style: isSmall
                        ? t.typography.labelMedium
                        : t.typography.titleSmall,
                  ),
                  GlowingStatusDot(
                    color: isOnline
                        ? NeumorphicColors.accentSuccess
                        : t.colors.textTertiary,
                    isGlowing: isOnline,
                    size: isSmall ? 6 : 8,
                  ),
                ],
              ),
              SizedBox(height: isSmall ? 4 : 8),
              Text(
                deviceName,
                style: t.typography.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    strings.filterStatus,
                    style: t.typography.labelSmall.copyWith(
                      color: t.colors.textSecondary,
                      fontSize: isSmall ? 10 : null,
                    ),
                  ),
                  Text(
                    '$filterPercent%',
                    style: t.typography.labelSmall.copyWith(
                      color: _getFilterColor(filterPercent),
                      fontWeight: FontWeight.w600,
                      fontSize: isSmall ? 10 : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmall ? 2 : 4),
              LinearProgressIndicator(
                value: filterPercent / 100,
                backgroundColor: t.colors.textTertiary.withValues(alpha: 0.2),
                valueColor:
                    AlwaysStoppedAnimation(_getFilterColor(filterPercent)),
                minHeight: isSmall ? 3 : 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getFilterColor(int percent) {
    if (percent >= 80) return NeumorphicColors.accentSuccess;
    if (percent >= 50) return NeumorphicColors.airQualityGood;
    if (percent >= 30) return NeumorphicColors.accentWarning;
    return NeumorphicColors.accentError;
  }
}

/// Global Zone grid with shared widgets
class _GlobalZoneGrid extends StatelessWidget {
  final DashboardState state;
  final AppStrings strings;

  const _GlobalZoneGrid({required this.state, required this.strings});

  @override
  Widget build(BuildContext context) {
    final stats = state.energyStats;
    final climate = state.climate;

    return BentoGrid(
      columns: 4,
      gap: 16,
      cellHeight: null,
      items: [
        // Energy statistics
        BentoItem(
          size: BentoSize.large,
          child: EnergyStatsCard(
            totalKwh: stats?.totalKwh ?? 0,
            totalHours: stats?.totalHours ?? 0,
            hourlyData: stats?.hourlyData.map((h) => h.kwh).toList() ?? [],
            title: strings.usageStatus,
            spentLabel: strings.totalSpent,
            hoursLabel: strings.totalHours,
            periodLabel: strings.today,
          ),
        ),

        // Air quality
        BentoItem(
          size: BentoSize.square,
          child: AirQualityCard(
            co2Ppm: climate?.co2Ppm ?? 500,
            pm25: 12,
            voc: 0.3,
            title: strings.airQuality,
          ),
        ),

        // Unified notification center
        BentoItem(
          size: BentoSize.square,
          child: NotificationCenterCard(
            deviceAlerts: _getMockAllDeviceAlerts(state),
            companyNotifications: _getMockCompanyNotifications(),
            title: strings.notifications,
            onViewAll: () {
              // Navigate to notifications page
            },
          ),
        ),

        // Quick actions
        BentoItem(
          size: BentoSize.wide,
          child: QuickActionsCard(
            actions: QuickActionsCard.defaultActions(
              allOffLabel: strings.allOff,
              syncLabel: strings.sync,
              scheduleLabel: strings.schedule,
              settingsLabel: strings.settings,
            ),
            title: strings.quickActions,
            onActionPressed: (id) => _handleQuickAction(context, id),
          ),
        ),
      ],
    );
  }

  void _handleQuickAction(BuildContext context, String actionId) {
    final bloc = context.read<DashboardBloc>();
    switch (actionId) {
      case 'all_off':
        bloc.add(const AllDevicesOff());
        break;
      case 'sync':
        bloc.add(const DashboardRefreshed());
        break;
      case 'schedule':
      case 'settings':
        break;
    }
  }

  List<DeviceAlert> _getMockAllDeviceAlerts(DashboardState state) => [
        DeviceAlert(
          id: '1',
          title: 'Замена фильтра',
          message: 'Рекомендуется заменить',
          timestamp: DateTime.now(),
          deviceId: 'zilon-1',
          deviceName: 'ZILON ZPE-6000',
          type: DeviceAlertType.filterChange,
          dueDate: DateTime.now().add(const Duration(days: 14)),
        ),
        DeviceAlert(
          id: '2',
          title: 'Обновление',
          message: 'Версия v2.5.0',
          timestamp: DateTime.now(),
          deviceId: 'lg-1',
          deviceName: 'LG Dual Inverter',
          type: DeviceAlertType.firmwareUpdate,
        ),
        DeviceAlert(
          id: '3',
          title: 'Офлайн',
          message: 'Нет связи с устройством',
          timestamp: DateTime.now(),
          deviceId: 'xiaomi-1',
          deviceName: 'Xiaomi Humidifier',
          type: DeviceAlertType.offline,
        ),
      ];

  List<CompanyNotification> _getMockCompanyNotifications() => [
        CompanyNotification(
          id: 'c1',
          title: 'Зимние скидки',
          message: 'Скидка 20% на обслуживание до конца января',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: CompanyNotificationType.promo,
        ),
        CompanyNotification(
          id: 'c2',
          title: 'Совет эксперта',
          message: 'Оптимальная влажность зимой: 40-60%',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: CompanyNotificationType.tip,
        ),
      ];
}

/// Mobile dashboard layout
class _MobileDashboard extends StatelessWidget {
  final DashboardState state;
  final ValueChanged<int>? onNavigate;

  const _MobileDashboard({required this.state, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final climate = state.climate;
    final t = NeumorphicTheme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(NeumorphicSpacing.md),
        child: Column(
          children: [
            // Device switcher horizontal
            _MobileDeviceSwitcher(state: state),
            const SizedBox(height: NeumorphicSpacing.md),

            // Sensors row
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    icon: Icons.thermostat,
                    value:
                        '${climate?.currentTemperature.toStringAsFixed(0) ?? '--'}°',
                    label: s.temperature,
                    unit: '',
                    color: NeumorphicColors.modeHeating,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SensorCard(
                    icon: Icons.water_drop,
                    value: '${climate?.humidity.toStringAsFixed(0) ?? '--'}%',
                    label: s.humidity,
                    unit: '',
                    color: NeumorphicColors.modeCooling,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SensorCard(
                    icon: Icons.cloud_outlined,
                    value: '${climate?.co2Ppm ?? '--'}',
                    label: 'CO₂',
                    unit: '',
                    color: _co2Color(climate?.co2Ppm),
                    isCompact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: NeumorphicSpacing.md),

            // Quick actions grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: NeumorphicSpacing.sm,
                mainAxisSpacing: NeumorphicSpacing.sm,
                childAspectRatio: 1.3,
                children: [
                  // Power toggle
                  NeumorphicCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.power_settings_new,
                              color: climate?.isOn == true
                                  ? NeumorphicColors.accentPrimary
                                  : t.colors.textTertiary,
                            ),
                            NeumorphicToggle(
                              value: climate?.isOn ?? false,
                              onChanged: (v) => context
                                  .read<DashboardBloc>()
                                  .add(DevicePowerToggled(v)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          climate?.deviceName ?? 'HVAC',
                          style: t.typography.titleSmall,
                        ),
                        Text(
                          climate?.isOn == true ? 'Активен' : 'Ожидание',
                          style: t.typography.labelSmall.copyWith(
                            color: climate?.isOn == true
                                ? NeumorphicColors.accentSuccess
                                : t.colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Sync
                  NeumorphicCard(
                    onTap: () => context
                        .read<DashboardBloc>()
                        .add(const DashboardRefreshed()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sync,
                          color: NeumorphicColors.accentPrimary,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(s.sync, style: t.typography.labelSmall),
                      ],
                    ),
                  ),
                  // Schedule
                  NeumorphicCard(
                    onTap: () => onNavigate?.call(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: NeumorphicColors.accentPrimary,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(s.schedule, style: t.typography.labelSmall),
                      ],
                    ),
                  ),
                  // Stats
                  NeumorphicCard(
                    onTap: () => onNavigate?.call(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart,
                          color: NeumorphicColors.accentPrimary,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(s.statistics, style: t.typography.labelSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _co2Color(int? ppm) {
    if (ppm == null) return NeumorphicColors.airQualityGood;
    if (ppm < 600) return NeumorphicColors.airQualityExcellent;
    if (ppm < 800) return NeumorphicColors.airQualityGood;
    if (ppm < 1000) return NeumorphicColors.airQualityModerate;
    return NeumorphicColors.airQualityPoor;
  }
}

/// Mobile horizontal device switcher
class _MobileDeviceSwitcher extends StatelessWidget {
  final DashboardState state;

  const _MobileDeviceSwitcher({required this.state});

  @override
  Widget build(BuildContext context) {
    final devices = state.hvacDevices
        .map((d) => DeviceInfo(
              id: d.id,
              name: d.brand,
              type: d.type,
              isOnline: d.isOnline,
              isActive: d.isActive,
              icon: d.icon,
            ))
        .toList();

    return DeviceSwitcherHorizontal(
      devices: devices,
      selectedDeviceId: state.selectedHvacDeviceId,
      onDeviceSelected: (id) =>
          context.read<DashboardBloc>().add(HvacDeviceSelected(id)),
      onAddDevice: () {},
    );
  }
}

/// Right panel with climate control
class _RightPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (prev, curr) => prev.climate != curr.climate,
      builder: (context, state) {
        final climate = state.climate;

        return DeviceClimateControl(
          targetTemperature: climate?.targetTemperature ?? 22,
          mode: climate?.mode ?? ClimateMode.auto,
          modeLabel: _getModeLabel(s, climate?.mode ?? ClimateMode.auto),
          supplyAirflow: climate?.supplyAirflow ?? 50,
          exhaustAirflow: climate?.exhaustAirflow ?? 40,
          preset: climate?.preset ?? 'auto',
          targetTempLabel: s.targetTemperature,
          heatingLabel: s.heating,
          coolingLabel: s.cooling,
          autoLabel: s.auto,
          ventilationLabel: s.ventilation,
          airflowControlLabel: s.airflowControl,
          supplyLabel: s.supplyAirflow,
          exhaustLabel: s.exhaustAirflow,
          nightLabel: s.night,
          turboLabel: s.turbo,
          ecoLabel: s.eco,
          awayLabel: s.away,
          onTemperatureChanged: (v) =>
              context.read<DashboardBloc>().add(TemperatureChanged(v)),
          onModeChanged: (mode) =>
              context.read<DashboardBloc>().add(ClimateModeChanged(mode)),
          onSupplyAirflowChanged: (v) =>
              context.read<DashboardBloc>().add(SupplyAirflowChanged(v)),
          onExhaustAirflowChanged: (v) =>
              context.read<DashboardBloc>().add(ExhaustAirflowChanged(v)),
          onPresetChanged: (id) =>
              context.read<DashboardBloc>().add(PresetChanged(id)),
        );
      },
    );
  }

  String _getModeLabel(AppStrings s, ClimateMode mode) => switch (mode) {
        ClimateMode.heating => s.heating,
        ClimateMode.cooling => s.cooling,
        ClimateMode.auto => s.auto,
        ClimateMode.dry => s.dry,
        ClimateMode.ventilation => s.ventilation,
        ClimateMode.off => s.turnedOff,
      };
}

/// Error view
class _ErrorView extends StatelessWidget {
  final String? message;

  const _ErrorView({this.message});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${s.error}: $message'),
          const SizedBox(height: 16),
          NeumorphicButton(
            onPressed: () =>
                context.read<DashboardBloc>().add(const DashboardRefreshed()),
            child: Text(s.retry),
          ),
        ],
      ),
    );
  }
}

/// Footer
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = NeumorphicTheme.of(context);
    final now = DateTime.now();
    final syncTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Weather
        Row(
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              size: 16,
              color: NeumorphicColors.accentWarning,
            ),
            const SizedBox(width: 6),
            Text(
              '+5°C',
              style:
                  t.typography.bodySmall.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            Text(
              'На улице',
              style:
                  t.typography.bodySmall.copyWith(color: t.colors.textTertiary),
            ),
          ],
        ),
        // Sync time
        Row(
          children: [
            Icon(Icons.sync, size: 14, color: t.colors.textTertiary),
            const SizedBox(width: 4),
            Text(
              'Синхронизировано в $syncTime',
              style: t.typography.labelSmall
                  .copyWith(color: t.colors.textTertiary),
            ),
          ],
        ),
        // Version
        Text(
          'BREEZ Home v1.0.0',
          style:
              t.typography.labelSmall.copyWith(color: t.colors.textTertiary),
        ),
      ],
    );
  }
}

/// Theme toggle button
class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = NeumorphicTheme.of(context);

    return NeumorphicIconButton(
      icon: Icons.dark_mode_outlined,
      iconColor: t.colors.textSecondary,
      tooltip: 'Тёмная тема',
      onPressed: () {},
    );
  }
}

/// Language switch
class _LanguageSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = context.locale;
    final t = NeumorphicTheme.of(context);

    return PopupMenuButton<AppLocale>(
      initialValue: loc,
      onSelected: (l) => context.setLocale(l),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: t.colors.surface,
      elevation: 0,
      itemBuilder: (_) => AppLocale.values
          .map((l) => PopupMenuItem(
                value: l,
                child: Row(
                  children: [
                    if (l == loc)
                      Icon(
                        Icons.check,
                        size: 16,
                        color: NeumorphicColors.accentPrimary,
                      )
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 8),
                    Text(l.name, style: t.typography.bodyMedium),
                  ],
                ),
              ))
          .toList(),
      child: NeumorphicInteractiveCard(
        borderRadius: 10,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, size: 18, color: t.colors.textSecondary),
            const SizedBox(width: 6),
            Text(
              loc.code.toUpperCase(),
              style:
                  t.typography.labelSmall.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder page
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final t = NeumorphicTheme.of(context);

    return NeumorphicMainContent(
      title: title,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: t.colors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'Страница в разработке',
              style: t.typography.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
