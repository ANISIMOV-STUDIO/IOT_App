/// Dashboard Screen - Main app screen with home, rooms, schedule, stats, notifications
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection_container.dart' as di;
import '../../../core/l10n/l10n.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../widgets/layout/app_shell.dart';
import '../../widgets/ui/ui.dart';

/// Main dashboard screen
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
        NavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: s.dashboard,
        ),
        NavItem(
          icon: Icons.meeting_room_outlined,
          activeIcon: Icons.meeting_room,
          label: s.rooms,
        ),
        NavItem(
          icon: Icons.schedule_outlined,
          activeIcon: Icons.schedule,
          label: s.schedule,
        ),
        NavItem(
          icon: Icons.bar_chart_outlined,
          activeIcon: Icons.bar_chart,
          label: s.statistics,
        ),
        NavItem(
          icon: Icons.notifications_outlined,
          activeIcon: Icons.notifications,
          label: s.notifications,
          badgeCount: 2,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return AppShell(
      selectedIndex: _navIndex,
      onIndexChanged: (i) => setState(() => _navIndex = i),
      navItems: _navItems(s),
      userName: 'Артём',
      headerActions: [
        _ThemeToggle(),
        const SizedBox(width: 8),
        _SettingsButton(),
      ],
      pages: [
        const _HomePage(),
        _PlaceholderPage(title: s.rooms, icon: Icons.meeting_room),
        _PlaceholderPage(title: s.schedule, icon: Icons.schedule),
        _PlaceholderPage(title: s.statistics, icon: Icons.bar_chart),
        _PlaceholderPage(title: s.notifications, icon: Icons.notifications),
      ],
    );
  }
}

/// Home page with welcome banner, devices, stats
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return isMobile ? _MobileHome(state: state) : _DesktopHome(state: state);
      },
    );
  }
}

/// Mobile home layout
class _MobileHome extends StatelessWidget {
  final DashboardState state;

  const _MobileHome({required this.state});

  @override
  Widget build(BuildContext context) {
    final climate = state.climate;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome banner
          const WelcomeBanner(
            userName: 'Артём',
            subtitle: 'Все системы работают нормально',
          ),
          const SizedBox(height: 24),

          // Section: Shortcuts
          _SectionTitle(title: 'Устройства'),
          const SizedBox(height: 12),
          _DevicesGrid(devices: state.devices),
          const SizedBox(height: 24),

          // Stats row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 140,
                  child: TemperatureCard(
                    title: 'Температура',
                    value: climate?.targetTemperature ?? 22,
                    onChanged: (v) => _onTemperatureChanged(context, v),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 140,
                  child: CircularStatCard(
                    title: 'Влажность',
                    value: climate?.humidity ?? 45,
                    unit: '%',
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Energy chart
          _SectionTitle(title: 'Энергопотребление'),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: EnergyChartCard(
              data: _getEnergyData(state),
            ),
          ),
          const SizedBox(height: 24),

          // Rooms
          _SectionTitle(title: 'Комнаты'),
          const SizedBox(height: 12),
          RoomsRow(rooms: _getRooms()),

          const SizedBox(height: 100), // Bottom padding for nav
        ],
      ),
    );
  }

  void _onTemperatureChanged(BuildContext context, double value) {
    context.read<DashboardBloc>().add(
          TemperatureChanged(value),
        );
  }
}

/// Desktop home layout (two columns)
class _DesktopHome extends StatelessWidget {
  final DashboardState state;

  const _DesktopHome({required this.state});

