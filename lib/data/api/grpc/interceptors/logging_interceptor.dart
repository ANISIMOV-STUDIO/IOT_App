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
  ) async {
    final service = method.path.split('/')[1];
    final methodName = method.path.split('/')[2];

    ApiLogger.logGrpcRequest(service, methodName, request);

    try {
      final response = await invoker(method, request, options);
      ApiLogger.logGrpcResponse(service, methodName, response);
      return response;
    } catch (error) {
      ApiLogger.logGrpcError(service, methodName, error);
      rethrow;
    }
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) async* {
    final service = method.path.split('/')[1];
    final methodName = method.path.split('/')[2];

    ApiLogger.logStreamStart('$service.$methodName');

    try {
      await for (final response in invoker(method, requests, options)) {
        ApiLogger.logStreamData('$service.$methodName', response);
        yield response;
      }
    } catch (error) {
      ApiLogger.logStreamError('$service.$methodName', error);
      rethrow;
    } finally {
      ApiLogger.logStreamClose('$service.$methodName');
    }
  }
}
