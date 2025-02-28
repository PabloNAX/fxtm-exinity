import 'package:shared_preferences/shared_preferences.dart';

import '../../core/exceptions/forex_exception.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/finnhub_service.dart';
import '../models/candle_data.dart';
import '../models/candle_data_api_model.dart';
import '../models/forex_pair.dart';
import '../models/forex_symbols_api_model.dart';

class ForexRepository {
  final FinnhubService _service;
  final CacheService _cacheService;

  static const List<String> _defaultPairs = [
    'OANDA:EUR_USD',
    'OANDA:GBP_USD',
    'OANDA:USD_JPY',
    'OANDA:AUD_USD',
    'OANDA:USD_CAD',
    'OANDA:USD_CHF',
    'OANDA:EUR_GBP',
    'OANDA:EUR_JPY'
  ];

  ForexRepository({
    required FinnhubService service,
    required CacheService cacheService,
  })  : _service = service,
        _cacheService = cacheService;

  Future<List<ForexPair>> getForexPairs() async {
    try {
      // Try to get from cache first
      final cachedSymbols = await _cacheService.getCachedForexPairs();
      if (cachedSymbols != null) {
        print('кэщ');
        return _convertToForexPairs(cachedSymbols);
      }

      // If not in cache, fetch from API
      final symbols = await _service.fetchForexPairs();
      await _cacheService.cacheForexPairs(symbols);
      return _convertToForexPairs(symbols);
    } catch (e) {
      throw ForexException('Failed to get forex pairs: $e');
    }
  }

  Future<List<CandleData>> getHistoricalData(String symbol,
      {String resolution = 'D'}) async {
    try {
      final candleDataApiModel =
          await _service.fetchHistoricalData(symbol, resolution: resolution);
      return _convertToCandleData(candleDataApiModel);
    } catch (e) {
      throw ForexException('Failed to get historical data: $e');
    }
  }

  List<CandleData> _convertToCandleData(CandleDataApiModel apiModel) {
    List<CandleData> candles = [];
    for (int i = 0; i < apiModel.t.length; i++) {
      candles.add(CandleData(
        open: apiModel.o[i],
        high: apiModel.h[i],
        low: apiModel.l[i],
        close: apiModel.c[i],
        timestamp: apiModel.t[i],
        volume: apiModel.v[i],
      ));
    }
    return candles;
  }

  List<ForexPair> _convertToForexPairs(List<ForexSymbolsApiModel> symbols) {
    // Your existing implementation
    symbols = symbols
        .where((symbol) => _defaultPairs.contains(symbol.symbol))
        .toList();

    return symbols
        .map((symbol) => ForexPair(
            symbol: symbol.symbol ?? '',
            currentPrice: 0.0,
            change: 0.0,
            percentChange: 0.0))
        .toList();
  }
}
