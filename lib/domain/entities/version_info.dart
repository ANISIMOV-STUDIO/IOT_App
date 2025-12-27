/// Version information
class VersionInfo {
  final String version;
  final DateTime buildTime;

  const VersionInfo({
    required this.version,
    required this.buildTime,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      version: json['version'] as String,
      buildTime: DateTime.parse(json['buildTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'buildTime': buildTime.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VersionInfo &&
          runtimeType == other.runtimeType &&
          version == other.version;

  @override
  int get hashCode => version.hashCode;
}
