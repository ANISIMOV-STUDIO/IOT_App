/// Graph Data Entity - Represents data for operation graphs
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Graph metric type
enum GraphMetric { temperature, humidity, airflow }

/// Graph data point for charts
class GraphDataPoint extends Equatable {

  const GraphDataPoint({
    required this.label,
    required this.value,
  });
  final String label;
  final double value;

  GraphDataPoint copyWith({
    String? label,
    double? value,
  }) => GraphDataPoint(
      label: label ?? this.label,
      value: value ?? this.value,
    );

  @override
  List<Object?> get props => [label, value];
}

/// Graph series for multi-line charts
///
/// Represents a single data series with its own color and visibility state.
class GraphSeries extends Equatable {

  const GraphSeries({
    required this.id,
    required this.metric,
    required this.color,
    required this.data,
    this.label,
    this.isVisible = true,
  });

  /// Unique identifier for this series
  final String id;

  /// Metric type this series represents
  final GraphMetric metric;

  /// Color for this series line
  final Color color;

  /// Data points for this series
  final List<GraphDataPoint> data;

  /// Optional display label (defaults to metric name)
  final String? label;

  /// Whether this series is currently visible
  final bool isVisible;

  GraphSeries copyWith({
    String? id,
    GraphMetric? metric,
    Color? color,
    List<GraphDataPoint>? data,
    String? label,
    bool? isVisible,
  }) => GraphSeries(
      id: id ?? this.id,
      metric: metric ?? this.metric,
      color: color ?? this.color,
      data: data ?? this.data,
      label: label ?? this.label,
      isVisible: isVisible ?? this.isVisible,
    );

  @override
  List<Object?> get props => [id, metric, color, data, label, isVisible];
}
