/// Schedule Entry Entity - Represents a schedule entry
library;

import 'package:equatable/equatable.dart';

/// Schedule entry data for weekly schedule
class ScheduleEntry extends Equatable {
  final String day;
  final String mode;
  final String timeRange;
  final int tempDay;
  final int tempNight;
  final bool isActive;

  const ScheduleEntry({
    required this.day,
    required this.mode,
    required this.timeRange,
    required this.tempDay,
    required this.tempNight,
    this.isActive = false,
  });

  ScheduleEntry copyWith({
    String? day,
    String? mode,
    String? timeRange,
    int? tempDay,
    int? tempNight,
    bool? isActive,
  }) {
    return ScheduleEntry(
      day: day ?? this.day,
      mode: mode ?? this.mode,
      timeRange: timeRange ?? this.timeRange,
      tempDay: tempDay ?? this.tempDay,
      tempNight: tempNight ?? this.tempNight,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [day, mode, timeRange, tempDay, tempNight, isActive];
}
