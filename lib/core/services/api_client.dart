import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final String apiKey;
  final Dio dio;

  ApiClient({required this.apiKey}) : dio = Dio() {
    _initDio();
  }

  void _initDio() {
    dio.options
      ..baseUrl = 'https://finnhub.io/api/v1'
      ..queryParameters = {'token': apiKey};

    // if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
    // }
  }
}
