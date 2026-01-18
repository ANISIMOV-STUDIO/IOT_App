// This is a generated file - do not edit.
//
// Generated from common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references, do_not_use_environment
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Режим работы HVAC системы
class OperationMode extends $pb.ProtobufEnum {

  const OperationMode._(super.value, super.name);
  static const OperationMode OPERATION_MODE_UNSPECIFIED =
      OperationMode._(0, _omitEnumNames ? '' : 'OPERATION_MODE_UNSPECIFIED');
  static const OperationMode OPERATION_MODE_AUTO =
      OperationMode._(1, _omitEnumNames ? '' : 'OPERATION_MODE_AUTO');
  static const OperationMode OPERATION_MODE_HEAT =
      OperationMode._(2, _omitEnumNames ? '' : 'OPERATION_MODE_HEAT');
  static const OperationMode OPERATION_MODE_COOL =
      OperationMode._(3, _omitEnumNames ? '' : 'OPERATION_MODE_COOL');
  static const OperationMode OPERATION_MODE_FAN_ONLY =
      OperationMode._(4, _omitEnumNames ? '' : 'OPERATION_MODE_FAN_ONLY');

  static const $core.List<OperationMode> values = <OperationMode>[
    OPERATION_MODE_UNSPECIFIED,
    OPERATION_MODE_AUTO,
    OPERATION_MODE_HEAT,
    OPERATION_MODE_COOL,
    OPERATION_MODE_FAN_ONLY,
  ];

  static final $core.List<OperationMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static OperationMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];
}

/// Скорость вентилятора
class FanSpeed extends $pb.ProtobufEnum {

  const FanSpeed._(super.value, super.name);
  static const FanSpeed FAN_SPEED_UNSPECIFIED =
      FanSpeed._(0, _omitEnumNames ? '' : 'FAN_SPEED_UNSPECIFIED');
  static const FanSpeed FAN_SPEED_LOW =
      FanSpeed._(1, _omitEnumNames ? '' : 'FAN_SPEED_LOW');
  static const FanSpeed FAN_SPEED_MEDIUM =
      FanSpeed._(2, _omitEnumNames ? '' : 'FAN_SPEED_MEDIUM');
  static const FanSpeed FAN_SPEED_HIGH =
      FanSpeed._(3, _omitEnumNames ? '' : 'FAN_SPEED_HIGH');
  static const FanSpeed FAN_SPEED_AUTO =
      FanSpeed._(4, _omitEnumNames ? '' : 'FAN_SPEED_AUTO');

  static const $core.List<FanSpeed> values = <FanSpeed>[
    FAN_SPEED_UNSPECIFIED,
    FAN_SPEED_LOW,
    FAN_SPEED_MEDIUM,
    FAN_SPEED_HIGH,
    FAN_SPEED_AUTO,
  ];

  static final $core.List<FanSpeed?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static FanSpeed? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];
}

/// Статус устройства
class DeviceStatus extends $pb.ProtobufEnum {

  const DeviceStatus._(super.value, super.name);
  static const DeviceStatus DEVICE_STATUS_UNSPECIFIED =
      DeviceStatus._(0, _omitEnumNames ? '' : 'DEVICE_STATUS_UNSPECIFIED');
  static const DeviceStatus DEVICE_STATUS_ONLINE =
      DeviceStatus._(1, _omitEnumNames ? '' : 'DEVICE_STATUS_ONLINE');
  static const DeviceStatus DEVICE_STATUS_OFFLINE =
      DeviceStatus._(2, _omitEnumNames ? '' : 'DEVICE_STATUS_OFFLINE');
  static const DeviceStatus DEVICE_STATUS_ERROR =
      DeviceStatus._(3, _omitEnumNames ? '' : 'DEVICE_STATUS_ERROR');
  static const DeviceStatus DEVICE_STATUS_MAINTENANCE =
      DeviceStatus._(4, _omitEnumNames ? '' : 'DEVICE_STATUS_MAINTENANCE');

  static const $core.List<DeviceStatus> values = <DeviceStatus>[
    DEVICE_STATUS_UNSPECIFIED,
    DEVICE_STATUS_ONLINE,
    DEVICE_STATUS_OFFLINE,
    DEVICE_STATUS_ERROR,
    DEVICE_STATUS_MAINTENANCE,
  ];

  static final $core.List<DeviceStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DeviceStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];
}

/// Тип оповещения
class AlertType extends $pb.ProtobufEnum {

  const AlertType._(super.value, super.name);
  static const AlertType ALERT_TYPE_UNSPECIFIED =
      AlertType._(0, _omitEnumNames ? '' : 'ALERT_TYPE_UNSPECIFIED');
  static const AlertType ALERT_TYPE_FILTER_REPLACEMENT =
      AlertType._(1, _omitEnumNames ? '' : 'ALERT_TYPE_FILTER_REPLACEMENT');
  static const AlertType ALERT_TYPE_MAINTENANCE_REQUIRED =
      AlertType._(2, _omitEnumNames ? '' : 'ALERT_TYPE_MAINTENANCE_REQUIRED');
  static const AlertType ALERT_TYPE_HIGH_TEMPERATURE =
      AlertType._(3, _omitEnumNames ? '' : 'ALERT_TYPE_HIGH_TEMPERATURE');
  static const AlertType ALERT_TYPE_LOW_TEMPERATURE =
      AlertType._(4, _omitEnumNames ? '' : 'ALERT_TYPE_LOW_TEMPERATURE');
  static const AlertType ALERT_TYPE_HIGH_HUMIDITY =
      AlertType._(5, _omitEnumNames ? '' : 'ALERT_TYPE_HIGH_HUMIDITY');
  static const AlertType ALERT_TYPE_HIGH_CO2 =
      AlertType._(6, _omitEnumNames ? '' : 'ALERT_TYPE_HIGH_CO2');
  static const AlertType ALERT_TYPE_SYSTEM_ERROR =
      AlertType._(7, _omitEnumNames ? '' : 'ALERT_TYPE_SYSTEM_ERROR');

