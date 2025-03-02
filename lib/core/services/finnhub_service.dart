import 'dart:async';
import '../../data/models/candle_data_api_model.dart';
import '../../data/models/forex_symbols_api_model.dart';
import 'api_client.dart';

/// Interface for FinnhubService
abstract class FinnhubService {
  Future<List<ForexSymbolsApiModel>> fetchForexPairs();
  Future<CandleDataApiModel> fetchHistoricalData(
    String symbol, {
    String resolution,
    int? from,
    int? to,
  });
}

/// Implementation of the FinnhubService for fetching forex pairs and historical data.
class FinnhubServiceImpl implements FinnhubService {
  final ApiClient _apiClient;

  FinnhubServiceImpl(this._apiClient);

  @override
  Future<List<ForexSymbolsApiModel>> fetchForexPairs() async {
    try {
      final response = await _apiClient.dio.get(
        '/forex/symbol',
        queryParameters: {'exchange': 'oanda'},
      );

      return (response.data as List)
          .map((json) => ForexSymbolsApiModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow; // Rethrowing to handle errors at a different layer (error layer).
    }
  }

  /// Fetches historical candle data for a given symbol.
  // TODO: Implement date parameters for fetchHistoricalData API call
  @override
  Future<CandleDataApiModel> fetchHistoricalData(
    String symbol, {
    String resolution = 'D',
    int? from,
    int? to,
  }) async {
    try {
      // If no time frame is specified, take the last 30 days
      final now = DateTime.now();
      from ??=
          (now.subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000);
      to ??= (now.millisecondsSinceEpoch ~/ 1000);

      final response = await _apiClient.dio.get(
        '/forex/candle',
        queryParameters: {
          'symbol': symbol,
          'resolution': resolution,
          'from': from,
          'to': to,
        },
      );

      return CandleDataApiModel.fromJson(response.data);
    } catch (e) {
      rethrow; // Rethrowing to handle errors at a different layer (error layer).
    }
  }
}
