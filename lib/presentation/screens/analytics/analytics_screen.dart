/// Analytics Screen - Параметры устройства с выбором показателей для главного экрана
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart';
import 'package:hvac_control/presentation/bloc/devices/devices_bloc.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';
import 'package:hvac_control/presentation/widgets/loading/skeleton.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _AnalyticsConstants {
  static const int maxSelectedSensors = 3;
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

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            right: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Column(
            children: [
              // Селектор устройств
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: BlocBuilder<DevicesBloc, DevicesState>(
                  buildWhen: (prev, curr) =>
                      prev.devices != curr.devices ||
                      prev.selectedDeviceId != curr.selectedDeviceId,
                  builder: (context, devicesState) {
                    final units = devicesState.devices
                        .map((d) => UnitState(
                              id: d.id,
                              name: d.name,
                              power: d.isActive,
                              temp: 0,
                              mode: '',
                              humidity: 0,
                              outsideTemp: 0,
                              filterPercent: 0,
                              isOnline: d.isOnline,
                            ))
                        .toList();
                    final selectedIndex = units.indexWhere(
                      (u) => u.id == devicesState.selectedDeviceId,
                    );

                    return UnitTabsContainer(
                      units: units,
                      selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
                      onUnitSelected: (index) {
                        if (index < units.length) {
                          context.read<DevicesBloc>().add(
                            DevicesDeviceSelected(units[index].id),
                          );
                        }
                      },
                      leading: const BreezLogo.small(),
                      trailing: const _SelectionIndicator(),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Сетка датчиков (50%)
              Expanded(
                child: BlocBuilder<ClimateBloc, ClimateControlState>(
                  buildWhen: (prev, curr) =>
                      prev.status != curr.status ||
                      prev.deviceFullState != curr.deviceFullState ||
                      prev.climate != curr.climate,
                  builder: (context, state) {
                    // При загрузке или ошибке показываем скелетон (без ненужных ошибок)
                    if (state.status == ClimateControlStatus.loading ||
                        state.status == ClimateControlStatus.failure) {
                      return const _SensorsCardSkeleton();
                    }

                    final fullState = state.deviceFullState;
                    final climate = state.climate;
                    if (fullState == null && climate == null) {
                      return const _SensorsCardSkeleton();
                    }

                    final unit = _createUnitState(fullState, climate);
                    final sensors = _buildSensorsList(context, unit);

                    return BreezCard(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: AnalyticsSensorsGrid(
                        sensors: sensors,
                        selectable: true,
                        expandHeight: true,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // График (50%)
              Expanded(
                child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
                  buildWhen: (prev, curr) =>
                      prev.status != curr.status ||
                      prev.graphData != curr.graphData ||
                      prev.selectedMetric != curr.selectedMetric,
                  builder: (context, state) {
                    // Скелетон при загрузке, ошибке или пустых данных
                    if (state.status == AnalyticsStatus.loading ||
                        state.status == AnalyticsStatus.initial ||
                        state.status == AnalyticsStatus.failure ||
                        state.graphData.isEmpty) {
                      return const _GraphSkeleton();
                    }

                    return OperationGraph(
                      data: state.graphData,
                      selectedMetric: state.selectedMetric,
                      onMetricChanged: (metric) {
                        context.read<AnalyticsBloc>().add(
                          AnalyticsGraphMetricChanged(metric),
                        );
                      },
                      compact: true,
                    );
                  },
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
// SKELETON
// =============================================================================

/// Скелетон для карточки с датчиками (Expanded, адаптивная высота)
class _SensorsCardSkeleton extends StatelessWidget {
  const _SensorsCardSkeleton();

  static const int _crossAxisCount = 4;
  static const int _itemCount = 12;

  @override
  Widget build(BuildContext context) => BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rowCount = (_itemCount / _crossAxisCount).ceil();
          const totalSpacingH = AppSpacing.xs * (_crossAxisCount - 1);
          final totalSpacingV = AppSpacing.xs * (rowCount - 1);

          final cellWidth = (constraints.maxWidth - totalSpacingH) / _crossAxisCount;
          final cellHeight = (constraints.maxHeight - totalSpacingV) / rowCount;
          final aspectRatio = (cellWidth / cellHeight).clamp(0.5, 2.5);

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount,
              mainAxisSpacing: AppSpacing.xs,
              crossAxisSpacing: AppSpacing.xs,
              childAspectRatio: aspectRatio,
            ),
            itemCount: _itemCount,
            itemBuilder: (context, index) =>
                const SkeletonBox(borderRadius: AppRadius.cardSmall),
          );
        },
      ),
    );
}

/// Скелетон для графика (Expanded - заполняет всё доступное пространство)
class _GraphSkeleton extends StatelessWidget {
  const _GraphSkeleton();

  @override
  Widget build(BuildContext context) => const BreezCard(
      padding: EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Табы
          SkeletonBox(
            width: double.infinity,
            height: AppSizes.tabHeight,
            borderRadius: AppRadius.chip,
          ),
          SizedBox(height: AppSpacing.xs),
          // Заголовок с бейджами
          Row(
            children: [
              SkeletonBox(
                width: 60,
                height: AppFontSizes.h2,
                borderRadius: AppRadius.indicator,
              ),
              SizedBox(width: AppSpacing.sm),
              SkeletonBox(
                width: 50,
                height: 20,
                borderRadius: AppRadius.indicator,
              ),
              SizedBox(width: AppSpacing.xs),
              SkeletonBox(
                width: 50,
                height: 20,
                borderRadius: AppRadius.indicator,
              ),
              SizedBox(width: AppSpacing.xs),
              SkeletonBox(
                width: 50,
                height: 20,
                borderRadius: AppRadius.indicator,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          // Область графика
          Expanded(
            child: SkeletonBox(
              width: double.infinity,
              borderRadius: AppRadius.button,
            ),
          ),
        ],
      ),
    );
}
