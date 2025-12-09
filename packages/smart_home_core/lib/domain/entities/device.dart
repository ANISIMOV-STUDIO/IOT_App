import 'package:equatable/equatable.dart';

/// Base class for all smart home devices
abstract class Device extends Equatable {
  final String id;
  final String name;
  final String type;
  
  const Device({
    required this.id,
    required this.name,
    required this.type,
  });

  /// Returns a copy of the device with updated properties
  Device copyWith();
  
  /// Helper to check if device supports a specific trait
  bool supports<T>() => this is T;

  @override
  List<Object?> get props => [id, name, type];
}
