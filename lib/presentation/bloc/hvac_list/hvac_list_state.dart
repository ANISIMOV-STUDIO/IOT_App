/// HVAC List States
library;

import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/hvac_unit.dart';

abstract class HvacListState extends Equatable {
  const HvacListState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HvacListInitial extends HvacListState {
  const HvacListInitial();
}

/// Loading state
class HvacListLoading extends HvacListState {
  const HvacListLoading();
}

/// Loaded state with data
class HvacListLoaded extends HvacListState {
  final List<HvacUnit> units;

  const HvacListLoaded(this.units);

  @override
  List<Object?> get props => [units];
}

/// Error state
class HvacListError extends HvacListState {
  final String message;

  const HvacListError(this.message);

  @override
  List<Object?> get props => [message];
}
