// This is a generated file - do not edit.
//
// Generated from energy.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references, do_not_use_environment
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Период агрегации данных
class EnergyPeriod extends $pb.ProtobufEnum {

  const EnergyPeriod._(super.value, super.name);
  static const EnergyPeriod ENERGY_PERIOD_UNSPECIFIED =
      EnergyPeriod._(0, _omitEnumNames ? '' : 'ENERGY_PERIOD_UNSPECIFIED');
  static const EnergyPeriod ENERGY_PERIOD_HOURLY =
      EnergyPeriod._(1, _omitEnumNames ? '' : 'ENERGY_PERIOD_HOURLY');
  static const EnergyPeriod ENERGY_PERIOD_DAILY =
      EnergyPeriod._(2, _omitEnumNames ? '' : 'ENERGY_PERIOD_DAILY');
  static const EnergyPeriod ENERGY_PERIOD_WEEKLY =
      EnergyPeriod._(3, _omitEnumNames ? '' : 'ENERGY_PERIOD_WEEKLY');
  static const EnergyPeriod ENERGY_PERIOD_MONTHLY =
      EnergyPeriod._(4, _omitEnumNames ? '' : 'ENERGY_PERIOD_MONTHLY');

  static const $core.List<EnergyPeriod> values = <EnergyPeriod>[
    ENERGY_PERIOD_UNSPECIFIED,
    ENERGY_PERIOD_HOURLY,
    ENERGY_PERIOD_DAILY,
    ENERGY_PERIOD_WEEKLY,
    ENERGY_PERIOD_MONTHLY,
  ];

  static final $core.List<EnergyPeriod?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static EnergyPeriod? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
