/// gRPC Auth Interceptor
/// Adds authorization header to all gRPC calls
library;

import 'package:grpc/grpc.dart';

/// Interceptor that adds Bearer token to gRPC calls
class AuthGrpcInterceptor extends ClientInterceptor {
  final Future<String?> Function() _getToken;

  AuthGrpcInterceptor(this._getToken);

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    return invoker(
      method,
      request,
      options.mergedWith(_authOptions()),
    );
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    return invoker(
      method,
      requests,
      options.mergedWith(_authOptions()),
    );
  }

  CallOptions _authOptions() {
    return CallOptions(
      providers: [
        (metadata, uri) async {
          final token = await _getToken();
          if (token != null) {
            metadata['authorization'] = 'Bearer $token';
          }
        },
      ],
    );
  }
}
