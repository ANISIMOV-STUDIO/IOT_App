/// Platform-aware API client factory
library;

import 'api_client.dart';
import '../../../core/services/auth_storage_service.dart';
import '../../services/auth_service.dart';
// Conditional imports - функция createPlatformApiClient будет из разных файлов
import 'api_client_mobile.dart'
    if (dart.library.html) 'api_client_web.dart';

class ApiClientFactory {
  static ApiClient create(
    AuthStorageService authStorage,
    AuthService authService,
  ) {
    // Использует createPlatformApiClient из conditional import
    return createPlatformApiClient(authStorage, authService);
  }
}
