/// Room Detail Content Component
/// Main content section with controls
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/hvac_detail/hvac_detail_bloc.dart';
import '../../bloc/hvac_detail/hvac_detail_event.dart';
import '../../bloc/hvac_detail/hvac_detail_state.dart';
import 'device_status_card.dart';
import 'light_control_card.dart';
import 'temperature_control_card.dart';

/// Room detail content section
class RoomDetailContent extends StatelessWidget {
  final HvacDetailLoaded state;

  const RoomDetailContent({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device status cards
            _buildDeviceStatusCards(context),

            const SizedBox(height: 32.0),

            // Light controls section
            _buildLightingSection(context),

            const SizedBox(height: 32.0),

            // Temperature control
            _buildTemperatureSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceStatusCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DeviceStatusCard(
            icon: Icons.water_drop,
            label: 'Humidifier\nAir',
            value: '${state.unit.humidity.toInt()}%',
            isOn: state.unit.power,
            onToggle: (value) {
              context.read<HvacDetailBloc>().add(
                    UpdatePowerEvent(value),
                  );
            },
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: DeviceStatusCard(
            icon: Icons.air,
            label: 'Purifier\nAir',
            value: '${state.unit.fanSpeed}%',
            isOn: state.unit.power,
            onToggle: (value) {
              context.read<HvacDetailBloc>().add(
                    UpdatePowerEvent(value),
                  );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLightingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lighting',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16.0),

        // Main light slider
        LightControlCard(
          label: 'Main light',
          value: 0.7,
          onChanged: (value) {
            // Handle light change
          },
        ),

        const SizedBox(height: 16.0),

        // Floor lamp slider
        LightControlCard(
          label: 'Floor lamp',
          value: 0.5,
          onChanged: (value) {
            // Handle light change
          },
        ),
      ],
    );
  }

  Widget _buildTemperatureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temperature',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16.0),
        TemperatureControlCard(unit: state.unit),
      ],
    );
  }
}