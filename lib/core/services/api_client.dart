// lib/core/services/api_client.dart

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../exceptions/forex_exception.dart';
import 'connectivity_service.dart';

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
      ..queryParameters = {'token': apiKey};

    // Logger для API-запросов
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    // Интерцептор для проверки подключения
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Проверяем подключение перед каждым запросом
          final hasConnection = await _connectivityService.hasConnection();
          if (!hasConnection) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: 'Нет подключения к интернету',
              ),
            );
          }
          return handler.next(options);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) {
          // Преобразуем DioException в ForexException
          final forexException = _handleDioError(e);
          throw forexException; // Выбрасываем ForexException
        },
      ),
    );
  }

  // Преобразует DioException в ForexException
  ForexException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ForexException.fromType(ErrorType.timeout, e);
      case DioExceptionType.connectionError:
        return ForexException.fromType(ErrorType.network, e);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == null) {
          return ForexException.fromType(ErrorType.unknown, e);
        }

        if (statusCode >= 500) {
          return ForexException.fromType(ErrorType.server, e);
        } else if (statusCode == 401 || statusCode == 403) {
          return ForexException.fromType(ErrorType.auth, e);
        } else if (statusCode == 404) {
          return ForexException.fromType(ErrorType.notFound, e);
        } else if (statusCode == 429) {
          return ForexException.fromType(ErrorType.rateLimit, e);
        } else {
          return ForexException.fromType(ErrorType.unknown, e);
        }
      default:
        return ForexException.fromType(ErrorType.unknown, e);
    }
  }
}
