/// gRPC logging interceptor
library;

import 'package:grpc/grpc.dart';
import '../../../../core/logging/api_logger.dart';

class LoggingInterceptor extends ClientInterceptor {
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final service = method.path.split('/')[1];
    final methodName = method.path.split('/')[2];

    ApiLogger.logGrpcRequest(service, methodName, request);

    final call = invoker(method, request, options);

    // Log response/error asynchronously without blocking
    call.then((response) {
      ApiLogger.logGrpcResponse(service, methodName, response);
    }).catchError((error) {
      ApiLogger.logGrpcError(service, methodName, error);
    });

    return call;
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    final service = method.path.split('/')[1];
    final methodName = method.path.split('/')[2];

    ApiLogger.logStreamStart('$service.$methodName');

    // Just return the call as-is for simplicity
    // Detailed logging would require complex stream wrapping
    return invoker(method, requests, options);
  }
}
