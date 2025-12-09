import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/temperature_reading.dart';
import '../../../../domain/repositories/history_repository.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final HistoryRepository repository;

  StatisticsBloc({required this.repository}) : super(StatisticsInitial()) {
    on<LoadStatisticsEvent>(_onLoadStatistics);
  }

  Future<void> _onLoadStatistics(
    LoadStatisticsEvent event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(StatisticsLoading());

    try {
      final now = DateTime.now();
      DateTime start;

      // Calculate timerange based on period
      switch (event.period) {
        case StatsPeriod.day:
          start = now.subtract(const Duration(hours: 24));
          break;
        case StatsPeriod.week:
          start = now.subtract(const Duration(days: 7));
          break;
        case StatsPeriod.month:
          start = now.subtract(const Duration(days: 30));
          break;
        case StatsPeriod.year:
          start = now.subtract(const Duration(days: 365));
          break;
      }

      // Fetch data in parallel
      final results = await Future.wait([
        repository.getTemperatureHistory(event.deviceId, start: start, end: now),
        repository.getEnergyConsumption(event.deviceId, start: start, end: now),
      ]);

      emit(StatisticsLoaded(
        temperatureHistory: results[0] as List<TemperatureReading>,
        energyConsumption: results[1] as List<double>,
        period: event.period,
      ));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}
