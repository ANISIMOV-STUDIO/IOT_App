import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/version_info.dart';

/// Service for checking app version updates
class VersionCheckService {
  final http.Client _client;
  final String _baseUrl;

  VersionInfo? _currentVersion;
  Timer? _checkTimer;
  final _versionChangedController = StreamController<VersionInfo>.broadcast();

  VersionCheckService(this._client)
      : _baseUrl = const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:8080/api',
        );

  /// Stream that emits when a new version is detected
  Stream<VersionInfo> get onVersionChanged => _versionChangedController.stream;

  /// Initialize and start periodic version checking
  Future<void> initialize({
    Duration checkInterval = const Duration(minutes: 5),
  }) async {
    // Load current version
    _currentVersion = await _fetchVersion();

    // Start periodic checking
    _checkTimer = Timer.periodic(checkInterval, (_) => _checkForUpdates());
  }

  /// Check for version updates
  Future<void> _checkForUpdates() async {
    try {
      final newVersion = await _fetchVersion();

      // If version changed, emit event
      if (_currentVersion != null &&
          newVersion != null &&
          newVersion != _currentVersion) {
        _versionChangedController.add(newVersion);
      }
    } catch (e) {
      // Silently ignore errors
    }
  }

  /// Fetch version from server
  Future<VersionInfo?> _fetchVersion() async {
    try {
      final uri = Uri.parse('$_baseUrl/releases/latest');
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        // API возвращает: { version, title, changelog, releaseDate, buildTime }
        return VersionInfo(
          version: json['version'] as String,
          buildTime: DateTime.parse(json['buildTime'] as String),
          changelog: json['changelog'] as String?,
        );
      }
    } catch (e) {
      // Return null on error
    }
    return null;
  }

  /// Dispose resources
  void dispose() {
    _checkTimer?.cancel();
    _versionChangedController.close();
  }
}
