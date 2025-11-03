/// Schedule data model
///
/// Represents a single schedule configuration for HVAC control
library;

class Schedule {
  final String id;
  final String name;
  final String time;
  final List<String> days;
  final double temperature;
  final String mode;
  bool isActive;

  Schedule({
    required this.id,
    required this.name,
    required this.time,
    required this.days,
    required this.temperature,
    required this.mode,
    required this.isActive,
  });

  /// Creates a copy of the schedule with optional parameter updates
  Schedule copyWith({
    String? id,
    String? name,
    String? time,
    List<String>? days,
    double? temperature,
    String? mode,
    bool? isActive,
  }) {
    return Schedule(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      days: days ?? this.days,
      temperature: temperature ?? this.temperature,
      mode: mode ?? this.mode,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Generates semantic label for accessibility
  String get semanticLabel {
    final status = isActive ? 'active' : 'inactive';
    return 'Schedule $name, $time, ${days.join(', ')}, '
        '$temperature degrees Celsius, $mode mode, currently $status';
  }
}