// lib/mocks/repositories/mock_forex_repository.dart
import 'dart:math';

import 'package:fxtm/core/services/cache_service.dart';
import 'package:fxtm/data/models/candle_data.dart';
import 'package:fxtm/data/models/forex_pair.dart';
import 'package:fxtm/data/repositories/forex_repository.dart';
import '../services/mock_finnhub_service.dart';

class MockForexRepository extends ForexRepository {
  final MockFinhubService _mockService;

  MockForexRepository({
    required MockFinhubService mockService,
    required CacheService cacheService,
  })  : _mockService = mockService,
        super(service: mockService, cacheService: cacheService);

  @override
  Future<List<ForexPair>> getForexPairs() async {
    final symbols = await _mockService.fetchForexPairs();

    // Convert to ForexPair objects with mock prices
    return symbols.map((symbol) {
      // Generate random price and change values
      final random = Random();
      final basePrice = symbol.symbol == 'OANDA:EUR_USD'
          ? 1.10
          : symbol.symbol == 'OANDA:GBP_USD'
              ? 1.30
              : symbol.symbol == 'OANDA:USD_JPY'
                  ? 110.0
                  : symbol.symbol == 'OANDA:AUD_USD'
                      ? 0.70
                      : 1.0;

      final currentPrice = basePrice * (1 + (random.nextDouble() - 0.5) * 0.01);
      final change = (random.nextDouble() - 0.5) * 0.005;
      final percentChange = change / basePrice * 100;

      return ForexPair(
        symbol: symbol.symbol ?? '',
        currentPrice: double.parse(currentPrice.toStringAsFixed(5)),
        change: double.parse(change.toStringAsFixed(5)),
        percentChange: double.parse(percentChange.toStringAsFixed(2)),
      );
    }).toList();
  }

  // @override
  // Future<List<CandleData>> getHistoricalData(String symbol) async {
  //   final candleDataApiModel = await _mockService.fetchHistoricalData(symbol);
  //   return _convertToCandleData(candleDataApiModel);
  // }
}
