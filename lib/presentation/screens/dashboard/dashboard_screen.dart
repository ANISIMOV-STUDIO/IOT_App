/// Main dashboard screen - modular architecture
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

/// Desktop layout with Bento Grid and zone separation
class _DesktopDashboard extends StatelessWidget {
  final DashboardState state;
  final AppStrings strings;

  const _DesktopDashboard({required this.state, required this.strings});

  @override
  Widget build(BuildContext context) {
    final climate = state.climate;
    final t = NeumorphicTheme.of(context);

    return NeumorphicMainContent(
      title: strings.dashboard,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === DEVICE ZONE ===
            SectionHeader(
              title: climate?.deviceName ?? 'Устройство',
              subtitle: _getDeviceSubtitle(state),
              icon: Icons.device_hub,
              accentColor: NeumorphicColors.accentPrimary,
              trailing: _DeviceSwitcherCompact(state: state),
            ),
            const SizedBox(height: 12),
            _DeviceZoneGrid(state: state, strings: strings),

            // === ZONE DIVIDER ===
            const ZoneDivider(label: 'Общее'),

            // === GLOBAL ZONE ===
            SectionHeader(
              title: 'Общая информация',
              icon: Icons.public,
              accentColor: t.colors.textSecondary,
            ),
            const SizedBox(height: 12),
            _GlobalZoneGrid(state: state, strings: strings),
          ],
        ),
      ),
    );
  }

  String? _getDeviceSubtitle(DashboardState state) {
    final device = state.hvacDevices.firstWhere(
      (d) => d.id == state.selectedHvacDeviceId,
      orElse: () => state.hvacDevices.first,
    );
    return '${device.brand} • ${device.type}';
  }
}

/// Compact device switcher for header
class _DeviceSwitcherCompact extends StatelessWidget {
  final DashboardState state;

