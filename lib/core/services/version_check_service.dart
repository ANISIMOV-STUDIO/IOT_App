import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/version_info.dart';

/// Service for checking app version updates
class VersionCheckService {
  VersionInfo? _currentVersion;
  Timer? _checkTimer;
  final _versionChangedController = StreamController<VersionInfo>.broadcast();

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
      // Add cache-busting parameter
      final uri = Uri.parse('/version.json?t=${DateTime.now().millisecondsSinceEpoch}');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return VersionInfo.fromJson(json);
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
