/// gRPC authentication interceptor
library;

import 'package:grpc/grpc.dart';
import '../../platform/api_client.dart';

class AuthInterceptor extends ClientInterceptor {
  // ignore: unused_field
  final ApiClient _apiClient;

  AuthInterceptor(this._apiClient);

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    // Get token synchronously if possible, otherwise use empty metadata
    // Note: This is a limitation of the current implementation
    // For proper async token retrieval, consider using a different approach
    final metadata = <String, String>{
      ...options.metadata,
      // Token will be added by HTTP interceptor instead
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
  ) {
    // Same approach as unary
    final metadata = <String, String>{
      ...options.metadata,
    };

    final newOptions = options.mergedWith(
      CallOptions(metadata: metadata),
    );

    return invoker(method, requests, newOptions);
  }
}
