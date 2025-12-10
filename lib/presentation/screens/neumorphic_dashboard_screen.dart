import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart' hide AirQualityLevel;

import '../../core/di/injection_container.dart';
import '../../core/l10n/l10n.dart';
import '../../domain/entities/climate.dart';
import '../bloc/dashboard/dashboard_bloc.dart';

/// Главный экран Smart Home Dashboard
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
        NeumorphicNavItem(icon: Icons.history, label: s.recent),
        NeumorphicNavItem(icon: Icons.bookmark_outline, label: s.bookmarks),
        NeumorphicNavItem(icon: Icons.notifications_outlined, label: s.notifications, badge: '3'),
        NeumorphicNavItem(icon: Icons.download_outlined, label: s.downloads),
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
              NeumorphicButton(onPressed: () => context.read<DashboardBloc>().add(const DashboardRefreshed()), child: Text(s.retry)),
            ],
          ));
        }
        return NeumorphicMainContent(
          title: s.myDevices,
          actions: [_langSwitch(context)],
          child: Column(children: [
            _devicesGrid(context, state),
            const SizedBox(height: NeumorphicSpacing.sectionGap),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 2, child: _usageCard(context, state)),
              const SizedBox(width: NeumorphicSpacing.cardGap),
              Expanded(flex: 2, child: _appliancesCard(context)),
            ]),
            const SizedBox(height: NeumorphicSpacing.cardGap),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _powerCard(context, state)),
              const SizedBox(width: NeumorphicSpacing.cardGap),
              Expanded(child: _occupantsCard(context, state)),
            ]),
            const SizedBox(height: NeumorphicSpacing.xl),
          ]),
        );
      },
    );
  }

  Widget _rightPanel(BuildContext context) {
    final s = context.l10n;
    final t = NeumorphicThemeData.light();
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final climate = state.climate;
        return NeumorphicRightPanel(children: [
          // Temperature section
          Text(s.temperature, style: t.typography.titleLarge),
          const SizedBox(height: NeumorphicSpacing.md),
          Center(child: SizedBox(
            width: 220,
            height: 220,
            child: NeumorphicTemperatureDial(
              value: climate?.targetTemperature ?? 22,
              minValue: 10, maxValue: 30,
              mode: _mapMode(climate?.mode),
              label: _modeLabel(context, climate?.mode ?? ClimateMode.heating),
              onChanged: (v) => context.read<DashboardBloc>().add(TemperatureChanged(v)),
            ),
          )),
          const SizedBox(height: NeumorphicSpacing.md),
          _modeSelector(context, climate?.mode ?? ClimateMode.heating),
          const SizedBox(height: NeumorphicSpacing.lg),
          
          // Humidity section
          NeumorphicSlider(label: s.humidity, value: climate?.humidity ?? 60, suffix: '%',
            onChanged: (v) => context.read<DashboardBloc>().add(HumidityChanged(v))),
          const SizedBox(height: NeumorphicSpacing.sm),
          NeumorphicSliderPresets(currentValue: climate?.humidity ?? 60, presets: [
            SliderPreset(label: s.auto, value: 50),
            const SliderPreset(label: '30%', value: 30),
            const SliderPreset(label: '60%', value: 60),
          ], onPresetSelected: (v) => context.read<DashboardBloc>().add(HumidityChanged(v))),
          const SizedBox(height: NeumorphicSpacing.lg),
          
          // Air quality section
          _airQualityCard(context, state),
        ]);
      },
    );
  }

  Widget _devicesGrid(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final devices = state.devices;
    final row1 = devices.take(3).toList();
    final row2 = devices.skip(3).take(3).toList();
    return Column(children: [
      _deviceRow(context, row1, s),
      const SizedBox(height: NeumorphicSpacing.cardGap),
      _deviceRow(context, row2, s),
    ]);
  }

  Widget _deviceRow(BuildContext context, List devices, AppStrings s) {
    if (devices.isEmpty) return const SizedBox.shrink();
    return Row(children: devices.map((d) => Expanded(child: Padding(
      padding: EdgeInsets.only(right: d != devices.last ? NeumorphicSpacing.cardGap : 0),
      child: SizedBox(height: 140, child: NeumorphicDeviceCard(
        name: _deviceName(d.type, s),
        icon: _deviceIcon(d.type),
        isOn: d.isOn,
        subtitle: '${s.activeFor} ${d.activeTime.inHours} ${s.hours(d.activeTime.inHours)}',
        powerConsumption: '${d.powerConsumption.toStringAsFixed(0)}кВт',
        onToggle: (v) => context.read<DashboardBloc>().add(DeviceToggled(d.id, v)),
      )),
    ))).toList());
  }

  Widget _langSwitch(BuildContext context) {
    final loc = context.locale;
    return PopupMenuButton<AppLocale>(
      initialValue: loc,
      onSelected: (l) => context.setLocale(l),
      itemBuilder: (_) => AppLocale.values.map((l) => PopupMenuItem(value: l, child: Row(children: [
        if (l == loc) const Icon(Icons.check, size: 16),
        const SizedBox(width: 8), Text(l.name),
      ]))).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: NeumorphicColors.lightCardSurface, borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.language, size: 18), const SizedBox(width: 6), Text(loc.code.toUpperCase()),
        ]),
      ),
    );
  }

  Widget _modeSelector(BuildContext context, ClimateMode current) {
    final t = NeumorphicThemeData.light();
    // Только основные 4 режима для компактности
    final modes = [ClimateMode.heating, ClimateMode.cooling, ClimateMode.auto, ClimateMode.dry];
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: modes.map((m) {
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
            Text(_modeLabel(context, m), style: t.typography.labelSmall.copyWith(color: sel ? t.colors.textPrimary : t.colors.textTertiary, fontSize: 10)),
          ]),
        ),
      );
    }).toList());
  }

  Widget _airQualityCard(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final t = NeumorphicThemeData.light();
    final aq = state.airQuality;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(s.airQuality, style: t.typography.titleLarge),
        Text(_aqLevelText(aq, s), style: t.typography.titleMedium.copyWith(color: _aqLevelColor(aq))),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _statCard(t, _co2Status(state.co2Ppm, s), s.co2, '${state.co2Ppm ?? 0}', 'ppm')),
        const SizedBox(width: 8),
        Expanded(child: _statCard(t, _aqiStatus(state.pollutantsAqi, s), s.pollutants, '${state.pollutantsAqi ?? 0}', 'AQI')),
      ]),
    ]);
  }

  Widget _usageCard(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final t = NeumorphicThemeData.light();
    final st = state.energyStats;
    return NeumorphicCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(s.usageStatus, style: t.typography.titleMedium),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: NeumorphicColors.lightSurface, borderRadius: BorderRadius.circular(8)),
          child: Text(s.today, style: t.typography.labelSmall)),
      ]),
      const SizedBox(height: 16),
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.totalSpent, style: t.typography.labelSmall),
          Text('${st?.totalKwh.toStringAsFixed(2) ?? '0'}кВт⋅ч', style: t.typography.numericLarge),
        ]),
        const SizedBox(width: 32),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.totalHours, style: t.typography.labelSmall),
          Text('${st?.totalHours ?? 0}ч', style: t.typography.numericLarge),
        ]),
      ]),
      const SizedBox(height: 24),
      Container(height: 80, decoration: BoxDecoration(color: NeumorphicColors.lightSurface, borderRadius: BorderRadius.circular(8)),
        child: const Center(child: Text('График'))),
    ]));
  }

  Widget _appliancesCard(BuildContext context) {
    final s = context.l10n;
    final t = NeumorphicThemeData.light();
    return NeumorphicCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(s.appliances.toUpperCase(), style: t.typography.titleMedium),
      const SizedBox(height: 12),
      Wrap(spacing: 12, children: [s.all, s.hall, s.lounge, s.bedroom].map((x) => Text(x, style: t.typography.labelSmall)).toList()),
      const SizedBox(height: 16),
      _appRow(t, s.tvSet, s.lightFixture, false, 50),
      _appRow(t, s.stereoSystem, s.backlight, true, 70),
      _appRow(t, s.playStation, '${s.lamp} 1', false, 10),
      _appRow(t, s.computer, '${s.lamp} 2', false, 30),
    ]));
  }

  Widget _powerCard(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final t = NeumorphicThemeData.light();
    return NeumorphicCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(s.devicePowerConsumption, style: t.typography.titleMedium),
      const SizedBox(height: 12),
      ...state.powerUsage.map((p) => _pwrRow(t, _pwrIcon(p.deviceType), p.deviceName, s.units(p.unitCount), '${p.totalKwh.toStringAsFixed(0)}кВт')),
    ]));
  }

  Widget _occupantsCard(BuildContext context, DashboardState state) {
    final s = context.l10n;
    final t = NeumorphicThemeData.light();
    return NeumorphicCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(s.occupants, style: t.typography.titleMedium),
        Text('${s.seeAll} →', style: t.typography.labelSmall),
      ]),
      const SizedBox(height: 16),
      Wrap(spacing: 8, runSpacing: 8, children: [
        ...state.occupants.map((o) => _avatar(o.name, o.isHome)),
        _avatarAdd(s.add),
      ]),
    ]));
  }

  // Helpers
  Widget _statCard(NeumorphicThemeData t, String st, String lb, String v, String u) => NeumorphicCard(
    padding: const EdgeInsets.all(10), variant: NeumorphicCardVariant.flat,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(st, style: t.typography.labelSmall, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 4),
      Row(children: [
        Flexible(child: Text(lb, style: t.typography.bodySmall, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 4),
        Text(v, style: t.typography.numericMedium),
        Text(u, style: t.typography.labelSmall),
      ]),
    ]));

  Widget _appRow(NeumorphicThemeData t, String l, String r, bool on, int p) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Expanded(child: Row(children: [Text(l, style: t.typography.bodySmall), const Spacer(), Switch(value: on, onChanged: null, activeThumbColor: NeumorphicColors.accentPrimary)])),
      const SizedBox(width: 16),
      Expanded(child: Row(children: [Text(r, style: t.typography.bodySmall), const Spacer(), Text('$p%', style: t.typography.labelSmall)])),
    ]));

  Widget _pwrRow(NeumorphicThemeData t, IconData ic, String nm, String un, String pw) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Container(width: 32, height: 32, decoration: BoxDecoration(color: NeumorphicColors.lightSurface, borderRadius: BorderRadius.circular(8)), child: Icon(ic, size: 16)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(nm, style: t.typography.bodySmall), Text(un, style: t.typography.labelSmall)])),
      Text(pw, style: t.typography.numericMedium),
    ]));

  Widget _avatar(String n, bool home) => Column(children: [
    CircleAvatar(radius: 22, backgroundColor: home ? NeumorphicColors.accentPrimary : NeumorphicColors.lightShadowDark, child: Text(n[0], style: const TextStyle(color: Colors.white))),
    const SizedBox(height: 4), Text(n, style: NeumorphicThemeData.light().typography.labelSmall),
  ]);

  Widget _avatarAdd(String lb) => Column(children: [
    const CircleAvatar(radius: 22, backgroundColor: NeumorphicColors.lightSurface, child: Icon(Icons.add, size: 18)),
    const SizedBox(height: 4), Text(lb, style: NeumorphicThemeData.light().typography.labelSmall),
  ]);

  // Mappers
  TemperatureMode _mapMode(ClimateMode? m) => switch (m) { ClimateMode.heating => TemperatureMode.heating, ClimateMode.cooling => TemperatureMode.cooling, ClimateMode.auto => TemperatureMode.auto, ClimateMode.dry => TemperatureMode.dry, _ => TemperatureMode.auto };
  String _modeLabel(BuildContext c, ClimateMode m) { final s = c.l10n; return switch (m) { ClimateMode.heating => s.heating, ClimateMode.cooling => s.cooling, ClimateMode.auto => s.auto, ClimateMode.dry => s.dry, ClimateMode.ventilation => s.ventilation, ClimateMode.off => s.turnedOff }; }
  IconData _modeIcon(ClimateMode m) => switch (m) { ClimateMode.heating => Icons.whatshot_outlined, ClimateMode.cooling => Icons.ac_unit, ClimateMode.auto => Icons.autorenew, ClimateMode.dry => Icons.water_drop_outlined, ClimateMode.ventilation => Icons.air, ClimateMode.off => Icons.power_settings_new };
  Color _modeColor(ClimateMode m) => switch (m) { ClimateMode.heating => NeumorphicColors.modeHeating, ClimateMode.cooling => NeumorphicColors.modeCooling, ClimateMode.auto => NeumorphicColors.modeAuto, ClimateMode.dry => NeumorphicColors.modeDry, ClimateMode.ventilation => NeumorphicColors.accentPrimary, ClimateMode.off => Colors.grey };
  String _deviceName(dynamic t, AppStrings s) => switch (t.toString()) { 'SmartDeviceType.tv' => s.smartTv, 'SmartDeviceType.speaker' => s.speaker, 'SmartDeviceType.router' => s.router, 'SmartDeviceType.wifi' => s.wifi, 'SmartDeviceType.heater' => s.heater, 'SmartDeviceType.socket' => s.socket, 'SmartDeviceType.lamp' => s.smartLamp, 'SmartDeviceType.airCondition' => s.airCondition, _ => 'Устройство' };
  IconData _deviceIcon(dynamic t) => switch (t.toString()) { 'SmartDeviceType.tv' => Icons.tv, 'SmartDeviceType.speaker' => Icons.speaker, 'SmartDeviceType.router' => Icons.router, 'SmartDeviceType.wifi' => Icons.wifi, 'SmartDeviceType.heater' => Icons.heat_pump, 'SmartDeviceType.socket' => Icons.power, 'SmartDeviceType.lamp' => Icons.lightbulb_outline, 'SmartDeviceType.airCondition' => Icons.ac_unit, _ => Icons.devices };
  IconData _pwrIcon(String t) => switch (t) { 'airCondition' => Icons.ac_unit, 'lamp' => Icons.lightbulb_outline, 'tv' => Icons.tv, 'speaker' => Icons.speaker, _ => Icons.devices };
  String _aqLevelText(AirQualityLevel? l, AppStrings s) => switch (l) { AirQualityLevel.excellent => s.excellent, AirQualityLevel.good => s.good, AirQualityLevel.moderate => s.moderate, AirQualityLevel.poor => s.poor, AirQualityLevel.hazardous => s.hazardous, _ => s.good };
  Color _aqLevelColor(AirQualityLevel? l) => switch (l) { AirQualityLevel.excellent => NeumorphicColors.airQualityExcellent, AirQualityLevel.good => NeumorphicColors.airQualityGood, AirQualityLevel.moderate => NeumorphicColors.airQualityModerate, AirQualityLevel.poor => NeumorphicColors.airQualityPoor, AirQualityLevel.hazardous => NeumorphicColors.airQualityHazardous, _ => NeumorphicColors.airQualityGood };
  String _co2Status(int? v, AppStrings s) { if (v == null) return s.good; if (v < 600) return s.excellent; if (v < 800) return s.good; if (v < 1000) return s.moderate; return s.poor; }
  String _aqiStatus(int? v, AppStrings s) { if (v == null) return s.good; if (v < 50) return s.excellent; if (v < 100) return s.good; if (v < 150) return s.moderate; return s.poor; }
}
