/// Analytics Screen - Датчики и графики
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../domain/entities/device_full_state.dart';
import '../../../domain/entities/climate.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/analytics/analytics_bloc.dart';
import '../../bloc/climate/climate_bloc.dart';
import '../../widgets/breez/breez.dart';
import '../../widgets/loading/skeleton.dart';

/// Экран аналитики: датчики сверху + график снизу
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
            context.read<AnalyticsBloc>().add(const AnalyticsRefreshRequested());
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: CustomScrollView(
            slivers: [
              // Заголовок
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    l10n.analytics,
                    style: TextStyle(
                      fontSize: AppFontSizes.h2,
                      fontWeight: FontWeight.bold,
                      color: colors.text,
                    ),
                  ),
                ),
              ),

              // Датчики
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: BlocBuilder<ClimateBloc, ClimateControlState>(
                    builder: (context, state) {
                      if (state.status == ClimateControlStatus.loading) {
                        return const _SensorsSkeletonGrid();
                      }

                      final fullState = state.deviceFullState;
                      final climate = state.climate;
                      if (fullState == null && climate == null) {
                        return _buildNoDeviceState(context, colors, l10n);
                      }

                      final unit = _createUnitState(fullState, climate);
                      return _SensorsSection(
                        sensors: _buildSensorsList(unit, l10n),
                      );
                    },
                  ),
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
                    builder: (context, state) {
                      if (state.status == AnalyticsStatus.loading ||
                          state.status == AnalyticsStatus.initial) {
                        return const SkeletonGraph(height: 300);
                      }

                      return SizedBox(
                        height: 280,
                        child: OperationGraph(
                          data: state.graphData,
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

  /// Создаём UnitState из DeviceFullState и ClimateState
  UnitState _createUnitState(DeviceFullState? fullState, ClimateState? climate) {
    return UnitState(
      id: fullState?.id ?? '',
      name: fullState?.name ?? 'Device',
      power: fullState?.power ?? climate?.isOn ?? false,
      temp: climate?.currentTemperature.toInt() ?? 20,
      heatingTemp: fullState?.heatingTemperature ?? 21,
      coolingTemp: fullState?.coolingTemperature ?? 24,
      supplyFan: climate?.supplyAirflow.toInt() ?? 50,
      exhaustFan: climate?.exhaustAirflow.toInt() ?? 50,
      mode: climate?.mode.toString().split('.').last ?? 'auto',
      humidity: climate?.humidity.toInt() ?? 45,
      outsideTemp: fullState?.outdoorTemperature?.toInt() ?? 0,
      filterPercent: fullState?.kpdRecuperator ?? 0,
      airflowRate: fullState?.devicePower ?? 0,
      indoorTemp: fullState?.indoorTemperature?.toInt() ?? climate?.currentTemperature.toInt() ?? 22,
      supplyTemp: fullState?.supplyTemperature?.toInt() ?? 20,
      supplyTempAfterRecup: fullState?.supplyTempAfterRecup?.toInt() ?? 18,
      co2Level: fullState?.co2Level ?? 450,
      recuperatorEfficiency: fullState?.kpdRecuperator ?? 85,
      freeCooling: fullState?.freeCooling ?? 0,
      heaterPerformance: fullState?.heaterPerformance ?? 0,
      coolerStatus: fullState?.coolerStatus ?? 0,
      ductPressure: fullState?.ductPressure ?? 120,
    );
  }

  /// Формируем список датчиков из UnitState
  List<SensorData> _buildSensorsList(UnitState unit, AppLocalizations l10n) {
    return [
      SensorData(
        icon: Icons.thermostat_outlined,
        value: '${unit.outsideTemp}°',
        shortLabel: l10n.outdoor,
        fullLabel: l10n.outdoorTemp,
        description: 'Температура воздуха снаружи здания',
        accentColor: AppColors.accent,
      ),
      SensorData(
        icon: Icons.home_outlined,
        value: '${unit.indoorTemp}°',
        shortLabel: l10n.indoor,
        fullLabel: l10n.indoorTemp,
        description: 'Температура воздуха внутри помещения',
        accentColor: AppColors.accentGreen,
      ),
      SensorData(
        icon: Icons.air,
        value: '${unit.supplyTempAfterRecup}°',
        shortLabel: l10n.afterRecup,
        fullLabel: l10n.supplyTempAfterRecup,
        description: 'Температура приточного воздуха после теплообмена в рекуператоре',
        accentColor: AppColors.accent,
      ),
      SensorData(
        icon: Icons.thermostat,
        value: '${unit.supplyTemp}°',
        shortLabel: l10n.supply,
        fullLabel: l10n.supplyTemp,
        description: 'Температура воздуха на выходе из вентиляционной установки',
        accentColor: AppColors.accentOrange,
      ),
      SensorData(
        icon: Icons.cloud_outlined,
        value: '${unit.co2Level}',
        shortLabel: 'CO₂ ppm',
        fullLabel: l10n.co2Level,
        description: 'Уровень углекислого газа в помещении. Норма: до 1000 ppm',
        accentColor: AppColors.accentGreen,
      ),
      SensorData(
        icon: Icons.recycling,
        value: '${unit.recuperatorEfficiency}%',
        shortLabel: l10n.efficiency,
        fullLabel: l10n.recuperatorEfficiency,
        description: 'Эффективность теплообмена в рекуператоре',
        accentColor: AppColors.accent,
      ),
      SensorData(
        icon: Icons.ac_unit,
        value: '${unit.freeCooling}',
        shortLabel: l10n.freeCool,
        fullLabel: l10n.freeCooling,
        description: 'Режим бесплатного охлаждения через рекуператор (м³/ч)',
        accentColor: AppColors.accent,
      ),
      SensorData(
        icon: Icons.local_fire_department_outlined,
        value: '${unit.heaterPerformance}%',
        shortLabel: l10n.heater,
        fullLabel: l10n.heaterPerformance,
        description: 'Текущая мощность электрического нагревателя',
        accentColor: AppColors.accentOrange,
      ),
      SensorData(
        icon: Icons.severe_cold,
        value: '${unit.coolerStatus}%',
        shortLabel: l10n.cooler,
        fullLabel: l10n.coolerStatus,
        description: 'Статус работы охладителя воздуха',
        accentColor: AppColors.accent,
      ),
      SensorData(
        icon: Icons.speed,
        value: '${unit.ductPressure}',
        shortLabel: l10n.pressure,
        fullLabel: l10n.ductPressure,
        description: 'Давление воздуха в воздуховоде (Па)',
        accentColor: Colors.grey,
      ),
      SensorData(
        icon: Icons.water_drop_outlined,
        value: '${unit.humidity}%',
        shortLabel: l10n.humidity,
        fullLabel: l10n.relativeHumidity,
        description: 'Относительная влажность воздуха в помещении',
        accentColor: AppColors.accent,
      ),
    ];
  }

  Widget _buildNoDeviceState(BuildContext context, BreezColors colors, AppLocalizations l10n) {
    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.sensors_off_outlined,
              size: 48,
              color: colors.textMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.noDeviceSelected,
              style: TextStyle(
                fontSize: 14,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Секция датчиков
class _SensorsSection extends StatelessWidget {
  final List<SensorData> sensors;

  const _SensorsSection({required this.sensors});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивное количество колонок
        final width = constraints.maxWidth;
        final crossAxisCount = width > 600 ? 6 : (width > 400 ? 4 : 3);

        return AnalyticsSensorsGrid(
          sensors: sensors,
          crossAxisCount: crossAxisCount,
          compact: width < 400,
        );
      },
    );
  }
}

/// Skeleton для загрузки датчиков
class _SensorsSkeletonGrid extends StatelessWidget {
  const _SensorsSkeletonGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.9,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => const SkeletonBox(
        height: 80,
        borderRadius: 12,
      ),
    );
  }
}

