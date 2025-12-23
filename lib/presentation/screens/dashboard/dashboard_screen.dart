/// Main dashboard screen - modular architecture with Device/Global zone separation
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection_container.dart' as di;
import '../../../core/l10n/l10n.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/theme/app_theme.dart';
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

  List<NavItem> _navItems(AppStrings s) => [
        NavItem(icon: Icons.dashboard, label: s.dashboard),
        NavItem(icon: Icons.meeting_room, label: s.rooms),
        NavItem(icon: Icons.calendar_today, label: s.schedule),
        NavItem(icon: Icons.bar_chart, label: s.statistics),
        NavItem(
          icon: Icons.notifications_outlined,
          label: s.notifications,
          badge: '2',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return ResponsiveShell(
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
    final isMobile = ResponsiveShell.usesBottomNav(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading) {
          return const Center(child: ShadProgress());
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
    return _MainContent(
      title: strings.dashboard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === DEVICE ZONE with visual container ===
          Expanded(
            flex: 6,
            child: DeviceZoneContainer(
              header: _buildDeviceSelectorHeader(context),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: _DeviceZoneGrid(state: state, strings: strings),
            ),
          ),

          // Zone spacing
          const SizedBox(height: 8),

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
      onAddDevice: () {},
      onManageDevices: () {},
    );
  }
}

/// Simple responsive grid for bento-style layout
class _ResponsiveGrid extends StatelessWidget {
  static const double _gap = 16;
  static const double _minCellWidth = 300;

  final List<Widget> children;

  const _ResponsiveGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / _minCellWidth).floor().clamp(1, 4);
        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: children.map((child) {
            final width = (constraints.maxWidth - (_gap * (columns - 1))) / columns;
            return SizedBox(width: width, child: child);
          }).toList(),
        );
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

    return SingleChildScrollView(
      child: _ResponsiveGrid(
        children: [
          // Power control
          SizedBox(
            height: 130,
            child: DeviceHeaderCard(
              deviceName: climate?.deviceName ?? 'HVAC',
              deviceType: _getDeviceType(state),
              isOn: climate?.isOn ?? false,
              isOnline: _isDeviceOnline(state),
              onPowerChanged: (v) =>
                  context.read<DashboardBloc>().add(DevicePowerToggled(v)),
            ),
          ),

          // Environment metrics (Temperature + Humidity + CO2)
          SizedBox(
            height: 130,
            child: EnvironmentCard(
              temperature: climate?.currentTemperature,
              humidity: climate?.humidity.toInt(),
              co2: climate?.co2Ppm,
              temperatureLabel: strings.temperature,
              humidityLabel: strings.humidity,
            ),
          ),

          // Schedule card (wide)
          SizedBox(
            height: 160,
            child: UnifiedScheduleCard(
              schedules: _getMockSchedules(),
              currentDeviceId: state.selectedHvacDeviceId,
              currentDeviceName: climate?.deviceName,
              title: strings.schedule,
            ),
          ),

          // System info
          SizedBox(
            height: 160,
            child: _CompactSystemInfoCard(
              deviceName: climate?.deviceName ?? 'HVAC',
              isOnline: _isDeviceOnline(state),
              filterPercent: 78,
              strings: strings,
            ),
          ),
        ],
      ),
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

  List<DeviceSchedule> _getMockSchedules() => [
        const DeviceSchedule(
          id: '1',
          deviceId: 'zilon-1',
          time: TimeOfDay(hour: 7, minute: 0),
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
      ];

}

/// Compact system info card
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
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                strings.systemStatus,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.foreground,
                ),
              ),
              GlowingStatusDot(
                color: isOnline ? AppColors.success : theme.colorScheme.muted,
                isGlowing: isOnline,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            deviceName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.foreground,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                strings.filterStatus,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
              Text(
                '$filterPercent%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getFilterColor(filterPercent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ShadProgress(value: filterPercent / 100),
        ],
      ),
    );
  }

  Color _getFilterColor(int percent) {
    if (percent >= 80) return AppColors.success;
    if (percent >= 50) return AppColors.airGood;
    if (percent >= 30) return AppColors.warning;
    return AppColors.error;
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

    return SingleChildScrollView(
      child: _ResponsiveGrid(
        children: [
          // Energy statistics
          SizedBox(
            height: 200,
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
          SizedBox(
            height: 160,
            child: AirQualityCard(
              co2Ppm: climate?.co2Ppm ?? 500,
              pm25: 12,
              voc: 0.3,
              title: strings.airQuality,
            ),
          ),

          // Notifications
          SizedBox(
            height: 160,
            child: NotificationCenterCard(
              deviceAlerts: _getMockAllDeviceAlerts(state),
              companyNotifications: _getMockCompanyNotifications(),
              title: strings.notifications,
              onViewAll: () {},
            ),
          ),

          // Quick actions
          SizedBox(
            height: 160,
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
      ),
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
      ];

  List<CompanyNotification> _getMockCompanyNotifications() => [
        CompanyNotification(
          id: 'c1',
          title: 'Зимние скидки',
          message: 'Скидка 20% на обслуживание',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: CompanyNotificationType.promo,
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
    final theme = ShadTheme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Device switcher horizontal
            _MobileDeviceSwitcher(state: state),
            const SizedBox(height: 16),

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
                    color: AppColors.heating,
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
                    color: AppColors.cooling,
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
            const SizedBox(height: 16),

            // Quick actions grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.3,
                children: [
                  // Power toggle
                  ShadCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.power_settings_new,
                              color: climate?.isOn == true
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.muted,
                            ),
                            ShadSwitch(
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.foreground,
                          ),
                        ),
                        Text(
                          climate?.isOn == true ? 'Активен' : 'Ожидание',
                          style: TextStyle(
                            fontSize: 12,
                            color: climate?.isOn == true
                                ? AppColors.success
                                : theme.colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Sync
                  _MobileActionCard(
                    icon: Icons.sync,
                    label: s.sync,
                    onTap: () => context
                        .read<DashboardBloc>()
                        .add(const DashboardRefreshed()),
                  ),
                  // Schedule
                  _MobileActionCard(
                    icon: Icons.calendar_today,
                    label: s.schedule,
                    onTap: () => onNavigate?.call(2),
                  ),
                  // Stats
                  _MobileActionCard(
                    icon: Icons.bar_chart,
                    label: s.statistics,
                    onTap: () => onNavigate?.call(3),
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
    if (ppm == null) return AppColors.airGood;
    if (ppm < 600) return AppColors.success;
    if (ppm < 800) return AppColors.airGood;
    if (ppm < 1000) return AppColors.warning;
    return AppColors.error;
  }
}

class _MobileActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MobileActionCard({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.foreground,
              ),
            ),
          ],
        ),
      ),
    );
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
          ShadAlert.destructive(
            title: Text(s.error),
            description: Text(message ?? 'Unknown error'),
          ),
          const SizedBox(height: 16),
          ShadButton(
            onPressed: () =>
                context.read<DashboardBloc>().add(const DashboardRefreshed()),
            child: Text(s.retry),
          ),
        ],
      ),
    );
  }
}