  @override
  Widget build(BuildContext context) {
    final climate = state.climate;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome banner
                const WelcomeBanner(
                  userName: 'Артём',
                  subtitle: 'Все системы работают нормально. Температура в доме оптимальна.',
                ),
                const SizedBox(height: 24),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 160,
                        child: TemperatureCard(
                          title: 'Температура',
                          value: climate?.targetTemperature ?? 22,
                          onChanged: (v) => _onTemperatureChanged(context, v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 160,
                        child: CircularStatCard(
                          title: 'Влажность',
                          value: climate?.humidity ?? 45,
                          unit: '%',
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Energy chart
                SizedBox(
                  height: 200,
                  child: EnergyChartCard(
                    data: _getEnergyData(state),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),

          // Right column
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: 'Устройства'),
                const SizedBox(height: 12),
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: _DevicesGrid(devices: state.devices),
                ),
                const SizedBox(height: 24),

                _SectionTitle(title: 'Комнаты'),
                const SizedBox(height: 12),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: _getRooms()
                        .map((room) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _RoomListItem(room: room),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onTemperatureChanged(BuildContext context, double value) {
    context.read<DashboardBloc>().add(
          TemperatureChanged(value),
        );
  }
}

class _RoomListItem extends StatelessWidget {
  final RoomData room;

  const _RoomListItem({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${room.deviceCount} устройств',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

/// Devices grid showing shortcuts
class _DevicesGrid extends StatelessWidget {
  final List<dynamic> devices;

  const _DevicesGrid({required this.devices});

  @override
  Widget build(BuildContext context) {
    final shortcuts = _getDeviceShortcuts(devices);

    return DeviceShortcutsGrid(
      devices: shortcuts,
      onDeviceToggle: (data) => _onDeviceToggle(context, data.$1, data.$2),
      onAddDevice: () {},
    );
  }

  void _onDeviceToggle(BuildContext context, String id, bool isOn) {
    context.read<DashboardBloc>().add(DeviceToggled(id, isOn));
  }

  List<DeviceShortcutData> _getDeviceShortcuts(List<dynamic> devices) {
    if (devices.isEmpty) {
      // Default mock devices
      return [
        const DeviceShortcutData(
          id: '1',
          label: 'ПВ-1',
          icon: Icons.air,
          isOn: true,
        ),
        const DeviceShortcutData(
          id: '2',
          label: 'ПВ-2',
          icon: Icons.air,
          isOn: false,
        ),
        const DeviceShortcutData(
          id: '3',
          label: 'ПВ-3',
          icon: Icons.air,
          isOn: true,
          isOnline: false,
        ),
      ];
    }

    return devices.map((d) {
      return DeviceShortcutData(
        id: d.id.toString(),
        label: d.name ?? 'Device',
        icon: Icons.air,
        isOn: d.isActive ?? false,
        isOnline: d.isOnline ?? true,
      );
    }).toList();
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

List<EnergyDataPoint> _getEnergyData(DashboardState state) {
  final stats = state.energyStats;
  if (stats != null && stats.hourlyData.isNotEmpty) {
    // Use real data
    return stats.hourlyData.take(5).map((h) {
      return EnergyDataPoint(label: '${h.hour}:00', value: h.kwh);
    }).toList();
  }

  // Mock data
  return const [
    EnergyDataPoint(label: 'Пн', value: 45),
    EnergyDataPoint(label: 'Вт', value: 52),
    EnergyDataPoint(label: 'Ср', value: 38),
    EnergyDataPoint(label: 'Чт', value: 65),
    EnergyDataPoint(label: 'Пт', value: 48),
  ];
}

List<RoomData> _getRooms() {
  return const [
    RoomData(id: '1', name: 'Гостиная', deviceCount: 3),
    RoomData(id: '2', name: 'Спальня', deviceCount: 2),
    RoomData(id: '3', name: 'Кухня', deviceCount: 1),
    RoomData(id: '4', name: 'Офис', deviceCount: 2),
  ];
}

/// Theme toggle button
class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = di.sl<ThemeService>();

    return ListenableBuilder(
      listenable: themeService,
      builder: (context, _) {
        final isDark = themeService.isDark;

        return IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: AppColors.textSecondary,
          ),
          onPressed: () => themeService.toggleTheme(),
          tooltip: isDark ? 'Светлая тема' : 'Тёмная тема',
        );
      },
    );
  }
}

/// Settings button
class _SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
      onPressed: () {},
      tooltip: 'Настройки',
    );
  }
}

/// Placeholder page for unimplemented tabs
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderPage({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Раздел в разработке',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
