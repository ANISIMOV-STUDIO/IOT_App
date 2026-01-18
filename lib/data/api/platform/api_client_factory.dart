/// Platform-aware API client factory
library;

import 'package:hvac_control/core/services/auth_storage_service.dart';
import 'package:hvac_control/data/api/platform/api_client.dart';
// Conditional imports - функция createPlatformApiClient будет из разных файлов
import 'package:hvac_control/data/api/platform/api_client_mobile.dart'
    if (dart.library.html) 'api_client_web.dart';
import 'package:hvac_control/data/services/auth_service.dart';

class ApiClientFactory {
  static ApiClient create(
    AuthStorageService authStorage,
    AuthService authService,
  ) =>
      // Использует createPlatformApiClient из conditional import
      createPlatformApiClient(authStorage, authService);
}
