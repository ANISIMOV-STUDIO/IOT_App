/// Analytics Screen - Параметры устройства с выбором показателей для главного экрана
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/services/quick_sensors_service.dart';
import '../../../data/api/http/clients/hvac_http_client.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../domain/entities/device_full_state.dart';
import '../../../domain/entities/climate.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/analytics/analytics_bloc.dart';
import '../../bloc/climate/climate_bloc.dart';
import '../../bloc/devices/devices_bloc.dart';
import '../../widgets/breez/breez.dart';
import '../../widgets/loading/skeleton.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _AnalyticsConstants {
  // Selection
  static const int maxSelectedSensors = 3;

  // Tile sizes
  static const double tileIconSize = 24.0;
  static const double tileValueFontSize = 16.0;
  static const double tileLabelFontSize = 10.0;
  static const double tileLabelSpacing = 2.0;

  // Tile selection indicator
  static const double checkBadgeTop = 4.0;
  static const double checkBadgeRight = 4.0;
  static const double checkBadgePadding = 2.0;
  static const double checkIconSize = 10.0;
  static const double selectedBorderWidth = 2.0;
  static const double defaultBorderWidth = 1.0;

  // Dialog
  static const double dialogIconSize = 48.0;
  static const double dialogValueFontSize = 28.0;
  static const double dialogLabelFontSize = 16.0;
  static const double dialogDescFontSize = 14.0;
  static const double dialogDescLineHeight = 1.4;

  // Graph
  static const double graphHeight = 280.0;

  // Indicator
  static const double indicatorSize = 14.0;
  static const double indicatorIconSize = 16.0;
  static const double indicatorFontSize = 13.0;
}

// =============================================================================
// MAIN SCREEN
// =============================================================================

