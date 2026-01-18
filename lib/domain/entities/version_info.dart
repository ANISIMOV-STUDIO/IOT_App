import 'package:meta/meta.dart';

/// Version information
@immutable
class VersionInfo {

  const VersionInfo({
    required this.version,
    required this.buildTime,
    this.changelog,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) => VersionInfo(
        version: json['version'] as String? ?? '0.0.0',
        buildTime: DateTime.tryParse(json['buildTime'] as String? ?? '') ?? DateTime.now(),
        changelog: json['changelog'] as String?,
      );
  final String version;
  final DateTime buildTime;
  final String? changelog;

  Map<String, dynamic> toJson() => {
        'version': version,
        'buildTime': buildTime.toIso8601String(),
        if (changelog != null) 'changelog': changelog,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VersionInfo &&
          runtimeType == other.runtimeType &&
          version == other.version;

  @override
  int get hashCode => version.hashCode;
}