  static const $core.List<AlertType> values = <AlertType>[
    ALERT_TYPE_UNSPECIFIED,
    ALERT_TYPE_FILTER_REPLACEMENT,
    ALERT_TYPE_MAINTENANCE_REQUIRED,
    ALERT_TYPE_HIGH_TEMPERATURE,
    ALERT_TYPE_LOW_TEMPERATURE,
    ALERT_TYPE_HIGH_HUMIDITY,
    ALERT_TYPE_HIGH_CO2,
    ALERT_TYPE_SYSTEM_ERROR,
  ];

  static final $core.List<AlertType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static AlertType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];
}

/// Тип уведомления
class NotificationType extends $pb.ProtobufEnum {

  const NotificationType._(super.value, super.name);
  static const NotificationType NOTIFICATION_TYPE_UNSPECIFIED =
      NotificationType._(
          0, _omitEnumNames ? '' : 'NOTIFICATION_TYPE_UNSPECIFIED',);
  static const NotificationType NOTIFICATION_TYPE_INFO =
      NotificationType._(1, _omitEnumNames ? '' : 'NOTIFICATION_TYPE_INFO');
  static const NotificationType NOTIFICATION_TYPE_WARNING =
      NotificationType._(2, _omitEnumNames ? '' : 'NOTIFICATION_TYPE_WARNING');
  static const NotificationType NOTIFICATION_TYPE_ERROR =
      NotificationType._(3, _omitEnumNames ? '' : 'NOTIFICATION_TYPE_ERROR');

  static const $core.List<NotificationType> values = <NotificationType>[
    NOTIFICATION_TYPE_UNSPECIFIED,
    NOTIFICATION_TYPE_INFO,
    NOTIFICATION_TYPE_WARNING,
    NOTIFICATION_TYPE_ERROR,
  ];

  static final $core.List<NotificationType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static NotificationType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];
}

/// Метрика для графика
class GraphMetric extends $pb.ProtobufEnum {

  const GraphMetric._(super.value, super.name);
  static const GraphMetric GRAPH_METRIC_UNSPECIFIED =
      GraphMetric._(0, _omitEnumNames ? '' : 'GRAPH_METRIC_UNSPECIFIED');
  static const GraphMetric GRAPH_METRIC_TEMPERATURE =
      GraphMetric._(1, _omitEnumNames ? '' : 'GRAPH_METRIC_TEMPERATURE');
  static const GraphMetric GRAPH_METRIC_HUMIDITY =
      GraphMetric._(2, _omitEnumNames ? '' : 'GRAPH_METRIC_HUMIDITY');
  static const GraphMetric GRAPH_METRIC_AIRFLOW =
      GraphMetric._(3, _omitEnumNames ? '' : 'GRAPH_METRIC_AIRFLOW');
  static const GraphMetric GRAPH_METRIC_ENERGY =
      GraphMetric._(4, _omitEnumNames ? '' : 'GRAPH_METRIC_ENERGY');
  static const GraphMetric GRAPH_METRIC_CO2 =
      GraphMetric._(5, _omitEnumNames ? '' : 'GRAPH_METRIC_CO2');

  static const $core.List<GraphMetric> values = <GraphMetric>[
    GRAPH_METRIC_UNSPECIFIED,
    GRAPH_METRIC_TEMPERATURE,
    GRAPH_METRIC_HUMIDITY,
    GRAPH_METRIC_AIRFLOW,
    GRAPH_METRIC_ENERGY,
    GRAPH_METRIC_CO2,
  ];

  static final $core.List<GraphMetric?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static GraphMetric? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];
}

/// Качество воздуха
class AirQuality extends $pb.ProtobufEnum {

  const AirQuality._(super.value, super.name);
  static const AirQuality AIR_QUALITY_UNSPECIFIED =
      AirQuality._(0, _omitEnumNames ? '' : 'AIR_QUALITY_UNSPECIFIED');
  static const AirQuality AIR_QUALITY_EXCELLENT =
      AirQuality._(1, _omitEnumNames ? '' : 'AIR_QUALITY_EXCELLENT');
  static const AirQuality AIR_QUALITY_GOOD =
      AirQuality._(2, _omitEnumNames ? '' : 'AIR_QUALITY_GOOD');
  static const AirQuality AIR_QUALITY_FAIR =
      AirQuality._(3, _omitEnumNames ? '' : 'AIR_QUALITY_FAIR');
  static const AirQuality AIR_QUALITY_POOR =
      AirQuality._(4, _omitEnumNames ? '' : 'AIR_QUALITY_POOR');

  static const $core.List<AirQuality> values = <AirQuality>[
    AIR_QUALITY_UNSPECIFIED,
    AIR_QUALITY_EXCELLENT,
    AIR_QUALITY_GOOD,
    AIR_QUALITY_FAIR,
    AIR_QUALITY_POOR,
  ];

  static final $core.List<AirQuality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AirQuality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
