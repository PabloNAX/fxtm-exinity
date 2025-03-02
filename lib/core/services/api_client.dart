// lib/core/services/api_client.dart

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'connectivity_service.dart';

/// Client for making API requests with Dio, including connectivity checks.
class ApiClient {
  final String apiKey;
  final Dio dio;
  final ConnectivityService _connectivityService;

  ApiClient({
    required this.apiKey,
    required ConnectivityService connectivityService,
  })  : dio = Dio(),
        _connectivityService = connectivityService {
    _initDio();
  }

  void _initDio() {
    dio.options
      ..baseUrl = 'https://finnhub.io/api/v1'
      ..queryParameters = {'token': apiKey}
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 10)
      ..sendTimeout = const Duration(seconds: 10);

    // Logger for API requests
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    // Interceptor for checking connectivity
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check connectivity before each request
          final hasConnection = await _connectivityService.hasConnection();
          if (!hasConnection) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: 'No internet connection',
              ),
            );
          }
          return handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          print('API Error: ${error.type} - ${error.message}');
          return handler.reject(error);
        },
      ),
    );
  }
}