  const _DeviceSwitcherCompact({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = NeumorphicTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...state.hvacDevices.take(3).map((device) {
          final isSelected = device.id == state.selectedHvacDeviceId;
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: GestureDetector(
              onTap: () => context.read<DashboardBloc>().add(
                    HvacDeviceSelected(device.id),
                  ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected
                      ? NeumorphicColors.accentPrimary.withValues(alpha: 0.15)
                      : t.colors.cardSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(
                          color: NeumorphicColors.accentPrimary,
                          width: 2,
                        )
                      : null,
                  boxShadow: isSelected ? null : t.shadows.convexSmall,
                ),
                child: Icon(
                  device.icon,
                  size: 18,
                  color: isSelected
                      ? NeumorphicColors.accentPrimary
                      : t.colors.textSecondary,
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        NeumorphicIconButton(
          icon: Icons.add,
          size: 32,
          iconColor: NeumorphicColors.accentPrimary,
          onPressed: () {},
        ),
      ],
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
      gap: 12,
      cellHeight: 180,
      items: [
        // Device status + power
        BentoItem(
          size: BentoSize.tall,
          child: DeviceHeaderCard(
            deviceName: climate?.deviceName ?? 'HVAC',
            deviceType: _getDeviceType(state),
            isOn: climate?.isOn ?? false,
            isOnline: _isDeviceOnline(state),
            onPowerChanged: (v) =>
                context.read<DashboardBloc>().add(DevicePowerToggled(v)),
          ),
        ),

        // Temperature sensor
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

        // Humidity sensor
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

        // System info
        BentoItem(
          size: BentoSize.tall,
          child: DeviceSystemInfoCard(
            deviceName: climate?.deviceName ?? 'HVAC',
            isOnline: _isDeviceOnline(state),
            title: strings.systemStatus,
            deviceLabel: strings.device,
            firmwareLabel: strings.firmware,
            connectionLabel: strings.connection,
            efficiencyLabel: strings.efficiency,
            filterLabel: strings.filterStatus,
            uptimeLabel: strings.uptime,
          ),
        ),

        // CO2 sensor
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

        // Device schedule
        BentoItem(
          size: BentoSize.wide,
          child: DeviceScheduleCard(
            schedules: _getMockSchedules(),
            title: strings.schedule,
          ),
        ),

        // Device alerts
        BentoItem(
          size: BentoSize.wide,
          child: DeviceAlertsCard(
            alerts: _getMockDeviceAlerts(state),
            title: strings.notifications,
          ),
        ),
      ],
    );
  }

  String? _getDeviceType(DashboardState state) {
    final device = state.hvacDevices.firstWhere(
      (d) => d.id == state.selectedHvacDeviceId,
      orElse: () => state.hvacDevices.first,
    );
    return device.type;
  }

  bool _isDeviceOnline(DashboardState state) {
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

  // Mock data - will be replaced with real data from BLoC
  List<DeviceSchedule> _getMockSchedules() => [
        DeviceSchedule(
          id: '1',
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
          time: const TimeOfDay(hour: 9, minute: 0),
          action: ScheduleAction.setTemperature,
          temperature: 18,
          repeatDays: DayOfWeek.values.toSet(),
          label: 'Уход',
          isEnabled: false,
        ),
        DeviceSchedule(
          id: '3',
          time: const TimeOfDay(hour: 18, minute: 0),
          action: ScheduleAction.setTemperature,
          temperature: 21,
          repeatDays: DayOfWeek.values.toSet(),
          label: 'Возвращение',
        ),
        DeviceSchedule(
          id: '4',
          time: const TimeOfDay(hour: 22, minute: 0),
          action: ScheduleAction.turnOff,
          repeatDays: DayOfWeek.values.toSet(),
          label: 'Сон',
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
      gap: 12,
      cellHeight: 180,
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
          size: BentoSize.wide,
          child: AirQualityCard(
            co2Ppm: climate?.co2Ppm ?? 500,
            pm25: 12,
            voc: 0.3,
            title: strings.airQuality,
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

        // Company notifications
        BentoItem(
          size: BentoSize.wide,
          child: CompanyNotificationsCard(
            notifications: _getMockCompanyNotifications(),
            title: 'Новости BREEZ',
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
        // Navigate to respective pages
        break;
    }
  }

  List<CompanyNotification> _getMockCompanyNotifications() => [
        CompanyNotification(
          id: '1',
          title: 'Новая версия приложения',
          message: 'Обновите приложение до версии 2.0 для новых функций',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: CompanyNotificationType.update,
          actionUrl: 'https://breez.ru/update',
        ),
        CompanyNotification(
          id: '2',
          title: 'Совет по энергосбережению',
          message: 'Используйте ночной режим для экономии до 30% энергии',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: CompanyNotificationType.tip,
          isRead: true,
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
                    value: '${climate?.currentTemperature.toStringAsFixed(0) ?? '--'}°',
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
    final devices = state.hvacDevices.map((d) => DeviceInfo(
          id: d.id,
          name: d.brand,
          type: d.type,
          isOnline: d.isOnline,
          isActive: d.isActive,
          icon: d.icon,
        )).toList();

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

        return Column(
          children: [
            // Climate control
            Expanded(
              child: DeviceClimateControl(
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
              ),
            ),
            const SizedBox(height: NeumorphicSpacing.md),
            // Device alerts summary
            Expanded(
              child: DeviceAlertsCard(
                alerts: _getMockDeviceAlerts(state),
                title: s.notifications,
              ),
            ),
          ],
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

  List<DeviceAlert> _getMockDeviceAlerts(DashboardState state) => [
        DeviceAlert(
          id: '1',
          title: 'Замена фильтра',
          message: 'Через 14 дней',
          timestamp: DateTime.now(),
          deviceId: state.selectedHvacDeviceId ?? 'zilon-1',
          deviceName: state.climate?.deviceName ?? 'HVAC',
          type: DeviceAlertType.filterChange,
          dueDate: DateTime.now().add(const Duration(days: 14)),
        ),
        DeviceAlert(
          id: '2',
          title: 'Обновление',
          message: 'Доступна v2.5.0',
          timestamp: DateTime.now(),
          deviceId: state.selectedHvacDeviceId ?? 'zilon-1',
          deviceName: state.climate?.deviceName ?? 'HVAC',
          type: DeviceAlertType.firmwareUpdate,
        ),
      ];
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
