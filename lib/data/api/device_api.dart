import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/requests/add_device_request.dart';
import '../models/requests/pair_device_request.dart';
import '../models/responses/device_response.dart';
import '../models/responses/scan_response.dart';
import '../models/responses/generic_response.dart';

part 'device_api.g.dart';

@RestApi()
abstract class DeviceApi {
  factory DeviceApi(Dio dio, {String? baseUrl}) = _DeviceApi;

  @GET('/devices')
  Future<List<DeviceResponse>> getDevices();

  @POST('/devices')
  Future<DeviceResponse> addDevice(@Body() AddDeviceRequest request);

  @DELETE('/devices/{id}')
  Future<void> removeDevice(@Path('id') String deviceId);

  @GET('/devices/scan')
  Future<ScanResponse> scanForDevices();

  @POST('/devices/pair')
  Future<GenericResponse> pairDevice(@Body() PairDeviceRequest request);

  @POST('/devices/{id}/reset')
  Future<GenericResponse> factoryReset(@Path('id') String deviceId);

  @POST('/devices/{id}/firmware')
  Future<GenericResponse> updateFirmware(
    @Path('id') String deviceId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/devices/{id}/diagnostics')
  Future<DiagnosticsResponse> getDiagnostics(@Path('id') String deviceId);
}
