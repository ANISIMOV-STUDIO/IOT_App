/// Репозиторий умных устройств
library;

import 'package:hvac_control/domain/entities/smart_device.dart';

abstract class SmartDeviceRepository {
  /// Получить все устройства
  Future<List<SmartDevice>> getAllDevices();

  /// Получить устройства по комнате
  Future<List<SmartDevice>> getDevicesByRoom(String roomId);

  /// Получить устройство по ID
  Future<SmartDevice?> getDeviceById(String id);

  /// Включить/выключить устройство
  Future<SmartDevice> toggleDevice(String id, {required bool isOn});

  /// Обновить устройство
  Future<SmartDevice> updateDevice(SmartDevice device);

  /// Стрим обновлений устройств
  Stream<List<SmartDevice>> watchDevices();
}
