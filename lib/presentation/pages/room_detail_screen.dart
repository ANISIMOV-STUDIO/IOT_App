/// Room Detail Screen
///
/// Detailed control screen for a room/device with background image
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/hvac_detail/hvac_detail_bloc.dart';
import '../bloc/hvac_detail/hvac_detail_event.dart';
import '../bloc/hvac_detail/hvac_detail_state.dart';

class RoomDetailScreen extends StatelessWidget {
  final String unitId;

  const RoomDetailScreen({
    super.key,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: BlocBuilder<HvacDetailBloc, HvacDetailState>(
        builder: (context, state) {
          if (state is HvacDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            );
          }

          if (state is HvacDetailError) {
            return _buildError(context, state.message);
          }

          if (state is HvacDetailLoaded) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              'Error',
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
      ),
    );
  }

  Widget _buildContent(BuildContext context, HvacDetailLoaded state) {
    final unit = state.unit;
    final modeColor = AppTheme.getModeColor(unit.mode);

    return CustomScrollView(
      slivers: [
        // Header with background image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppTheme.backgroundDark,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // TODO: Show notifications
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              unit.location ?? unit.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Background image (placeholder for now)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        modeColor.withValues(alpha: 0.3),
                        AppTheme.backgroundDark,
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.home_outlined,
                    size: 120,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppTheme.backgroundDark.withValues(alpha: 0.7),
                        AppTheme.backgroundDark,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Device status cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusCard(
                        context,
                        icon: Icons.water_drop,
                        label: 'Humidifier\nAir',
                        value: '${unit.humidity.toInt()}%',
                        isOn: unit.power,
                        onToggle: (value) {
                          context.read<HvacDetailBloc>().add(
                            UpdatePowerEvent(value),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatusCard(
                        context,
                        icon: Icons.air,
                        label: 'Purifier\nAir',
                        value: '${unit.fanSpeed}%',
                        isOn: unit.power,
                        onToggle: (value) {
                          context.read<HvacDetailBloc>().add(
                            UpdatePowerEvent(value),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Light controls section
                Text(
                  'Lighting',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // Main light slider
                _buildLightControl(
                  context,
                  label: 'Main light',
                  value: 0.7,
                  onChanged: (value) {
                    // TODO: Update light brightness
                  },
                ),

                const SizedBox(height: 16),

                // Floor lamp slider
                _buildLightControl(
                  context,
                  label: 'Floor lamp',
                  value: 0.5,
                  onChanged: (value) {
                    // TODO: Update lamp brightness
                  },
                ),

                const SizedBox(height: 32),

                // Temperature control
                Text(
                  'Temperature',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                _buildTemperatureControl(context, state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isOn,
    required ValueChanged<bool> onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 24, color: AppTheme.textSecondary),
              Text(
                'Mode 2',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isOn ? 'On' : 'Off',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Switch(
                value: isOn,
                onChanged: onToggle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLightControl(
    BuildContext context, {
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 8,
              ),
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.primaryOrange,
              inactiveColor: AppTheme.backgroundCardBorder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureControl(
    BuildContext context,
    HvacDetailLoaded state,
  ) {
    final unit = state.unit;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.deviceCard(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${unit.currentTemp.toInt()}°',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Target',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${unit.targetTemp.toInt()}°',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
              ),
            ),
            child: Slider(
              value: unit.targetTemp,
              min: 16,
              max: 30,
              divisions: 28,
              label: '${unit.targetTemp.toInt()}°',
              onChanged: (value) {
                context.read<HvacDetailBloc>().add(
                  UpdateTargetTempEvent(value),
                );
              },
              activeColor: AppTheme.primaryOrange,
              inactiveColor: AppTheme.backgroundCardBorder,
            ),
          ),
        ],
      ),
    );
  }
}
