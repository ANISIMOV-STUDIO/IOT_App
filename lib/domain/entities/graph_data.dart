/// Graph Data Entity - Represents data for operation graphs
library;

import 'package:equatable/equatable.dart';

/// Graph metric type
enum GraphMetric { temperature, humidity, airflow }

/// Graph data point for charts
class GraphDataPoint extends Equatable {
  final String label;
  final double value;

  const GraphDataPoint({
    required this.label,
    required this.value,
  });

  GraphDataPoint copyWith({
    String? label,
    double? value,
  }) {
    return GraphDataPoint(
      label: label ?? this.label,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [label, value];
}
