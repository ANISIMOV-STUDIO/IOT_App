/// HVAC Detail States
library;

import 'package:equatable/equatable.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/temperature_reading.dart';

abstract class HvacDetailState extends Equatable {
  const HvacDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HvacDetailInitial extends HvacDetailState {
  const HvacDetailInitial();
}

/// Loading state
class HvacDetailLoading extends HvacDetailState {
  const HvacDetailLoading();
}

/// Loaded state
class HvacDetailLoaded extends HvacDetailState {
  final HvacUnit unit;
  final List<TemperatureReading> history;
  final bool isUpdating;

  const HvacDetailLoaded({
    required this.unit,
    this.history = const [],
    this.isUpdating = false,
  });

  HvacDetailLoaded copyWith({
    HvacUnit? unit,
    List<TemperatureReading>? history,
    bool? isUpdating,
  }) {
    return HvacDetailLoaded(
      unit: unit ?? this.unit,
      history: history ?? this.history,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [unit, history, isUpdating];
}

/// Error state
class HvacDetailError extends HvacDetailState {
  final String message;

  const HvacDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
