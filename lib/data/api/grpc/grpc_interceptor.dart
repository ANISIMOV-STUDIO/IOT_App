/// gRPC Auth Interceptor
/// Adds authorization header to all gRPC calls
library;

import 'package:grpc/grpc.dart';

/// Interceptor that adds Bearer token to gRPC calls
class AuthGrpcInterceptor extends ClientInterceptor {

  AuthGrpcInterceptor(this._getToken);
  final Future<String?> Function() _getToken;

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) => invoker(
      method,
      request,
      options.mergedWith(_authOptions()),
    );

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) => invoker(
      method,
      requests,
      options.mergedWith(_authOptions()),
    );

  CallOptions _authOptions() => CallOptions(
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
