part of 'devices_bloc.dart';

/// События для DevicesBloc
///
/// Именование по конвенции flutter_bloc:
/// - sealed class для базового события
/// - final class для конкретных событий
/// - Префикс Devices + существительное + прошедшее время
sealed class DevicesEvent extends Equatable {
  const DevicesEvent();

  @override
  List<Object?> get props => [];
}

/// Запрос на подписку к списку устройств (инициализация)
final class DevicesSubscriptionRequested extends DevicesEvent {
  const DevicesSubscriptionRequested();
}

/// Устройство выбрано пользователем
final class DevicesDeviceSelected extends DevicesEvent {
  final String deviceId;

  const DevicesDeviceSelected(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

/// Список устройств обновлён (из стрима)
final class DevicesListUpdated extends DevicesEvent {
  final List<HvacDevice> devices;

  const DevicesListUpdated(this.devices);

  @override
  List<Object?> get props => [devices];
}

/// Запрошена регистрация нового устройства
final class DevicesRegistrationRequested extends DevicesEvent {
  final String macAddress;
  final String name;

  const DevicesRegistrationRequested({
    required this.macAddress,
    required this.name,
  });

  @override
  List<Object?> get props => [macAddress, name];
}

/// Ошибка регистрации очищена
final class DevicesRegistrationErrorCleared extends DevicesEvent {
  const DevicesRegistrationErrorCleared();
}

/// Ошибка операции очищена (удаление, переименование)
final class DevicesOperationErrorCleared extends DevicesEvent {
  const DevicesOperationErrorCleared();
}

/// Запрошено удаление устройства
final class DevicesDeletionRequested extends DevicesEvent {
  final String deviceId;

  const DevicesDeletionRequested(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

/// Запрошено переименование устройства
final class DevicesRenameRequested extends DevicesEvent {
  final String deviceId;
  final String newName;

  const DevicesRenameRequested({
    required this.deviceId,
    required this.newName,
  });

  @override
  List<Object?> get props => [deviceId, newName];
}

/// Запрошено выключение всех устройств (Master Power Off)
final class DevicesMasterPowerOffRequested extends DevicesEvent {
  const DevicesMasterPowerOffRequested();
}

/// Запрошена установка времени на устройстве
final class DevicesTimeSetRequested extends DevicesEvent {
  final String deviceId;
  final DateTime time;

  const DevicesTimeSetRequested({
    required this.deviceId,
    required this.time,
  });

  @override
  List<Object?> get props => [deviceId, time];
}
