import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart' hide AirQualityLevel;

import '../../core/di/injection_container.dart';
import '../../core/l10n/l10n.dart';
import '../../domain/entities/climate.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../widgets/charts/energy_chart.dart';
import '../widgets/climate/mobile_temperature_card.dart';
import '../widgets/devices/device_switcher_card.dart';

/// Главный экран HVAC Dashboard
class NeumorphicDashboardScreen extends StatelessWidget {
  const NeumorphicDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return L10nProvider(
      child: BlocProvider(
        create: (_) => sl<DashboardBloc>()..add(const DashboardStarted()),
        child: const _DashboardView(),
      ),
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

  // Navigation items for both sidebar and bottom nav
  List<NeumorphicNavItem> _navItems(AppStrings s) => [
    NeumorphicNavItem(icon: Icons.dashboard, label: s.dashboard),
    NeumorphicNavItem(icon: Icons.meeting_room, label: s.rooms),
    NeumorphicNavItem(icon: Icons.calendar_today, label: s.schedule),
    NeumorphicNavItem(icon: Icons.bar_chart, label: s.statistics),
    NeumorphicNavItem(icon: Icons.notifications_outlined, label: s.notifications, badge: '2'),
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
        pages: [
          _dashboardPage(context, s),
          _roomsPlaceholder(context, s),
          _schedulePlaceholder(context, s),
          _statisticsPlaceholder(context, s),
          _notificationsPlaceholder(context, s),
        ],
        rightPanelBuilder: (ctx) => _rightPanelContent(ctx),
      ),
    );
  }

  // Main dashboard page - adapts to mobile/desktop
  Widget _dashboardPage(BuildContext context, AppStrings s) {
    final isMobile = ResponsiveDashboardShell.isMobile(context);

    if (isMobile) {
      return _mobileDashboardContent(context, s);
    }
    return _desktopDashboardContent(context, s);
  }

  // Mobile-optimized dashboard
  Widget _mobileDashboardContent(BuildContext context, AppStrings s) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == DashboardStatus.failure) {
          return _errorView(context, s, state.errorMessage);
        }

        final climate = state.climate;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(NeumorphicSpacing.md),
            child: Column(
              children: [
                // Compact temperature card
                MobileTemperatureCard(
                  temperature: climate?.targetTemperature ?? 22,
                  mode: _mapMode(climate?.mode),
                  onTemperatureChanged: (v) =>
                      context.read<DashboardBloc>().add(TemperatureChanged(v)),
                  onModeChanged: (mode) {
                    final climateMode = _reverseMapMode(mode);
                    context.read<DashboardBloc>().add(ClimateModeChanged(climateMode));
                  },
                ),
                const SizedBox(height: NeumorphicSpacing.md),

                // Sensors row (horizontal)
                _mobileSensorsRow(context, state),
                const SizedBox(height: NeumorphicSpacing.md),

                // Device cards grid (2 columns)
                Expanded(
                  child: _mobileDeviceGrid(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mobileSensorsRow(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final climate = state.climate;

    return Row(
      children: [
        Expanded(child: _compactSensorCard(
          icon: Icons.thermostat,
          value: '${climate?.currentTemperature.toStringAsFixed(0) ?? '--'}°',
          label: s.temperature,
          color: NeumorphicColors.modeHeating,
        )),
        const SizedBox(width: 8),
        Expanded(child: _compactSensorCard(
          icon: Icons.water_drop,
          value: '${climate?.humidity.toStringAsFixed(0) ?? '--'}%',
          label: s.humidity,
          color: NeumorphicColors.modeCooling,
        )),
        const SizedBox(width: 8),
        Expanded(child: _compactSensorCard(
          icon: Icons.cloud_outlined,
          value: '${climate?.co2Ppm ?? '--'}',
          label: 'CO₂',
          color: _co2Color(climate?.co2Ppm),
        )),
      ],
    );
  }

  Widget _compactSensorCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final t = NeumorphicTheme.of(context);
    return NeumorphicCard(
      padding: const EdgeInsets.symmetric(
        horizontal: NeumorphicSpacing.sm,
        vertical: NeumorphicSpacing.sm,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(value, style: t.typography.numericMedium.copyWith(color: color)),
          Text(label, style: t.typography.labelSmall),
        ],
      ),
    );
  }

  Widget _mobileDeviceGrid(BuildContext context, DashboardState state) {
    final t = NeumorphicTheme.of(context);
    final climate = state.climate;
    final isOn = climate?.isOn ?? false;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: NeumorphicSpacing.sm,
      mainAxisSpacing: NeumorphicSpacing.sm,
      childAspectRatio: 1.3,
      children: [
        // Device status card
        NeumorphicCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.power_settings_new,
                    color: isOn ? NeumorphicColors.accentPrimary : t.colors.textTertiary,
                  ),
                  NeumorphicToggle(
                    value: isOn,
                    onChanged: (v) => context.read<DashboardBloc>().add(DevicePowerToggled(v)),
                  ),
                ],
              ),
              const Spacer(),
              Text(climate?.deviceName ?? 'HVAC', style: t.typography.titleSmall),
              Text(
                isOn ? 'Активен' : 'Ожидание',
                style: t.typography.labelSmall.copyWith(
                  color: isOn ? NeumorphicColors.accentSuccess : t.colors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        // Quick actions
        NeumorphicCard(
          onTap: () => context.read<DashboardBloc>().add(const DashboardRefreshed()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sync, color: NeumorphicColors.accentPrimary, size: 28),
              const SizedBox(height: 8),
              Text('Синхронизация', style: t.typography.labelSmall),
            ],
          ),
        ),
        // Schedule shortcut
        NeumorphicCard(
          onTap: () => setState(() => _navIndex = 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, color: NeumorphicColors.accentPrimary, size: 28),
              const SizedBox(height: 8),
              Text('Расписание', style: t.typography.labelSmall),
            ],
          ),
        ),
        // Stats shortcut
        NeumorphicCard(
          onTap: () => setState(() => _navIndex = 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, color: NeumorphicColors.accentPrimary, size: 28),
              const SizedBox(height: 8),
              Text('Статистика', style: t.typography.labelSmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _errorView(BuildContext context, AppStrings s, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${s.error}: $message'),
          const SizedBox(height: 16),
          NeumorphicButton(
            onPressed: () => context.read<DashboardBloc>().add(const DashboardRefreshed()),
            child: Text(s.retry),
          ),
        ],
      ),
    );
  }

  // Desktop dashboard content with Bento Grid
  Widget _desktopDashboardContent(BuildContext context, AppStrings s) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == DashboardStatus.failure) {
          return _errorView(context, s, state.errorMessage);
        }

        final climate = state.climate;

        return NeumorphicMainContent(
          title: s.dashboard,
          actions: [_langSwitch(context)],
          child: BentoGrid(
            columns: 4,
            gap: 16,
            cellHeight: 150,
            items: [
              // Row 1: Energy Stats (wide) + Device Status + Temp
              BentoItem(
                size: BentoSize.wide,
                child: _energyStatsCardBento(context, state),
              ),
              BentoItem(
                size: BentoSize.square,
                child: _deviceStatusCardBento(context, state),
              ),
              BentoItem(
                size: BentoSize.square,
                child: _sensorCardBento(
                  context,
                  icon: Icons.thermostat,
                  label: s.temperature,
                  value: '${climate?.currentTemperature.toStringAsFixed(1) ?? '--'}',
                  unit: '°C',
                  color: NeumorphicColors.modeHeating,
                ),
              ),

              // Row 2: Humidity + CO2 + Devices (wide)
              BentoItem(
                size: BentoSize.square,
                child: _sensorCardBento(
                  context,
                  icon: Icons.water_drop,
                  label: s.humidity,
                  value: '${climate?.humidity.toStringAsFixed(0) ?? '--'}',
                  unit: '%',
                  color: NeumorphicColors.modeCooling,
                ),
              ),
              BentoItem(
                size: BentoSize.square,
                child: _sensorCardBento(
                  context,
                  icon: Icons.cloud_outlined,
                  label: 'CO₂',
                  value: '${climate?.co2Ppm ?? '--'}',
                  unit: 'ppm',
                  color: _co2Color(climate?.co2Ppm),
                ),
              ),
              BentoItem(
                size: BentoSize.wide,
                child: _deviceSwitcherCardHorizontal(context),
              ),

              // Row 3: Schedule (wide) + Quick Actions (wide)
              BentoItem(
                size: BentoSize.wide,
                child: _scheduleCardBento(context, state),
              ),
              BentoItem(
                size: BentoSize.wide,
                child: _quickActionsCardBento(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================
  // BENTO CARD VARIANTS (all use NeumorphicCard + unified typography)
  // ============================================

  Widget _energyStatsCardBento(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final t = NeumorphicTheme.of(context);
    final stats = state.energyStats;

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s.usageStatus, style: t.typography.titleMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: NeumorphicColors.accentPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  s.today,
                  style: t.typography.labelSmall.copyWith(
                    color: NeumorphicColors.accentPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _miniStat(context, s.totalSpent, '${stats?.totalKwh.toStringAsFixed(1) ?? '0'}', 'кВт⋅ч'),
              const SizedBox(width: 24),
              _miniStat(context, s.totalHours, '${stats?.totalHours ?? 0}', 'ч'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: EnergyConsumptionChart(
              hourlyData: stats?.hourlyData.isNotEmpty == true
                  ? stats!.hourlyData.map((h) => h.kwh).toList()
                  : EnergyChartData.generateSampleHourlyData(),
              height: 60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(BuildContext context, String label, String value, String unit) {
    final t = NeumorphicTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.typography.labelSmall),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: t.typography.numericMedium),
            const SizedBox(width: 2),
            Text(unit, style: t.typography.labelSmall),
          ],
        ),
      ],
    );
  }

  Widget _deviceStatusCardBento(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final t = NeumorphicTheme.of(context);
    final climate = state.climate;
    final isOn = climate?.isOn ?? false;

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isOn ? NeumorphicColors.accentPrimary : Colors.grey)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.power_settings_new,
                  color: isOn ? NeumorphicColors.accentPrimary : Colors.grey,
                  size: 20,
                ),
              ),
              NeumorphicToggle(
                value: isOn,
                onChanged: (v) => context.read<DashboardBloc>().add(DevicePowerToggled(v)),
              ),
            ],
          ),
          const Spacer(),
          Text(climate?.deviceName ?? 'HVAC', style: t.typography.titleMedium),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOn ? NeumorphicColors.accentSuccess : Colors.grey,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isOn ? s.active : s.standby,
                style: t.typography.labelSmall.copyWith(
                  color: isOn ? NeumorphicColors.accentSuccess : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sensorCardBento(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    final t = NeumorphicTheme.of(context);
    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(label, style: t.typography.labelSmall),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: t.typography.numericLarge),
              const SizedBox(width: 4),
              Text(unit, style: t.typography.labelSmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deviceSwitcherCardHorizontal(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (prev, curr) =>
          prev.hvacDevices != curr.hvacDevices ||
          prev.selectedHvacDeviceId != curr.selectedHvacDeviceId,
      builder: (context, state) {
        // Конвертируем HvacDevice -> DeviceInfo для виджета
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
          onDeviceSelected: (id) {
            context.read<DashboardBloc>().add(HvacDeviceSelected(id));
          },
          onAddDevice: () {
            // TODO: Navigate to add device screen
          },
        );
      },
    );
  }

  Widget _scheduleCardBento(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final t = NeumorphicTheme.of(context);

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s.schedule, style: t.typography.titleMedium),
              Icon(Icons.calendar_month, color: t.colors.textTertiary, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: state.schedule.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = state.schedule[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _scheduleItemBento(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleItemBento(BuildContext context, ScheduleItem item) {
    final t = NeumorphicTheme.of(context);
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.isActive ? NeumorphicColors.accentPrimary : t.colors.textTertiary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          item.time,
          style: t.typography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: item.isActive ? NeumorphicColors.accentPrimary : t.colors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.event,
            style: t.typography.bodyMedium.copyWith(color: t.colors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '${item.temperature.round()}°',
          style: t.typography.labelSmall,
        ),
      ],
    );
  }

  Widget _quickActionsCardBento(BuildContext context) {
    final s = context.l10n;
    final t = NeumorphicTheme.of(context);

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.quickActions, style: t.typography.titleMedium),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _quickActionItem(
                  context,
                  icon: Icons.power_settings_new,
                  label: s.allOff,
                  color: NeumorphicColors.accentError,
                  onTap: () => context.read<DashboardBloc>().add(const AllDevicesOff()),
                )),
                const SizedBox(width: 8),
                Expanded(child: _quickActionItem(
                  context,
                  icon: Icons.sync,
                  label: s.sync,
                  onTap: () => context.read<DashboardBloc>().add(const DashboardRefreshed()),
                )),
                const SizedBox(width: 8),
                Expanded(child: _quickActionItem(
                  context,
                  icon: Icons.calendar_today,
                  label: s.schedule,
                  onTap: () => setState(() => _navIndex = 2),
                )),
                const SizedBox(width: 8),
                Expanded(child: _quickActionItem(
                  context,
                  icon: Icons.settings,
                  label: s.settings,
                  onTap: () {},
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    final t = NeumorphicTheme.of(context);
    final c = color ?? NeumorphicColors.accentPrimary;
    return NeumorphicInteractiveCard(
      onTap: onTap,
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: c, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: t.typography.labelSmall.copyWith(color: c),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _roomsPlaceholder(BuildContext context, AppStrings s) {
    final theme = NeumorphicTheme.of(context);
    return NeumorphicMainContent(
      title: s.rooms,
      actions: [_langSwitch(context)],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.meeting_room, size: 64, color: theme.colors.textTertiary),
            const SizedBox(height: 16),
            Text('Страница комнат в разработке', style: theme.typography.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _schedulePlaceholder(BuildContext context, AppStrings s) {
    final theme = NeumorphicTheme.of(context);
    return NeumorphicMainContent(
      title: s.schedule,
      actions: [_langSwitch(context)],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: theme.colors.textTertiary),
            const SizedBox(height: 16),
            Text('Страница расписания в разработке', style: theme.typography.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _statisticsPlaceholder(BuildContext context, AppStrings s) {
    final theme = NeumorphicTheme.of(context);
    return NeumorphicMainContent(
      title: s.statistics,
      actions: [_langSwitch(context)],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: theme.colors.textTertiary),
            const SizedBox(height: 16),
            Text('Страница статистики в разработке', style: theme.typography.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _notificationsPlaceholder(BuildContext context, AppStrings s) {
    final theme = NeumorphicTheme.of(context);
    return NeumorphicMainContent(
      title: s.notifications,
      actions: [_langSwitch(context)],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_outlined, size: 64, color: theme.colors.textTertiary),
            const SizedBox(height: 16),
            Text('Страница уведомлений в разработке', style: theme.typography.titleMedium),
          ],
        ),
      ),
    );
  }

  // ============================================
  // RIGHT PANEL
  // ============================================
  Widget _rightPanelContent(BuildContext context) {
    final s = context.l10n;
    final t = NeumorphicTheme.of(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      // Оптимизация: перестраивать только при изменении climate
      buildWhen: (prev, curr) => prev.climate != curr.climate,
      builder: (context, state) {
        final climate = state.climate;
        return NeumorphicRightPanel(children: [
          // 1. Temperature Control
          Text(s.targetTemperature, style: t.typography.titleLarge),
          const SizedBox(height: 12),
          Center(child: SizedBox(
            width: 180,
            height: 180,
            child: NeumorphicTemperatureDial(
              value: climate?.targetTemperature ?? 22,
              minValue: 10, maxValue: 30,
              mode: _mapMode(climate?.mode),
              label: _modeLabel(context, climate?.mode ?? ClimateMode.auto),
              onChangeEnd: (v) => context.read<DashboardBloc>().add(TemperatureChanged(v)),
            ),
          )),
          const SizedBox(height: 12),
          
          // 2. Mode Selector (Segmented Control)
          NeumorphicSegmentedControl<ClimateMode>(
            segments: [
              SegmentItem(
                value: ClimateMode.heating,
                label: s.heating,
                icon: Icons.whatshot_outlined,
                activeColor: NeumorphicColors.modeHeating,
              ),
              SegmentItem(
                value: ClimateMode.cooling,
                label: s.cooling,
                icon: Icons.ac_unit,
                activeColor: NeumorphicColors.modeCooling,
              ),
              SegmentItem(
                value: ClimateMode.auto,
                label: s.auto,
                icon: Icons.autorenew,
                activeColor: NeumorphicColors.modeAuto,
              ),
              SegmentItem(
                value: ClimateMode.ventilation,
                label: s.ventilation,
                icon: Icons.air,
                activeColor: NeumorphicColors.accentPrimary,
              ),
            ],
            selectedValue: climate?.mode ?? ClimateMode.auto,
            onSelected: (mode) => context.read<DashboardBloc>().add(ClimateModeChanged(mode)),
          ),
          const SizedBox(height: 20),
          
          // 3. Airflow Control
          Text(s.airflowControl, style: t.typography.titleMedium),
          const SizedBox(height: 12),
          NeumorphicSlider(
            label: s.supplyAirflow,
            value: climate?.supplyAirflow ?? 50,
            suffix: '%',
            activeColor: NeumorphicColors.accentPrimary,
            onChangeEnd: (v) => context.read<DashboardBloc>().add(SupplyAirflowChanged(v)),
          ),
          const SizedBox(height: 12),
          NeumorphicSlider(
            label: s.exhaustAirflow,
            value: climate?.exhaustAirflow ?? 40,
            suffix: '%',
            activeColor: NeumorphicColors.modeCooling,
            onChangeEnd: (v) => context.read<DashboardBloc>().add(ExhaustAirflowChanged(v)),
          ),
          const SizedBox(height: 20),
          
          // 4. Presets (Icon Grid 2×3)
          Text(s.presets, style: t.typography.titleMedium),
          const SizedBox(height: 12),
          NeumorphicPresetGrid(
            presets: [
              PresetItem(id: 'auto', label: s.auto, icon: Icons.hdr_auto, activeColor: NeumorphicColors.modeAuto),
              PresetItem(id: 'night', label: s.night, icon: Icons.nights_stay, activeColor: NeumorphicColors.modeCooling),
              PresetItem(id: 'turbo', label: s.turbo, icon: Icons.rocket_launch, activeColor: NeumorphicColors.modeHeating),
              PresetItem(id: 'eco', label: s.eco, icon: Icons.eco, activeColor: NeumorphicColors.accentSuccess),
              PresetItem(id: 'away', label: s.away, icon: Icons.sensor_door, activeColor: NeumorphicColors.accentPrimary),
            ],
            selectedId: climate?.preset ?? 'auto',
            onSelected: (id) => context.read<DashboardBloc>().add(PresetChanged(id)),
          ),
        ]);
      },
    );
  }

  // ============================================
  // HELPERS
  // ============================================
  Widget _langSwitch(BuildContext context) {
    final loc = context.locale;
    return PopupMenuButton<AppLocale>(
      initialValue: loc,
      onSelected: (l) => context.setLocale(l),
      itemBuilder: (_) => AppLocale.values.map((l) => PopupMenuItem(
        value: l,
        child: Row(children: [
          if (l == loc) const Icon(Icons.check, size: 16),
          const SizedBox(width: 8),
          Text(l.name),
        ]),
      )).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: NeumorphicColors.lightCardSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.language, size: 18),
          const SizedBox(width: 6),
          Text(loc.code.toUpperCase()),
        ]),
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

  // Mappers
  TemperatureMode _mapMode(ClimateMode? m) => switch (m) {
    ClimateMode.heating => TemperatureMode.heating,
    ClimateMode.cooling => TemperatureMode.cooling,
    ClimateMode.auto => TemperatureMode.auto,
    ClimateMode.dry => TemperatureMode.dry,
    _ => TemperatureMode.auto,
  };

  ClimateMode _reverseMapMode(TemperatureMode m) => switch (m) {
    TemperatureMode.heating => ClimateMode.heating,
    TemperatureMode.cooling => ClimateMode.cooling,
    TemperatureMode.auto => ClimateMode.auto,
    TemperatureMode.dry => ClimateMode.dry,
  };

  String _modeLabel(BuildContext c, ClimateMode m) {
    final s = c.l10n;
    return switch (m) {
      ClimateMode.heating => s.heating,
      ClimateMode.cooling => s.cooling,
      ClimateMode.auto => s.auto,
      ClimateMode.dry => s.dry,
      ClimateMode.ventilation => s.ventilation,
      ClimateMode.off => s.turnedOff,
    };
  }

}
