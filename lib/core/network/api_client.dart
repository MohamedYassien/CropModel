import 'dart:async';
import 'dart:io';

import 'package:cropmodel/core/constants/app_strings.dart';
import 'package:cropmodel/core/network/API_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../features/Login/data/service/SecureStorage.dart';
import 'API.dart';

class APIClient {
  final Dio dio = Dio();
  final Dio cachingDio = Dio();

  APIClient() {
    _init();
  }

  Future<void> _init() async {
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
    await _setupCacheInterceptor();
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
      final storage = SecureStorage();
      final String token = await storage.getToken();

      final bool isFormData = body is FormData;

      final bool isAbsoluteUrl =
          api.path.startsWith('http://') || api.path.startsWith('https://');

      final String resolvedUrl =
          "${AppStrings.baseUrl}${api.path.startsWith('/') ? '' : '/'}${api.path}"
          "${pathParam != null ? '/$pathParam' : ''}";
      final requestOptions = RequestOptions(
        path: resolvedUrl,
        method: api.method.name.toUpperCase(),
        queryParameters: queryParameters,
        data: body,
        headers: {
          if (headers != null) ...headers,
         if (token.isNotEmpty) 'Authorization': 'Bearer $token',
          if (!isFormData) HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      final response = cache
          ? await cachingDio.fetch(requestOptions)
          : await dio.fetch(requestOptions);

      return mapper(response.data);
    } on DioException catch (e) {
      final data = e.response?.data;

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw APIError(
            message: "Connection timeout, check your internet connection",
          );

        case DioExceptionType.connectionError:
          throw APIError(
            message: "No internet connection",
          );

        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 401 ||
              e.response?.statusCode == 403) {
            throw APIError(
              message: "Unauthorized, please login again",
              code: "401",
            );
          }

          throw APIError(
            message: data?['message'] ?? "Something went wrong",
            code: data?['code']?.toString(),
          );

        default:
          throw APIError(
            message: data?['message'] ?? "Something went wrong",
            code: data?['code']?.toString(),
          );
      }
    }
  }
}