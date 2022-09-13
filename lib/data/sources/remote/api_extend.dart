part of 'api_client.dart';

// ignore: constant_identifier_names
enum HttpMethods { GET, POST, PUT, DELETE }

class AuthInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final cookieStr = await LocalStorage.cookie.get();
    if (cookieStr != null && cookieStr.isNotEmpty) {
      options.headers['cookie'] = cookieStr;
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final cookies = response.headers['set-cookie'];
    if (cookies != null && cookies.isNotEmpty) {
      final cookieStr = cookies.join();
      await LocalStorage.cookie.set(cookieStr);
    }
    return super.onResponse(response, handler);
  }
}

class LogInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // logger.i(
    //   "onRequest: ${options.uri}\n"
    //   "method=${options.method}\n"
    //   "headers=${options.headers}\n"
    //   "queryParameters=${options.queryParameters}\n"
    //   "body=${options.data}",
    // );
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // logger.i(
    //   "statusCode=${response.statusCode}\n"
    //   "responseBody=${response.data}",
    // );
    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    // logger.e(
    //   "onError: $err\n"
    //   "Response: ${err.response}",
    // );
    super.onError(err, handler);
  }
}
