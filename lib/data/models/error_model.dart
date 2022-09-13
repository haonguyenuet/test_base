import 'package:custom_widgets/exceptions/connection_exception.dart';
import 'package:dio/dio.dart';

class ErrorCode {
  static const unknown = -1;
  static const noInternet = 0;
  static const badRequest = 400;
  static const unauthorized = 401;
  static const notFound = 404;
  static const internalServer = 500;
}

class ErrorModel {
  final int code;
  final String message;

  const ErrorModel._({this.code = ErrorCode.unknown, this.message = ""});
  const ErrorModel.empty() : this._();

  const ErrorModel.unknown() : this._(message: "Unexpected error occured");

  const ErrorModel.requestCancelled()
      : this._(message: "Request to API server was cancelled");

  const ErrorModel.requestTimeout()
      : this._(message: "Request timeout with API server");

  const ErrorModel.receiveTimeout()
      : this._(message: "Receive timeout with API server");

  const ErrorModel.sendTimeout()
      : this._(message: "Send timeout with API server");

  const ErrorModel.noInternet()
      : this._(code: ErrorCode.noInternet, message: "No Internet");

  const ErrorModel.badRequest({String? message})
      : this._(code: ErrorCode.badRequest, message: message ?? "Bad Request");

  const ErrorModel.unauthorized({String? message})
      : this._(code: ErrorCode.unauthorized, message: message ?? "Unauthorized");

  const ErrorModel.notFound({String? message})
      : this._(code: ErrorCode.notFound, message: message ?? "Not Found");

  const ErrorModel.internalServer({String? message})
      : this._(code: ErrorCode.internalServer, message: message ?? "Internal Server");

  factory ErrorModel.parseException(Exception exception) {
    ErrorModel errorEntity = const ErrorModel.unknown();

    if (exception is ConnectionException) {
      errorEntity = const ErrorModel.noInternet();
    } else if (exception is DioError) {
      switch (exception.type) {
        case DioErrorType.cancel:
          errorEntity = const ErrorModel.requestCancelled();
          break;
        case DioErrorType.connectTimeout:
          errorEntity = const ErrorModel.requestTimeout();
          break;
        case DioErrorType.other:
          errorEntity = const ErrorModel.unknown();
          break;
        case DioErrorType.receiveTimeout:
          errorEntity = const ErrorModel.receiveTimeout();
          break;
        case DioErrorType.response:
          errorEntity = ErrorModel.handleResponse(exception.response);
          break;
        case DioErrorType.sendTimeout:
          errorEntity = const ErrorModel.sendTimeout();
          break;
      }
    }
    return errorEntity;
  }

  factory ErrorModel.handleResponse(Response? response) {
    final statusCode = response?.statusCode ?? ErrorCode.unknown;
    final data = response?.data;

    String? message;
    if (response?.data is Map && data.containsKey("message")) {
      message = data["message"];
    }

    switch (statusCode) {
      case ErrorCode.badRequest:
        return ErrorModel.badRequest(message: message);
      case ErrorCode.unauthorized:
        return ErrorModel.unauthorized(message: message);
      case ErrorCode.notFound:
        return ErrorModel.notFound(message: message);
      case ErrorCode.internalServer:
        return ErrorModel.internalServer(message: message);
      default:
        return const ErrorModel.unknown();
    }
  }
}