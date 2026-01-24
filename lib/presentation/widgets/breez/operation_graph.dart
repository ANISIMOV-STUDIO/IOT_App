/// Operation Graph Widget - Shows unit operation history
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_segmented_control.dart';
import 'package:hvac_control/presentation/widgets/breez/operation_graph_controller.dart';
import 'package:hvac_control/presentation/widgets/breez/operation_graph_painter.dart';
import 'package:hvac_control/presentation/widgets/breez/operation_graph_widgets.dart';

export '../../../domain/entities/graph_data.dart';
export 'operation_graph_controller.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для OperationGraph
abstract class _GraphConstants {
  // Размеры осей
  static const double yAxisWidth = AppSpacing.xl; // 32 — для 3-значных чисел
  static const double xAxisHeight = 30;

  // Шрифты - используем дизайн-систему
  static const double valueFontSize = AppFontSizes.h1 + AppSpacing.xxs; // 32
  static const double unitFontSize = AppFontSizes.h4; // 16
  static const double axisFontSize = AppFontSizes.captionSmall; // 11 — читаемее
  static const double xAxisFontSize = AppFontSizes.captionSmall; // 11

  // Отступы
  static const int maxXAxisLabels = 6;

  // Порядок метрик для табов и свайпа
  static const metrics = [
    GraphMetric.temperature,
    GraphMetric.humidity,
    GraphMetric.airflow,
  ];
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
/// - Анимация появления кривой
/// - Множественные линии (multiSeries)
/// - Zoom/pan
class OperationGraph extends StatefulWidget {

  const OperationGraph({
    required this.data,
    super.key,
    this.selectedMetric = GraphMetric.temperature,
    this.onMetricChanged,
    this.highlightValue,
    this.highlightIndex,
    this.animateOnDataChange = true,
    this.multiSeries,
    this.onSeriesVisibilityChanged,
    this.showCard = true,
    this.compact = false,
  });

  /// Single series data (legacy API)
  final List<GraphDataPoint> data;

  /// Selected metric type
  final GraphMetric selectedMetric;

  /// Callback when metric selection changes
  final ValueChanged<GraphMetric>? onMetricChanged;

  /// Value to highlight
  final double? highlightValue;

  /// Index to highlight
  final int? highlightIndex;

  /// Whether to animate curve drawing when data changes
  final bool animateOnDataChange;

  /// Multiple series for multi-line mode (new API)
  final List<GraphSeries>? multiSeries;

  /// Callback when series visibility changes
  final void Function(String seriesId, {required bool isVisible})? onSeriesVisibilityChanged;

  /// Whether to show the card wrapper
  final bool showCard;

  /// Compact mode for smaller spaces (smaller fonts)
  final bool compact;

  @override
  State<OperationGraph> createState() => _OperationGraphState();
}

class _OperationGraphState extends State<OperationGraph>
    with TickerProviderStateMixin {
  int? _hoveredIndex;
  _GraphStats? _cachedStats;
  List<GraphDataPoint>? _lastData;
  late final OperationGraphController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = OperationGraphController(vsync: this);
    _tabController = TabController(
      length: _GraphConstants.metrics.length,
      vsync: this,
      initialIndex: _GraphConstants.metrics.indexOf(widget.selectedMetric),
    );
    _tabController.addListener(_onTabChanged);

    // Start with animation if data is present
    if (widget.data.isNotEmpty && widget.animateOnDataChange) {
      _controller.animateDrawCurve();
    }
  }

  @override
  void didUpdateWidget(OperationGraph oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync tab controller with external selectedMetric changes
    if (widget.selectedMetric != oldWidget.selectedMetric) {
      final newIndex = _GraphConstants.metrics.indexOf(widget.selectedMetric);
      if (_tabController.index != newIndex) {
        _tabController.animateTo(newIndex);
      }
    }

    // Animate when data changes
    if (widget.animateOnDataChange &&
        widget.data != oldWidget.data &&
        widget.data.isNotEmpty) {
      _controller.animateDrawCurve();
    }
  }

