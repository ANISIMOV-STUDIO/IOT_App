/// HVAC List Events
library;

import 'package:equatable/equatable.dart';

abstract class HvacListEvent extends Equatable {
  const HvacListEvent();

  @override
  List<Object?> get props => [];
}

/// Load all HVAC units
class LoadHvacUnitsEvent extends HvacListEvent {
  const LoadHvacUnitsEvent();
}

/// Refresh HVAC units
class RefreshHvacUnitsEvent extends HvacListEvent {
  const RefreshHvacUnitsEvent();
}
