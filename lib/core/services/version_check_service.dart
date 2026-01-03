import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/api/websocket/signalr_hub_connection.dart';
import '../../domain/entities/version_info.dart';

/// Сервис проверки обновлений приложения
///
/// Использует:
/// - SignalR для real-time уведомлений о новых версиях
/// - Периодический HTTP опрос как резервный механизм
class VersionCheckService {
  final http.Client _client;
  final SignalRHubConnection? _signalR;
  final String _baseUrl;

  VersionInfo? _currentVersion;
  Timer? _fallbackTimer;
  StreamSubscription<Map<String, dynamic>>? _signalRSubscription;
  final _versionChangedController = StreamController<VersionInfo>.broadcast();

  VersionCheckService(this._client, [this._signalR])
      : _baseUrl = const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://hvac.anisimovstudio.ru/api',
        );

  /// Стрим для получения уведомлений о новых версиях
  Stream<VersionInfo> get onVersionChanged => _versionChangedController.stream;

  /// Инициализация сервиса проверки версий
  Future<void> initialize({
    Duration fallbackInterval = const Duration(hours: 1),
  }) async {
    // Загружаем текущую версию
    _currentVersion = await _fetchVersion();

    // Подключаемся к SignalR стриму (если доступен)
    _setupSignalRSubscription();

    // Периодическая проверка (1 раз в час как резервный механизм)
    _fallbackTimer = Timer.periodic(fallbackInterval, (_) => _checkForUpdates());
  }

  /// Подписка на SignalR стрим новых релизов
  void _setupSignalRSubscription() {
    if (_signalR == null) return;

    _signalRSubscription = _signalR.releases.listen((releaseData) {
      try {
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
      } catch (e) {
        // Игнорируем ошибки парсинга
      }
    });
  }

  /// Проверка обновлений по HTTP
  Future<void> _checkForUpdates() async {
    try {
      final newVersion = await _fetchVersion();

      // Если версия изменилась - отправляем событие
      if (_currentVersion != null &&
          newVersion != null &&
          newVersion != _currentVersion) {
        _versionChangedController.add(newVersion);
        _currentVersion = newVersion;
      }
    } catch (e) {
      // Игнорируем ошибки
    }
  }

  /// Получение версии с сервера
  Future<VersionInfo?> _fetchVersion() async {
    try {
      final uri = Uri.parse('$_baseUrl/release/latest');
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
      // Возвращаем null при ошибке
    }
    return null;
  }

  /// Освобождение ресурсов
  void dispose() {
    _fallbackTimer?.cancel();
    _signalRSubscription?.cancel();
    _versionChangedController.close();
  }
}