/// Экран аналитики с выбором показателей для главного экрана
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<String> _selectedSensorKeys = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedSensors();
  }

  void _loadSelectedSensors() {
    final climateState = context.read<ClimateBloc>().state;
    final fullState = climateState.deviceFullState;
    if (fullState != null && fullState.quickSensors.isNotEmpty) {
      setState(() {
        _selectedSensorKeys = List<String>.from(fullState.quickSensors);
      });
    } else {
      setState(() {
        _selectedSensorKeys = List<String>.from(QuickSensorsService.defaultSensorKeys);
      });
    }
  }

  Future<void> _toggleSensor(String sensorKey) async {
    setState(() {
      final current = List<String>.from(_selectedSensorKeys);
      if (current.contains(sensorKey)) {
        current.remove(sensorKey);
      } else if (current.length < _AnalyticsConstants.maxSelectedSensors) {
        current.add(sensorKey);
      } else {
        // Заменяем первый выбранный
        current.removeAt(0);
        current.add(sensorKey);
      }
      _selectedSensorKeys = current;
    });

    // Автосохранение если выбрано 3
    if (_selectedSensorKeys.length == _AnalyticsConstants.maxSelectedSensors) {
      await _saveSensors();
    }
  }

  void _onSensorTap(_SensorInfo sensor) {
    _showSensorInfoDialog(sensor);
  }

  void _showSensorInfoDialog(_SensorInfo sensor) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: colors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                sensor.icon,
                size: _AnalyticsConstants.dialogIconSize,
                color: sensor.color,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                sensor.value,
                style: TextStyle(
                  fontSize: _AnalyticsConstants.dialogValueFontSize,
                  fontWeight: FontWeight.bold,
                  color: colors.text,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                sensor.label,
                style: TextStyle(
                  fontSize: _AnalyticsConstants.dialogLabelFontSize,
                  fontWeight: FontWeight.w500,
                  color: colors.text,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                sensor.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _AnalyticsConstants.dialogDescFontSize,
                  color: colors.textMuted,
                  height: _AnalyticsConstants.dialogDescLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: colors.buttonBg,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  child: Text(
                    l10n.close,
                    style: TextStyle(color: colors.text),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSensorLongPress(String sensorKey) async {
    final isSelected = _selectedSensorKeys.contains(sensorKey);

    if (isSelected) {
      // Убираем из выбранных
      setState(() {
        final current = List<String>.from(_selectedSensorKeys);
        current.remove(sensorKey);
        _selectedSensorKeys = current;
      });
    } else {
      // Добавляем/заменяем
      await _toggleSensor(sensorKey);
    }
  }

  Future<void> _saveSensors() async {
    if (_isSaving || _selectedSensorKeys.length != _AnalyticsConstants.maxSelectedSensors) return;

    final devicesState = context.read<DevicesBloc>().state;
    final deviceId = devicesState.selectedDeviceId;
    if (deviceId == null) return;

    setState(() => _isSaving = true);

    try {
      final httpClient = GetIt.instance<HvacHttpClient>();
      await httpClient.setQuickSensors(deviceId, _selectedSensorKeys);

      // Обновляем локальное состояние в BLoC
      if (mounted) {
        context.read<ClimateBloc>().add(
          ClimateQuickSensorsUpdated(List<String>.from(_selectedSensorKeys)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

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
            _loadSelectedSensors();
            await Future.delayed(const Duration(milliseconds: 500));
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.analytics,
                            style: TextStyle(
                              fontSize: AppFontSizes.h2,
                              fontWeight: FontWeight.bold,
                              color: colors.text,
                            ),
                          ),
                          _buildSelectionIndicator(colors, l10n),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        l10n.sensorInteractionHint,
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
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                        child: _buildErrorState(colors, l10n, state.errorMessage),
                      );
                    }

                    final fullState = state.deviceFullState;
                    final climate = state.climate;
                    if (fullState == null && climate == null) {
                      return SliverToBoxAdapter(
                        child: _buildNoDeviceState(colors, l10n),
                      );
                    }

                    final unit = _createUnitState(fullState, climate);
                    final sensors = _buildSensorsList(unit, l10n);

                    return SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: AppSpacing.xs,
                        crossAxisSpacing: AppSpacing.xs,
                        childAspectRatio: 0.85,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final sensor = sensors[index];
                          return _SensorTile(
                            sensor: sensor,
                            isSelected: _selectedSensorKeys.contains(sensor.key),
                            onTap: () => _onSensorTap(sensor),
                            onLongPress: () => _onSensorLongPress(sensor.key),
                          );
                        },
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
                        return const SkeletonGraph(height: _AnalyticsConstants.graphHeight);
                      }

                      if (state.status == AnalyticsStatus.failure) {
                        return _buildGraphErrorState(colors, l10n, state.errorMessage);
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

  Widget _buildSelectionIndicator(BreezColors colors, AppLocalizations l10n) {
    final count = _selectedSensorKeys.length;
    const max = _AnalyticsConstants.maxSelectedSensors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isSaving)
          SizedBox(
            width: _AnalyticsConstants.indicatorSize,
            height: _AnalyticsConstants.indicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: _AnalyticsConstants.defaultBorderWidth,
              color: AppColors.accent,
            ),
          )
        else
          Icon(
            count == max ? Icons.check_circle : Icons.radio_button_unchecked,
            size: _AnalyticsConstants.indicatorIconSize,
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
  }

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
      outsideTemp: fullState?.outdoorTemperature ?? 0.0,
      filterPercent: fullState?.kpdRecuperator ?? 0,
      airflowRate: fullState?.devicePower ?? 0,
      indoorTemp: fullState?.indoorTemperature ?? climate?.currentTemperature ?? 22.0,
      supplyTemp: fullState?.supplyTemperature ?? 20.0,
      supplyTempAfterRecup: fullState?.supplyTempAfterRecup ?? 18.0,
      co2Level: fullState?.co2Level ?? 0,
      recuperatorEfficiency: fullState?.kpdRecuperator ?? 0,
      freeCooling: fullState?.freeCooling ?? false,
      heaterPerformance: fullState?.heaterPerformance ?? 0,
      coolerStatus: fullState?.coolerStatus ?? 'Н/Д',
      ductPressure: fullState?.ductPressure ?? 0,
      isOnline: fullState?.isOnline ?? true,
    );
  }

  List<_SensorInfo> _buildSensorsList(UnitState unit, AppLocalizations l10n) {
    return [
      _SensorInfo(
        key: 'outside_temp',
        icon: Icons.thermostat_outlined,
        value: '${unit.outsideTemp.toStringAsFixed(1)}°',
        label: l10n.outdoor,
        description: 'Температура наружного воздуха с датчика устройства',
        color: AppColors.accent,
      ),
      _SensorInfo(
        key: 'indoor_temp',
        icon: Icons.home_outlined,
        value: '${unit.indoorTemp.toStringAsFixed(1)}°',
        label: l10n.indoor,
        description: 'Температура воздуха в помещении',
        color: AppColors.accentGreen,
      ),
      _SensorInfo(
        key: 'supply_temp',
        icon: Icons.air,
        value: '${unit.supplyTemp.toStringAsFixed(1)}°',
        label: l10n.supply,
        description: 'Температура приточного воздуха после обработки',
        color: AppColors.accentOrange,
      ),
      _SensorInfo(
        key: 'humidity',
        icon: Icons.water_drop_outlined,
        value: '${unit.humidity}%',
        label: l10n.humidity,
        description: 'Относительная влажность воздуха в помещении',
        color: AppColors.accent,
      ),
      _SensorInfo(
        key: 'co2_level',
        icon: Icons.cloud_outlined,
        value: '${unit.co2Level}',
        label: 'CO₂',
        description: 'Уровень углекислого газа в помещении (ppm)',
        color: AppColors.accentGreen,
      ),
      _SensorInfo(
        key: 'recuperator_eff',
        icon: Icons.recycling,
        value: '${unit.recuperatorEfficiency}%',
        label: l10n.efficiency,
        description: 'КПД рекуператора — эффективность теплообмена',
        color: AppColors.accent,
      ),
      _SensorInfo(
        key: 'heater_perf',
        icon: Icons.local_fire_department_outlined,
        value: '${unit.heaterPerformance}%',
        label: l10n.heater,
        description: 'Мощность работы нагревателя',
        color: AppColors.accentOrange,
      ),
      _SensorInfo(
        key: 'duct_pressure',
        icon: Icons.speed,
        value: '${unit.ductPressure}',
        label: l10n.pressure,
        description: l10n.ductPressureDesc,
        color: AppColors.darkTextMuted,
      ),
      _SensorInfo(
        key: 'filter_percent',
        icon: Icons.filter_alt_outlined,
        value: '${unit.filterPercent}%',
        label: l10n.filter,
        description: 'Загрязнённость фильтра, требует замены при 100%',
        color: AppColors.accent,
      ),
      _SensorInfo(
        key: 'airflow_rate',
        icon: Icons.air,
        value: '${unit.airflowRate}',
        label: l10n.airflowRate,
        description: 'Текущий расход воздуха системы (м³/ч)',
        color: AppColors.accent,
      ),
    ];
  }

  Widget _buildNoDeviceState(BreezColors colors, AppLocalizations l10n) {
    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.sensors_off_outlined, size: 48, color: colors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.noDeviceSelected,
              style: TextStyle(fontSize: 14, color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BreezColors colors, AppLocalizations l10n, String? errorMessage) {
    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.critical),
            const SizedBox(height: AppSpacing.md),
            Text(
              errorMessage ?? l10n.errorLoadingFailed,
              style: TextStyle(fontSize: 14, color: colors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: () {
                context.read<ClimateBloc>().add(const ClimateSubscriptionRequested());
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphErrorState(BreezColors colors, AppLocalizations l10n, String? errorMessage) {
    return SizedBox(
      height: _AnalyticsConstants.graphHeight,
      child: BreezCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.show_chart, size: 48, color: AppColors.critical),
              const SizedBox(height: AppSpacing.md),
              Text(
                errorMessage ?? l10n.errorLoadingFailed,
                style: TextStyle(fontSize: 14, color: colors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton.icon(
                onPressed: () {
                  context.read<AnalyticsBloc>().add(const AnalyticsRefreshRequested());
                },
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SENSOR TILE
// =============================================================================

class _SensorInfo {
  final String key;
  final IconData icon;
  final String value;
  final String label;
  final String description;
  final Color color;

  const _SensorInfo({
    required this.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.description,
    required this.color,
  });
}

class _SensorTile extends StatelessWidget {
  final _SensorInfo sensor;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _SensorTile({
    required this.sensor,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${sensor.label}: ${sensor.value}',
      hint: isSelected ? 'Зажмите чтобы убрать' : 'Зажмите чтобы выбрать',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppRadius.cardSmall),
          child: Container(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppRadius.cardSmall),
              border: Border.all(
                color: isSelected ? AppColors.accent : colors.border,
                width: isSelected
                    ? _AnalyticsConstants.selectedBorderWidth
                    : _AnalyticsConstants.defaultBorderWidth,
              ),
            ),
            child: Stack(
              children: [
                // Основной контент
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          sensor.icon,
                          size: _AnalyticsConstants.tileIconSize,
                          color: isSelected ? AppColors.accent : sensor.color,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          sensor.value,
                          style: TextStyle(
                            fontSize: _AnalyticsConstants.tileValueFontSize,
                            fontWeight: FontWeight.w700,
                            color: colors.text,
                          ),
                        ),
                        SizedBox(height: _AnalyticsConstants.tileLabelSpacing),
                        Text(
                          sensor.label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: _AnalyticsConstants.tileLabelFontSize,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Галочка выбора
                if (isSelected)
                  Positioned(
                    top: _AnalyticsConstants.checkBadgeTop,
                    right: _AnalyticsConstants.checkBadgeRight,
                    child: Container(
                      padding: EdgeInsets.all(_AnalyticsConstants.checkBadgePadding),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: _AnalyticsConstants.checkIconSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
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
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.xs,
        crossAxisSpacing: AppSpacing.xs,
        childAspectRatio: 0.85,
      ),
      itemCount: 10,
      itemBuilder: (context, index) => const SkeletonBox(
        height: 80,
        borderRadius: AppRadius.cardSmall,
      ),
    );
  }
}
