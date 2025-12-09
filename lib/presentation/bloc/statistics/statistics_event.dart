import 'package:equatable/equatable.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object?> get props => [];
}

enum StatsPeriod { day, week, month, year }

class LoadStatisticsEvent extends StatisticsEvent {
  final String deviceId;
  final StatsPeriod period;

  const LoadStatisticsEvent({
    required this.deviceId,
    this.period = StatsPeriod.day,
  });

  @override
  List<Object?> get props => [deviceId, period];
}
