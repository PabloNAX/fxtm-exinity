// lib/mocks/services/mock_finnhub_service.dart

/// Mock implementation of the FinnhubService for testing purposes.
import '../../core/services/finnhub_service.dart';
import '../../data/models/candle_data_api_model.dart';
import '../../data/models/forex_symbols_api_model.dart';
import '../data/mock_data.dart';

class MockFinnhubService implements FinnhubService {
  @override
  Future<List<ForexSymbolsApiModel>> fetchForexPairs() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.getForexSymbols();
  }

  @override
  Future<CandleDataApiModel> fetchHistoricalData(
    String symbol, {
    String resolution = 'D',
    int? from,
    int? to,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Determine the number of days based on the time range
    int days = 30;
    if (from != null && to != null) {
      final fromDate = DateTime.fromMillisecondsSinceEpoch(from * 1000);
      final toDate = DateTime.fromMillisecondsSinceEpoch(to * 1000);
      days = toDate.difference(fromDate).inDays;
    }

    return MockData.getHistoricalData(symbol, days: days);
  }
}