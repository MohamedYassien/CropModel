import  'dart:async';
import 'dart:io';

import 'package:cropmodel/core/constants/app_strings.dart';
import 'package:cropmodel/core/network/API_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'API.dart';

class APIClient {
  final dio = Dio();
  final cachingDio = Dio();

  APIClient() {
    if (kDebugMode) {
      if (!dio.interceptors.any((i) => i is PrettyDioLogger)) {
        dio.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            compact: true,
            maxWidth: 90,
          ),
        );
      }
    }

    _setupCacheInterceptor();
  }

  Future<void> _setupCacheInterceptor() async {
    if (kDebugMode &&
        !cachingDio.interceptors.any((i) => i is PrettyDioLogger)) {
      cachingDio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  final logger = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    request: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
  );

  Future<Res?> fetch<Req, Res>({
    required API api,
    Req? body,
    String? pathParam,
    bool? exportCsv,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required Res Function(dynamic) mapper,
    bool cache = false,
    context,
  }) async {
    try {
      final requestOptions = RequestOptions(
        baseUrl:
            "${AppStrings.baseUrl}/${api.path}${pathParam != null ? "/$pathParam" : ""}",
        method: api.method.name,
        queryParameters: queryParameters,
        data: body,
        headers: {
          if (headers != null) ...headers,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      final response = cache
          ? await cachingDio.fetch(requestOptions)
          : await dio.fetch(requestOptions);

      return mapper(response.data);
    } on DioException catch (e) {
      final data = e.response?.data;

      switch (e.type.name) {
        case 'connectionError':
        case 'connectionTimeout':
          throw APIError(message: "Connection timeout, check your connection");

        case 'badResponse':
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            throw APIError(
              message: "Unauthorized, please login again",
              code: "401",
            );
          }

          // Fallback for other errors
          final message = data?['message'] ?? "Something went wrong";
          throw APIError(
            message: message.toString(),
            code: data?['code']?.toString(),
          );

        default:
          throw APIError(message: "Something went wrong, try again", code: "1");
      }
    }
  }
}
