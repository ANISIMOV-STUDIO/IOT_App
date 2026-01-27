part of 'devices_bloc.dart';

/// Sentinel для различения null от "не передано"
const _sentinel = Object();

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

  const DevicesState({
    this.status = DevicesStatus.initial,
    this.devices = const [],
    this.selectedDeviceId,
    this.errorMessage,
    this.isRegistering = false,
    this.registrationError,
    this.operationError,
    this.isMasterPowerOffInProgress = false,
    this.masterPowerOffSuccess = false,
    this.masterPowerOffError,
    this.togglingPowerDeviceIds = const {},
    this.pendingPowerStates = const {},
  });
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

  /// Ошибка операции (удаление, переименование)
  final String? operationError;

  /// Идёт выключение всех устройств
  final bool isMasterPowerOffInProgress;

  /// Успешное выключение всех устройств
  final bool masterPowerOffSuccess;

  /// Ошибка выключения всех устройств
  final String? masterPowerOffError;

  /// ID устройств, для которых идёт переключение питания
  final Set<String> togglingPowerDeviceIds;

  /// Ожидаемое состояние питания (deviceId → isOn)
  final Map<String, bool> pendingPowerStates;

  /// Получить выбранное устройство
  HvacDevice? get selectedDevice {
    if (selectedDeviceId == null || devices.isEmpty) {
      return null;
    }
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
    Object? selectedDeviceId = _sentinel,
    String? errorMessage,
    bool? isRegistering,
    String? registrationError,
    String? operationError,
    bool? isMasterPowerOffInProgress,
    bool? masterPowerOffSuccess,
    String? masterPowerOffError,
    Set<String>? togglingPowerDeviceIds,
    Map<String, bool>? pendingPowerStates,
  }) =>
      DevicesState(
        status: status ?? this.status,
        devices: devices ?? this.devices,
        selectedDeviceId: selectedDeviceId == _sentinel
            ? this.selectedDeviceId
            : selectedDeviceId as String?,
        errorMessage: errorMessage,
        isRegistering: isRegistering ?? this.isRegistering,
        registrationError: registrationError,
        operationError: operationError,
        isMasterPowerOffInProgress:
            isMasterPowerOffInProgress ?? this.isMasterPowerOffInProgress,
        masterPowerOffSuccess: masterPowerOffSuccess ?? false,
        masterPowerOffError: masterPowerOffError,
        togglingPowerDeviceIds:
            togglingPowerDeviceIds ?? this.togglingPowerDeviceIds,
        pendingPowerStates: pendingPowerStates ?? this.pendingPowerStates,
      );

  @override
  List<Object?> get props => [
        status,
        devices,
        selectedDeviceId,
        errorMessage,
        isRegistering,
        registrationError,
        operationError,
        isMasterPowerOffInProgress,
        masterPowerOffSuccess,
        masterPowerOffError,
        togglingPowerDeviceIds,
        pendingPowerStates,
      ];
}
