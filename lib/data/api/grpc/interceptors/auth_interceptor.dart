/// gRPC authentication interceptor
library;

import 'package:grpc/grpc.dart';
import '../../platform/api_client.dart';

class AuthInterceptor extends ClientInterceptor {
  final ApiClient _apiClient;

  AuthInterceptor(this._apiClient);

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) async {
    final token = await _apiClient.getAuthToken();

    final metadata = <String, String>{
      ...options.metadata ?? {},
      if (token != null) 'authorization': 'Bearer $token',
    };

    final newOptions = options.mergedWith(
      CallOptions(metadata: metadata),
    );

    return invoker(method, request, newOptions);
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) async* {
    final token = await _apiClient.getAuthToken();

    final metadata = <String, String>{
      ...options.metadata ?? {},
      if (token != null) 'authorization': 'Bearer $token',
    };

    final newOptions = options.mergedWith(
      CallOptions(metadata: metadata),
    );

    yield* invoker(method, requests, newOptions);
  }
}
