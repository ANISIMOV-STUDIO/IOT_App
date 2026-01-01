/// Драйвер для запуска интеграционных тестов
///
/// Используется для запуска E2E тестов на реальных устройствах
/// и в веб-браузере через `flutter drive`
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
