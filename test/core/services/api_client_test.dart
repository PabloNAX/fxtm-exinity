import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:fxtm/core/services/api_client.dart';

void main() {
  group('ApiClient', () {
    late ApiClient apiClient;
    const String testApiKey = 'test_api_key';

    setUp(() {
      apiClient = ApiClient(apiKey: testApiKey, connectivityService: null);
    });

    test('should initialize Dio with correct base URL', () {
      // Проверяем, что базовый URL настроен правильно
      expect(apiClient.dio.options.baseUrl, 'https://finnhub.io/api/v1');
    });

    test('should add API key to query parameters', () {
      // Проверяем, что API ключ добавлен в параметры запроса
      expect(apiClient.dio.options.queryParameters['token'], testApiKey);
    });

    test('should have PrettyDioLogger interceptor', () {
      // Проверяем, что логгер добавлен в интерцепторы
      final hasLogger = apiClient.dio.interceptors.any(
          (interceptor) => interceptor.toString().contains('PrettyDioLogger'));
      expect(hasLogger, true);
    });
  });
}
