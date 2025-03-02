// test/mocks/services/mock_finnhub_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:fxtm/core/services/finnhub_service.dart';
import 'package:fxtm/data/models/candle_data_api_model.dart';
import 'package:fxtm/data/models/forex_symbols_api_model.dart';
import 'package:fxtm/mocks/data/mock_data.dart';

class MockFinnhubServiceTest implements FinnhubService {
  @override
  Future<List<ForexSymbolsApiModel>> fetchForexPairs() async {
    // Use your existing mock data
    return MockData.getForexSymbols();
  }

  @override
  Future<CandleDataApiModel> fetchHistoricalData(
    String symbol, {
    String resolution = 'D',
    int? from,
    int? to,
  }) async {
    // Use your existing mock data
    return MockData.getHistoricalData(symbol);
  }
}

void main() {
  group('MockFinnhubServiceTest', () {
    late MockFinnhubServiceTest service;

    setUp(() {
      service = MockFinnhubServiceTest();
    });

    test('fetchForexPairs returns mock forex pairs', () async {
      final result = await service.fetchForexPairs();
      expect(result, isA<List<ForexSymbolsApiModel>>());
      expect(result.length, 5); // Based on your mock data
      expect(result.first.symbol, 'OANDA:EUR_USD');
    });

    test('fetchHistoricalData returns mock historical data', () async {
      final result = await service.fetchHistoricalData('OANDA:EUR_USD');
      expect(result, isA<CandleDataApiModel>());
      expect(result.s, 'ok');
      expect(result.c.length, 31); // 30 days + current day
    });
  });
}
