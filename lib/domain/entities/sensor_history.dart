/// Историческая запись показаний датчиков устройства
library;

/// Запись истории сенсоров устройства
class SensorHistory {
  final String id;
  final DateTime timestamp;
  final double? supplyTemperature;
  final double? roomTemperature;
  final double? outdoorTemperature;
  final int? humidity;
  final int? supplyFan;
  final int? exhaustFan;
  final int? power;

  const SensorHistory({
    required this.id,
    required this.timestamp,
    this.supplyTemperature,
    this.roomTemperature,
    this.outdoorTemperature,
    this.humidity,
    this.supplyFan,
    this.exhaustFan,
    this.power,
  });

  /// Получить значение по названию метрики
  double? getValueByMetric(String metric) {
    switch (metric) {
      case 'temperature':
        return roomTemperature;
      case 'supplyTemperature':
        return supplyTemperature;
      case 'outdoorTemperature':
        return outdoorTemperature;
      case 'humidity':
        return humidity?.toDouble();
      case 'airflow':
      case 'supplyFan':
        return supplyFan?.toDouble();
      case 'exhaustFan':
        return exhaustFan?.toDouble();
      case 'power':
        return power?.toDouble();
      default:
        return roomTemperature;
    }
  }

  @override
  String toString() => 'SensorHistory(id: $id, timestamp: $timestamp, '
      'roomTemp: $roomTemperature, humidity: $humidity)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorHistory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
