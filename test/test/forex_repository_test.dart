// test/unit/data/repositories/forex_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fxtm/core/exceptions/forex_exception.dart';
import 'package:fxtm/data/models/candle_data.dart';
import 'package:fxtm/data/models/forex_pair.dart';
import 'package:fxtm/data/repositories/forex_repository.dart';
import 'package:fxtm/mocks/data/mock_data.dart';

import 'mock_classes.mocks.dart';

void main() {
  late MockFinnhubService mockFinnhubService;
  late MockCacheService mockCacheService;
  late ForexRepository repository;

  setUp(() {
    mockFinnhubService = MockFinnhubService();
    mockCacheService = MockCacheService();
    repository = ForexRepository(
      service: mockFinnhubService,
      cacheService: mockCacheService,
    );
  });

  group('getForexPairs', () {
    test('should return forex pairs from cache when cache is available',
        () async {
      // Arrange
      final mockSymbols = MockData.getForexSymbols();
      when(mockCacheService.getCachedForexPairs())
          .thenAnswer((_) async => mockSymbols);

      // Act
      final result = await repository.getForexPairs();

      // Assert
      expect(result, isA<List<ForexPair>>());
      verify(mockCacheService.getCachedForexPairs()).called(1);
      verifyNever(mockFinnhubService.fetchForexPairs());
    });

    test('should fetch forex pairs from API when cache is not available',
        () async {
      // Arrange
      final mockSymbols = MockData.getForexSymbols();
      when(mockCacheService.getCachedForexPairs())
          .thenAnswer((_) async => null);
      when(mockFinnhubService.fetchForexPairs())
          .thenAnswer((_) async => mockSymbols);

      // Act
      final result = await repository.getForexPairs();

      // Assert
      expect(result, isA<List<ForexPair>>());
      verify(mockCacheService.getCachedForexPairs()).called(1);
      verify(mockFinnhubService.fetchForexPairs()).called(1);
      verify(mockCacheService.cacheForexPairs(mockSymbols)).called(1);
    });

    test('should throw ForexException when an error occurs', () async {
      // Arrange
      when(mockCacheService.getCachedForexPairs())
          .thenAnswer((_) async => null);
      when(mockFinnhubService.fetchForexPairs())
          .thenThrow(Exception('API error'));

      // Act & Assert
      expect(() => repository.getForexPairs(), throwsA(isA<ForexException>()));
    });
  });

  group('getHistoricalData', () {
    test('should return historical data for a forex pair', () async {
      // Arrange
      final mockCandleDataApiModel =
          MockData.getHistoricalData('OANDA:EUR_USD');
      when(mockFinnhubService.fetchHistoricalData(
        'OANDA:EUR_USD',
        resolution: 'D',
        from: 1646092800,
        to: 1646265600,
      )).thenAnswer((_) async => mockCandleDataApiModel);

      // Act
      final result = await repository.getHistoricalData(
        'OANDA:EUR_USD',
        resolution: 'D',
        from: 1646092800,
        to: 1646265600,
      );

      // Assert
      expect(result, isA<List<CandleData>>());
      verify(mockFinnhubService.fetchHistoricalData(
        'OANDA:EUR_USD',
        resolution: 'D',
        from: 1646092800,
        to: 1646265600,
      )).called(1);
    });

    test('should throw ForexException when an error occurs', () async {
      // Arrange
      when(mockFinnhubService.fetchHistoricalData(
        'OANDA:EUR_USD',
        resolution: 'D',
        from: 1646092800,
        to: 1646265600,
      )).thenThrow(Exception('API error'));

      // Act & Assert
      expect(
        () => repository.getHistoricalData(
          'OANDA:EUR_USD',
          resolution: 'D',
          from: 1646092800,
          to: 1646265600,
        ),
        throwsA(isA<ForexException>()),
      );
    });
  });
}
