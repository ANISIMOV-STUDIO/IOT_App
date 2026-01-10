/// Operation Graph Widget - Shows unit operation history
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/graph_data.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';
import 'operation_graph_painter.dart';
import 'operation_graph_widgets.dart';

export '../../../domain/entities/graph_data.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для OperationGraph
abstract class _GraphConstants {
  // Размеры
  static const double yAxisWidth = 28.0;
  static const double xAxisHeight = 30.0;

  // Шрифты
  static const double labelFontSize = 9.0;
  static const double valueFontSize = 32.0;
  static const double unitFontSize = 16.0;
  static const double axisFontSize = 9.0;
  static const double xAxisFontSize = 10.0;

  // Отступы
  static const int maxXAxisLabels = 6;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Operation graph widget with smooth curve
///
/// Поддерживает:
/// - Переключение метрик (температура, влажность, поток)
/// - Hover эффекты
/// - Кэширование статистики
/// - Accessibility через Semantics
class OperationGraph extends StatefulWidget {
  final List<GraphDataPoint> data;
  final GraphMetric selectedMetric;
  final ValueChanged<GraphMetric>? onMetricChanged;
  final double? highlightValue;
  final int? highlightIndex;

  const OperationGraph({
    super.key,
    required this.data,
    this.selectedMetric = GraphMetric.temperature,
    this.onMetricChanged,
    this.highlightValue,
    this.highlightIndex,
  });

  @override
  State<OperationGraph> createState() => _OperationGraphState();
}

class _OperationGraphState extends State<OperationGraph> {
  int? _hoveredIndex;
  _GraphStats? _cachedStats;
  List<GraphDataPoint>? _lastData;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Кэширование статистики - пересчёт только при изменении данных
    if (_lastData != widget.data) {
      _cachedStats = _calculateStats();
      _lastData = widget.data;
    }
    final stats = _cachedStats ?? _calculateStats();

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and metric tabs
          _GraphHeader(
            currentValue: stats.current,
            metricLabel: _getMetricLabel(l10n),
            metricUnit: _getMetricUnit(l10n),
            selectedMetric: widget.selectedMetric,
            onMetricChanged: widget.onMetricChanged,
            l10n: l10n,
            colors: colors,
          ),

          const SizedBox(height: AppSpacing.xs),

          // Statistics row
          _StatisticsRow(
            minValue: stats.min,
            maxValue: stats.max,
            avgValue: stats.avg,
            unit: _getMetricUnit(l10n),
            l10n: l10n,
          ),

          const SizedBox(height: AppSpacing.xs),

          // Graph area
          Expanded(
            child: _GraphArea(
              data: widget.data,
              hoveredIndex: _hoveredIndex,
              highlightIndex: widget.highlightIndex,
              onHoverChanged: (index) => setState(() => _hoveredIndex = index),
              colors: colors,
            ),
          ),
        ],
      ),
    );
  }

  _GraphStats _calculateStats() {
    final data = widget.data;
    if (data.isEmpty) {
      return const _GraphStats(current: 0, min: 0, max: 0, avg: 0);
    }

    // Один проход вместо 4 отдельных reduce
    double minVal = data.first.value;
    double maxVal = data.first.value;
    double sum = 0;

    for (final point in data) {
      final v = point.value;
      if (v < minVal) minVal = v;
      if (v > maxVal) maxVal = v;
      sum += v;
    }

    return _GraphStats(
      current: data.last.value,
      min: minVal,
      max: maxVal,
      avg: sum / data.length,
    );
  }

  String _getMetricLabel(AppLocalizations l10n) {
    final labelMap = <GraphMetric, String>{
      GraphMetric.temperature: l10n.graphTemperatureLabel,
      GraphMetric.humidity: l10n.graphHumidityLabel,
      GraphMetric.airflow: l10n.graphAirflowLabel,
    };
    return labelMap[widget.selectedMetric] ?? '';
  }

  String _getMetricUnit(AppLocalizations l10n) {
    final unitMap = <GraphMetric, String>{
      GraphMetric.temperature: '°C',
      GraphMetric.humidity: '%',
      GraphMetric.airflow: '%',
    };
    return unitMap[widget.selectedMetric] ?? '';
  }
}

/// Graph statistics data
class _GraphStats {
  final double current;
  final double min;
  final double max;
  final double avg;

  const _GraphStats({
    required this.current,
    required this.min,
    required this.max,
    required this.avg,
  });
}

/// Header with current value and metric tabs
class _GraphHeader extends StatelessWidget {
  final double currentValue;
  final String metricLabel;
  final String metricUnit;
  final GraphMetric selectedMetric;
  final ValueChanged<GraphMetric>? onMetricChanged;
  final AppLocalizations l10n;
  final BreezColors colors;

