import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../../domain/entities/hvac_unit.dart';

class ZilonControlsScreen extends StatefulWidget {
  const ZilonControlsScreen({super.key});

  @override
  State<ZilonControlsScreen> createState() => _ZilonControlsScreenState();
}

class _ZilonControlsScreenState extends State<ZilonControlsScreen> {
  // Local state for smooth slider interaction
  // We sync this with BLoC state when not dragging
  double? _dragTemp;
  double? _dragFanSpeed;

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    
    return BlocBuilder<HvacListBloc, HvacListState>(
      builder: (context, state) {
        if (state is HvacListLoading) {
           return const Center(child: CircularProgressIndicator());
        }
        
        if (state is HvacListLoaded && state.units.isNotEmpty) {
           // Target the first unit for demo controls
           final device = state.units.first;
           
           final currentTemp = _dragTemp ?? device.targetTemp;
           // Use supplyFanSpeed if available, else 0
           final currentFan = _dragFanSpeed ?? (device.supplyFanSpeed?.toDouble() ?? 50.0);
           final currentMode = device.mode;

           return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.v24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Manual Control', style: AppTypography.displayMedium.copyWith(color: theme.colorScheme.onSurface)),
                    const SizedBox(height: 24),
                    
                    // Main Temp Control
                    _buildTempControl(context, device, currentTemp),
                    const SizedBox(height: 24),
                    
                    // Mode Grid
                    Text('Operation Mode', style: AppTypography.titleMedium.copyWith(color: theme.colorScheme.onSurface)),
                    const SizedBox(height: 12),
                    _buildModeGrid(context, device, currentMode),
                    const SizedBox(height: 32),
                    
                    // Fan Speed
                    Text('Fan Speed', style: AppTypography.titleMedium.copyWith(color: theme.colorScheme.onSurface)),
                    const SizedBox(height: 12),
                    SmartCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.wind_power),
                              Text('${currentFan.round()}%', style: AppTypography.headlineMedium.copyWith(color: theme.colorScheme.primary)),
                            ],
                          ),
                          Slider(
                            value: currentFan.clamp(0.0, 100.0),
                            min: 0,
                            max: 100,
                            activeColor: theme.colorScheme.primary,
                            onChanged: (v) {
                              setState(() => _dragFanSpeed = v);
                            },
                            onChangeEnd: (v) {
                               setState(() => _dragFanSpeed = null);
                               context.read<HvacListBloc>().add(
                                 UpdateDeviceFanSpeedEvent(deviceId: device.id, speed: v.round())
                               );
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                     Text('Advanced', style: AppTypography.titleMedium.copyWith(color: theme.colorScheme.onSurface)),
                     const SizedBox(height: 12),
                     Row(
                       children: [
                         Expanded(child: _buildToggleCard(context, 'Eco Mode', Icons.eco, true)),
                         const SizedBox(width: 16),
                         Expanded(child: _buildToggleCard(context, 'Turbo', Icons.rocket_launch, false)),
                         const SizedBox(width: 16),
                         Expanded(child: _buildToggleCard(context, 'Quiet', Icons.volume_off, false)),
                       ],
                     ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Center(child: Text('No devices found'));
      },
    );
  }

  Widget _buildTempControl(BuildContext context, HvacUnit device, double temp) {
    final theme = Theme.of(context);
    return SmartCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text('Target Temperature', style: AppTypography.titleMedium),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircularButton(Icons.remove, () {
                 final newTemp = temp - 0.5;
                 context.read<HvacListBloc>().add(
                   UpdateDeviceTargetTemperatureEvent(deviceId: device.id, temperature: newTemp)
                 );
              }),
              const SizedBox(width: 32),
              Text(
                '${temp.toStringAsFixed(1)}°',
                style: AppTypography.displayLarge.copyWith(fontSize: 64, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 32),
              _buildCircularButton(Icons.add, () {
                  final newTemp = temp + 0.5;
                 context.read<HvacListBloc>().add(
                   UpdateDeviceTargetTemperatureEvent(deviceId: device.id, temperature: newTemp)
                 );
              }),
            ],
          ),
          const SizedBox(height: 8),
          Text('Current: ${device.currentTemp}°', style: AppTypography.bodyMedium.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(icon, size: 32),
        ),
      ),
    );
  }

  Widget _buildModeGrid(BuildContext context, HvacUnit device, String currentMode) {
    final modes = [
      {'name': 'Auto', 'icon': Icons.hdr_auto},
      {'name': 'Cool', 'icon': Icons.ac_unit},
      {'name': 'Heat', 'icon': Icons.local_fire_department},
      {'name': 'Vent', 'icon': Icons.air},
    ];

    return Row(
      children: modes.map((m) {
        final isSelected = currentMode.toLowerCase() == m['name'].toString().toLowerCase();
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _buildModeCard(context, device, m['name'] as String, m['icon'] as IconData, isSelected),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildModeCard(BuildContext context, HvacUnit device, String name, IconData icon, bool isSelected) {
     final theme = Theme.of(context);
     return InkWell(
        onTap: () {
           context.read<HvacListBloc>().add(
              UpdateDeviceModeEvent(deviceId: device.id, mode: name)
           );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.2)),
            boxShadow: isSelected ? [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface, size: 28),
              const SizedBox(height: 8),
              Text(name, style: AppTypography.labelMedium.copyWith(color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface)),
            ],
          ),
        ),
     );
  }
  
  Widget _buildToggleCard(BuildContext context, String label, IconData icon, bool isActive) {
     final theme = Theme.of(context);
     return Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         color: isActive ? theme.colorScheme.secondaryContainer : theme.colorScheme.surface,
         borderRadius: BorderRadius.circular(12),
         border: Border.all(color: isActive ? theme.colorScheme.secondary : theme.colorScheme.outline.withOpacity(0.1)),
       ),
       child: Column(
         children: [
           Icon(icon, color: isActive ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onSurface),
           const SizedBox(height: 8),
           Text(label, style: TextStyle(color: isActive ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onSurface)),
         ],
       ),
     );
  }
}