  void _onTabChanged() {
    // Only trigger callback when animation settles (not during swipe)
    if (!_tabController.indexIsChanging) {
      final newMetric = _GraphConstants.metrics[_tabController.index];
      if (newMetric != widget.selectedMetric) {
        widget.onMetricChanged?.call(newMetric);
      }
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) {
      return;
    }

    final currentIndex = _GraphConstants.metrics.indexOf(widget.selectedMetric);
    int newIndex;

    if (details.primaryVelocity! < 0) {
      // Swipe left -> next metric
      newIndex = (currentIndex + 1).clamp(0, _GraphConstants.metrics.length - 1);
    } else {
      // Swipe right -> previous metric
      newIndex = (currentIndex - 1).clamp(0, _GraphConstants.metrics.length - 1);
    }

    if (newIndex != currentIndex) {
      _tabController.animateTo(newIndex);
    }
  }

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

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        // Content must be inside builder to react to animation changes
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with metric tabs (synced with TabController)
            _GraphHeader(
              currentValue: stats.current,
              metricLabel: _getMetricLabel(l10n),
              metricUnit: _getMetricUnit(l10n),
              selectedMetric: widget.selectedMetric,
              tabController: _tabController,
              minValue: stats.min,
              maxValue: stats.max,
              avgValue: stats.avg,
              l10n: l10n,
              colors: colors,
              compact: widget.compact,
            ),

            const SizedBox(height: AppSpacing.xs),

