import '../entities/device.dart';

/// Информация об устройстве для сканирования/pairing
class DeviceInfo {
  final String macAddress;
  final String name;
  final String? location;
  final String? model;
  final String? firmware;

  const DeviceInfo({
    required this.macAddress,
    required this.name,
    this.location,
    this.model,
    this.firmware,
  });
}

/// Репозиторий устройств — контракт для работы с устройствами
abstract class DeviceRepository {
  /// Получить все устройства
  Future<List<Device>> getDevices();

  /// Получить устройства по комнате
  Future<List<Device>> getDevicesByRoom(String roomId);

  /// Получить устройство по ID
  Future<Device?> getDevice(String id);

  /// Включить/выключить устройство
  Future<Device> toggleDevice(String id);

  /// Обновить настройки устройства
  Future<Device> updateDevice(String id, Map<String, dynamic> settings);

  /// Стрим изменений устройств (для real-time обновлений)
  Stream<List<Device>> watchDevices();

  /// Стрим одного устройства
  Stream<Device> watchDevice(String id);
}

/// Расширенный репозиторий для HVAC устройств (hardware-специфичный)
abstract class HvacDeviceRepository extends DeviceRepository {
  /// Подключиться к устройствам
  Future<void> connect();

  /// Отключиться
  Future<void> disconnect();

  /// Проверить подключение
  bool isConnected();

  /// Сканировать новые устройства
  Future<List<DeviceInfo>> scanForDevices();

  /// Добавить устройство
  Future<Device> addDevice(DeviceInfo deviceInfo);

  /// Удалить устройство
  Future<bool> removeDevice(String deviceId);

  /// Связать устройство
  Future<bool> pairDevice(String macAddress, String pairingCode);

  /// Сброс к заводским настройкам
  Future<bool> factoryReset(String deviceId);

  /// Обновить прошивку
  Future<bool> updateFirmware(String deviceId, String firmwareVersion);

  /// Получить диагностику
  Future<Map<String, dynamic>> getDeviceDiagnostics(String deviceId);
}
