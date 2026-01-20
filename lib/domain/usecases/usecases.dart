/// Domain Use Cases - Barrel export
///
/// Use Cases инкапсулируют бизнес-логику приложения.
/// Presentation layer вызывает Use Cases, а не репозитории напрямую.
library;

export 'analytics/get_device_power_usage.dart';
export 'analytics/get_graph_data.dart';
// Analytics Use Cases
export 'analytics/get_today_stats.dart';
export 'analytics/watch_energy_stats.dart';
export 'analytics/watch_graph_data.dart';
export 'auth/check_session.dart';
// Auth Use Cases
export 'auth/login.dart';
export 'auth/logout.dart';
export 'auth/register.dart';
export 'auth/resend_code.dart';
export 'auth/verify_email.dart';
// Climate Use Cases
export 'climate/get_all_hvac_devices.dart';
export 'climate/get_current_climate_state.dart';
export 'climate/get_device_state.dart';
export 'climate/set_airflow.dart';
export 'climate/set_climate_mode.dart';
export 'climate/set_cooling_temperature.dart';
export 'climate/set_device_power.dart';
export 'climate/set_humidity.dart';
export 'climate/set_mode_settings.dart';
export 'climate/set_operating_mode.dart';
export 'climate/set_preset.dart';
export 'climate/set_quick_mode.dart';
export 'climate/set_schedule_enabled.dart';
export 'climate/set_temperature.dart';
export 'climate/watch_current_climate.dart';
export 'device/delete_device.dart';
export 'device/get_alarm_history.dart';
export 'device/get_device_full_state.dart';
// Device Management Use Cases
export 'device/register_device.dart';
export 'device/rename_device.dart';
export 'device/request_device_update.dart';
export 'device/reset_alarm.dart';
export 'device/set_device_time.dart';
export 'device/watch_device_full_state.dart';
export 'device/watch_hvac_devices.dart';
export 'notifications/dismiss_notification.dart';
// Notifications Use Cases
export 'notifications/get_notifications.dart';
export 'notifications/mark_notification_as_read.dart';
export 'notifications/watch_notifications.dart';
// Базовые классы
export 'usecase.dart';
