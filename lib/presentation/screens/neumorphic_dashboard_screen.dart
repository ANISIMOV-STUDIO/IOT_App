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
            const SizedBox(height: NeumorphicSpacing.xl),
          ]),
        );
      },
    );
  }

  // ============================================
  // 1. СТАТУС УСТРОЙСТВА
  // ============================================
  Widget _deviceStatusCard(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final t = NeumorphicThemeData.light();
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
          const Spacer(),
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
    final t = NeumorphicThemeData.light();
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
            const Spacer(),
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
    final t = NeumorphicThemeData.light();

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

    return Column(children: [
      Row(children: [
        Expanded(child: _actionButton(
          icon: Icons.power_settings_new,
          label: s.allOff,
          color: NeumorphicColors.accentError,
          onTap: () => context.read<DashboardBloc>().add(const AllDevicesOff()),
        )),
        const SizedBox(width: NeumorphicSpacing.sm),
        Expanded(child: _actionButton(
          icon: Icons.calendar_today,
          label: s.schedule,
          onTap: () {},
        )),
      ]),
      const SizedBox(height: NeumorphicSpacing.sm),
      Row(children: [
        Expanded(child: _actionButton(
          icon: Icons.sync,
          label: s.sync,
          onTap: () => context.read<DashboardBloc>().add(const DashboardRefreshed()),
        )),
        const SizedBox(width: NeumorphicSpacing.sm),
        Expanded(child: _actionButton(
          icon: Icons.settings,
          label: s.settings,
          onTap: () {},
        )),
      ]),
    ]);
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    final t = NeumorphicThemeData.light();
    final c = color ?? NeumorphicColors.accentPrimary;

    return NeumorphicButton(
      onPressed: onTap,
      size: NeumorphicButtonSize.large,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: c, size: 22),
          const SizedBox(height: 4),
          Text(label, style: t.typography.labelSmall),
        ],
      ),
    );
  }

  // ============================================
  // 5. СТАТИСТИКА ЭНЕРГИИ
  // ============================================
  Widget _energyStatsCard(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final t = NeumorphicThemeData.light();
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
    final t = NeumorphicThemeData.light();

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final climate = state.climate;
        return NeumorphicRightPanel(children: [
          // 1. Temperature Control
          Text(s.targetTemperature, style: t.typography.titleLarge),
          const SizedBox(height: NeumorphicSpacing.md),
          Center(child: SizedBox(
            width: 200,
            height: 200,
            child: NeumorphicTemperatureDial(
              value: climate?.targetTemperature ?? 22,
              minValue: 10, maxValue: 30,
              mode: _mapMode(climate?.mode),
              label: _modeLabel(context, climate?.mode ?? ClimateMode.auto),
              onChangeEnd: (v) => context.read<DashboardBloc>().add(TemperatureChanged(v)),
            ),
          )),
          const SizedBox(height: NeumorphicSpacing.md),
          
          // 2. Mode Selector
          _modeSelector(context, climate?.mode ?? ClimateMode.auto),
          const SizedBox(height: NeumorphicSpacing.xl),
          
          // 3. Airflow Control
          Text(s.airflowControl, style: t.typography.titleMedium),
          const SizedBox(height: NeumorphicSpacing.md),
          NeumorphicSlider(
            label: s.supplyAirflow,
            value: climate?.supplyAirflow ?? 50,
            suffix: '%',
            activeColor: NeumorphicColors.accentPrimary,
            onChangeEnd: (v) => context.read<DashboardBloc>().add(SupplyAirflowChanged(v)),
          ),
          const SizedBox(height: NeumorphicSpacing.md),
          NeumorphicSlider(
            label: s.exhaustAirflow,
            value: climate?.exhaustAirflow ?? 40,
            suffix: '%',
            activeColor: NeumorphicColors.modeCooling,
            onChangeEnd: (v) => context.read<DashboardBloc>().add(ExhaustAirflowChanged(v)),
          ),
          const SizedBox(height: NeumorphicSpacing.xl),
          
          // 4. Presets
          Text(s.presets, style: t.typography.titleMedium),
          const SizedBox(height: NeumorphicSpacing.sm),
          _presetsGrid(context, climate?.preset ?? 'auto'),
        ]);
      },
    );
  }

  Widget _modeSelector(BuildContext context, ClimateMode current) {
    final t = NeumorphicThemeData.light();
    final modes = [ClimateMode.heating, ClimateMode.cooling, ClimateMode.auto, ClimateMode.ventilation];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: modes.map((m) {
        final sel = m == current;
        return GestureDetector(
          onTap: () => context.read<DashboardBloc>().add(ClimateModeChanged(m)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: sel ? t.colors.cardSurface : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: sel ? t.shadows.convexSmall : null,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(_modeIcon(m), color: sel ? _modeColor(m) : t.colors.textTertiary, size: 22),
              const SizedBox(height: 2),
              Text(
                _modeLabel(context, m),
                style: t.typography.labelSmall.copyWith(
                  color: sel ? t.colors.textPrimary : t.colors.textTertiary,
                  fontSize: 10,
                ),
              ),
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget _presetsGrid(BuildContext context, String currentPreset) {
    final s = context.l10n;
    final presets = [
      ('auto', s.auto, Icons.hdr_auto),
      ('night', s.night, Icons.nights_stay),
      ('turbo', s.turbo, Icons.rocket_launch),
      ('eco', s.eco, Icons.eco),
      ('away', s.away, Icons.sensor_door),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((p) {
        final isSelected = currentPreset == p.$1;
        return _presetChip(
          context,
          label: p.$2,
          icon: p.$3,
          isSelected: isSelected,
          onTap: () => context.read<DashboardBloc>().add(PresetChanged(p.$1)),
        );
      }).toList(),
    );
  }

  Widget _presetChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final t = NeumorphicThemeData.light();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? NeumorphicColors.accentPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? NeumorphicColors.accentPrimary : t.colors.textTertiary,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : t.colors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: t.typography.labelSmall.copyWith(
                color: isSelected ? Colors.white : t.colors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
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

  IconData _modeIcon(ClimateMode m) => switch (m) {
    ClimateMode.heating => Icons.whatshot_outlined,
    ClimateMode.cooling => Icons.ac_unit,
    ClimateMode.auto => Icons.autorenew,
    ClimateMode.dry => Icons.water_drop_outlined,
    ClimateMode.ventilation => Icons.air,
    ClimateMode.off => Icons.power_settings_new,
  };

  Color _modeColor(ClimateMode m) => switch (m) {
    ClimateMode.heating => NeumorphicColors.modeHeating,
    ClimateMode.cooling => NeumorphicColors.modeCooling,
    ClimateMode.auto => NeumorphicColors.modeAuto,
    ClimateMode.dry => NeumorphicColors.modeDry,
    ClimateMode.ventilation => NeumorphicColors.accentPrimary,
    ClimateMode.off => Colors.grey,
  };
}