/// Footer - clean and minimal
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Weather only - the most useful info for HVAC context
        const Icon(Icons.wb_sunny_outlined, size: 16, color: AppColors.warning),
        const SizedBox(width: 6),
        Text(
          '+5°C',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.foreground,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'На улице',
          style: TextStyle(
            fontSize: 13,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

/// Theme toggle button
class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final themeService = di.sl<ThemeService>();

    return ShadButton.outline(
      size: ShadButtonSize.sm,
      onPressed: themeService.toggleTheme,
      child: Icon(
        themeService.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        size: 18,
        color: theme.colorScheme.mutedForeground,
      ),
    );
  }
}

/// Language switch
class _LanguageSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = context.locale;
    final theme = ShadTheme.of(context);

    return PopupMenuButton<AppLocale>(
      initialValue: loc,
      onSelected: (l) => context.setLocale(l),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: theme.colorScheme.card,
      itemBuilder: (_) => AppLocale.values
          .map((l) => PopupMenuItem(
                value: l,
                child: Row(
                  children: [
                    if (l == loc)
                      Icon(Icons.check, size: 16, color: theme.colorScheme.primary)
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 8),
                    Text(l.name),
                  ],
                ),
              ))
          .toList(),
      child: ShadButton.outline(
        size: ShadButtonSize.sm,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, size: 16, color: theme.colorScheme.mutedForeground),
            const SizedBox(width: 6),
            Text(loc.code.toUpperCase()),
          ],
        ),
      ),
    );
  }
}

/// Main content wrapper
class _MainContent extends StatelessWidget {
  final String title;
  final Widget child;

  const _MainContent({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.foreground,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: child,
          ),
        ),
      ],
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
    final theme = ShadTheme.of(context);

    return _MainContent(
      title: title,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.muted),
            const SizedBox(height: 16),
            Text(
              'Страница в разработке',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