            // Swipeable graph area
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: _onHorizontalSwipe,
                behavior: HitTestBehavior.opaque,
                child: _GraphArea(
                  data: widget.data,
                  hoveredIndex: _hoveredIndex,
                  highlightIndex: widget.highlightIndex,
                  onHoverChanged: (index) => setState(() => _hoveredIndex = index),
                  colors: colors,
                  drawProgress: _controller.drawProgress,
                  controller: _controller,
                  multiSeries: widget.multiSeries,
                ),
              ),
            ),

            // Multi-series legend (if multiSeries provided)
            if (widget.multiSeries != null && widget.onSeriesVisibilityChanged != null) ...[
              const SizedBox(height: AppSpacing.xs),
              GraphSeriesLegend(
                series: widget.multiSeries!,
                onToggleVisibility: widget.onSeriesVisibilityChanged!,
              ),
            ],
          ],
        );

        return widget.showCard
            ? BreezCard(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: content,
              )
            : content;
      },
    );
  }

  _GraphStats _calculateStats() {
    final data = widget.data;
    if (data.isEmpty) {
      return const _GraphStats(current: 0, min: 0, max: 0, avg: 0);
    }

    // Один проход вместо 4 отдельных reduce
    var minVal = data.first.value;
    var maxVal = data.first.value;
    double sum = 0;

    for (final point in data) {
      final v = point.value;
      if (v < minVal) {
        minVal = v;
      }
      if (v > maxVal) {
        maxVal = v;
      }
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

  const _GraphStats({
    required this.current,
    required this.min,
    required this.max,
    required this.avg,
  });
  final double current;
  final double min;
  final double max;
  final double avg;
}

/// Header with metric tabs, value, and statistics in one row
class _GraphHeader extends StatelessWidget {

  const _GraphHeader({
    required this.currentValue,
    required this.metricLabel,
    required this.metricUnit,
    required this.selectedMetric,
    required this.tabController,
    required this.minValue,
    required this.maxValue,
    required this.avgValue,
    required this.l10n,
    required this.colors,
    this.compact = false,
  });
  final double currentValue;
  final String metricLabel;
  final String metricUnit;
  final GraphMetric selectedMetric;
  final TabController tabController;
  final double minValue;
  final double maxValue;
  final double avgValue;
  final AppLocalizations l10n;
  final BreezColors colors;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    // Compact mode: меньше шрифт значения
    final valueFontSize = compact ? AppFontSizes.h2 : _GraphConstants.valueFontSize;
    final unitFontSize = compact ? AppFontSizes.body : _GraphConstants.unitFontSize;

    return Semantics(
      label: '$metricLabel: ${currentValue.toStringAsFixed(1)} $metricUnit',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metric selector - synced with TabController for swipe support
          AnimatedBuilder(
            animation: tabController,
            builder: (context, _) => BreezSegmentedControl<GraphMetric>(
              value: _GraphConstants.metrics[tabController.index],
              segments: [
                BreezSegment(
                  value: GraphMetric.temperature,
                  label: l10n.tempShort,
                  icon: Icons.thermostat_outlined,
                ),
                BreezSegment(
                  value: GraphMetric.humidity,
                  label: l10n.humidShort,
                  icon: Icons.water_drop_outlined,
                ),
                BreezSegment(
                  value: GraphMetric.airflow,
                  label: l10n.airflowShort,
                  icon: Icons.air,
                ),
              ],
              onChanged: (metric) {
                final index = _GraphConstants.metrics.indexOf(metric);
                tabController.animateTo(index);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Current value + statistics in one row
          Row(
            children: [
              // Current value
              Text(
                currentValue.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: colors.text,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                metricUnit,
                style: TextStyle(
                  fontSize: unitFontSize,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Statistics badges
              GraphStatBadge(
                label: l10n.minShort,
                value: '${minValue.toStringAsFixed(1)}$metricUnit',
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.xs),
              GraphStatBadge(
                label: l10n.maxShort,
                value: '${maxValue.toStringAsFixed(1)}$metricUnit',
                color: AppColors.accentRed,
              ),
              const SizedBox(width: AppSpacing.xs),
              GraphStatBadge(
                label: l10n.avgShort,
                value: '${avgValue.toStringAsFixed(1)}$metricUnit',
                color: AppColors.accentGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Graph area with Y-axis, canvas, and X-axis
class _GraphArea extends StatelessWidget {

  const _GraphArea({
    required this.data,
    required this.onHoverChanged,
    required this.colors,
    required this.drawProgress,
    required this.controller,
    this.hoveredIndex,
    this.highlightIndex,
    this.multiSeries,
  });
  final List<GraphDataPoint> data;
  final int? hoveredIndex;
  final int? highlightIndex;
  final ValueChanged<int?> onHoverChanged;
  final BreezColors colors;
  final double drawProgress;
  final OperationGraphController controller;
  final List<GraphSeries>? multiSeries;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => Row(
          children: [
            // Y-axis labels (fixed, not affected by zoom)
            _YAxis(data: data, colors: colors, multiSeries: multiSeries),

            // Graph with zoom/pan
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      // Double-tap to reset zoom
                      onDoubleTap: controller.resetZoom,
                      // Touch support for mobile
                      onTapDown: (details) {
                        final index = _getIndexFromPosition(
                          details.localPosition.dx,
                          constraints.maxWidth - _GraphConstants.yAxisWidth,
                        );
                        onHoverChanged(index);
                      },
                      onTapUp: (_) => onHoverChanged(null),
                      onTapCancel: () => onHoverChanged(null),
                      onLongPressStart: (details) {
                        final index = _getIndexFromPosition(
                          details.localPosition.dx,
                          constraints.maxWidth - _GraphConstants.yAxisWidth,
                        );
                        onHoverChanged(index);
                      },
                      onLongPressMoveUpdate: (details) {
                        final index = _getIndexFromPosition(
                          details.localPosition.dx,
                          constraints.maxWidth - _GraphConstants.yAxisWidth,
                        );
                        onHoverChanged(index);
                      },
                      onLongPressEnd: (_) => onHoverChanged(null),
                      child: InteractiveViewer(
                        transformationController: controller.transformController,
                        minScale: controller.minScale,
                        maxScale: controller.maxScale,
                        onInteractionUpdate: (details) {
                          controller.updateTransform(
                            controller.transformController.value,
                          );
                        },
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
                              drawProgress: drawProgress,
                              multiSeries: multiSeries,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // X-axis labels (fixed, not affected by zoom)
                  _XAxis(data: data, colors: colors),
                ],
              ),
            ),
          ],
        ),
    );

  int? _getIndexFromPosition(double dx, double width) {
    if (data.isEmpty) {
      return null;
    }
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

  const _YAxis({
    required this.data,
    required this.colors,
    this.multiSeries,
  });
  final List<GraphDataPoint> data;
  final BreezColors colors;
  final List<GraphSeries>? multiSeries;

  List<GraphDataPoint> get _allDataPoints {
    if (multiSeries != null && multiSeries!.isNotEmpty) {
      return multiSeries!
          .where((s) => s.isVisible)
          .expand((s) => s.data)
          .toList();
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final allPoints = _allDataPoints;
    final maxValue = allPoints.isEmpty
        ? 30
        : allPoints.map((e) => e.value).reduce(math.max).ceil();
    final minValue = allPoints.isEmpty
        ? 0
        : allPoints.map((e) => e.value).reduce(math.min).floor();

    return SizedBox(
      width: _GraphConstants.yAxisWidth,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.xxs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildLabel('${maxValue + 2}', colors),
            _buildLabel('${((maxValue + minValue) / 2).round()}', colors),
            _buildLabel('${minValue - 2 < 0 ? 0 : minValue - 2}', colors),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, BreezColors colors) => Text(
      text,
      style: TextStyle(
        fontSize: _GraphConstants.axisFontSize,
        fontWeight: FontWeight.w500,
        color: colors.textMuted,
      ),
    );
}

/// X-axis labels widget
class _XAxis extends StatelessWidget {

  const _XAxis({
    required this.data,
    required this.colors,
  });
  final List<GraphDataPoint> data;
  final BreezColors colors;

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
