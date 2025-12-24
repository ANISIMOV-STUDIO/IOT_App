/// Schedule Entry Entity - Represents a schedule entry
library;

import 'package:equatable/equatable.dart';

/// Schedule entry data for weekly schedule
class ScheduleEntry extends Equatable {
  final String id;
  final String deviceId;
  final String day;
  final String mode;
  final String timeRange;
  final int tempDay;
  final int tempNight;
  final bool isActive;

  const ScheduleEntry({
    required this.id,
    required this.deviceId,
    required this.day,
    required this.mode,
    required this.timeRange,
    required this.tempDay,
    required this.tempNight,
    this.isActive = false,
  });

  ScheduleEntry copyWith({
    String? id,
    String? deviceId,
    String? day,
    String? mode,
    String? timeRange,
    int? tempDay,
    int? tempNight,
    bool? isActive,
  }) {
    return ScheduleEntry(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      day: day ?? this.day,
      mode: mode ?? this.mode,
      timeRange: timeRange ?? this.timeRange,
      tempDay: tempDay ?? this.tempDay,
      tempNight: tempNight ?? this.tempNight,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, deviceId, day, mode, timeRange, tempDay, tempNight, isActive];
}
