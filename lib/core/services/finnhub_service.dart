import 'dart:async';
import '../../data/models/candle_data_api_model.dart';
import '../../data/models/forex_symbols_api_model.dart';
import '../exceptions/forex_exception.dart';
import 'api_client.dart';

abstract class FinnhubService {
  Future<List<ForexSymbolsApiModel>> fetchForexPairs();
  Future<CandleDataApiModel> fetchHistoricalData(String symbol,
      {String resolution});
}

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
      throw ForexException('Failed to fetch forex pairs: $e');
    }
  }

  @override
  @override
  Future<CandleDataApiModel> fetchHistoricalData(
    String symbol, {
    String resolution = 'D',
    int? from,
    int? to,
  }) async {
    try {
      // Если не указаны временные рамки, берем последние 30 дней
      final now = DateTime.now();
      from ??=
          (now.subtract(Duration(days: 30)).millisecondsSinceEpoch ~/ 1000);
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
      throw ForexException('Failed to fetch historical data: $e');
    }
  }
}
