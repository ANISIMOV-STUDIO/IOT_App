/// Analytics Screen - Параметры устройства с выбором показателей для главного экрана
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';
import 'package:hvac_control/presentation/widgets/loading/skeleton.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _AnalyticsConstants {
  static const int maxSelectedSensors = 3;
  static const double graphHeight = 280;
  static const double indicatorFontSize = 13;
}

// =============================================================================
// MAIN SCREEN
// =============================================================================

/// Экран аналитики с выбором показателей для главного экрана
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () async {
            context.read<AnalyticsBloc>().add(
              const AnalyticsRefreshRequested(),
            );
            await Future<void>.delayed(AppDurations.long);
          },
          child: CustomScrollView(
            slivers: [
              // Заголовок с счётчиком
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BreezSectionHeader.pageTitle(
                        title: l10n.analytics,
                        icon: Icons.bar_chart,
                        trailing: const _SelectionIndicator(),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        l10n.analyticsHint,
                        style: TextStyle(
                          fontSize: AppFontSizes.captionSmall,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.sm),
              ),

              // Сетка датчиков
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                sliver: BlocBuilder<ClimateBloc, ClimateControlState>(
                  buildWhen: (prev, curr) =>
                      prev.status != curr.status ||
                      prev.deviceFullState != curr.deviceFullState ||
                      prev.climate != curr.climate,
                  builder: (context, state) {
                    if (state.status == ClimateControlStatus.loading) {
                      return const SliverToBoxAdapter(
                        child: _SensorsSkeletonGrid(),
                      );
                    }

                    if (state.status == ClimateControlStatus.failure) {
                      return SliverToBoxAdapter(
                        child: _ErrorState(
                          errorMessage: state.errorMessage,
                        ),
                      );
                    }

                    final fullState = state.deviceFullState;
                    final climate = state.climate;
                    if (fullState == null && climate == null) {
                      return const SliverToBoxAdapter(
                        child: _NoDeviceState(),
                      );
                    }

                    final unit = _createUnitState(fullState, climate);
                    final sensors = _buildSensorsList(context, unit);

                    return SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: AppSpacing.xs,
                            crossAxisSpacing: AppSpacing.xs,
                            childAspectRatio: 0.85,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => SensorTile(
                          sensor: sensors[index],
                          selectable: true,
                        ),
                        childCount: sensors.length,
                      ),
                    );
                  },
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.lg),
              ),

              // График
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                sliver: SliverToBoxAdapter(
                  child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
                    buildWhen: (prev, curr) =>
                        prev.status != curr.status ||
                        prev.graphData != curr.graphData ||
                        prev.selectedMetric != curr.selectedMetric,
                    builder: (context, state) {
                      if (state.status == AnalyticsStatus.loading ||
                          state.status == AnalyticsStatus.initial) {
                        return const SkeletonGraph(
                          height: _AnalyticsConstants.graphHeight,
                        );
                      }

                      if (state.status == AnalyticsStatus.failure) {
                        return _GraphErrorState(
                          errorMessage: state.errorMessage,
                        );
                      }

                      return SizedBox(
                        height: _AnalyticsConstants.graphHeight,
                        child: OperationGraph(
                          data: state.graphData,
                          selectedMetric: state.selectedMetric,
                          onMetricChanged: (metric) {
                            context.read<AnalyticsBloc>().add(
                              AnalyticsGraphMetricChanged(metric),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static UnitState _createUnitState(
    DeviceFullState? fullState,
    ClimateState? climate,
  ) {
    final currentMode = fullState?.operatingMode ?? climate?.preset ?? '';
    final modeSettings = fullState?.modeSettings?[currentMode];

    return UnitState(
      id: fullState?.id ?? '',
      name: fullState?.name ?? 'Device',
      power: fullState?.power ?? climate?.isOn ?? false,
      temp: climate?.currentTemperature.toInt() ?? 20,
      heatingTemp: modeSettings?.heatingTemperature,
      coolingTemp: modeSettings?.coolingTemperature,
      supplyFan: modeSettings?.supplyFan,
      exhaustFan: modeSettings?.exhaustFan,
      mode: currentMode,
      humidity: climate?.humidity.toInt() ?? 45,
      outsideTemp: fullState?.outdoorTemperature ?? 0.0,
      filterPercent: fullState?.kpdRecuperator ?? 0,
      indoorTemp:
          fullState?.indoorTemperature ?? climate?.currentTemperature ?? 22.0,
      supplyTemp: fullState?.supplyTemperature ?? 20.0,
      supplyTempAfterRecup: fullState?.supplyTempAfterRecup ?? 18.0,
      co2Level: fullState?.co2Level ?? 0,
      recuperatorEfficiency: fullState?.kpdRecuperator ?? 0,
      freeCooling: fullState?.freeCooling ?? false,
      heaterPower: fullState?.heaterPower ?? 0,
      coolerStatus: fullState?.coolerStatus ?? 'Н/Д',
      ductPressure: fullState?.ductPressure ?? 0,
      isOnline: fullState?.isOnline ?? true,
    );
  }

  static List<SensorData> _buildSensorsList(
    BuildContext context,
    UnitState unit,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return [
      SensorData(
        key: 'outside_temp',
        icon: Icons.thermostat_outlined,
        value: '${unit.outsideTemp.toStringAsFixed(1)}°',
        label: l10n.outdoor,
        description: l10n.outdoorTempDesc,
        color: AppColors.accent,
      ),
      SensorData(
        key: 'indoor_temp',
        icon: Icons.home_outlined,
        value: '${unit.indoorTemp.toStringAsFixed(1)}°',
        label: l10n.indoor,
        description: l10n.indoorTempDesc,
        color: AppColors.accentGreen,
      ),
      SensorData(
        key: 'supply_temp',
        icon: Icons.air,
        value: '${unit.supplyTemp.toStringAsFixed(1)}°',
        label: l10n.supply,
        description: l10n.supplyTempDesc,
        color: AppColors.accentOrange,
      ),
      SensorData(
        key: 'supply_temp_after_recup',
        icon: Icons.air,
        value: '${unit.supplyTempAfterRecup.toStringAsFixed(1)}°',
        label: l10n.afterRecup,
        description: l10n.supplyTempAfterRecupDesc,
        color: AppColors.accentGreen,
      ),
      SensorData(
        key: 'humidity',
        icon: Icons.water_drop_outlined,
        value: '${unit.humidity}%',
        label: l10n.humidity,
        description: l10n.humidityDesc,
        color: AppColors.accent,
      ),
      SensorData(
        key: 'co2_level',
        icon: Icons.cloud_outlined,
        value: '${unit.co2Level}',
        label: 'CO₂',
        description: l10n.co2LevelDesc,
        color: AppColors.accentGreen,
      ),
      SensorData(
        key: 'recuperator_eff',
        icon: Icons.recycling,
        value: '${unit.recuperatorEfficiency}%',
        label: l10n.efficiency,
        description: l10n.recuperatorEfficiencyDesc,
        color: AppColors.accent,
      ),
      SensorData(
        key: 'heater_perf',
        icon: Icons.local_fire_department_outlined,
        value: '${unit.heaterPower}%',
        label: l10n.heater,
        description: l10n.heaterPerformanceDesc,
        color: AppColors.accentOrange,
      ),
      SensorData(
        key: 'cooler_status',
        icon: Icons.ac_unit,
        value: unit.coolerStatus,
        label: l10n.cooler,
        description: l10n.coolerStatusDesc,
        color: AppColors.accent,
      ),
      SensorData(
        key: 'duct_pressure',
        icon: Icons.speed,
        value: '${unit.ductPressure}',
        label: l10n.pressure,
        description: l10n.ductPressureDesc,
        color: AppColors.darkTextMuted,
      ),
      SensorData(
        key: 'free_cooling',
        icon: Icons.ac_unit,
        value: unit.freeCooling ? l10n.on : l10n.off,
        label: l10n.freeCool,
        description: l10n.freeCoolingDesc,
        color: unit.freeCooling
            ? AppColors.accentGreen
            : AppColors.darkTextMuted,
      ),
      SensorData(
        key: 'filter_percent',
        icon: Icons.filter_alt_outlined,
        value: '${unit.filterPercent}%',
        label: l10n.filter,
        description: l10n.filterDesc,
        color: AppColors.accent,
      ),
    ];
  }
}

// =============================================================================
// SELECTION INDICATOR
// =============================================================================

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BlocBuilder<ClimateBloc, ClimateControlState>(
      buildWhen: (prev, curr) =>
          prev.deviceFullState?.quickSensors !=
          curr.deviceFullState?.quickSensors,
      builder: (context, state) {
        final quickSensors = state.deviceFullState?.quickSensors;

        // Показываем лоадер пока данные не загружены
        if (quickSensors == null) {
          return const BreezLoader.small();
        }

        final count = quickSensors.length;
        const max = _AnalyticsConstants.maxSelectedSensors;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              count == max ? Icons.check_circle : Icons.radio_button_unchecked,
              size: AppIconSizes.standard,
              color: count == max ? AppColors.accent : colors.textMuted,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              '$count/$max',
              style: TextStyle(
                fontSize: _AnalyticsConstants.indicatorFontSize,
                fontWeight: FontWeight.w500,
                color: count == max ? AppColors.accent : colors.textMuted,
              ),
            ),
          ],
        );
      },
    );
  }
}

