/// HVAC Detail Screen
///
/// Detailed view and controls for a single HVAC unit
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../bloc/hvac_detail/hvac_detail_bloc.dart';
import '../bloc/hvac_detail/hvac_detail_event.dart';
import '../bloc/hvac_detail/hvac_detail_state.dart';
import '../widgets/temperature_control_slider.dart';
import '../widgets/mode_selector.dart';
import '../widgets/fan_speed_control.dart';
import '../widgets/temperature_chart.dart';

class HvacDetailScreen extends StatelessWidget {
  final String unitId;

  const HvacDetailScreen({
    super.key,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HvacDetailBloc>(param1: unitId)
        ..add(const LoadUnitDetailEvent()),
      child: const _HvacDetailView(),
    );
  }
}

class _HvacDetailView extends StatelessWidget {
  const _HvacDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<HvacDetailBloc, HvacDetailState>(
          builder: (context, state) {
            if (state is HvacDetailLoaded) {
              return Text(state.unit.name);
            }
            return const Text('HVAC Unit');
          },
        ),
      ),
      body: BlocBuilder<HvacDetailBloc, HvacDetailState>(
        builder: (context, state) {
          if (state is HvacDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is HvacDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is HvacDetailLoaded) {
            final unit = state.unit;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Power Switch
                  Card(
                    child: SwitchListTile(
                      title: const Text('Power'),
                      subtitle: Text(unit.power ? 'On' : 'Off'),
                      value: unit.power,
                      onChanged: (value) {
                        context.read<HvacDetailBloc>().add(
                              UpdatePowerEvent(value),
                            );
                      },
                      secondary: Icon(
                        unit.power ? Icons.power : Icons.power_off,
                        color: unit.power ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Temperature Control
                  TemperatureControlSlider(
                    currentTemp: unit.currentTemp,
                    targetTemp: unit.targetTemp,
                    onChanged: (value) {
                      context.read<HvacDetailBloc>().add(
                            UpdateTargetTempEvent(value),
                          );
                    },
                    enabled: unit.power,
                  ),
                  const SizedBox(height: 24),

                  // Mode Selector
                  ModeSelector(
                    selectedMode: unit.mode,
                    onModeChanged: (mode) {
                      context.read<HvacDetailBloc>().add(
                            UpdateModeEvent(mode),
                          );
                    },
                    enabled: unit.power,
                  ),
                  const SizedBox(height: 24),

                  // Fan Speed Control
                  FanSpeedControl(
                    selectedSpeed: unit.fanSpeed,
                    onSpeedChanged: (speed) {
                      context.read<HvacDetailBloc>().add(
                            UpdateFanSpeedEvent(speed),
                          );
                    },
                    enabled: unit.power,
                  ),
                  const SizedBox(height: 24),

                  // Temperature Chart
                  if (state.history.isNotEmpty)
                    TemperatureChart(
                      readings: state.history,
                      targetTemp: unit.targetTemp,
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
