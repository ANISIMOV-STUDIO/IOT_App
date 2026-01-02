part of 'devices_bloc.dart';

/// Статус загрузки DevicesBloc
enum DevicesStatus {
  /// Начальное состояние
  initial,

  /// Загрузка списка устройств
  loading,

  /// Успешная загрузка
  success,

  /// Ошибка загрузки
  failure,
}

/// Состояние списка HVAC устройств
final class DevicesState extends Equatable {
  /// Статус загрузки
  final DevicesStatus status;

  /// Список HVAC устройств
  final List<HvacDevice> devices;

  /// ID выбранного устройства
  final String? selectedDeviceId;

  /// Сообщение об ошибке
  final String? errorMessage;

  /// Идёт регистрация нового устройства
  final bool isRegistering;

  /// Ошибка регистрации устройства
  final String? registrationError;

  const DevicesState({
    this.status = DevicesStatus.initial,
    this.devices = const [],
    this.selectedDeviceId,
    this.errorMessage,
    this.isRegistering = false,
    this.registrationError,
  });

  /// Получить выбранное устройство
  HvacDevice? get selectedDevice {
    if (selectedDeviceId == null || devices.isEmpty) return null;
    return devices.firstWhere(
      (d) => d.id == selectedDeviceId,
      orElse: () => devices.first,
    );
  }

  /// Проверка наличия устройств
  bool get hasDevices => devices.isNotEmpty;

  /// Количество устройств
  int get deviceCount => devices.length;

  /// Количество устройств онлайн
  int get onlineCount => devices.where((d) => d.isOnline).length;

  DevicesState copyWith({
    DevicesStatus? status,
    List<HvacDevice>? devices,
    String? selectedDeviceId,
    String? errorMessage,
    bool? isRegistering,
    String? registrationError,
  }) {
    return DevicesState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      selectedDeviceId: selectedDeviceId ?? this.selectedDeviceId,
      errorMessage: errorMessage,
      isRegistering: isRegistering ?? this.isRegistering,
      registrationError: registrationError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        devices,
        selectedDeviceId,
        errorMessage,
        isRegistering,
        registrationError,
      ];
}
