import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:signalr_netcore/signalr_client.dart';
import '../../domain/entities/version_info.dart';

/// Service for checking app version updates
class VersionCheckService {
  final http.Client _client;
  final String _baseUrl;

  HubConnection? _hubConnection;
  VersionInfo? _currentVersion;
  Timer? _fallbackTimer;
  final _versionChangedController = StreamController<VersionInfo>.broadcast();

  VersionCheckService(this._client)
      : _baseUrl = const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:8080/api',
        );

  /// Stream that emits when a new version is detected
  Stream<VersionInfo> get onVersionChanged => _versionChangedController.stream;

  /// Initialize and start real-time version checking
  Future<void> initialize({
    Duration fallbackInterval = const Duration(hours: 1),
  }) async {
    // Load current version
    _currentVersion = await _fetchVersion();

    // Connect to SignalR hub
    await _connectToHub();

    // Start fallback periodic checking (1 раз в час как резервный механизм)
    _fallbackTimer = Timer.periodic(fallbackInterval, (_) => _checkForUpdates());
  }

  /// Connect to SignalR hub for real-time updates
  Future<void> _connectToHub() async {
    try {
      // Извлекаем base URL без /api
      final hubUrl = _baseUrl.replaceAll('/api', '');

      _hubConnection = HubConnectionBuilder()
          .withUrl('$hubUrl/hubs/devices')
          .withAutomaticReconnect()
          .build();

      // Слушаем событие о новом релизе
      _hubConnection!.on('NewReleaseAvailable', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final releaseData = arguments[0] as Map<String, dynamic>;
          final newVersion = VersionInfo(
            version: releaseData['version'] as String,
            buildTime: DateTime.parse(releaseData['buildTime'] as String),
            changelog: releaseData['changelog'] as String?,
          );

          // Проверяем что версия действительно новая
          if (_currentVersion == null || newVersion != _currentVersion) {
            _versionChangedController.add(newVersion);
            _currentVersion = newVersion;
          }
        }
      });

      await _hubConnection!.start();
    } catch (e) {
      // Silently handle SignalR connection errors - fallback timer will work
    }
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
    _fallbackTimer?.cancel();
    _hubConnection?.stop();
    _versionChangedController.close();
  }
}
