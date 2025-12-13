import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart' hide AirQualityLevel;

import '../../core/di/injection_container.dart';
import '../../core/l10n/l10n.dart';
import '../../domain/entities/climate.dart';
import '../bloc/dashboard/dashboard_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      data: NeumorphicThemeData.light(),
      child: NeumorphicDashboardShell(
        sidebar: _sidebar(context),
        mainContent: _mainContent(context),
        rightPanel: _rightPanel(context),
      ),
    );
  }

  Widget _sidebar(BuildContext context) {
    final s = context.l10n;
    return NeumorphicSidebar(
      selectedIndex: _navIndex,
      onItemSelected: (i) => setState(() => _navIndex = i),
      userName: 'Артём',
      items: [
        NeumorphicNavItem(icon: Icons.dashboard, label: s.dashboard),
        NeumorphicNavItem(icon: Icons.meeting_room, label: s.rooms),
        NeumorphicNavItem(icon: Icons.calendar_today, label: s.schedule),
        NeumorphicNavItem(icon: Icons.bar_chart, label: s.statistics),
        NeumorphicNavItem(icon: Icons.notifications_outlined, label: s.notifications, badge: '2'),
      ],
      bottomItems: [
        NeumorphicNavItem(icon: Icons.help_outline, label: s.support),
        NeumorphicNavItem(icon: Icons.settings_outlined, label: s.settings),
      ],
    );
  }

  Widget _mainContent(BuildContext context) {
    final s = context.l10n;
    
    // Переключение контента по вкладкам
    return switch (_navIndex) {
      0 => _dashboardContent(context, s),
      1 => _roomsPlaceholder(context, s),
      2 => _schedulePlaceholder(context, s),
      3 => _statisticsPlaceholder(context, s),
      4 => _notificationsPlaceholder(context, s),
      _ => _dashboardContent(context, s),
    };
  }

  Widget _dashboardContent(BuildContext context, AppStrings s) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == DashboardStatus.failure) {
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${s.error}: ${state.errorMessage}'),
              const SizedBox(height: 16),
              NeumorphicButton(
                onPressed: () => context.read<DashboardBloc>().add(const DashboardRefreshed()),
                child: Text(s.retry),
              ),
            ],
          ));
        }
        return NeumorphicMainContent(
          title: s.dashboard,
          actions: [_langSwitch(context)],
          child: Column(children: [
            // Row 1: Device Status + Sensors
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 1, child: _deviceStatusCard(context, state)),
              const SizedBox(width: NeumorphicSpacing.cardGap),
              Expanded(flex: 2, child: _sensorsGrid(context, state)),
            ]),
            const SizedBox(height: NeumorphicSpacing.cardGap),
            
            // Row 2: Schedule + Quick Actions
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 3, child: _scheduleCard(context, state)),
              const SizedBox(width: NeumorphicSpacing.cardGap),
              Expanded(flex: 2, child: _quickActionsCard(context)),
            ]),
            const SizedBox(height: NeumorphicSpacing.cardGap),
            
            // Row 3: Energy Stats
            _energyStatsCard(context, state),
            const SizedBox(height: 24),
          ]),
        );
      },
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
  // 1. СТАТУС УСТРОЙСТВА
  // ============================================
  Widget _deviceStatusCard(BuildContext context, DashboardState state) {
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
              Icon(
                Icons.power_settings_new,
                color: isOn ? NeumorphicColors.accentPrimary : t.colors.textTertiary,
                size: 28,
              ),
              NeumorphicToggle(
                value: isOn,
                onChanged: (v) => context.read<DashboardBloc>().add(DevicePowerToggled(v)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            climate?.deviceName ?? 'HVAC Unit',
            style: t.typography.headlineMedium,
          ),
          const SizedBox(height: 4),
          Row(children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn ? NeumorphicColors.accentSuccess : t.colors.textTertiary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isOn ? s.active : s.standby,
              style: t.typography.bodyMedium.copyWith(
                color: isOn ? NeumorphicColors.accentSuccess : t.colors.textTertiary,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // ============================================
  // 2. СЕНСОРЫ (Температура, Влажность, CO2)
  // ============================================
  Widget _sensorsGrid(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final climate = state.climate;

    return Row(children: [
      Expanded(child: _sensorCard(
        icon: Icons.thermostat,
        label: s.currentTemperature,
        value: '${climate?.currentTemperature.toStringAsFixed(1) ?? '--'}',
        unit: '°C',
        color: NeumorphicColors.modeHeating,
      )),
      const SizedBox(width: NeumorphicSpacing.cardGap),
      Expanded(child: _sensorCard(
        icon: Icons.water_drop,
        label: s.humidity,
        value: '${climate?.humidity.toStringAsFixed(0) ?? '--'}',
        unit: '%',
        color: NeumorphicColors.modeCooling,
      )),
      const SizedBox(width: NeumorphicSpacing.cardGap),
      Expanded(child: _sensorCard(
        icon: Icons.cloud_outlined,
        label: s.co2,
        value: '${climate?.co2Ppm ?? '--'}',
        unit: 'ppm',
        color: _co2Color(climate?.co2Ppm),
      )),
    ]);
  }

  Widget _sensorCard({
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
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          ]),
          const SizedBox(height: 12),
          Text(label, style: t.typography.labelSmall),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: t.typography.numericLarge),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(unit, style: t.typography.labelSmall),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================
  // 3. РАСПИСАНИЕ
  // ============================================
  Widget _scheduleCard(BuildContext context, DashboardState state) {
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
          const SizedBox(height: 16),
          ...state.schedule.asMap().entries.map((entry) {
            final item = entry.value;
            final isLast = entry.key == state.schedule.length - 1;
            return _scheduleItem(t, item, isLast);
          }),
        ],
      ),
    );
  }

  Widget _scheduleItem(NeumorphicThemeData t, ScheduleItem item, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot and line
        Column(children: [
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.isActive ? NeumorphicColors.accentPrimary : t.colors.textTertiary,
              border: item.isActive ? null : Border.all(color: t.colors.textTertiary, width: 2),
            ),
          ),
          if (!isLast)
            Container(
              width: 2, height: 32,
              color: t.colors.textTertiary.withValues(alpha: 0.3),
            ),
        ]),
        const SizedBox(width: 12),
        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Row(children: [
              Text(item.time, style: t.typography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.event, style: t.typography.bodyMedium),
                  Text('${item.temperature.round()}°C', style: t.typography.labelSmall),
                ],
              )),
              if (item.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: NeumorphicColors.accentPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Активно',
                    style: t.typography.labelSmall.copyWith(
                      color: NeumorphicColors.accentPrimary,
                      fontSize: 10,
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ],
    );
  }

  // ============================================
  // 4. БЫСТРЫЕ ДЕЙСТВИЯ
  // ============================================
  Widget _quickActionsCard(BuildContext context) {
    final s = context.l10n;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(children: [
          Expanded(child: _actionButton(
            icon: Icons.power_settings_new,
            label: s.allOff,
            color: NeumorphicColors.accentError,
            onTap: () => context.read<DashboardBloc>().add(const AllDevicesOff()),
          )),
          const SizedBox(width: 8),
          Expanded(child: _actionButton(
            icon: Icons.calendar_today,
            label: s.schedule,
            onTap: () => setState(() => _navIndex = 2),
          )),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _actionButton(
            icon: Icons.sync,
            label: s.sync,
            onTap: () => context.read<DashboardBloc>().add(const DashboardRefreshed()),
          )),
          const SizedBox(width: 8),
          Expanded(child: _actionButton(
            icon: Icons.settings,
            label: s.settings,
            onTap: () {},
          )),
        ]),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    final t = NeumorphicTheme.of(context);
    final c = color ?? NeumorphicColors.accentPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: t.colors.cardSurface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: t.shadows.convexSmall,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: c, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: t.typography.labelSmall.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // 5. СТАТИСТИКА ЭНЕРГИИ
  // ============================================
  Widget _energyStatsCard(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final t = NeumorphicTheme.of(context);
    final stats = state.energyStats;

    return NeumorphicCard(
      child: Row(children: [
        // Left: Stats
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s.usageStatus, style: t.typography.titleMedium),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: t.colors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(s.today, style: t.typography.labelSmall),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(children: [
                _statItem(t, s.totalSpent, '${stats?.totalKwh.toStringAsFixed(1) ?? '0'}', 'кВт⋅ч'),
                const SizedBox(width: 40),
                _statItem(t, s.totalHours, '${stats?.totalHours ?? 0}', 'ч'),
              ]),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Right: Chart placeholder
        Expanded(
          flex: 3,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: t.colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('📊 График потребления', style: t.typography.labelSmall),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _statItem(NeumorphicThemeData t, String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.typography.labelSmall),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: t.typography.numericLarge),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(unit, style: t.typography.labelSmall),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================
  // RIGHT PANEL
  // ============================================
  Widget _rightPanel(BuildContext context) {
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