// =============================================================================
// ERROR STATES
// =============================================================================

class _NoDeviceState extends StatelessWidget {
  const _NoDeviceState();

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.sensors_off_outlined,
              size: AppIconSizes.standard,
              color: colors.textMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.noDeviceSelected,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              size: AppIconSizes.standard,
              color: AppColors.critical,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              errorMessage ?? l10n.errorLoadingFailed,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                color: colors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            BreezButton(
              onTap: () {
                context.read<ClimateBloc>().add(
                  const ClimateSubscriptionRequested(),
                );
              },
              backgroundColor: colors.card.withValues(alpha: 0),
              hoverColor: AppColors.accent.withValues(
                alpha: AppColors.opacityLight,
              ),
              pressedColor: AppColors.accent.withValues(
                alpha: AppColors.opacitySubtle,
              ),
              showBorder: false,
              semanticLabel: l10n.retry,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, color: AppColors.accent),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    l10n.retry,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GraphErrorState extends StatelessWidget {
  const _GraphErrorState({this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: _AnalyticsConstants.graphHeight,
      child: BreezCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.show_chart,
                size: AppIconSizes.standard,
                color: AppColors.critical,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                errorMessage ?? l10n.errorLoadingFailed,
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  color: colors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              BreezButton(
                onTap: () {
                  context.read<AnalyticsBloc>().add(
                    const AnalyticsRefreshRequested(),
                  );
                },
                backgroundColor: colors.card.withValues(alpha: 0),
                hoverColor: AppColors.accent.withValues(
                  alpha: AppColors.opacityLight,
                ),
                pressedColor: AppColors.accent.withValues(
                  alpha: AppColors.opacitySubtle,
                ),
                showBorder: false,
                semanticLabel: l10n.retry,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh, color: AppColors.accent),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      l10n.retry,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SKELETON
// =============================================================================

class _SensorsSkeletonGrid extends StatelessWidget {
  const _SensorsSkeletonGrid();

  @override
  Widget build(BuildContext context) => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.xs,
        crossAxisSpacing: AppSpacing.xs,
        childAspectRatio: 0.85,
      ),
      itemCount: 12,
      itemBuilder: (context, index) =>
          const SkeletonBox(height: 80, borderRadius: AppRadius.cardSmall),
    );
}