  const _GraphHeader({
    required this.currentValue,
    required this.metricLabel,
    required this.metricUnit,
    required this.selectedMetric,
    this.onMetricChanged,
    required this.l10n,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$metricLabel: ${currentValue.toStringAsFixed(1)} $metricUnit',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metricLabel,
                  style: TextStyle(
                    fontSize: _GraphConstants.labelFontSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: colors.textMuted,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      currentValue.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: _GraphConstants.valueFontSize,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        color: colors.text,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xxs),
                    Text(
                      metricUnit,
                      style: TextStyle(
                        fontSize: _GraphConstants.unitFontSize,
                        fontWeight: FontWeight.w600,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Metric tabs
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GraphMetricTab(
                icon: Icons.thermostat_outlined,
                label: l10n.tempShort,
                isSelected: selectedMetric == GraphMetric.temperature,
                onTap: () => onMetricChanged?.call(GraphMetric.temperature),
              ),
              SizedBox(width: AppSpacing.xs),
              GraphMetricTab(
                icon: Icons.water_drop_outlined,
                label: l10n.humidShort,
                isSelected: selectedMetric == GraphMetric.humidity,
                onTap: () => onMetricChanged?.call(GraphMetric.humidity),
              ),
              SizedBox(width: AppSpacing.xs),
              GraphMetricTab(
                icon: Icons.air,
                label: l10n.airflowShort,
                isSelected: selectedMetric == GraphMetric.airflow,
                onTap: () => onMetricChanged?.call(GraphMetric.airflow),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Statistics row with min/max/avg badges
class _StatisticsRow extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final double avgValue;
  final String unit;
  final AppLocalizations l10n;

  const _StatisticsRow({
    required this.minValue,
    required this.maxValue,
    required this.avgValue,
    required this.unit,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GraphStatBadge(
          label: l10n.minShort,
          value: '${minValue.toStringAsFixed(1)}$unit',
          color: AppColors.accent,
        ),
        const SizedBox(width: AppSpacing.xs),
        GraphStatBadge(
          label: l10n.maxShort,
          value: '${maxValue.toStringAsFixed(1)}$unit',
          color: AppColors.accentRed,
        ),
        const SizedBox(width: AppSpacing.xs),
        GraphStatBadge(
          label: l10n.avgShort,
          value: '${avgValue.toStringAsFixed(1)}$unit',
          color: AppColors.accentGreen,
        ),
      ],
    );
  }
}

/// Graph area with Y-axis, canvas, and X-axis
class _GraphArea extends StatelessWidget {
  final List<GraphDataPoint> data;
  final int? hoveredIndex;
  final int? highlightIndex;
  final ValueChanged<int?> onHoverChanged;
  final BreezColors colors;

  const _GraphArea({
    required this.data,
    this.hoveredIndex,
    this.highlightIndex,
    required this.onHoverChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            // Y-axis labels
            _YAxis(data: data, colors: colors),

            // Graph
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: MouseRegion(
                      onHover: (event) {
                        final index = _getIndexFromPosition(
                          event.localPosition.dx,
                          constraints.maxWidth - _GraphConstants.yAxisWidth,
                        );
                        onHoverChanged(index);
                      },
                      onExit: (_) => onHoverChanged(null),
                      child: CustomPaint(
                        size: Size(
                          constraints.maxWidth - _GraphConstants.yAxisWidth,
                          constraints.maxHeight - _GraphConstants.xAxisHeight,
                        ),
                        painter: OperationGraphPainter(
                          data: data,
                          color: AppColors.accent,
                          hoveredIndex: hoveredIndex,
                          highlightIndex: highlightIndex,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  // X-axis labels
                  _XAxis(data: data, colors: colors),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  int? _getIndexFromPosition(double dx, double width) {
    if (data.isEmpty) return null;
    final stepWidth = width / (data.length - 1);
    final index = (dx / stepWidth).round();
    if (index >= 0 && index < data.length) {
      return index;
    }
    return null;
  }
}

/// Y-axis labels widget
class _YAxis extends StatelessWidget {
  final List<GraphDataPoint> data;
  final BreezColors colors;

  const _YAxis({
    required this.data,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = data.isEmpty
        ? 30
        : data.map((e) => e.value).reduce(math.max).ceil();
    final minValue = data.isEmpty
        ? 0
        : data.map((e) => e.value).reduce(math.min).floor();

    return SizedBox(
      width: _GraphConstants.yAxisWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildLabel('${maxValue + 2}', colors),
          _buildLabel('${((maxValue + minValue) / 2).round()}', colors),
          _buildLabel('${minValue - 2 < 0 ? 0 : minValue - 2}', colors),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, BreezColors colors) {
    return Text(
      text,
      style: TextStyle(
        fontSize: _GraphConstants.axisFontSize,
        fontWeight: FontWeight.w500,
        color: colors.textMuted.withValues(alpha: 0.6),
      ),
    );
  }
}

/// X-axis labels widget
class _XAxis extends StatelessWidget {
  final List<GraphDataPoint> data;
  final BreezColors colors;

  const _XAxis({
    required this.data,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final labelCount = data.length;
    final step = labelCount <= _GraphConstants.maxXAxisLabels
        ? 1
        : (labelCount / (_GraphConstants.maxXAxisLabels - 1)).ceil();

    final labels = <Widget>[];
    for (var i = 0; i < labelCount; i++) {
      if (i == 0 || i == labelCount - 1 || (step > 1 && i % step == 0)) {
        labels.add(
          Text(
            data[i].label,
            style: TextStyle(
              fontSize: _GraphConstants.xAxisFontSize,
              color: colors.textMuted,
            ),
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels,
    );
  }
}
