import '../../core/services/cache_service.dart';
import '../../core/services/finnhub_service.dart';
import '../../core/utils/constants.dart';
import '../models/candle_data.dart';
import '../models/candle_data_api_model.dart';
import '../models/forex_pair.dart';
import '../models/forex_symbols_api_model.dart';

/// Repository for managing forex data, including fetching and caching forex pairs and historical data.
class ForexRepository {
  final FinnhubService _service;
  final CacheService _cacheService;

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
        print('data fetched from cache');
        return _convertToForexPairs(cachedSymbols);
      }

      // If not in cache, fetch from API
      final symbols = await _service.fetchForexPairs();
      await _cacheService.cacheForexPairs(symbols);
      return _convertToForexPairs(symbols);
    } catch (e) {
      // Rethrow to handle errors at a different layer
      rethrow;
    }
  }

  // TODO: Implement date parameters for fetchHistoricalData API call
  Future<List<CandleData>> getHistoricalData(
    String symbol, {
    String resolution = 'D',
    int? from,
    int? to,
  }) async {
    try {
      final candleDataApiModel = await _service.fetchHistoricalData(symbol,
          resolution: resolution, from: from, to: to);
      return _convertToCandleData(candleDataApiModel);
    } catch (e) {
      rethrow; // Rethrow to handle errors at a different layer
    }
  }

  List<CandleData> _convertToCandleData(CandleDataApiModel apiModel) {
    final List<CandleData> candles = [];
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
    symbols = symbols
        .where((symbol) => defaultPairs.contains(symbol.symbol))
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
