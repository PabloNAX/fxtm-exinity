import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:fxtm/core/services/api_client.dart';
import 'package:fxtm/core/services/finnhub_service.dart';
import 'package:fxtm/core/exceptions/forex_exception.dart';
import 'package:fxtm/data/models/candle_data_api_model.dart';
import 'package:fxtm/data/models/forex_symbols_api_model.dart';

// Создаем моки
class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  group('FinnhubService', () {
    late FinnhubServiceImpl finnhubService;
    late MockApiClient mockApiClient;
    late MockDio mockDio;

    setUp(() {
      mockApiClient = MockApiClient();
      mockDio = MockDio();

      // Настраиваем мок ApiClient, чтобы он возвращал наш мок Dio
      when(() => mockApiClient.dio).thenReturn(mockDio);

      finnhubService = FinnhubServiceImpl(mockApiClient);
    });

    group('fetchForexPairs', () {
      test(
          'should return list of ForexSymbolsApiModel when API call is successful',
          () async {
        // Arrange
        final responseData = [
          {
            'description': 'EUR/USD',
            'displaySymbol': 'EUR/USD',
            'symbol': 'OANDA:EUR_USD'
          }
        ];

        // Настраиваем мок для успешного ответа
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => Response(
              data: responseData,
              statusCode: 200,
              requestOptions: RequestOptions(path: '/forex/symbol'),
            ));

        // Act
        final result = await finnhubService.fetchForexPairs();

        // Assert
        expect(result, isA<List<ForexSymbolsApiModel>>());
        expect(result.length, 1);
        expect(result.first.symbol, 'OANDA:EUR_USD');

        // Проверяем, что был вызван правильный метод с правильными параметрами
        verify(() => mockDio.get(
              '/forex/symbol',
              queryParameters: {'exchange': 'oanda'},
            )).called(1);
      });

      test('should throw ForexException when API call fails', () async {
        // Arrange
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/forex/symbol'),
          error: 'Network error',
        ));

        // Act & Assert
        expect(
          () => finnhubService.fetchForexPairs(),
          throwsA(isA<ForexException>()),
        );
      });
    });

    group('fetchHistoricalData', () {
      test('should return CandleDataApiModel when API call is successful',
          () async {
        // Arrange
        final responseData = {
          'c': [1.1, 1.2, 1.3],
          'h': [1.15, 1.25, 1.35],
          'l': [1.05, 1.15, 1.25],
          'o': [1.1, 1.2, 1.3],
          't': [1625097600, 1625184000, 1625270400],
          'v': [1000, 2000, 3000],
          's': 'ok'
        };

        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => Response(
              data: responseData,
              statusCode: 200,
              requestOptions: RequestOptions(path: '/forex/candle'),
            ));

        // Act
        final result =
            await finnhubService.fetchHistoricalData('OANDA:EUR_USD');

        // Assert
        expect(result, isA<CandleDataApiModel>());
        expect(result.s, 'ok');
        expect(result.c.length, 3);

        // Проверяем вызов метода
        verify(() => mockDio.get(
              '/forex/candle',
              queryParameters: any(named: 'queryParameters'),
            )).called(1);
      });

      test('should throw ForexException when API call fails', () async {
        // Arrange
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/forex/candle'),
          error: 'Network error',
        ));

        // Act & Assert
        expect(
          () => finnhubService.fetchHistoricalData('OANDA:EUR_USD'),
          throwsA(isA<ForexException>()),
        );
      });
    });
  });
}
