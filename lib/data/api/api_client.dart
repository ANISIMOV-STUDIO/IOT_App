import 'package:dio/dio.dart';
import 'auth_api.dart';
import 'device_api.dart';

/// Centralized API client factory
class ApiClient {
  final Dio _dio;

  late final AuthApi authApi;
  late final DeviceApi deviceApi;

  ApiClient(this._dio) {
    authApi = AuthApi(_dio);
    deviceApi = DeviceApi(_dio);
  }
}
