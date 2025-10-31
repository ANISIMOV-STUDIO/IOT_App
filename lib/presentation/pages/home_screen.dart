/// Home Screen
///
/// Modern smart home dashboard with live room view
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../widgets/room_preview_card.dart';
import '../widgets/device_control_card.dart';
import '../widgets/activity_timeline.dart';
import '../../domain/entities/hvac_unit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedUnit = 'ПВ1';
  double _lampBrightness = 0.55;
  double _acTemperature = 21.0;

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

                  // Center - HVAC Unit tabs
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildUnitTab('ПВ1', _selectedUnit == 'ПВ1'),
                        const SizedBox(width: 12),
                        _buildUnitTab('ПВ2', _selectedUnit == 'ПВ2'),
                        const SizedBox(width: 12),
                        _buildUnitTab('ПВ3', _selectedUnit == 'ПВ3'),
                        const SizedBox(width: 12),
                        _buildUnitTab('ПВ4', _selectedUnit == 'ПВ4'),
                        const SizedBox(width: 12),
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
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppTheme.backgroundCard,
                        backgroundImage: null, // Add user avatar here
                        child: const Icon(
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
                  roomName: _selectedUnit,
                  isLive: true,
                  badges: [
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

                // Device control cards
                Expanded(
                  child: Row(
                    children: [
                      // Smart Lamp
                      Expanded(
                        child: DeviceControlCard(
                          title: 'Smart Lamp',
                          subtitle: '5 devices',
                          type: DeviceType.lamp,
                          deviceImage: Icon(
                            Icons.light,
                            size: 80,
                            color: AppTheme.warning.withValues(alpha: 0.3),
                          ),
                          controls: [
                            BrightnessControl(
                              value: _lampBrightness,
                              onChanged: (value) {
                                setState(() => _lampBrightness = value);
                              },
                            ),
                          ],
                          stats: const [
                            DeviceStatItem(
                              icon: Icons.brightness_6,
                              label: 'Brightness',
                              value: '55%',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Air Conditioner
                      Expanded(
                        child: DeviceControlCard(
                          title: 'Air Conditioner',
                          subtitle: 'Full house',
                          type: DeviceType.airConditioner,
                          deviceImage: Icon(
                            Icons.ac_unit,
                            size: 80,
                            color: AppTheme.info.withValues(alpha: 0.3),
                          ),
                          controls: [
                            TemperatureControl(
                              value: currentUnit?.currentTemp ?? _acTemperature,
                              min: 15,
                              max: 29,
                              onChanged: (value) {
                                setState(() => _acTemperature = value);
                              },
                            ),
                          ],
                          stats: const [
                            DeviceStatItem(
                              icon: Icons.wb_sunny_outlined,
                              label: 'Auto Mode',
                              value: 'Auto',
                            ),
                            DeviceStatItem(
                              icon: Icons.schedule,
                              label: 'Cooling time',
                              value: '35 min',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Robot Vacuum
                      Expanded(
                        child: DeviceControlCard(
                          title: 'Robot vacuum cleaner',
                          subtitle: '4 devices',
                          type: DeviceType.vacuum,
                          deviceImage: Icon(
                            Icons.cleaning_services,
                            size: 80,
                            color: AppTheme.textSecondary.withValues(alpha: 0.3),
                          ),
                          controls: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Column(
                                children: [
                                  Text(
                                    '09:00 AM',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Next Cleaning',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundDark,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    '50%',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Filter Status',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          stats: const [
                            DeviceStatItem(
                              icon: Icons.crop_square,
                              label: 'Area cleaned',
                              value: '58 m²',
                            ),
                            DeviceStatItem(
                              icon: Icons.schedule,
                              label: 'Cleaning time',
                              value: '30 min',
                            ),
                            DeviceStatItem(
                              icon: Icons.battery_charging_full,
                              label: 'Battery charge',
                              value: '67%',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Activity sidebar
          SizedBox(
            width: 320,
            child: ActivityTimeline(
              activities: const [
                ActivityItem(
                  time: '07:25',
                  title: 'Smart Plug',
                  description: 'Plug turned on for coffee maker',
                ),
                ActivityItem(
                  time: '07:05',
                  title: 'Air Conditioner',
                  description: 'Set to 21°C',
                ),
                ActivityItem(
                  time: '07:00',
                  title: 'Smart Lamp',
                  description: 'Turned on automatically',
                ),
              ],
              onSeeAll: () {},
            ),
          ),
        ],
      ),
    );
  }
}
