/// Analytics Screen - Параметры устройства с выбором показателей для главного экрана
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/data/api/http/clients/hvac_http_client.dart';
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
  // Selection
  static const int maxSelectedSensors = 3;

  // Tile sizes
  static const double tileValueFontSize = 16;
  static const double tileLabelFontSize = 10;
  static const double tileLabelSpacing = 2;

  // Tile selection indicator
  static const double checkBadgeTop = 4;
  static const double checkBadgeRight = 4;
  static const double checkBadgePadding = 2;
  static const double selectedBorderWidth = 2;
  static const double defaultBorderWidth = 1;

  // Dialog
  static const double dialogValueFontSize = 28;
  static const double dialogLabelFontSize = 16;
  static const double dialogDescFontSize = 14;
  static const double dialogDescLineHeight = 1.4;

  // Graph
  static const double graphHeight = 280;

  // Indicator
  static const double indicatorFontSize = 13;
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
  bool _isInitializedFromServer = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedSensors();
  }

  /// Синхронизирует _selectedSensorKeys с сервером при первой загрузке
  /// Вызывается из BlocListener когда deviceFullState становится доступным
  void _syncFromServerIfNeeded(DeviceFullState? fullState) {
    if (_isInitializedFromServer || fullState == null) {
      return;
    }

    _isInitializedFromServer = true;
    setState(() {
      _selectedSensorKeys = List<String>.from(fullState.quickSensors);
    });
  }

  void _loadSelectedSensors() {
    final climateState = context.read<ClimateBloc>().state;
    final fullState = climateState.deviceFullState;
    if (fullState != null) {
      // Данные с сервера - помечаем как инициализированные
      _isInitializedFromServer = true;
      setState(() {
        _selectedSensorKeys = List<String>.from(fullState.quickSensors);
      });
    }
    // Если данных нет - оставляем пустой список, BlocListener обновит позже
  }

  Future<void> _toggleSensor(String sensorKey) async {
    setState(() {
      final current = List<String>.from(_selectedSensorKeys);
      if (current.contains(sensorKey)) {
        current.remove(sensorKey);
      } else if (current.length < _AnalyticsConstants.maxSelectedSensors) {
        current.add(sensorKey);
      }
      // Если уже 3 выбрано - не добавляем (нужно сначала убрать один)
      _selectedSensorKeys = current;
    });

    // Автосохранение при любом изменении
    await _saveSensors();
  }

  void _onSensorTap(_SensorInfo sensor) {
    _showSensorInfoDialog(sensor);
  }

  void _showSensorInfoDialog(_SensorInfo sensor) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isSelected = _selectedSensorKeys.contains(sensor.key);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
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
              // Иконка с индикатором выбора
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: sensor.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppColors.accent, width: 2)
                          : null,
                    ),
                    child: Icon(
                      sensor.icon,
                      size: AppIconSizes.standard,
                      color: sensor.color,
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xxs),
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: AppIconSizes.standard,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                ],
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
              // Кнопки: выбор + закрыть
              Row(
                children: [
                  // Кнопка выбора
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        // Можно добавить если не достигнут лимит или убрать если уже выбран
                        final canAdd =
                            _selectedSensorKeys.length <
                            _AnalyticsConstants.maxSelectedSensors;
                        final isEnabled = isSelected || canAdd;
                        final buttonColor = isEnabled
                            ? AppColors.accent
                            : colors.textMuted;

                        return BreezButton(
                          onTap: isEnabled
                              ? () {
                                  Navigator.pop(dialogContext);
                                  _toggleSensor(sensor.key);
                                }
                              : null,
                          backgroundColor: isSelected
                              ? colors.buttonBg
                              : isEnabled
                              ? AppColors.accent.withValues(alpha: 0.15)
                              : colors.buttonBg.withValues(alpha: 0.5),
                          hoverColor: isSelected
                              ? colors.cardLight
                              : AppColors.accent.withValues(alpha: 0.2),
                          border: isSelected || !isEnabled
                              ? null
                              : Border.all(color: AppColors.accent),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          semanticLabel: isSelected
                              ? 'Убрать'
                              : isEnabled
                              ? 'На главную'
                              : 'Максимум 3',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.remove_circle_outline
                                    : Icons.add_circle_outline,
                                size: AppIconSizes.standard,
                                color: isSelected
                                    ? colors.textMuted
                                    : buttonColor,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                isSelected
                                    ? 'Убрать'
                                    : isEnabled
                                    ? 'На главную'
                                    : 'Максимум 3',
                                style: TextStyle(
                                  color: isSelected
                                      ? colors.textMuted
                                      : buttonColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  // Кнопка закрыть
                  Expanded(
                    child: BreezButton(
                      onTap: () => Navigator.pop(dialogContext),
                      backgroundColor: colors.buttonBg,
                      hoverColor: colors.cardLight,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      semanticLabel: l10n.close,
                      child: Text(
                        l10n.close,
                        style: TextStyle(color: colors.text),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveSensors() async {
    if (_isSaving) {
      return;
    }

    final devicesState = context.read<DevicesBloc>().state;
    final deviceId = devicesState.selectedDeviceId;
    if (deviceId == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final httpClient = GetIt.instance<HvacHttpClient>();
      await httpClient.setQuickSensors(deviceId, _selectedSensorKeys);

      // Обновляем только quickSensors без перезагрузки всего состояния
      if (mounted) {
        context.read<ClimateBloc>().add(
          ClimateQuickSensorsUpdated(_selectedSensorKeys),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка сохранения: $e')));
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

    return BlocListener<ClimateBloc, ClimateControlState>(
      listenWhen: (prev, curr) =>
          prev.deviceFullState?.quickSensors !=
          curr.deviceFullState?.quickSensors,
      listener: (context, state) {
        _syncFromServerIfNeeded(state.deviceFullState);
      },
      child: Scaffold(
        backgroundColor: colors.bg,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.accent,
            onRefresh: () async {
              context.read<AnalyticsBloc>().add(
                const AnalyticsRefreshRequested(),
              );
              _loadSelectedSensors();
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
                          trailing: _buildSelectionIndicator(colors, l10n),
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
                          child: _buildErrorState(
                            colors,
                            l10n,
                            state.errorMessage,
                          ),
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: AppSpacing.xs,
                              crossAxisSpacing: AppSpacing.xs,
                              childAspectRatio: 0.85,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final sensor = sensors[index];
                          return _SensorTile(
                            sensor: sensor,
                            isSelected: _selectedSensorKeys.contains(
                              sensor.key,
                            ),
                            onTap: () => _onSensorTap(sensor),
                          );
                        }, childCount: sensors.length),
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
                          return _buildGraphErrorState(
                            colors,
                            l10n,
                            state.errorMessage,
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
      ),
    );
  }

  Widget _buildSelectionIndicator(BreezColors colors, AppLocalizations l10n) {
    // Показываем лоадер пока данные не загружены с сервера
    if (!_isInitializedFromServer) {
      return const BreezLoader.small();
    }

    final count = _selectedSensorKeys.length;
    const max = _AnalyticsConstants.maxSelectedSensors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isSaving)
          const BreezLoader.small()
        else
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
  }

  UnitState _createUnitState(
    DeviceFullState? fullState,
    ClimateState? climate,
  ) {
    // Получаем текущий режим и его настройки
    final currentMode = fullState?.operatingMode ?? climate?.preset ?? '';
    final modeSettings = fullState?.modeSettings?[currentMode];

    return UnitState(
      id: fullState?.id ?? '',
      name: fullState?.name ?? 'Device',
      power: fullState?.power ?? climate?.isOn ?? false,
      temp: climate?.currentTemperature.toInt() ?? 20,
      // Берём значения из настроек текущего режима
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

  List<_SensorInfo> _buildSensorsList(UnitState unit, AppLocalizations l10n) => [
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
        value: '${unit.heaterPower}%',
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
        key: 'free_cooling',
        icon: Icons.ac_unit,
        value: unit.freeCooling ? l10n.on : l10n.off,
        label: l10n.freeCool,
        description: l10n.freeCoolingDesc,
        color: unit.freeCooling
            ? AppColors.accentGreen
            : AppColors.darkTextMuted,
      ),
      _SensorInfo(
        key: 'filter_percent',
        icon: Icons.filter_alt_outlined,
        value: '${unit.filterPercent}%',
        label: l10n.filter,
        description: 'Загрязнённость фильтра, требует замены при 100%',
        color: AppColors.accent,
      ),
    ];

  Widget _buildNoDeviceState(BreezColors colors, AppLocalizations l10n) => BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.sensors_off_outlined, size: AppIconSizes.standard, color: colors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.noDeviceSelected,
              style: TextStyle(fontSize: AppFontSizes.body, color: colors.textMuted),
            ),
          ],
        ),
      ),
    );

  Widget _buildErrorState(
    BreezColors colors,
    AppLocalizations l10n,
    String? errorMessage,
  ) => BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: AppIconSizes.standard,
              color: AppColors.critical,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              errorMessage ?? l10n.errorLoadingFailed,
              style: TextStyle(fontSize: AppFontSizes.body, color: colors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            BreezButton(
              onTap: () {
                context.read<ClimateBloc>().add(
                  const ClimateSubscriptionRequested(),
                );
              },
              backgroundColor: Colors.transparent,
              hoverColor: AppColors.accent.withValues(alpha: 0.1),
              pressedColor: AppColors.accent.withValues(alpha: 0.15),
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

  Widget _buildGraphErrorState(
    BreezColors colors,
    AppLocalizations l10n,
    String? errorMessage,
  ) => SizedBox(
      height: _AnalyticsConstants.graphHeight,
      child: BreezCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart, size: AppIconSizes.standard, color: AppColors.critical),
              const SizedBox(height: AppSpacing.md),
              Text(
                errorMessage ?? l10n.errorLoadingFailed,
                style: TextStyle(fontSize: AppFontSizes.body, color: colors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              BreezButton(
                onTap: () {
                  context.read<AnalyticsBloc>().add(
                    const AnalyticsRefreshRequested(),
                  );
                },
                backgroundColor: Colors.transparent,
                hoverColor: AppColors.accent.withValues(alpha: 0.1),
                pressedColor: AppColors.accent.withValues(alpha: 0.15),
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

// =============================================================================
// SENSOR TILE
// =============================================================================

class _SensorInfo {

  const _SensorInfo({
    required this.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.description,
    required this.color,
  });
  final String key;
  final IconData icon;
  final String value;
  final String label;
  final String description;
  final Color color;
}

class _SensorTile extends StatelessWidget {

  const _SensorTile({
    required this.sensor,
    required this.isSelected,
    required this.onTap,
  });
  final _SensorInfo sensor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: onTap,
      backgroundColor: colors.card,
      hoverColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.15)
          : colors.cardLight,
      border: Border.all(
        color: isSelected ? AppColors.accent : colors.border,
        width: isSelected
            ? _AnalyticsConstants.selectedBorderWidth
            : _AnalyticsConstants.defaultBorderWidth,
      ),
      padding: const EdgeInsets.all(AppSpacing.xs),
      semanticLabel: '${sensor.label}: ${sensor.value}',
      tooltip: 'Нажмите для подробностей',
      child: Stack(
        children: [
          // Основной контент
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  sensor.icon,
                  size: AppIconSizes.standard,
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
                const SizedBox(height: _AnalyticsConstants.tileLabelSpacing),
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
          // Галочка выбора
          if (isSelected)
            Positioned(
              top: _AnalyticsConstants.checkBadgeTop,
              right: _AnalyticsConstants.checkBadgeRight,
              child: Container(
                padding: const EdgeInsets.all(_AnalyticsConstants.checkBadgePadding),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: AppIconSizes.standard,
                  color: AppColors.white,
                ),
              ),
            ),
        ],
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
      itemCount: 10,
      itemBuilder: (context, index) =>
          const SkeletonBox(height: 80, borderRadius: AppRadius.cardSmall),
    );
}
