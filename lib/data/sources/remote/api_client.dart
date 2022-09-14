import 'dart:io';

import 'package:custom_widgets/data/sources/local/storage/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

part './api_extend.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "localhost:1337/api/v1",
        receiveTimeout: 2000,
        connectTimeout: 2000,
        contentType: "application/json",
      ),
    );
    _mockResponseData(_dio);
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LogInterceptor());
  }

  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async =>
      _request(
        method: HttpMethods.GET,
        path: path,
        queryParams: queryParams,
        headers: headers,
      );

  Future<dynamic> post({
    required String path,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    dynamic body,
  }) async =>
      _request(
        method: HttpMethods.POST,
        path: path,
        queryParams: queryParams,
        headers: headers,
        body: body,
      );

  Future<dynamic> put({
    required String path,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    dynamic body,
  }) async =>
      _request(
        method: HttpMethods.PUT,
        path: path,
        queryParams: queryParams,
        headers: headers,
        body: body,
      );

  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    dynamic body,
  }) async =>
      _request(
        method: HttpMethods.DELETE,
        path: path,
        queryParams: queryParams,
        headers: headers,
        body: body,
      );

  Future<dynamic> _request({
    required HttpMethods method,
    required String path,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    dynamic body,
  }) async {
    // Check connection
    // final hasConnection = await ConnectionUtil.isNetworkAvailable();
    // if (!hasConnection) {
    //   throw ConnectionException();
    // }

    var response = await _dio.request(
      path,
      queryParameters: queryParams,
      data: body,
      options: Options(
        method: method.name,
        headers: headers,
      ),
    );

    return response.data;
  }

  void _mockResponseData(Dio dio) {
    final dioAdapter = DioAdapter(dio: dio);
    dioAdapter.onGet(
      "/products",
      (server) => {
        server.reply(
          HttpStatus.ok,
          {
            "status": true,
            "data": [
              {
                "id": 1,
                "desc": "product1",
                "isAvailable": false,
                "price": 100.0,
                "types": []
              },
              {
                "id": 2,
                "desc": "product2",
                "isAvailable": false,
                "price": 100.0,
                "types": []
              },
              {
                "id": 3,
                "desc": "product3",
                "isAvailable": false,
                "price": 100.0,
                "types": []
              }
            ],
            "pagination": {
              "page": 0,
              "pageSize": 10,
              "pageCount": 1,
              "total": 3,
            },
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 2),
        )
      },
      data: Matchers.any,
    );
    dioAdapter.onGet(
      "/products/1",
      (server) => {
        server.reply(
          HttpStatus.ok,
          {
            "status": true,
            "data": {
              "id": 1,
              "desc": "product1",
              "isAvailable": false,
              "price": 100.0,
              "types": []
            }
          },
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 10),
        )
      },
      data: Matchers.any,
    );
  }
}
