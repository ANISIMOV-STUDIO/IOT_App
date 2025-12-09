import 'package:equatable/equatable.dart';
import '../../../../domain/entities/temperature_reading.dart';
import 'statistics_event.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final List<TemperatureReading> temperatureHistory;
  final List<double> energyConsumption;
  final StatsPeriod period;

  const StatisticsLoaded({
    required this.temperatureHistory,
    required this.energyConsumption,
    required this.period,
  });

  @override
  List<Object?> get props => [temperatureHistory, energyConsumption, period];
}

class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}
