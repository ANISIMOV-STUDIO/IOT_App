import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../bloc/hvac_list/hvac_list_state.dart';

class ZilonDashboardScreen extends StatefulWidget {
  const ZilonDashboardScreen({super.key});

  @override
  State<ZilonDashboardScreen> createState() => _ZilonDashboardScreenState();
}

class _ZilonDashboardScreenState extends State<ZilonDashboardScreen> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    // Responsive Breakpoints
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 1200; // Full 2-column grid
    final isDark = _isDark;

    return Theme(
      data: isDark ? AppTheme.dark : AppTheme.light,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          
          return BlocBuilder<HvacListBloc, HvacListState>(
            builder: (context, state) {
              if (state is HvacListLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (state is HvacListError) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is HvacListLoaded && state.units.isNotEmpty) {
                // For demo purposes, we take the first unit. 
                // ideally we would have a selector or tab per unit
                final unit = state.units.first;

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                        title: const Text('ZILON Home'),
                        backgroundColor: theme.scaffoldBackgroundColor,
                        automaticallyImplyLeading: false, // Handled by Shell
                        actions: [
                           IconButton(
                            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                            onPressed: () => setState(() => _isDark = !_isDark),
                          )
                        ],
                      ),

                    SliverPadding(
                      padding: const EdgeInsets.all(AppSpacing.pageMargin),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Dashboard Grid
                          if (isDesktop) 
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 1300),
                                child: _buildDesktopGrid(unit),
                              ),
                            )
                          else 
                            _buildMobileColumn(unit),
                        ]),
                      ),
                    ),
                  ],
                );
              }
              
              return const Center(child: Text('No devices found'));
            },
          );
        }
      ),
    );
  }

  Widget _buildDesktopGrid(HvacUnit device) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column (Status & Schedule)
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: ZilonStatusCard(
                      roomName: device.name,
                      isPowerOn: device.power,
                      onToggle: () => _togglePower(device),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  const ZilonSchedulePreview(),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  const ZilonPresetsCard(),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sectionSpacing),
            
            // Right Column (Controls & Sensors)
            Expanded(
              flex: 4,
              child: Column(
                children: [
                   ZilonControlCard(
                    supplyAirflow: _parseFanSpeed(device),
                    exhaustAirflow: _parseFanSpeed(device) * 0.8,
                    onSupplyChanged: (v) => _updateFanSpeed(device, v),
                    onExhaustChanged: (_) {},
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: ZilonSensorGrid(
                          temperature: device.currentTemp,
                          co2: 850, 
                          humidity: device.humidity,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sectionSpacing),
                      const Expanded(
                        flex: 4,
                        child: ZilonQuickActions(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileColumn(HvacUnit device) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ZilonStatusCard(
            roomName: device.name,
            isPowerOn: device.power,
            onToggle: () => _togglePower(device),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionSpacing),
        ZilonControlCard(
          supplyAirflow: _parseFanSpeed(device),
          exhaustAirflow: _parseFanSpeed(device) * 0.8,
           onSupplyChanged: (v) => _updateFanSpeed(device, v),
           onExhaustChanged: (_) {},
        ),
         const SizedBox(height: AppSpacing.sectionSpacing),
        const ZilonSchedulePreview(),
         const SizedBox(height: AppSpacing.sectionSpacing),
        ZilonSensorGrid(
          temperature: device.currentTemp,
          co2: 850,
          humidity: device.humidity,
        ),
         const SizedBox(height: AppSpacing.sectionSpacing),
        const ZilonQuickActions(),
      ],
    );
  }

  double _parseFanSpeed(HvacUnit device) {
    // If specific supply speed is available, use it (0-100)
    if (device.supplyFanSpeed != null) return device.supplyFanSpeed!.toDouble();
    
    // Fallback to generic speed string mapping
    switch (device.fanSpeed.toLowerCase()) {
      case 'low': return 33.0;
      case 'medium': return 66.0;
      case 'high': return 100.0;
      default: return 0.0;
    }
  }

  void _togglePower(HvacUnit device) {
    context.read<HvacListBloc>().add(UpdateDevicePowerEvent(
      deviceId: device.id, 
      power: !device.power
    ));
  }

  void _updateFanSpeed(HvacUnit device, double value) {
    // Determine string mode based on slider value for now
    String mode = 'off';
    if (value > 0) mode = 'low';
    if (value > 33) mode = 'medium';
    if (value > 66) mode = 'high';

    context.read<HvacListBloc>().add(UpdateDeviceModeEvent(
      deviceId: device.id, 
      mode: mode
    ));
  }
}
