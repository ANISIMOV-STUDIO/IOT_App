/// Domain Use Cases - Barrel export
///
/// Use Cases инкапсулируют бизнес-логику приложения.
/// Presentation layer вызывает Use Cases, а не репозитории напрямую.
library;

// Базовые классы
export 'usecase.dart';

// Auth Use Cases
export 'auth/login.dart';
export 'auth/register.dart';
export 'auth/verify_email.dart';
export 'auth/logout.dart';
export 'auth/check_session.dart';
export 'auth/resend_code.dart';

// Climate Use Cases
export 'climate/get_all_hvac_devices.dart';
export 'climate/get_device_state.dart';
export 'climate/get_current_climate_state.dart';
export 'climate/set_device_power.dart';
export 'climate/set_temperature.dart';
export 'climate/set_humidity.dart';
export 'climate/set_climate_mode.dart';
export 'climate/set_preset.dart';
export 'climate/set_airflow.dart';
export 'climate/watch_current_climate.dart';

// Device Management Use Cases
export 'device/register_device.dart';
export 'device/delete_device.dart';
export 'device/rename_device.dart';
export 'device/get_device_full_state.dart';
export 'device/watch_hvac_devices.dart';

// Analytics Use Cases
export 'analytics/get_today_stats.dart';
export 'analytics/get_device_power_usage.dart';
export 'analytics/watch_energy_stats.dart';
export 'analytics/get_graph_data.dart';
export 'analytics/watch_graph_data.dart';

// Notifications Use Cases
export 'notifications/get_notifications.dart';
export 'notifications/watch_notifications.dart';
export 'notifications/mark_notification_as_read.dart';
export 'notifications/dismiss_notification.dart';
