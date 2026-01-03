/// Mock-репозитории для тестирования
library;

import 'package:mocktail/mocktail.dart';

import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/repositories/smart_device_repository.dart';
import 'package:hvac_control/domain/repositories/energy_repository.dart';
import 'package:hvac_control/domain/repositories/notification_repository.dart';
import 'package:hvac_control/domain/repositories/schedule_repository.dart';
import 'package:hvac_control/domain/repositories/graph_data_repository.dart';

/// Mock для ClimateRepository
class MockClimateRepository extends Mock implements ClimateRepository {}

/// Mock для SmartDeviceRepository
class MockSmartDeviceRepository extends Mock implements SmartDeviceRepository {}

/// Mock для EnergyRepository
class MockEnergyRepository extends Mock implements EnergyRepository {}

/// Mock для NotificationRepository
class MockNotificationRepository extends Mock implements NotificationRepository {}

/// Mock для ScheduleRepository
class MockScheduleRepository extends Mock implements ScheduleRepository {}

/// Mock для GraphDataRepository
class MockGraphDataRepository extends Mock implements GraphDataRepository {}
